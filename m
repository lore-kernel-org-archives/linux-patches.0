Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF5126056D;
	Wed, 25 Feb 2026 01:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983577; cv=none; b=Uym2amvscLiuicvZpZE+3EQ1DBAkV+NpCH4kD5WrNyOduzDfQ8J15/Qboy4iFQ51ckIkixp9gnUQoICRrNO4P0PgCrX9QTWqtS+U+hHiSAIFHfMRFNEQ11XRmbGSDo77bl46aK5XjVH0ggDzyc7T2BZjlVyRCDsg/MFnZLQVPB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983577; c=relaxed/simple;
	bh=kwLytkPD0qmVmS+Hkl1SsDQHRIraEAeQqRfFqGKLsq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7xxMFtpXH5ytlFutYu6TVNHpuYeEkcvgRz11GXMJXvlgeNNLxrxkPI2V763kccjJfKLNMQw0surlrCTytmlxI9d+0fKMKipemfZ6UkVWU7SO3jbDT6Uc9it6ODhfqxoPTVjKw1xjtj9bYrDBLsTkA0Yh0ACu4O5ye0mLbD675A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMdH3fDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMdH3fDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6E7C116D0;
	Wed, 25 Feb 2026 01:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983577;
	bh=kwLytkPD0qmVmS+Hkl1SsDQHRIraEAeQqRfFqGKLsq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMdH3fDnxkV+SNPbp84zQrGDTCyO6JiJkb/jh6w2ONZ1uw0KTacNg/tCQIXUKybFo
	 9xmqnbWrTb8vYLdI5sX0KRXwfYc0rms+knM3GycplOEB80tLbKNgqVlL6+GU5G7+un
	 yTD4h9s++NUQT1/rT3vAwN1eerLGhzZmk1/CYs8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 678/781] icmp: prevent possible overflow in icmp_global_allow()
Date: Tue, 24 Feb 2026 17:23:07 -0800
Message-ID: <20260225012416.408376221@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 034bbd806298e9ba4197dd1587b0348ee30996ea ]

Following expression can overflow
if sysctl_icmp_msgs_per_sec is big enough.

sysctl_icmp_msgs_per_sec * delta / HZ;

Fixes: 4cdf507d5452 ("icmp: add a global rate limitation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260216142832.3834174-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index a2cff16668d72..471dd862f6639 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -248,7 +248,8 @@ bool icmp_global_allow(struct net *net)
 	if (delta < HZ / 50)
 		return false;
 
-	incr = READ_ONCE(net->ipv4.sysctl_icmp_msgs_per_sec) * delta / HZ;
+	incr = READ_ONCE(net->ipv4.sysctl_icmp_msgs_per_sec);
+	incr = div_u64((u64)incr * delta, HZ);
 	if (!incr)
 		return false;
 
-- 
2.51.0




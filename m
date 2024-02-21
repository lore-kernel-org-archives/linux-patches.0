Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DA17BB12;
	Wed, 21 Feb 2024 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522897; cv=none; b=ulF2Z6i830wrh4wRzQKDKT8mh1Jlf/klYFRFHsXKqCjCkMXIVThmC98pltMlaOSIn2uDNtou3AXCvWtK7han/HMUFOfHyj+qlY5Z6++sNB2h8sjZWTTSpBQLF5RvblVQ47gPxOuBZk1rosrITuFON2DqvPJxX76is1Z+Gfpz88o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522897; c=relaxed/simple;
	bh=VxrWu4JPGPdQGF0h0yUFpJMQvCgrGRVsAYkRFHwJmV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QboECYG5Vkh3e9wC9XH7/HvhnuAa5JXZeIg/aO9Mj5LyREFcmW+FzGpFWO1l5TNjGw1s5NeEahGWUhLAve0tKVZtayMBrKBRiR2z5DEBgHCRzEQrsaczmOsUBsaEKgIRN0T8muB95hLXzdcBxWqHp8gWZK84S6oYyfJwsDrjpUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pi16TWM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pi16TWM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25306C433F1;
	Wed, 21 Feb 2024 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522897;
	bh=VxrWu4JPGPdQGF0h0yUFpJMQvCgrGRVsAYkRFHwJmV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pi16TWM7vdporFchU0dGOqx87Fs9UU2wI0KdGL5IapZHI9jun/DGfonxux9LXVEhS
	 oh7QpFdpRPjAGMXkX9Z+1QBewhBHJwrcnCd2H0rm4yQa6n3bJIqa+P3gAwSNXlQ9Cz
	 0TPE8AdVkKGQ085xmFIF+vMJRdRS7PaE7Bk95sIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/476] net: ipv4: fix a memleak in ip_setup_cork
Date: Wed, 21 Feb 2024 14:05:37 +0100
Message-ID: <20240221130018.575824918@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 5dee6d6923458e26966717f2a3eae7d09fc10bf6 ]

When inetdev_valid_mtu fails, cork->opt should be freed if it is
allocated in ip_setup_cork. Otherwise there could be a memleak.

Fixes: 501a90c94510 ("inet: protect against too small mtu values.")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240129091017.2938835-1-alexious@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index a445e4e05e0d..ee4e7e7a0992 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1251,6 +1251,12 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
 	if (unlikely(!rt))
 		return -EFAULT;
 
+	cork->fragsize = ip_sk_use_pmtu(sk) ?
+			 dst_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
+
+	if (!inetdev_valid_mtu(cork->fragsize))
+		return -ENETUNREACH;
+
 	/*
 	 * setup for corking.
 	 */
@@ -1267,12 +1273,6 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
 		cork->addr = ipc->addr;
 	}
 
-	cork->fragsize = ip_sk_use_pmtu(sk) ?
-			 dst_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
-
-	if (!inetdev_valid_mtu(cork->fragsize))
-		return -ENETUNREACH;
-
 	cork->gso_size = ipc->gso_size;
 
 	cork->dst = &rt->dst;
-- 
2.43.0




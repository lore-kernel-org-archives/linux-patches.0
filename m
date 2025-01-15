Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6F41E9904;
	Wed, 15 Jan 2025 10:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937556; cv=none; b=QV182rWGD8aqhRnIuUiHHgFyyrRuSy4KkuUqNGuaGyp1dFe5GB8/l/NXxakVnKa9XPjGbRV5mPVrCoK8MIKO4iGkD4GvgJ9ztTQP+BMQg/X+WT7YXCPA5OcH8/uaP/vx/E7ieuPm6eyImBz2PI90W3dSsK8Ixz29EgGR5i0adYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937556; c=relaxed/simple;
	bh=wcLBkmYjQVNA4njtYCWsjQzmp4MOM0DJvuzck8sqQDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiBit6No2NLah55q+szwwZaVdfOd21Tui7lT7neNf+qIVfR5gWbXzbykM1tiqjHbR4ooiqBEznapkji1t39Ig1LSVICloc1PmxLXeVgR7G4RGUevld1jnSkrNG7VTf3WeTRUcFLUdO8kiE1w+hlSw1pJIYY3ryrNo6mNoNSkqTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQxU8Lnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQxU8Lnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626E2C4CEEA;
	Wed, 15 Jan 2025 10:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937556;
	bh=wcLBkmYjQVNA4njtYCWsjQzmp4MOM0DJvuzck8sqQDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQxU8LnhiP68fJS/EIyeNdYMG0H+zIwJXAHqmnZqcBl9ow2HafvH2nVuszCvzFslP
	 ILs+YHFUmcv6G0vorYV4Zj1Lrpitgydev9Au8fKe3mUO7GDNXJ6mLYN9M2sKN+ENUL
	 tBM/neKWquwLylhnRmKPND5WddeF3dUtFi4kAF+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/92] tcp/dccp: complete lockless accesses to sk->sk_max_ack_backlog
Date: Wed, 15 Jan 2025 11:36:33 +0100
Message-ID: <20250115103548.148855501@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 9a79c65f00e2b036e17af3a3a607d7d732b7affb ]

Since commit 099ecf59f05b ("net: annotate lockless accesses to
sk->sk_max_ack_backlog") decided to handle the sk_max_ack_backlog
locklessly, there is one more function mostly called in TCP/DCCP
cases. So this patch completes it:)

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240331090521.71965-1-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3479c7549fb1 ("tcp/dccp: allow a connection when sk_max_ack_backlog is zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 4242f863f560..1611fb656ea9 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -281,7 +281,7 @@ static inline int inet_csk_reqsk_queue_len(const struct sock *sk)
 
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
-	return inet_csk_reqsk_queue_len(sk) >= sk->sk_max_ack_backlog;
+	return inet_csk_reqsk_queue_len(sk) >= READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
-- 
2.39.5




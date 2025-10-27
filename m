Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4D831D75F;
	Mon, 27 Oct 2025 19:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593213; cv=none; b=ZrTjJ7ZQzqG/kiKOoLIl6qNyRn0PShfCG/lllFWZeVXxV7M8xu5o4IBpquJJNkFTxKLUwDIXjpOqug9IZCooHx4/vzuwl2YrunmJVEnTQ2iPyT85kWVAT7pFBzkTdzjoy8JFLi/xbC5vMHAMH003S5oImN312m8mC7yGf1S+0yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593213; c=relaxed/simple;
	bh=WVO2szA3Yq+6SqR8XJIISuS/4b7ufSal/1OiM4p9aqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twCssl1O+67gxF0Z+ugv50CmB+3w1RnNwkHvt7qzLAyuDcb15h5AD+xoitebs4zei1A5Urr62fQzI4iPuZt8MUqEdkasbhaqhHS4XXL2r01lt/Cn38HS/48q58fCxP98gIg2YG1AE1u/1Lp40sqtrfkSzyF7HWXVbV53mGdBY6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5t3PNIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5t3PNIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FA1C4CEF1;
	Mon, 27 Oct 2025 19:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593213;
	bh=WVO2szA3Yq+6SqR8XJIISuS/4b7ufSal/1OiM4p9aqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5t3PNICVcNZEH5rotvbxmmw2wzRpHXKIYVDjiALBJR9L5iQ7N+QmQVWqahVcXqMc
	 uBVV39/QKDYI11FHtFWA1QhCMmks4RBYXMFePR840PRpr+4LjhP4QoGdz5bb6gvV9U
	 rAjjZOQekGEF8P+36NPxARO2lLVvQHD5gvFCkI6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 056/184] espintcp: use datagram_poll_queue for socket readiness
Date: Mon, 27 Oct 2025 19:35:38 +0100
Message-ID: <20251027183516.409515628@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit 0fc3e32c2c069f541f2724d91f5e98480b640326 ]

espintcp uses a custom queue (ike_queue) to deliver packets to
userspace. The polling logic relies on datagram_poll, which checks
sk_receive_queue, which can lead to false readiness signals when that
queue contains non-userspace packets.

Switch espintcp_poll to use datagram_poll_queue with ike_queue, ensuring
poll only signals readiness when userspace data is actually available.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20251021100942.195010-3-ralf@mandelbit.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/espintcp.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index fc7a603b04f13..bf744ac9d5a73 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -555,14 +555,10 @@ static void espintcp_close(struct sock *sk, long timeout)
 static __poll_t espintcp_poll(struct file *file, struct socket *sock,
 			      poll_table *wait)
 {
-	__poll_t mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
-	if (!skb_queue_empty(&ctx->ike_queue))
-		mask |= EPOLLIN | EPOLLRDNORM;
-
-	return mask;
+	return datagram_poll_queue(file, sock, wait, &ctx->ike_queue);
 }
 
 static void build_protos(struct proto *espintcp_prot,
-- 
2.51.0




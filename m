Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C9F7868F;
	Mon,  4 Mar 2024 21:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589234; cv=none; b=pu/deD0jGXAIp9zHAxdC2T+X5rEFNB8ar+o9gxQ7Hqfu3BdVm1sYc5aHDbJDh2uTM4e3+PMc0ufK2EC0fRiu6sltcUcEH0Uml2zNWSs3mKFx5Vw+iGlvpl7WptFHeyYoP5gpXBKRCQENEhLfeJsWLNy8D/fT+pP7SNALye4u+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589234; c=relaxed/simple;
	bh=H4ZYKjFL3qGGS4Z75Nt2WLaiqaBYkLIUnhbLQfq4+Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXD4sPuosB2KXCj8/QK3Ij8/wtgLOiLbPjTRdQOrUeHi7CUn6iVR/ZNwuIENGGP28HRjnlq0W69Y8kAnYTA0A+id+AJSf2J/K2vFXj5Jyy05hLeVsLvNpGX4mHZxDD/ITS30v8W8Ll052JBk8FDBwpFZv27U27O8CJZDxGLbhlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LR8oyGBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LR8oyGBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38577C433F1;
	Mon,  4 Mar 2024 21:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589233;
	bh=H4ZYKjFL3qGGS4Z75Nt2WLaiqaBYkLIUnhbLQfq4+Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LR8oyGBKnCRAEldj2VO1Xufxvv1wUgwbRdXWI58l2buuaKFd9onwzE5lrzb4zW6OM
	 QIqq1y/REiEHWXyNFZTYj/t3kNx26iFZT1gQygwZyYvxVjFKnUVPNtB3JM0w1zy5l5
	 nWgwTHzF9s59fOH9xBk67p/CLw4TBulc4iLhRaiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/84] tls: hw: rx: use return value of tls_device_decrypted() to carry status
Date: Mon,  4 Mar 2024 21:24:04 +0000
Message-ID: <20240304211543.367960693@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 71471ca32505afa7c3f7f6a8268716e1ddb81cd4 ]

Instead of tls_device poking into internals of the message
return 1 from tls_device_decrypted() if the device handled
the decryption.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 7 ++-----
 net/tls/tls_sw.c     | 5 ++---
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f23d18e666284..e7c361807590d 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -936,7 +936,6 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 			 struct sk_buff *skb, struct strp_msg *rxm)
 {
 	struct tls_offload_context_rx *ctx = tls_offload_ctx_rx(tls_ctx);
-	struct tls_msg *tlm = tls_msg(skb);
 	int is_decrypted = skb->decrypted;
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
@@ -951,11 +950,9 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 				   tls_ctx->rx.rec_seq, rxm->full_len,
 				   is_encrypted, is_decrypted);
 
-	tlm->decrypted |= is_decrypted;
-
 	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {
 		if (likely(is_encrypted || is_decrypted))
-			return 0;
+			return is_decrypted;
 
 		/* After tls_device_down disables the offload, the next SKB will
 		 * likely have initial fragments decrypted, and final ones not
@@ -970,7 +967,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 	 */
 	if (is_decrypted) {
 		ctx->resync_nh_reset = 1;
-		return 0;
+		return is_decrypted;
 	}
 	if (is_encrypted) {
 		tls_device_core_ctrl_rx_resync(tls_ctx, ctx, sk, skb);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 7da17dd7c38b9..eed32ef3ca4a0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1571,9 +1571,8 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
 		if (err < 0)
 			return err;
-
-		/* skip SW decryption if NIC handled it already */
-		if (tlm->decrypted) {
+		if (err > 0) {
+			tlm->decrypted = 1;
 			*zc = false;
 			goto decrypt_done;
 		}
-- 
2.43.0




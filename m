Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1973B1C6AB;
	Mon,  4 Mar 2024 21:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589249; cv=none; b=owcHxMJlYPmnVyJITrW0W0anq90s3oNds2ZpbWeDlc9fqVr+sYXDSq61+el0o/GzGwtO8pW2bvmmK1XMU6Z8mimOOlbjOeYE1zBbV/9WZ6xU97L1WviJEdRJ8iO3QzaUwvr7Ob8Mm0srwAa12CNNVNCscdhP5qmr6qvvHfGFO2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589249; c=relaxed/simple;
	bh=LfhvCYunYY0JhLj8kmoHK48qXpWi+dj3JO6SHLh0koM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BR8NOe4UXTDSZ3zo5C2h2bR2TGA7fxotVgjwb25Et0n09w+Oe1RjS6Ze+iItm2xKBMnquNPLkFMt/Zuk053w5FK7m3Xd83oGooVnW3jep8mlUuFY0TRGFzfb9NOBHxHSy9j4O/qZuui7tDl41infOSces+/Xhfx0dxzRuloemAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3C5lsSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3C5lsSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DE5C433C7;
	Mon,  4 Mar 2024 21:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589249;
	bh=LfhvCYunYY0JhLj8kmoHK48qXpWi+dj3JO6SHLh0koM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3C5lsSXmd/c0o22jAgv3Zn121ckHt6yPhxpLKFxp4QEK4vdv1eA4e2buxY0Lqd+/
	 5X2glUV8N8ZeHfDNp0NWSqtAwcu5AJAvanmVngHjyjkyW7eEjCTcIa1mOoZAdxQqAA
	 Gs97ybsiHPpF4OVeRmS3tOIkWgA0+Df8UYFrRRvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/84] tls: rx: dont track the async count
Date: Mon,  4 Mar 2024 21:24:09 +0000
Message-ID: <20240304211543.544299632@linuxfoundation.org>
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

[ Upstream commit 7da18bcc5e4cfd14ea520367546c5697e64ae592 ]

We track both if the last record was handled by async crypto
and how many records were async. This is not necessary. We
implicitly assume once crypto goes async it will stay that
way, otherwise we'd reorder records. So just track if we're
in async mode, the exact number of records is not necessary.

This change also forces us into "async" mode more consistently
in case crypto ever decided to interleave async and sync.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index ca71a9f559b37..d3bbae9af9f41 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1753,13 +1753,13 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct sk_psock *psock;
-	int num_async, pending;
 	unsigned char control = 0;
 	ssize_t decrypted = 0;
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
+	bool async = false;
 	int target, err = 0;
 	long timeo;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
@@ -1791,12 +1791,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	decrypted = 0;
-	num_async = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		struct tls_decrypt_arg darg = {};
 		bool retain_skb = false;
 		int to_decrypt, chunk;
-		bool async;
 
 		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
 		if (!skb) {
@@ -1836,10 +1834,8 @@ int tls_sw_recvmsg(struct sock *sk,
 			goto recv_end;
 		}
 
-		if (err == -EINPROGRESS) {
+		if (err == -EINPROGRESS)
 			async = true;
-			num_async++;
-		}
 
 		/* If the type of records being processed is not known yet,
 		 * set it to record type just dequeued. If it is already known,
@@ -1914,7 +1910,9 @@ int tls_sw_recvmsg(struct sock *sk,
 	}
 
 recv_end:
-	if (num_async) {
+	if (async) {
+		int pending;
+
 		/* Wait for all previously submitted records to be decrypted */
 		spin_lock_bh(&ctx->decrypt_compl_lock);
 		ctx->async_notify = true;
-- 
2.43.0




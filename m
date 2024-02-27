Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84DC13B2B4;
	Tue, 27 Feb 2024 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043939; cv=none; b=J0HjisYHMGypVaMgu99a7UdZMTD1iQsUlbxDNFpBcIUXaqgN+A7OHvyTjTY5/kkD8aTEHgsZOlVhqD26OjXhaJTYi5Hgeq3esWRRaczzBC1lmVfutPHtFzgM5ykqoYKIVuyrGZVLsg0tMR0YN623Aar5FSi5El5ynT6448DGV+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043939; c=relaxed/simple;
	bh=aix25P/is0HV771E4fYQpTgse8vHiL4SEgeI1/68X7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWEtJkZ8k7mHe4/rfwoX17gu1K/h7v2pgftu3UZmgiWp3c9knlhIjUPAoHdhczDE9uzlpymXDhTu8tnl5YnO8uYBiY6Gwt1Jjf3vkcPnoYsIcEktslw4x2UeiY38nwm98v9RyNZGqjuinBU6iuNQT96yu6ALlnKI85ier+n8eIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ps245JR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ps245JR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53720C433F1;
	Tue, 27 Feb 2024 14:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043939;
	bh=aix25P/is0HV771E4fYQpTgse8vHiL4SEgeI1/68X7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ps245JR7kRmsky6mWv7fSqeTydZ+3AJJiZECGRWWOo08KV1hZUm8cJBdsKPPCwn1C
	 gKB2qZzcyzh7f9B6QVdFOHBMiYePG3IBnlOGQMMDuio4E+QQq1kIbGHUh9Z+DCOExW
	 TaD+J2bJJIClnVbUU3H+dXBFP57U8Gz9QC+get2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 77/84] tls: rx: jump to a more appropriate label
Date: Tue, 27 Feb 2024 14:27:44 +0100
Message-ID: <20240227131555.376345192@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit bfc06e1aaa130b86a81ce3c41ec71a2f5e191690 ]

'recv_end:' checks num_async and decrypted, and is then followed
by the 'end' label. Since we know that decrypted and num_async
are 0 at the start we can jump to 'end'.

Move the init of decrypted and num_async to let the compiler
catch if I'm wrong.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fdfbaec5923d ("tls: stop recv() if initial process_rx_list gave us non-DATA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 38592d0871a3f..606a51237c50f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1748,6 +1748,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct sk_psock *psock;
+	int num_async, pending;
 	unsigned char control = 0;
 	ssize_t decrypted = 0;
 	struct strp_msg *rxm;
@@ -1760,8 +1761,6 @@ int tls_sw_recvmsg(struct sock *sk,
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
 	bool bpf_strp_enabled;
-	int num_async = 0;
-	int pending;
 
 	flags |= nonblock;
 
@@ -1783,12 +1782,14 @@ int tls_sw_recvmsg(struct sock *sk,
 	}
 
 	if (len <= copied)
-		goto recv_end;
+		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 	len = len - copied;
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
+	decrypted = 0;
+	num_async = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		bool retain_skb = false;
 		bool zc = false;
-- 
2.43.0




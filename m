Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF771468E5;
	Tue, 27 Feb 2024 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044236; cv=none; b=usO2YALFjSZinugdYEvtpQ2SmASN50yv9manXttoLPGMa4MKEwYhPrGW4I3ALmc90i2Qyrle/ZLqemMaPxuJZpXTnkECkwESb8k1wTncrExhAsAg2bVU73pofPtOf/fLeXeO91tWgVtV6UboFU+8bEwzemDhvp7kr0n4jFiCaDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044236; c=relaxed/simple;
	bh=0XT8ii4X9HeUVQgShRmywb911IMkobXqtc6Sj+ZGb1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gqt+80HHlTN8djBM7CS2Kj1wGKD+6kdvOKqEaoLvUfOX5iwvj9TTuGWYpCuCkqB8VORikUwQyFyfW3hXQUDcjoLhLSBGQ5PmReV1UzGDcz1tcT7Y83PPyxRrQUxl3N4v4uoBv6ITW/Ed4R10Mj8gwBTKrli3TMRXQwMwV2+GvvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3YoHGcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3YoHGcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189B3C433C7;
	Tue, 27 Feb 2024 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044236;
	bh=0XT8ii4X9HeUVQgShRmywb911IMkobXqtc6Sj+ZGb1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3YoHGcxuJqRaBVIRTrsMhVkjOZy19XC32brA9v+wnKxbS+WHKADYgVRqFh7Qe7De
	 IN8nopdWEFLlTAkfwB9W8YtwJo6hlpjt3Q3hklTxaz3sfC0OZW+/vLhG41sxFFYB4C
	 h60+v81Yb+RzOCAoMQSJgu5Wjn3axrdNC/sBIpeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/122] tls: rx: jump to a more appropriate label
Date: Tue, 27 Feb 2024 14:27:53 +0100
Message-ID: <20240227131602.369042949@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dd980438f201f..d11094a81ee6c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1754,6 +1754,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct sk_psock *psock;
+	int num_async, pending;
 	unsigned char control = 0;
 	ssize_t decrypted = 0;
 	struct strp_msg *rxm;
@@ -1766,8 +1767,6 @@ int tls_sw_recvmsg(struct sock *sk,
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
 	bool bpf_strp_enabled;
-	int num_async = 0;
-	int pending;
 
 	flags |= nonblock;
 
@@ -1789,12 +1788,14 @@ int tls_sw_recvmsg(struct sock *sk,
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




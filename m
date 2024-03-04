Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AC179DCE;
	Mon,  4 Mar 2024 21:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589231; cv=none; b=m/d1AHwh267xVrOO7KB9zW/FUgDEXUUjMqjTRAjcA8z7Z6i6IHQo7hsij8Xc9O0XJt3mzbKxh5MtR9ijVh42AoP5OS3SDeOL+QyzaawshXo4XhfXRQ7PiIU/fnWEI5CfLUSPhB6xeohf9kiTdKbcOt0QISiNM8sEfQZzsWnxhXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589231; c=relaxed/simple;
	bh=oJ9c7b8l78dnOEpeNR/qgdL3X9arS+GTWNTVhhRepgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO/t+VueO7ycHMbPLz/JD9ru4NRvQTvAImZhqfPIG0HQrNltJbm2+kNX0ElIxI7USKa/l7jzZIlVmsN7+vUrITiA5HM+NrL+4n89kJTyHEUTmoT+M5vMWzfgG/I1yosmd+woA4vqiqAPnRhsXUocoUUCD1WGbP3NF1Vy0FMualE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvMz/SCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvMz/SCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95954C433F1;
	Mon,  4 Mar 2024 21:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589230;
	bh=oJ9c7b8l78dnOEpeNR/qgdL3X9arS+GTWNTVhhRepgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvMz/SCXHpP6AxeDRKeYJ+veOFsPrQrzLsFj37ndr4ap+TgLWTWGJ2/S3PbqsRSKb
	 mcPiNUSQ8wZVURAZTehp+57/kbUzDM9l1ovQi3Ifb1QcrRl1RNs3tRCeIhPn0l2FRn
	 aIdKV2G2RjEIeaYOlt61x0sDDV2dKhypRK12djO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/84] tls: rx: refactor decrypt_skb_update()
Date: Mon,  4 Mar 2024 21:24:03 +0000
Message-ID: <20240304211543.336438664@linuxfoundation.org>
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

[ Upstream commit 3764ae5ba6615095de86698a00e814513b9ad0d5 ]

Use early return and a jump label to remove two indentation levels.
No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 66 ++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 5fdc4f5193ee5..7da17dd7c38b9 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1560,46 +1560,46 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm = strp_msg(skb);
 	struct tls_msg *tlm = tls_msg(skb);
-	int pad, err = 0;
+	int pad, err;
 
-	if (!tlm->decrypted) {
-		if (tls_ctx->rx_conf == TLS_HW) {
-			err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
-			if (err < 0)
-				return err;
-		}
+	if (tlm->decrypted) {
+		*zc = false;
+		return 0;
+	}
 
-		/* Still not decrypted after tls_device */
-		if (!tlm->decrypted) {
-			err = decrypt_internal(sk, skb, dest, NULL, chunk, zc,
-					       async);
-			if (err < 0) {
-				if (err == -EINPROGRESS)
-					tls_advance_record_sn(sk, prot,
-							      &tls_ctx->rx);
-				else if (err == -EBADMSG)
-					TLS_INC_STATS(sock_net(sk),
-						      LINUX_MIB_TLSDECRYPTERROR);
-				return err;
-			}
-		} else {
+	if (tls_ctx->rx_conf == TLS_HW) {
+		err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
+		if (err < 0)
+			return err;
+
+		/* skip SW decryption if NIC handled it already */
+		if (tlm->decrypted) {
 			*zc = false;
+			goto decrypt_done;
 		}
+	}
 
-		pad = padding_length(prot, skb);
-		if (pad < 0)
-			return pad;
-
-		rxm->full_len -= pad;
-		rxm->offset += prot->prepend_size;
-		rxm->full_len -= prot->overhead_size;
-		tls_advance_record_sn(sk, prot, &tls_ctx->rx);
-		tlm->decrypted = 1;
-	} else {
-		*zc = false;
+	err = decrypt_internal(sk, skb, dest, NULL, chunk, zc, async);
+	if (err < 0) {
+		if (err == -EINPROGRESS)
+			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
+		else if (err == -EBADMSG)
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
+		return err;
 	}
 
-	return err;
+decrypt_done:
+	pad = padding_length(prot, skb);
+	if (pad < 0)
+		return pad;
+
+	rxm->full_len -= pad;
+	rxm->offset += prot->prepend_size;
+	rxm->full_len -= prot->overhead_size;
+	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
+	tlm->decrypted = 1;
+
+	return 0;
 }
 
 int decrypt_skb(struct sock *sk, struct sk_buff *skb,
-- 
2.43.0




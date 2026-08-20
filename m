Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F72347ACC3;
	Thu, 20 Aug 2026 17:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247729; cv=none; b=JQSlZCbu3z8WyriGcb0B5JaI09kOxencjTqlfhIeGCrcl3B3LIlmlJmfyTnQSECfJ0BeX/4OGlKJydhXXv190ZENLNITDWyEUxFhlI3iqaJ8FCeYj07vfXaz3E92ImSC71oSrM0M5c8vZTsXamSE8/N3VcbbVn4II1AKlOB961o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247729; c=relaxed/simple;
	bh=CinlsruaTkagUQRtBg/++IaFxIeRRlC2UDItSgAyw94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rast4tRHplPkRxgknPV7giXC55Fo27kVCSTtnXIl7V0tk3NnbJG1v/DvkRof3MyvppUD+3OtJ8pdBAQb9pXbm3ZxjTQoCs0WwVNapVk1SupEDYnsKzDtYKCzv3ACc/rNoZt1Kzf/kgso0ndXjWs6SqLaG9HEnjN9STlg3kKwAPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhtVvxyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhtVvxyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918651F000E9;
	Thu, 20 Aug 2026 17:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247728;
	bh=Pa+bdvZHB+qVQANUcyQdM7OQIA3DWJpiK5dPQHRP4Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhtVvxyURJl+kgOp/bQtEZX8WsC0GcRIaWUGOsvHdvOIFzzS9Kd3tAF/UF6g0tek3
	 wO2b7m8hCF5hRM4HufF2Bl6dYhmKomHOnkzUy0miF/vSnyGEvBbcjMctvmez+i2FWc
	 9Bjl6RRhHf+JrB9/3I7vypewMv0YtLmtXeFMjizc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/166] net/tls: Fail tls_sw_splice_read() after a failed async decrypt
Date: Thu, 20 Aug 2026 16:56:46 +0200
Message-ID: <20260820145215.593026671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 976df67f463db1fddaf2a32fb04f57ad2891a23d ]

When an async decrypt fails, tls_decrypt_done() records the error in
ctx->async_wait.err and calls tls_err_abort(), which stores it in
sk_err. tls_sw_recvmsg() and tls_sw_read_sock() each read
async_wait.err once they hold the reader lock and fail the call: a
record that did not authenticate breaks the connection.

tls_sw_splice_read() has no such check, and sk_err does not stand in
for one. tls_rx_rec_wait() tests sk_err only inside the loop it
skips whenever a record is already parsed, and the first reader to
reach sock_error() clears it, while async_wait.err persists. A
splice therefore keeps delivering records on a connection that
recvmsg() and read_sock() refuse to read.

Read async_wait.err in tls_sw_splice_read() as the other two readers
do.

Fixes: f314bfee81b1 ("tls: rx: return the already-copied data on crypto error")
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Chuck Lever <cel@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260806-tls-splice-crypto-fix-v1-1-a2624005a286@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f5af0db39cc2a..6f0b07fc97f63 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2287,6 +2287,11 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (err < 0)
 		return err;
 
+	/* If crypto failed the connection is broken */
+	err = ctx->async_wait.err;
+	if (err)
+		goto splice_read_end;
+
 	if (!skb_queue_empty(&ctx->rx_list)) {
 		skb = __skb_dequeue(&ctx->rx_list);
 	} else {
-- 
2.53.0




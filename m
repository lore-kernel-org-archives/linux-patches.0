Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF9D483817;
	Tue, 25 Aug 2026 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665728; cv=none; b=X37RRj0GUjkB2Rx7fqdT1ql84BEECRxFFS93NdNua0GiZp6xQ2ww+GvBp3OYDmeU7hVDMCuMLPG5ooYL1FPIgLJztIXucZFwUlLY4Ic5qtVI81ekCxlXl1g2mTWorv0aqvBbvqtCoPwTrf73pNsVUeEUZqXQWBgLmFJCbIUFaQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665728; c=relaxed/simple;
	bh=kiK4n9dZu7iEiL6CVftgJ87Uo8gKaCVuSa8x/VYpDFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGESWGSpHxhSx/HosDSl/EXwLxC0NcNyT9xOZuW9yAfaRkeoRii2/97+60Jn3g7x3P/mWRBSYvkUzlSO/79+Cd/ipG5tk3g+wes/e/1Wh24JFg5Kwdvgx0nMlPsmIuRO1zR9eQSmgv/lhnEDzESpxOQ0hB77/ic6XiOvspn9O2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+wqUL0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+wqUL0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293491F000E9;
	Tue, 25 Aug 2026 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665726;
	bh=e0/V730j8O+NL8DBwFHb7jECTNCSPAR2JgAFfgi1Xx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+wqUL0Ip9BW+anZZOIPnAUHe2eg5jicBmr/kxwozvjyfKObpl41UHF0w9Q2RLKmz
	 e3afFOjGcxOAjcxuCj78hEod7NhRE3kQausFD7Xsq5TQRr3XyJSf3/ZQPAJCCOYXlG
	 VUr32HCUscMRV2QX/DhzduXY+WyL9D5UubXdNzBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.6 45/87] nfc: st21nfca: validate ATR_REQ length against the received frame
Date: Tue, 25 Aug 2026 15:26:08 +0200
Message-ID: <20260825132543.613530598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 5cdcca5d62a66eda6b774110a44cba67bc1a8d1d upstream.

st21nfca_tm_recv_atr_req() checks that the received ATR_REQ frame is at
least ST21NFCA_ATR_REQ_MIN_SIZE and that the self-declared atr_req->length
is at least sizeof(struct st21nfca_atr_req), but never checks that
atr_req->length does not exceed the actual received length (skb->len).

st21nfca_tm_send_atr_res() then trusts the declared length:

	gb_len = atr_req->length - sizeof(struct st21nfca_atr_req);
	...
	memcpy(atr_res->gbi, atr_req->gbi, gb_len);

so an RF peer that sends a short frame but sets atr_req->length larger
than the frame makes gb_len exceed the general bytes actually present,
and the memcpy reads out of bounds past the received skb. Those bytes are
placed in the ATR_RES and sent back to the peer (kernel-memory disclosure
to a proximity attacker); a larger declared length is an out-of-bounds
read (DoS).

Reject frames whose declared length exceeds the received length. The
adjacent nfc_tm_activated() path in the same function already derives its
general-bytes length from skb->len rather than the declared field.

Found by 0sec (https://0sec.ai) using automated source analysis; the
missing bound is evident from source. Compile-tested.

Fixes: 1892bf844ea0 ("NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260711071301.58071-1-doruk@0sec.ai
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/st21nfca/dep.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nfc/st21nfca/dep.c
+++ b/drivers/nfc/st21nfca/dep.c
@@ -207,6 +207,9 @@ static int st21nfca_tm_recv_atr_req(stru
 	if (atr_req->length < sizeof(struct st21nfca_atr_req))
 		return -EPROTO;
 
+	if (atr_req->length > skb->len)
+		return -EPROTO;
+
 	r = st21nfca_tm_send_atr_res(hdev, atr_req);
 	if (r)
 		return r;



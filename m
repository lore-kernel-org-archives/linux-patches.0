Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF9D48094F;
	Tue, 25 Aug 2026 13:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664911; cv=none; b=QEzhQUeBMXxfk8KkwhXnnqDME6n1+Q/zLHPtEORiTwvrY6pQ1/hzKkD+Nt0DxtCa85ZRhuVwh/+yngTd/qdtjeebJyHo39KA3NoFwnKs0OSIAngwk70JL6/1D7tp70Upmz+F/o0oQXDWu5ifFNPpXhGIpYkvShgYVW+sfDXNbws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664911; c=relaxed/simple;
	bh=fGQSu0iJQQTs46t9GdcDEO/eLolhMLACNHvjLleh4pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wm3txyJj/ge6ytJG4ObNkBSKZMHeZYgPOXfWFShDWoLjrOwhahSD6ziS8a9GeJUsLRIFH5llhNZ1YqWCv4gwhGvuwvsaybvwJuHEvTBNYRFn9Hf2O+wF2+B9/12Fd10Xjhqz3sLF0FNzb5XgqfcF4hRdi7TKFbMFLd2GjXFDRw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tl5J0s1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tl5J0s1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EBD1F000E9;
	Tue, 25 Aug 2026 13:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664910;
	bh=rAqbNPtpaNyuh7QNYlAiYxNsZPJ0H+8v6aSjLjmQAGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tl5J0s1aYAyEPkjcvmApDaBVI/CXSXyMEJ7laVcaiw9EqBBGz2K8rFAEsgQLDpwF/
	 +SPBzX+bltho9V8wdqqGtgToH6GUYuEihBOjMxgZPHXtXpXhNuvBm+QefzqZjBGxHa
	 620MB9Po7Fl4/nqehpN5Sr4L454iZr20QxnhmEtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 7.1 044/101] nfc: st21nfca: validate ATR_REQ length against the received frame
Date: Tue, 25 Aug 2026 15:25:22 +0200
Message-ID: <20260825132543.743502223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -205,6 +205,9 @@ static int st21nfca_tm_recv_atr_req(stru
 	if (atr_req->length < sizeof(struct st21nfca_atr_req))
 		return -EPROTO;
 
+	if (atr_req->length > skb->len)
+		return -EPROTO;
+
 	r = st21nfca_tm_send_atr_res(hdev, atr_req);
 	if (r)
 		return r;



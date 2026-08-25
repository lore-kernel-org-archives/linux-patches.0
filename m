Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7684B45DF6B;
	Tue, 25 Aug 2026 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666198; cv=none; b=rLdasX0OdokkPXtTbOkgJy5bEv1xdc+1GJWAS3wRUga+iCQFT4glztoXPGdH0ZU+gn+W+PwXM95zn2o4hhTA5hMrZLTHiq726xt9JnLfBzxNgLI0MaSNy+OgHLSbG39ElUIeExFwKKc37TwSfIWYmalmWuPhtz6R1naZMvqz+9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666198; c=relaxed/simple;
	bh=JdRCM3SUFWnb3/3ZJ9XnCgtHi8ePE5mBI2YucopqByU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WonypMLZFmebD91mc5MahJ1iFvNpIZeyGNwbdMmCsfD/KugcZ/u8C6ujeM5cEVFr66DwusnGhvs03va2/CIXoGf5MLicA+mMyxT9zrXXuEs3yskaS6csDLvI8Nzrlswe76eKZstZsOEvh2YleWKquLCrMAOEDxSTdXZvS/YKcxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+II/FSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+II/FSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87D81F000E9;
	Tue, 25 Aug 2026 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666197;
	bh=SdwTKeHKiMg2V90SWYkmskihE8VFpm6UjbN72MV3LMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+II/FSeIS431BQG3r1ephBsao7jl8n3pxCtAuCfQTG7+ud970u84B2gfiwKn2/DG
	 ZJKIYu3JLxSM+Z1Gd7PFMp/VNmKNBQ9LNKUkYmArcMo0tRT8bp1z98D6Bph7t5wm5d
	 v5VFtJ2Tqv86Tjb92XvADEzOMLorvccZ24Qze9nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.15 36/76] nfc: st21nfca: validate ATR_REQ length against the received frame
Date: Tue, 25 Aug 2026 15:26:29 +0200
Message-ID: <20260825132542.981698938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



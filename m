Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60313E3C4D;
	Tue, 25 Aug 2026 13:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665202; cv=none; b=CKrCcnRV8DJ3o0k6N+wYWEE+QL/HPLKweiVhX6aWd3wtEK9TX67UkxDPcvMwP9ibAo27ge1PSKDZcj9xslXF3APHGGH91kKXzskRjnA59sIvKzvUgR9Ntzxtr0x97YbEvBCQafriF7M6yYeN9jLT7YiqjwuRhQGSW+KrrRoAv44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665202; c=relaxed/simple;
	bh=Eu0ReeYwvehRY5B2e+4ADjOln3NI514CzhOE+a2N1B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFcA7OHVEhAI3aslufwyhNlG6cy5wBzZ+Kai1hoGfnMx4PSpbYAGkXaTRWl864xfZtHTMrYAnEuK4Ojg4gpaRoewoW68v7vwfq9CvpKyxw5cTo3P9UeGwnw73ZqQwOMhr1KO2xsE2etaPakvndfREta3KwRS4uXaLKuWLIiSP5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2GbhE33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2GbhE33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0221F000E9;
	Tue, 25 Aug 2026 13:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665200;
	bh=ICf8f67FKRrFRaz7tPJQ3X57axbMJBX6Ufui44/cD5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2GbhE33m1AtsQfAHx7YTWnJr6wG1HePgVSqW5mb5TIP4FUTiY/UH6jcY2gN70fcG
	 IAV8BEChrImBz4R3Kb64T6zf+kCknjzi0Jyl6M89jleGWpREzxTiTn6TWikBr0Zs7c
	 T9GUyB2OU8ayXN8wWhTk2yyfin6s0QlAQYsBONDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.18 41/94] nfc: st21nfca: validate ATR_REQ length against the received frame
Date: Tue, 25 Aug 2026 15:25:37 +0200
Message-ID: <20260825132543.514138405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



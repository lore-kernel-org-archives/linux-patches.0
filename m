Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858C63D8912;
	Wed,  8 Apr 2026 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674185; cv=none; b=PAEkJSodo0fWofdC++KYb1NCaiRNJ8D7Zw1OkDlXvbIFkhKZYGfJinis0ULLyC4mO00ef/K4MWEDsa7G63n2t+DSusv6XlOZLyQSJsy8m+J2t7oZd66FrtgnmHxM+tKXCHS62/JQkJyG2TiZZkhyJOF9lWTi8JWlAJ2ipDjU10E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674185; c=relaxed/simple;
	bh=dW2z+4PlDKT2qPhznmgMZB+MUFlbWOzWe1JILRSxiPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFESwdLhhfU387m1mmabgawOIzUxMfjhRifsz86GEEZo4uRr4sAG6rAGcs7ca2j80UfZrrk0KZr4RhRDXAD2Xb2+Fk6/177EGzLft/Xkc7qqoLKSUjH1zSVMREUaQ39YMlzCJ0/l6lbjU71m8uLjJon2dceOSnQ20LFpb5PIC7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOsFCx32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOsFCx32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAA0C19421;
	Wed,  8 Apr 2026 18:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674185;
	bh=dW2z+4PlDKT2qPhznmgMZB+MUFlbWOzWe1JILRSxiPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOsFCx32ZiVaJrDhrhOCXDd2JlSdL/QwEHNRuoBCs0pMNwp8DbUCcPpvq04TdGKHP
	 YBWa7l3NGNdVBCts7CVda8M/YvBocFrfVwB/8G3JrShWLzD4rjNG+p6RPzhr4TXjjO
	 GI4FXeWegFUrLEO4QYVhsAuoI83Ek0HSSM26+Y1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taegu Ha <hataegu0826@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 211/242] usb: gadget: f_uac1_legacy: validate control request size
Date: Wed,  8 Apr 2026 20:04:11 +0200
Message-ID: <20260408175934.978649245@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taegu Ha <hataegu0826@gmail.com>

commit 6e0e34d85cd46ceb37d16054e97a373a32770f6c upstream.

f_audio_complete() copies req->length bytes into a 4-byte stack
variable:

  u32 data = 0;
  memcpy(&data, req->buf, req->length);

req->length is derived from the host-controlled USB request path,
which can lead to a stack out-of-bounds write.

Validate req->actual against the expected payload size for the
supported control selectors and decode only the expected amount
of data.

This avoids copying a host-influenced length into a fixed-size
stack object.

Signed-off-by: Taegu Ha <hataegu0826@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260401191311.3604898-1-hataegu0826@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac1_legacy.c |   47 ++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/function/f_uac1_legacy.c
+++ b/drivers/usb/gadget/function/f_uac1_legacy.c
@@ -360,19 +360,46 @@ static int f_audio_out_ep_complete(struc
 static void f_audio_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct f_audio *audio = req->context;
-	int status = req->status;
-	u32 data = 0;
 	struct usb_ep *out_ep = audio->out_ep;
 
-	switch (status) {
-
-	case 0:				/* normal completion? */
-		if (ep == out_ep)
+	switch (req->status) {
+	case 0:
+		if (ep == out_ep) {
 			f_audio_out_ep_complete(ep, req);
-		else if (audio->set_con) {
-			memcpy(&data, req->buf, req->length);
-			audio->set_con->set(audio->set_con, audio->set_cmd,
-					le16_to_cpu(data));
+		} else if (audio->set_con) {
+			struct usb_audio_control *con = audio->set_con;
+			u8 type = con->type;
+			u32 data;
+			bool valid_request = false;
+
+			switch (type) {
+			case UAC_FU_MUTE: {
+				u8 value;
+
+				if (req->actual == sizeof(value)) {
+					memcpy(&value, req->buf, sizeof(value));
+					data = value;
+					valid_request = true;
+				}
+				break;
+			}
+			case UAC_FU_VOLUME: {
+				__le16 value;
+
+				if (req->actual == sizeof(value)) {
+					memcpy(&value, req->buf, sizeof(value));
+					data = le16_to_cpu(value);
+					valid_request = true;
+				}
+				break;
+			}
+			}
+
+			if (valid_request)
+				con->set(con, audio->set_cmd, data);
+			else
+				usb_ep_set_halt(ep);
+
 			audio->set_con = NULL;
 		}
 		break;



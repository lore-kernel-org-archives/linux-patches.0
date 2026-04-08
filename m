Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A823ACEFB;
	Wed,  8 Apr 2026 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672796; cv=none; b=m7KgCkbtarDFJbFLzz89xn5zRRJTIiXdLohSwhR8CBFjOKYJHy9l4WLiBwD7fqm15goyKDUQfoAKCYRmoeAC5MUZzNS1qgGL86HLvV1heQmroKM8CNBgqX5yuFiLm9NFLiOdctVwN6TPA8F6bS1GAKSCnSppjwY2jyIJjoWTQqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672796; c=relaxed/simple;
	bh=d5feENmxwgqT1I2yq29s0VFt+IURlcalcHK6IOUG0rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuKr1+3L9E1IKMDzlMpwuCee8Mvtz5Oyp8yAKDoLT17PvzMehNa7zUV+D+r80heGE52NrqbKe62Rb2c/QTNqtQK4awAv6T20ENv3kvIGly8W6Zruo3MWRa9QG5vK8xcLBOdvDGgI15M6dIEPD4cocE8uARh3gb6fHPOUr6zmT+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IP9vb+Fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IP9vb+Fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0ABC19421;
	Wed,  8 Apr 2026 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672796;
	bh=d5feENmxwgqT1I2yq29s0VFt+IURlcalcHK6IOUG0rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IP9vb+FhCcl3svQH5emK2pDVvX/kqcPLigJQdpBr7hKeGjk9hORK3ziMly1wIEHES
	 Fz89r5MTrAc8y60U8b0L9HhLfIKfVYfgf2fKQHejAisQurLoTczmQ0Pq/IHE/xhN+s
	 BTfV/RpeXvpOFqB2e0spCCGZo6GlfmRILqnKwQvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taegu Ha <hataegu0826@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 146/160] usb: gadget: f_uac1_legacy: validate control request size
Date: Wed,  8 Apr 2026 20:03:53 +0200
Message-ID: <20260408175918.644488938@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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



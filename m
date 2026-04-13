Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E953231F9BC;
	Mon, 13 Apr 2026 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099623; cv=none; b=Dadi9v81LeKYEinaz4DrODjECDGVCgT7rWKPzIVoNHSM1zcLm3V5dDpgkufJ4J7/c9A3A22/YjzGon/DA862LYm4rznDCdWrmRzAfxbxouPP3NlFEtd1Zj1NzrUVApocVrb2LJflIp0uJlTjO9H2WgYZ71CX4bgGoQnTSAro9xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099623; c=relaxed/simple;
	bh=/kspHvZtvylmXJC7ieHAQt90p38GyAgZwPJkESiWZ5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0FA8Lu48HEX49BTMEFafG/zZB+GG5bSmZuJOzLLH+nZJfrwb5nwuKJXYY8GZowHtHcxv0h0JpPHaMj8xhkvjI9/2EjzZ7pgJ3317m0litEJb0tTRZmNu6XSGt3/rn3QHR1Y4UWspQp51AraRtC/doH2zXEiSoeRmsBKwY5l5Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNvFb+EN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNvFb+EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8091CC2BCAF;
	Mon, 13 Apr 2026 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099622;
	bh=/kspHvZtvylmXJC7ieHAQt90p38GyAgZwPJkESiWZ5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNvFb+ENoMdNkqBZU/k2Cws0UkZ1aE4fSTPAbA18ogogt4jlKkEDqQnW4OoX6TR/w
	 zvdj+oKEZ5JLfqjDMzjwETMAgyQDE+ptoJj28W9mJOHu5xCTRa2LZk57eVYAdLfdzC
	 WngLYpWk4g7EmCnGLPRQoalTAj4gIW70s8enHDOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taegu Ha <hataegu0826@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 411/491] usb: gadget: f_uac1_legacy: validate control request size
Date: Mon, 13 Apr 2026 18:00:56 +0200
Message-ID: <20260413155834.416971444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



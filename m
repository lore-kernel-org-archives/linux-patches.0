Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AA537C90E;
	Thu, 20 Aug 2026 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238153; cv=none; b=ZbsnkX6/EqaiL1jGbuUIAE5/3++2vbAILMQFQYaerXgNBRoabKKoB6tkyiL8W2sCTK4cWKQ3/OHv0Chq51xNX23mQaRJPEWu0VfVXmqrRNsTl1rRyodZlbw5veRSxYiF9IZaCB23QKlZR57WwalbIihURyFDuTvHe2PefT1CgRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238153; c=relaxed/simple;
	bh=GAzr/qW8Tnrx0z4bFandm5SicXy2Sb9PjzJsMwRs1Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePeGDoRf00u3UopLD9ZTLhRqVJ9zRuZSaYlgkkpMulSjX/IiXc8pmBjNR6o1VozpWfhk+XMbYkk7vokiHx/WaZW9GvVSAa0IJffpisHiASLnh8hWCL0Jwp5F2tbaDs2kz1NbUrEzyGXDBegr6Wf+OTyFSlOGF/tutPw2xReVWSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFmr6TCr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFmr6TCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9981F000E9;
	Thu, 20 Aug 2026 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238151;
	bh=6tfJTeOcBzKxAVbSbwbFRY+hae+bj3OoQ5pwnynaRI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFmr6TCryPNknLz8TdbT3uODczvNp4NmVeR6teW5lsARz8BxPIc2JzA4N3FUvX4KD
	 dgnJJGNYBC3LdwJ/XzcZ6RPpkJSyrkgWv7j7lq0nki7/RqJQcVW+Lg6z30Ns6CBpw4
	 JQa+tS8z9/ztrO++Qrjpudmp2bQQZBrqhS7Wqohc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 048/228] Input: iforce - validate input packet lengths
Date: Thu, 20 Aug 2026 16:53:10 +0200
Message-ID: <20260820145245.930629010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 5751c781d3c97ab6ce0e2a966156ed882152c415 upstream.

iforce_process_packet() reads fixed fields from joystick, wheel and
status packets without first checking their lengths. In particular, the
shared hats-and-buttons helper unconditionally reads data[6]. The status
tail is a sequence of 16-bit effect addresses, but an incomplete final
address is also consumed. A successful zero-length USB URB additionally
reads the packet ID before the common parser is called.

Reject the zero-length USB transfer, require the seven-byte joystick and
wheel prefixes and the two-byte status prefix, and consume only complete
status-tail addresses.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260720115018.75045-1-pengpeng@iscas.ac.cn
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/iforce/iforce-packets.c |   11 ++++++++++-
 drivers/input/joystick/iforce/iforce-usb.c     |    3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/input/joystick/iforce/iforce-packets.c
+++ b/drivers/input/joystick/iforce/iforce-packets.c
@@ -155,6 +155,9 @@ void iforce_process_packet(struct iforce
 	switch (packet_id) {
 
 	case 0x01:	/* joystick position data */
+		if (len < 7)
+			break;
+
 		input_report_abs(dev, ABS_X,
 				 (__s16) get_unaligned_le16(data));
 		input_report_abs(dev, ABS_Y,
@@ -170,6 +173,9 @@ void iforce_process_packet(struct iforce
 		break;
 
 	case 0x03:	/* wheel position data */
+		if (len < 7)
+			break;
+
 		input_report_abs(dev, ABS_WHEEL,
 				 (__s16) get_unaligned_le16(data));
 		input_report_abs(dev, ABS_GAS,   255 - data[2]);
@@ -181,6 +187,9 @@ void iforce_process_packet(struct iforce
 		break;
 
 	case 0x02:	/* status report */
+		if (len < 2)
+			break;
+
 		input_report_key(dev, BTN_DEAD, data[0] & 0x02);
 		input_sync(dev);
 
@@ -200,7 +209,7 @@ void iforce_process_packet(struct iforce
 			}
 		}
 
-		for (j = 3; j < len; j += 2)
+		for (j = 3; j + sizeof(u16) <= len; j += sizeof(u16))
 			mark_core_as_ready(iforce, get_unaligned_le16(data + j));
 
 		break;
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -158,6 +158,9 @@ static void iforce_usb_irq(struct urb *u
 		goto exit;
 	}
 
+	if (!urb->actual_length)
+		goto exit;
+
 	iforce_process_packet(iforce, iforce_usb->data_in[0],
 			      iforce_usb->data_in + 1, urb->actual_length - 1);
 



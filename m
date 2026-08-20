Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1588442B39;
	Thu, 20 Aug 2026 16:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244112; cv=none; b=Lhbd36Dx4wp7wFML59q3kQ0+zuRopZ6uXAS9OWxPEbvPaycNf4VM8Bw2iMuZ4ge8JpCZHQXQp+GEG5Jh97v4mUaZNNTL0DrDI9/VhWPx3jKHY2iJL8I3Sg1/oIUmU9afguzr7qYCC+k4RXtjkHRmdBS23fvjwH9rsl+SRXyxhkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244112; c=relaxed/simple;
	bh=AFSEUw4b066TSdVUKcDJr++/nwIm16ZI5NFlBq4TQLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSpmQU2afbvfgQfmsZ9l+mBIFwcFAI5inqgNpOYlm83D4SszkUSSZuNEz6V+v0zp8U9YRpMPWf0dFbYwo8BctSj0S1A/Cgavtn++bXpFJ8V5Fb5GbgPMGMmZGOXe2f/h27NSyOmmAcounJMgu7ZiwXTLlTfEbWuJpljaayfb7Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHOsyfEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHOsyfEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487CA1F000E9;
	Thu, 20 Aug 2026 16:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244110;
	bh=BImtivunzzv+zGJs2muqZ7OUwE7w1UD09n5xOVdmk/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yHOsyfErzs4zQPZ/sH4PmppJJ8nd/BQMb/4+6+fACCHSq9Kh4ph/IliODAXYKrWmy
	 kAxdEUoMiyOsPq8d6XNHCqex3uW+2WZeOTGDN2ZwiIMrzrbDU8oJf+L0JR3gZ3Ahgy
	 S50TZxDjkBIA2OjuCsuOJABPr4pJ6bOdTDC3L+RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 015/235] Input: iforce - validate input packet lengths
Date: Thu, 20 Aug 2026 16:54:11 +0200
Message-ID: <20260820145216.903886874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
@@ -161,6 +161,9 @@ void iforce_process_packet(struct iforce
 	switch (packet_id) {
 
 	case 0x01:	/* joystick position data */
+		if (len < 7)
+			break;
+
 		input_report_abs(dev, ABS_X,
 				 (__s16) get_unaligned_le16(data));
 		input_report_abs(dev, ABS_Y,
@@ -176,6 +179,9 @@ void iforce_process_packet(struct iforce
 		break;
 
 	case 0x03:	/* wheel position data */
+		if (len < 7)
+			break;
+
 		input_report_abs(dev, ABS_WHEEL,
 				 (__s16) get_unaligned_le16(data));
 		input_report_abs(dev, ABS_GAS,   255 - data[2]);
@@ -187,6 +193,9 @@ void iforce_process_packet(struct iforce
 		break;
 
 	case 0x02:	/* status report */
+		if (len < 2)
+			break;
+
 		input_report_key(dev, BTN_DEAD, data[0] & 0x02);
 		input_sync(dev);
 
@@ -206,7 +215,7 @@ void iforce_process_packet(struct iforce
 			}
 		}
 
-		for (j = 3; j < len; j += 2)
+		for (j = 3; j + sizeof(u16) <= len; j += sizeof(u16))
 			mark_core_as_ready(iforce, get_unaligned_le16(data + j));
 
 		break;
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -159,6 +159,9 @@ static void iforce_usb_irq(struct urb *u
 		goto exit;
 	}
 
+	if (!urb->actual_length)
+		goto exit;
+
 	iforce_process_packet(iforce, iforce_usb->data_in[0],
 			      iforce_usb->data_in + 1, urb->actual_length - 1);
 



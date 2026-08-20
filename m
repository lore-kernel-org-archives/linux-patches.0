Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C5E19049B;
	Thu, 20 Aug 2026 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243216; cv=none; b=X2BPYTnr87K0zeVHgEJo7qlHovTy8mR4aoOrKg3AIW4uw7kGTTbNLkledLezrbFs/Bb4GZvHOGS7eKQv4ejglK0Jijd28hYIneu0zbuLr6l9bLa4XKF5inREucL3C6i+gjRDQQcbjKgqgA3cnf5fuH0LNkd6jsspDrq1PbEE9dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243216; c=relaxed/simple;
	bh=e4tJCjKE18qbPQA5Sf7bUVcfmZcfjgTEaUh39zKQSKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRTRbuAKdoosMY6guGrcZu5CYkhCipFnybyo//CeUbPTpIs7Obvzf3r3o4bFaMncKbHy1ayzShXGL26NyU7UWQq7xWj2KDlq+LcPrzbqDJWmKiZbRZKwJezta/bzXiMZr2a/7jKJhkfL3wsQjTknk8XuC3PWAfOo4JXzIT5YuGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dxyu5ZBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dxyu5ZBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA1E1F000E9;
	Thu, 20 Aug 2026 16:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243214;
	bh=2D6abnyLJsc2ANPY8gD7C+S8teO1btqIj0B3eY9OILg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dxyu5ZBZvYVbBNb3CaymyVxPHdPI5qGJeQ2ZIeIoSg7mq9B7LYHnHYehnA9SaKVG5
	 ieY+BtY52FglvaYXQq890m/SmaSa2A4addbEBa2u6cEodB7rOVoGNIngnHC39gE1P+
	 wggn7VhYrtEx6Ff62xguKxUdXkxMWRj+u5a/hIlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 018/272] Input: iforce - validate input packet lengths
Date: Thu, 20 Aug 2026 16:53:22 +0200
Message-ID: <20260820145231.780682390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
 



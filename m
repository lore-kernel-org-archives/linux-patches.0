Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E543E0732;
	Fri,  7 Aug 2026 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113771; cv=none; b=We11u4xhAJ63oLWAQmco96UmH6N9WPsHGnZXLdJdNpqVUn5QR81cBOhwafpJXJ2Szu/URRu5WQw2LY/iGJ68wrvHTzBJLAzl2hjueeNwmQ6p0+EVkYcFtzW2n9mBLPWDNkP+0SLvJZAH2BFY+6v1/N2HM9DaekY5XJDt7UZJDWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113771; c=relaxed/simple;
	bh=/8TfETz8Fw8gwNz3LS91RNwKqIsBNNlq1aQRBhZepnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fflTjc2TADWKYndm39gOK911XV0zIPGKwQVBSBHTZZ92ziPtOnk98AHUwj4lIDS8kzrdGNJjEDTg9E/uQylMWJNOOZlc80TpYsp0osXpwR+7PhVTFlDgr9mYOgDC+B3q6nisgBdJZMIIld4gOVVOv5CTwMaM/LxJTivfvfx0tWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ig7lOvob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ig7lOvob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53BA1F00ACA;
	Fri,  7 Aug 2026 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113728;
	bh=u6w8FzQJ6TOK/keEUm5zYq7vMj5RmphAfe9zBL9/Zbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ig7lOvobzcVs6iKQZELuu+km7siLD+eAKohUSqTCkL+pXxoQsGZ7gxATf+5g/oyn3
	 AqCO7aZQUNrTIHycU4XjCxvlej8CRK0xbVxpLx55jwmgfVuMYy+IJ+LUz7TbCyJfD4
	 6zi4fB2JhbIkAqSoSraBnGt6XFqqJHNx99ahDsLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/337] HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT related user initiated OOB write
Date: Fri,  7 Aug 2026 16:33:38 +0200
Message-ID: <20260807143418.849473617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit b6a57912854e7ea36f3b270032661140cc4209cd ]

logi_dj_recv_send_report() assumes that all incoming REPORT_ID_DJ_SHORT
reports are 14 Bytes (DJREPORT_SHORT_LENGTH - 1) long.  It uses that
assumption to load the associated field's 'value' array with 14 Bytes of
data.  However, if a malicious user only sends say 1 Byte of data,
'report_count' will be 1 and only 1 Byte of memory will be allocated to
the 'value' Byte array.  When we come to populate 'value[1-13]' we will
experience an OOB write.

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index d6fb7015f0d77..3a37d61616293 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1750,6 +1750,7 @@ static int logi_dj_probe(struct hid_device *hdev,
 			 const struct hid_device_id *id)
 {
 	struct hid_report_enum *input_report_enum;
+	struct hid_report_enum *output_report_enum;
 	struct hid_report *rep;
 	struct dj_receiver_dev *djrcv_dev;
 	struct usb_interface *intf;
@@ -1793,6 +1794,15 @@ static int logi_dj_probe(struct hid_device *hdev,
 		}
 	}
 
+	output_report_enum = &hdev->report_enum[HID_OUTPUT_REPORT];
+	rep = output_report_enum->report_id_hash[REPORT_ID_DJ_SHORT];
+
+	if (rep->maxfield < 1 || rep->field[0]->report_count != DJREPORT_SHORT_LENGTH - 1) {
+		hid_err(hdev, "Expected size of DJ short report is %d, but got %d",
+			DJREPORT_SHORT_LENGTH - 1, rep->field[0]->report_count);
+		return -EINVAL;
+	}
+
 	input_report_enum = &hdev->report_enum[HID_INPUT_REPORT];
 
 	/* no input reports, bail out */
-- 
2.53.0




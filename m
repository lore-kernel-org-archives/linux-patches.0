Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCB51A681E;
	Fri,  7 Aug 2026 15:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115842; cv=none; b=OSzgX7FFYRaHPf+2YDBbcrJEB2/jG4WlpqF4d2v8pKPuoYtW4UEOlw7/+wOw2IfDmB/MJoY9AYQh7RxZxN7UHe/eRLQWggXmbJqxPGQhTDU85djtbGviYU84tjCow9OXCHPct2Rc8MVF//MUJOvw/JoO/1NbCI9w29prMJ8LGxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115842; c=relaxed/simple;
	bh=9dvaWbKLnGmKZEG1+rnWDSh2RLeoanJC908yI3T6rNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgO8PaOUJZY4teJHce+JWM8wpsUPe8uS11oDN4En4UbmylFuEqhCaCqsbjZR6Bcc/02Nd/UDPPEcuDSTS8YuEUV/kbSjXMxiadB/66pqBG/zkpv7nD6JOzvpi5gdN7GR/+2MFp9Osd6FSFdoiCFKX+OsFGiv/SyTNc94StN7mrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0TmPZ2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0TmPZ2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9998A1F00A3A;
	Fri,  7 Aug 2026 15:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115841;
	bh=V8utZuJ6ZYCuvrNIu7vNBfmMMGWXaEoSleujJ18w9M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0TmPZ2RdJF/Ot9Ai/mr6B6rflB4Y8L9Um9yj5idFyp1NCyIz2RmlvlPro7OQh/mL
	 Wc+WVC1Yy/Bi5/EXagwL38U/OWhR1diyicfPswxjFUCuNauBDlzhIrlUvyOdr4L/ta
	 otDE9im/YOGztHOww7DHthh/jKzC4ghE34gZSFWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/261] HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT related user initiated OOB write
Date: Fri,  7 Aug 2026 16:36:03 +0200
Message-ID: <20260807143415.501850878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
index 8b14a6062d181..3529fb55689a1 100644
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




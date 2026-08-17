Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F56D43F09A;
	Mon, 17 Aug 2026 14:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977181; cv=none; b=JYvQG0+03vJZqCw+gZ1NiIxsm5sB8bPoD2/m+xT6dps8lfAz86bir+Mfg/CI2IpJOJS9J1W9PhAHJBBnd0DT0DN0AyTWUfKWZh4wWkJ0WQiuevMFFBiRhy+zKM/5+i2CfswPcOaiQR4/3G/N6dap2U917ZeLaLKA4kkeAd9AxAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977181; c=relaxed/simple;
	bh=aQFxO+vVIuZyX8Y6zI3+pexIyUdfTIw40pwoFhFTJgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXyTvKk/JnVLR64IUqLTNXO4mpNa25OsoQ1gVywvqKm4BeUroN768JJ7qFxt6YosIeiOsHlDH3BCvo7TfAgOs+IihaAUflKfA1GyzZHN8Rdo5829nwncm/U1MD0nAoetGtGGpQJuFoL/5p1FiUJs5hHR+4ayI4cnMuh7oEOLmDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBbuMnMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBbuMnMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871201F000E9;
	Mon, 17 Aug 2026 14:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977180;
	bh=7NYZLLhTyHP8Duwn1e27jVD1cTscnZYhT42kybecpUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qBbuMnMaWlGmnQoa7BnycCmyPWL2KpB5B0TicEaRARtm78rUJBr1R3XEzN8tVVQFQ
	 tO3R7EJOIQHq+vuQFbB2HFWlDIJOL87lcHRPggiT9nPUBUNOOH2Fb+R3DAzdjj1yP1
	 YyuaEudfKuOH74ds6I9RahkepAafPw9Jh6DsGqn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/456] HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT related user initiated OOB write
Date: Mon, 17 Aug 2026 15:30:31 +0200
Message-ID: <20260817132549.504799238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 97b679e4cdbe3..591a8f56ad2e9 100644
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




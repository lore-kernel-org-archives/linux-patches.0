Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8516843E07D;
	Mon, 17 Aug 2026 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979670; cv=none; b=InqUNApD6JAahNOCgLqeJq0QU/d6D6kBye7tkNwhxP8kl1/ShLQ0lwFe+i5grQ7mXjn8EtIfgr4t5T8k/TtYiCEPWY92VzN2ml8qkdE28FwX03a2PeNW++XRg/Od+TDYsZzEeqdMqFiwnVqSvnTNcRxFwfCY1wTQYVf8D3Tt7F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979670; c=relaxed/simple;
	bh=E+AtrTgiV0kpB+G6wx7oBnHEjM3y+IO10l6k5Pkh+oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez8nClbcpolUiMBwKXTaTaneWfiH/fRE72VXKYNOKfpn1S5z1akXVw4+DYAstKUjyiZ1s03yGhNsDGV6XPo2MBEuHfQxIW4rcT5R/BE8RyQbDJNMBMhJrjBKwmDnwcOVKgasdftEv7flt41DkEX/Oku1zrv+C9IgqSUBWwwNjN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08KxM5Wl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08KxM5Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4E11F00A3A;
	Mon, 17 Aug 2026 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979668;
	bh=DHpMk44vtDYn+kLfTcCVLX/BPtCcAHfoNV9axToW6OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08KxM5WlXAj+ZNtCwsakR4JFnRwaP7RJPjGFtEmbbaTaXrJOu3b6c2zO6uFSvK45y
	 Opn9NeBwayLUVMxgKz1P+JNel1qTy7lQvKPTgHCBZMNYkLUcqj+xsK/mFpkNciPflV
	 vgrKQl2vxGrkh25wHywRC/vPbdk8VUuAywFfwEbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 305/609] HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT related user initiated OOB write
Date: Mon, 17 Aug 2026 15:30:01 +0200
Message-ID: <20260817132554.449909373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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




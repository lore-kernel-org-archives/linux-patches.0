Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677CB481649;
	Tue, 25 Aug 2026 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665074; cv=none; b=foSFBnjELnymxABV0Syt36vBHDrM4SzIgSGl5A9ymi2CTZF1pFYEM3brJuuiOe4qOOS/S2i0wmwKIjBdJMBKb9O+kDXkVtiSqbvJxX9e9+3Cw4fmT9QIrLHeYHz7eZn9v9zfylUXZbwzX0XJVGtDeqhVZNsFPjwuFlOyaihW4n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665074; c=relaxed/simple;
	bh=LSKxQvrxMvXmICoK6vt1Tugr02WXxaDkJuSq6ThF320=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLCwTpz7mRHYVK+ia6CNtYCJV52AgovIP4ZtUVv27VXJykDTsT9nXRddGQh5RPagi+KPzOc1w3xK/S9JXEqs9hAn2ajdzFE0OvQ99CpHx3W5DkJc02eiTMoZLK5QMKZv4hPPXAl6Qh5GPpVQh25FIK195xMMWelJQFSBD1dLsuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTOzGPGr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTOzGPGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95B11F000E9;
	Tue, 25 Aug 2026 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665073;
	bh=0IMj0wnTYzhTVHS3IICKWxtRIApYJlUrxKwNa6MjsJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTOzGPGrMUq31qC9VjfCIjvjXgIw42AAgTfvw04GN5nl/LCJp+Lj04LLEa+WTm+Ss
	 wuasD5btotZXMFovUk3kLhsWwc0QKtSiSMPfifrvr1Ypa7meet2yKigSc09j5m+Z5W
	 p9GSukjb0nNc1drilA+Chc8pi83Sg8zgJ4SuWiHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 101/101] Bluetooth: hci_aml: validate firmware segment lengths
Date: Tue, 25 Aug 2026 15:26:19 +0200
Message-ID: <20260825132545.692869408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit 2bf6b9baca9372ea51b6d0f2820dc9bf29a83ef4 upstream.

aml_download_firmware() reads two lengths from the firmware header and
uses them to build pointers before checking that the header and segment
data are present. A truncated or inconsistent firmware image can make
the driver read past firmware->data while constructing TCI commands.

Reject images shorter than the header and ensure that the ICCM and DCCM
ranges fit within the loaded firmware before downloading either segment.

Fixes: 37bac77e4649 ("Bluetooth: hci_uart: Add support for Amlogic HCI UART")
Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_aml.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_aml.c
+++ b/drivers/bluetooth/hci_aml.c
@@ -247,7 +247,7 @@ static int aml_download_firmware(struct
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	struct aml_serdev *amldev = serdev_device_get_drvdata(hu->serdev);
 	const struct firmware *firmware = NULL;
-	struct aml_fw_len *fw_len = NULL;
+	const struct aml_fw_len *fw_len = NULL;
 	u8 *iccm_start = NULL, *dccm_start = NULL;
 	u32 iccm_len, dccm_len;
 	u32 value = 0;
@@ -281,7 +281,21 @@ static int aml_download_firmware(struct
 		goto exit;
 	}
 
-	fw_len = (struct aml_fw_len *)firmware->data;
+	if (firmware->size < sizeof(*fw_len)) {
+		bt_dev_err(hdev, "Firmware is too small for its header");
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	fw_len = (const struct aml_fw_len *)firmware->data;
+	if (fw_len->iccm_len < amldev->aml_dev_data->iccm_offset ||
+	    fw_len->iccm_len > firmware->size - sizeof(*fw_len) ||
+	    fw_len->dccm_len > firmware->size - sizeof(*fw_len) -
+			fw_len->iccm_len) {
+		bt_dev_err(hdev, "Invalid firmware segment lengths");
+		ret = -EINVAL;
+		goto exit;
+	}
 
 	/* Download ICCM */
 	iccm_start = (u8 *)(firmware->data) + sizeof(struct aml_fw_len)



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A948124D;
	Tue, 25 Aug 2026 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665592; cv=none; b=DisQk6KrZqgKeEzgHDZzwbSBUJMhBlCZjQ4ApQ44ihwNljx/5KDlTeB+jbLA9LAX2KE/OeGHRCAwXHBjCes9yzItMyJFh3dySfs0JbrWRv3FF+0p+sTT+ctuu/LqnrURa+XOm2sW9zgRzwXgdEy7WK4IJtskH/Npd+2pPTlExgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665592; c=relaxed/simple;
	bh=6l17hm8gEjYinmylf4w+68nOVD4e7SN+FG4VVOnghA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WytlwweHjjBOrNtJGlmJS03S0inmZ0OAsr33oCD7eZfW3WN55O2RH2YnEo8DY3WwCLi/gH7q9Gelc4SjEDn0/kdP7QWETupyl3wcVOfxUP3DQKmFWNNMIIeFTlX0I3NZ52iqTbdtTNJFX/nTFZ7XDj7uHvpwJJxbtYjXtiaVRjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzGm4Wid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzGm4Wid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9140D1F000E9;
	Tue, 25 Aug 2026 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665590;
	bh=Q7cB7qCroq4kwET9zpe3lUuIUR010IsdQmLbjSHqvBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzGm4WidiQVGO6b5sHGIvLJVei/83Ee5WrI+34yybiPgCfIEbbW1Y7sykPp/xYVlE
	 flXf+REbXhAkJU27zwOU9grSpQODDiKxNl3L2+kdo0ur+vBahIwd3RGMES5SCrEpQW
	 LyKtwuK22/K/0VI3zB65Bl4+3a4Ic+zSMIhUccUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 77/77] Bluetooth: hci_aml: validate firmware segment lengths
Date: Tue, 25 Aug 2026 15:26:39 +0200
Message-ID: <20260825132544.528634179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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
 drivers/bluetooth/hci_aml.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/hci_aml.c b/drivers/bluetooth/hci_aml.c
index 959d9e67b669..067fbf278b44 100644
--- a/drivers/bluetooth/hci_aml.c
+++ b/drivers/bluetooth/hci_aml.c
@@ -247,7 +247,7 @@ static int aml_download_firmware(struct hci_dev *hdev, const char *fw_name)
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	struct aml_serdev *amldev = serdev_device_get_drvdata(hu->serdev);
 	const struct firmware *firmware = NULL;
-	struct aml_fw_len *fw_len = NULL;
+	const struct aml_fw_len *fw_len = NULL;
 	u8 *iccm_start = NULL, *dccm_start = NULL;
 	u32 iccm_len, dccm_len;
 	u32 value = 0;
@@ -281,7 +281,21 @@ static int aml_download_firmware(struct hci_dev *hdev, const char *fw_name)
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
-- 
2.55.0




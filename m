Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9222D40244F;
	Tue, 25 Aug 2026 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665359; cv=none; b=PP3UhvE3XOCk48GMFsSEJrrf/rogh4HyIWW5vl5AWbvX9mmyLEBkAUA7S9MQfX2h9bgxU/8bDaPrstv29nrBGLA7YCqrgxkuosZUdgMGShKvt7U7afSsi/4+3Z9ItUU2q/jEmmTwiT6NI2d+9i2bi+CbkJNOohtO66u74d/YtRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665359; c=relaxed/simple;
	bh=Fax3gbdw0bzL+G/KSNcZlR9djueEtW5nE2Hzc9O8EO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMsI5zLVBej5ywbQ8njRkslnDaIwpCipwi6k35cV7daAk67rdR4Silwykbi5GHpPKoxiiWNqwowV5Lxjl+Gq1SZFbaLERGSxfF0g1je6gQPJnABDVWo1eXTGG9a+jQBQqyxSG60AyxMWL9tMAyMFiq3qbCbFwOrgCWPbfN/8A/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvKoyLVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvKoyLVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB43B1F000E9;
	Tue, 25 Aug 2026 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665358;
	bh=oGeaBLWpR+309BkyxNrkJA0qMdosC3rgvEt6zKP4ro8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvKoyLVIIXpyRumP7hmEpKdfm08WWSHKZKEBFg2bgk6akBwNQdxCJE+nrRlGOfGj8
	 0dG6wKrm2Nt3oWnB2SyFBe6erC79G26XRcKDFmw/qpaoB8XKuy1nh+NEzD4tMpqPYT
	 qil7xG1u16jSiwpKUvqHheCNk1HfvZZ0Z7TSwdu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 94/94] Bluetooth: hci_aml: validate firmware segment lengths
Date: Tue, 25 Aug 2026 15:26:30 +0200
Message-ID: <20260825132545.395150868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



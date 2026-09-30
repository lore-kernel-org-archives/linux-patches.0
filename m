Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2251D4E2F09;
	Wed, 30 Sep 2026 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785601; cv=none; b=gMssDF5ZfxOa5hOvZjVZ7ll6AoFQKPcMDGTTUcSYteh6k02Hq5vFTl/S/Vv/+P61P1UVVTZwPy2Ejo1B5YpVUz5T3xQK41jSfOwB5LVnOl4AR+G6YtAvRMddEI8u3WWFRouKWnxMdD0u223sEeI4OX+GT/qAbSeRVD5BjuGXQYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785601; c=relaxed/simple;
	bh=ecsyK+h7Nq5wyQxSH9H2f1Ftk6tB04aXJw04hY2345w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tD9jSCWwkmQlSj5lKbdhVlFtO2UC1j8I2dfgrEVb+hCr1fzvVE1ezd2SvaMMDi9yHOfYGGoDNPDGwbbuX9y/heCiFsx3TiltU34eO1vuPaJoaLnGbqQBprWRXUJNtxGZLu3uSsgKBWSmCOlDEArHIj+clHDSkupD8YWPSsdiva4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thVEEM/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thVEEM/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40E81F000FF;
	Wed, 30 Sep 2026 16:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785588;
	bh=Mf0dyWJ+5pytMFeLqFQrl4awEuE79hhyeQzX+tX2cL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thVEEM/us3eHU5GcB4wacUtDEsTMDmrD0a5G5SPzdTFuAKqrp4I+5OPdrXQGtKQz3
	 H4JUaDaKFFZbuE8mq5YpLrcWVQse4XLflmD1xk2sa2V/+a/xS3DDh4gfCuk6wvHamr
	 jrWFXky7atlz5xhbgPjPjOkLxa9ZB5L+04O8+HrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 562/982] wifi: ath9k_htc: dont store usb_device_id
Date: Wed, 30 Sep 2026 17:21:38 +0200
Message-ID: <20260930152428.843111506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 14d2ac442d660e112efc0ce87ad10085013ed2b1 ]

usb_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from usb_device, so just store driver_data.

Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-1-632dcf3adfba@garyguo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 12 ++++++------
 drivers/net/wireless/ath/ath9k/hif_usb.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 7650f14dca8da..0a36fe39d5a25 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1099,7 +1099,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	}
 	kfree(buf);
 
-	if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+	if (IS_AR7010_DEVICE(hif_dev->id_info))
 		firm_offset = AR7010_FIRMWARE_TEXT;
 	else
 		firm_offset = AR9271_FIRMWARE_TEXT;
@@ -1194,7 +1194,7 @@ static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
 	if (MAJOR_VERSION_REQ == 1 && hif_dev->fw_minor_index == 3) {
 		const char *filename;
 
-		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+		if (IS_AR7010_DEVICE(hif_dev->id_info))
 			filename = FIRMWARE_AR7010_1_1;
 		else
 			filename = FIRMWARE_AR9271;
@@ -1210,7 +1210,7 @@ static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
 
 		return -ENOENT;
 	} else {
-		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+		if (IS_AR7010_DEVICE(hif_dev->id_info))
 			chip = "7010";
 		else
 			chip = "9271";
@@ -1267,9 +1267,9 @@ static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
 
 	ret = ath9k_htc_hw_init(hif_dev->htc_handle,
 				&hif_dev->interface->dev,
-				hif_dev->usb_device_id->idProduct,
+				le16_to_cpu(hif_dev->udev->descriptor.idProduct),
 				hif_dev->udev->product,
-				hif_dev->usb_device_id->driver_info);
+				hif_dev->id_info);
 	if (ret) {
 		ret = -EINVAL;
 		goto err_htc_hw_init;
@@ -1383,7 +1383,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 
 	hif_dev->udev = udev;
 	hif_dev->interface = interface;
-	hif_dev->usb_device_id = id;
+	hif_dev->id_info = id->driver_info;
 #ifdef CONFIG_PM
 	udev->reset_resume = 1;
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 5985aa15ca931..96c59af629982 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -115,7 +115,7 @@ struct cmd_buf {
 struct hif_device_usb {
 	struct usb_device *udev;
 	struct usb_interface *interface;
-	const struct usb_device_id *usb_device_id;
+	int id_info;
 	const void *fw_data;
 	size_t fw_size;
 	struct completion fw_done;
-- 
2.53.0




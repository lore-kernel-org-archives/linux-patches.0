Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5155E28382;
	Thu, 13 Feb 2025 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457366; cv=none; b=ryF/HbhJIc6JpGxs2OUotd4W/AB9UWaFln6a7FGXw956jWZAH4dvPmmVdiqWIxKl74JF8QU8DRA7r+EBFLTF+hV7QZBIp6FRVIKXMOsxIqLiYiDZk/mztSvi5dV0h12NbRHXZU6nVFocXNhrTpqo0zta0L+/IeJ+zjaNObZS1Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457366; c=relaxed/simple;
	bh=ltzvDAwSjFH9LaJGUOi2KnmH4aFgsAVm2kIR2WzAh8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHaw6fw8qBCJzt80PpqKbSe1DK3ah+3Wa8r3x4+djZ2j/qEKw+IfgXPm0kCnBQApxac9YXgnvyVBkH8ZIoiN8Qj7dVg1nVlZpyURfkGP8fq4FVrW19rdPO+5kfmQLV+uwe4iMq4nV6O5yynTrxLhoCL5BLagL2yYuwfaAOkHIj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAoA+R1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAoA+R1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E03C4CED1;
	Thu, 13 Feb 2025 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457366;
	bh=ltzvDAwSjFH9LaJGUOi2KnmH4aFgsAVm2kIR2WzAh8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAoA+R1X3QgO5PxNz6/5Jdx0bM1303s2Wt42fVYCzrmSXXz2myct8VsDZiifDWEbW
	 I4xYaGoaWIiuoW8GQcrGGfbkzaHMZS3deeXPvS5nD8BSK1OSKXXVaew6Eevwf1WLWU
	 LDptEit190MtL8fx1qQBGCmoWciXokDaj7hn/pZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enze Xie <enze@nfschina.com>,
	Youwan Wang <youwan@nfschina.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/422] HID: multitouch: Add quirk for Hantick 5288 touchpad
Date: Thu, 13 Feb 2025 15:23:26 +0100
Message-ID: <20250213142438.762760263@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Youwan Wang <youwan@nfschina.com>

[ Upstream commit b5e65ae557da9fd17b08482ee44ee108ba636182 ]

This device sometimes doesn't send touch release signals when moving
from >=2 fingers to <2 fingers. Using MT_QUIRK_NOT_SEEN_MEANS_UP instead
of MT_QUIRK_ALWAYS_VALID makes sure that no touches become stuck.

Signed-off-by: Enze Xie <enze@nfschina.com>
Signed-off-by: Youwan Wang <youwan@nfschina.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e07d63db5e1f4..369414c92fccb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2308,6 +2308,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY, USB_VENDOR_ID_SIS_TOUCH,
 			HID_ANY_ID) },
 
+	/* Hantick */
+	{ .driver_data = MT_CLS_NSMU,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			   I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288) },
+
 	/* Generic MT device */
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH, HID_ANY_ID, HID_ANY_ID) },
 
-- 
2.39.5




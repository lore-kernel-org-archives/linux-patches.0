Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B0244AB8E;
	Tue, 21 Jul 2026 21:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668207; cv=none; b=MU48gs8t72+aRvUvBpNxrIIfKhbpdNjoKt6FkEm0zIv4M8WqtmCSuK1eRIYw/Ck72r8rfwcEGPGnFfqLcQWGx++MXzB3yCwbsScjJHpcIP7keXhKBVi+CHqBrRDW20UXtlZv7UZAUTART1MIW/VWK68WkO9rbjV+BHqBFvk8AtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668207; c=relaxed/simple;
	bh=kLxW/JBobaBPbVXm1J9/R+fJ81pxGE7gQK2R+fNPBvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adxPs03kYy8MdwIHxgUAs11x7uXy+f3an1z8sK6KBM4tsz4q5pC0aDN1IKw9gK+7AfRzIe4JcsRewoYwGXspBdoRfDSUN8XZhp3+C3DoLRdKUqW67isXW+qFjnGGsey8FHreciMnEPUMuogDx+exH+XU8oXAvULcMf9BTRsSO+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvYQolyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvYQolyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8DA1F000E9;
	Tue, 21 Jul 2026 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668205;
	bh=ij9Ef1UZ5BWlYtaAXfaVc86mas+ndR4Qxvr8yvvOn0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvYQolyBafpEO2ETHpRKHpfA/sOlxtDNA60t2+xRqJmTb3YyWnOSS0CejmopO1OWT
	 9bwEKK2kRVQnhZOlDAwcuGubi9g9sctXE9k+xoCqpwj8ADu9uQ1A8im5dt+ecYkjG2
	 i2w70bSPdh0Yxj6LpdEdDNv8LWPGj44L/ErQUZ3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0087/1067] Bluetooth: btusb: fix use-after-free on registration failure
Date: Tue, 21 Jul 2026 17:11:28 +0200
Message-ID: <20260721152426.522603038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit eedc6867ebad73edbfaf9a0a65fbef7115cc4753 upstream.

Make sure to release the sibling interfaces in case controller
registration fails to avoid use-after-free and double-free when they are
eventually disconnected.

This issue was reported by Sashiko while reviewing a fix for a wakeup
source leak in the btusb probe errors paths.

Link: https://sashiko.dev/#/patchset/20260402092704.2346710-1-johan%40kernel.org
Fixes: 9bfa35fe422c ("[Bluetooth] Add SCO support to btusb driver")
Fixes: 9d08f50401ac ("Bluetooth: btusb: Add support for Broadcom LM_DIAG interface")
Cc: stable@vger.kernel.org	# 2.6.27
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4185,7 +4185,7 @@ static int btusb_probe(struct usb_interf
 
 	err = hci_register_dev(hdev);
 	if (err < 0)
-		goto out_free_dev;
+		goto err_release_siblings;
 
 	usb_set_intfdata(intf, data);
 
@@ -4194,6 +4194,15 @@ static int btusb_probe(struct usb_interf
 
 	return 0;
 
+err_release_siblings:
+	if (data->diag) {
+		usb_set_intfdata(data->diag, NULL);
+		usb_driver_release_interface(&btusb_driver, data->diag);
+	}
+	if (data->isoc) {
+		usb_set_intfdata(data->isoc, NULL);
+		usb_driver_release_interface(&btusb_driver, data->isoc);
+	}
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);



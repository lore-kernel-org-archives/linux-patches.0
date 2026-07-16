Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7BB3F482E;
	Thu, 16 Jul 2026 13:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209257; cv=none; b=RpibGnUiF4z3k0HbUcaAJFAKVUXb7Phmql/9tHoFOT/nKV7Hcb7OiNj/or/kgcaY/nbwqAv2qEB5UFws0w4RIlj6BKPc3+t5qXSEmvjIwEtX5aIoBP7TkCXDCYKtYEydlCYR+G047wkReQEK4/SWv2A0M6qhqSvuCPxppp87BTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209257; c=relaxed/simple;
	bh=i9Kfz9gBrz9rLNA/n0MKqZUr3Q8ThyVeS67yqbE5Ca8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cb7iPmJE06M4NtMMHNFbOrT1r0lUAQau3qy93LzSdycj3DvgXrPGQtN7ZRiNfphYxCTGBkp35MLDiCxitOCE75b18+741ACCo6LUMaK0scaeUhzIIWrONrw5ZWQ5WUveijN4+PTOTNKSNQlRd96ZiJ/+mxVdiUCfLCsV9mJAxRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdFjXeVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdFjXeVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F60B1F000E9;
	Thu, 16 Jul 2026 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209255;
	bh=5UN/eBN1aWbQg92wDSroMkVLLkYTmcvCvgBoz+wR5DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdFjXeVwsz3IaEnK9yo9MHvwyeV9lcMlbQF0V/spvmHmd3akQMa+NPnyEuATcKyPQ
	 P4nATllDxKQQh6SzRya/5fYEU17CIlzXY2oaTUfyU9tAeposhb0YZnxMfyMw9dujwr
	 GBo6Z4qvrgj9Qjovx0zassfjqEaGtmIUyhFnWLt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 114/518] Bluetooth: btusb: fix use-after-free on registration failure
Date: Thu, 16 Jul 2026 15:26:22 +0200
Message-ID: <20260716133050.345890788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -4409,7 +4409,7 @@ static int btusb_probe(struct usb_interf
 
 	err = hci_register_dev(hdev);
 	if (err < 0)
-		goto out_free_dev;
+		goto err_release_siblings;
 
 	usb_set_intfdata(intf, data);
 
@@ -4418,6 +4418,15 @@ static int btusb_probe(struct usb_interf
 
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



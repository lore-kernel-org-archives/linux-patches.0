Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BE937473A;
	Tue, 21 Jul 2026 21:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670993; cv=none; b=MKiB2mixXiFo57K5fzDoe7Za7VqFW+yyMyqHNCsafBBTyVky2IabURHSSr6iFNnP6zf45476j4a4dhLOWqC2rFhVPDfYcYBrtriEAUbiXSdyXGdtbiiY57Wqto8rYHr6rPk9PHx+QE0h9mjlUJUE9S3tLz584OzGfJTmxqQDjgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670993; c=relaxed/simple;
	bh=mi/KP2fp0M68tp52TKPiT54mqX1Vqeyh3mmsiwVPv00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3fn0gnnyQzyHtpyFlLA5qy4XzswmTolWCk5SAESdzC5CpJ1XZW4eWa5yZIaQLxWR5hyfchcw9yXIH0Ng8QXWZF2sCaOed/anSCFkAKJd99+5gDdQSyHEwo5eD8gKCUe/rtkfA1scQ00yNdeLym731XjJZloqMlfqOcqTH3iQyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzxNMAjb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzxNMAjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8581F000E9;
	Tue, 21 Jul 2026 21:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670992;
	bh=oLyeW4WyAVGfyFbq8ARz13VqZhZD2SQq0VNJtq5PjBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzxNMAjbiUlNsmuG7svPCNF1AKhEKU2wES01rXheR4xV9P/NcUmJKKoTpHgFKIDRO
	 J7UOUHmW7SgBxDmwJWswg4MG8M1xB7Lj+ycpiH+WG8wuVTatEeLYF4rC1akKxSjqWl
	 ZXWJEUdcM6nxZXcz8+97WlqVP7O746n+dSYdAORs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 076/843] Bluetooth: btusb: fix use-after-free on registration failure
Date: Tue, 21 Jul 2026 17:15:11 +0200
Message-ID: <20260721152407.702756068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -4108,12 +4108,21 @@ static int btusb_probe(struct usb_interf
 
 	err = hci_register_dev(hdev);
 	if (err < 0)
-		goto out_free_dev;
+		goto err_release_siblings;
 
 	usb_set_intfdata(intf, data);
 
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



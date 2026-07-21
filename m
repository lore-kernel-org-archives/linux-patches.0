Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91933375F81;
	Tue, 21 Jul 2026 22:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673167; cv=none; b=gaT3aPxXsA3Hfj//INCywS/D9jiyTvfJnFAEIvp7PQgMUrC0Lrc6MY4JyG+eW1o/fPhUzJ5Iv+hleGmTUlzt6bbnJgxJQcUtyI3cM7rQREsDhw8OnLK/pI6M4uRI7A8QaXrWbLrXUqyRGIkk45nzmxZ8xdPyKKYWctCD6OI3PeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673167; c=relaxed/simple;
	bh=TuuYVjc3KMepLXrKOPqW4de97P2RE1/xFMrTfPNA1WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiasHfqCqH7QOTZItCExLFiVpNd+rPqX5JrnBbqNT/2iKQn+mOhNdLgIYb6NAiy8KllibhMZOVPIFAjM5w0HCCMNMqIhpBM/ziDN27YjVCCBGtcvfmApiInnQtehTiXKYnlPLJnt9dwlikEua1VFE4VVnMssP7fG5pfW0kJCX/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crK0QdDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crK0QdDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D771F000E9;
	Tue, 21 Jul 2026 22:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673166;
	bh=oJ7UTQiovft/5CUL4KpzFSGt0hIAiF0brJ7SoZ3d9OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crK0QdDx/J0zM911CG9+vj6uFGrMcaalFMJ07vH617ui6dl1V/bzt3nYYk5OugNx6
	 K2dBIENB3EENppEelMhxSuT6jZ/awBjbUw3Dw+gCBmNr8XBlW1FHHejaceIx6fyYOm
	 0/I1us71ST4R/geHXv3IytEaJbwzgVcm6zqAg5dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 060/699] Bluetooth: btusb: fix use-after-free on registration failure
Date: Tue, 21 Jul 2026 17:16:59 +0200
Message-ID: <20260721152357.057727167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4369,12 +4369,21 @@ static int btusb_probe(struct usb_interf
 
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



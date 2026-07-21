Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD05434E4E;
	Tue, 21 Jul 2026 20:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664961; cv=none; b=gSvpBUKW8JyXlBIXi8ubKARusE5q1S+GgK69qPqO8nnZh3G84SaJor/bjz233aaZ6Ymp1RknfatSWtRbiZBJV9d52a3wvVJ1NyHfB+ilb5cae/CWcyAx3xEEXGbHGMhpvQKRCnpeY5aX+aMwZGP+qw5KHwynDy27NnZdwMTv8lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664961; c=relaxed/simple;
	bh=9VuEm/T2kpYWA7aMwiis1JXSWREnPC87JYst+hZdfGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzDyIDPfMEJ7IZl+bh073/E9UC83ojYVPSrKIR9cuLKoo5yCdJ9gYxwLU5zbjHLtIjHxsVTm8V+aNsStY4nf56c3u5xB8x39BPY7pmOxkJAC5WA7OXV1cJIX61VjAf5rUdBCR9b3GXpTX0QSjNzwPIBYq8RBcEXWmPeXs7ns5aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdTd9do7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdTd9do7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB021F000E9;
	Tue, 21 Jul 2026 20:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664960;
	bh=kNgw8Bl6FUtNJWtwFF7VMcacXuehRPiMmJaEIooS0Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdTd9do7HyVcuDBx+VHmorpmoh6ei1n9PLhb7zWoSP9oRdBQscaZqHyZ/qQqwtBs1
	 mFwfjZtn+Sef7P3UXvdpCPbqDgQFcHPtxmM2h+bAvEudb4nBUuHA8Km/6VMPsZfhUb
	 0AWZcQ2+LhVx6KcjokbuPMYTaVO+FgknGJW6421E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0123/1266] Bluetooth: btusb: fix use-after-free on registration failure
Date: Tue, 21 Jul 2026 17:09:20 +0200
Message-ID: <20260721152444.554363219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4078,7 +4078,7 @@ static int btusb_probe(struct usb_interf
 
 	err = hci_register_dev(hdev);
 	if (err < 0)
-		goto out_free_dev;
+		goto err_release_siblings;
 
 	usb_set_intfdata(intf, data);
 
@@ -4087,6 +4087,15 @@ static int btusb_probe(struct usb_interf
 
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



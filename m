Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFA02DF132;
	Tue, 17 Mar 2026 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765921; cv=none; b=WjZg9iAs4JOpKl98QGkk1GURTcE65XyK/I+1rbPbwU7OeRH1QQnn2eXRjbrvNvQLc+KgfiStouqGTBN7U/yCFYxt2BLQcrjFWAGJyaRsAw/LTY3z45Phr8JlxW6gkCg3uDG4GkpAX3JYsBLniUSCPbQDaYwC+2DNgdoVJTOjeKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765921; c=relaxed/simple;
	bh=DIO67tpfSx2E5W9EBjcjsZym9e2iXO+2bBM/JFThLZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKO2/AJzV0uTcppC/n3R5qivKacM40CmgaF17scZuDG8izBy1gGtT1EHT3/QEQKVmKKtOI653u+JKFFq7H9PfZ2H84Qhd+w/C/trOqFGjsHHRgRDxYDyWzZXlzuyY0/OZ1jw7Tnjx+tVOeuuHzn5/d0CxPVOwkxovsMpc7LOW24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bImQ/wm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bImQ/wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5019BC4CEF7;
	Tue, 17 Mar 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765921;
	bh=DIO67tpfSx2E5W9EBjcjsZym9e2iXO+2bBM/JFThLZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bImQ/wmb41S4UyulGkJI46L1tQQ21LkonebTHoKqC/ewbUu+Muvsm4P6IQthlqT0
	 ktnk+64+HnzmIdtPN+tB3zUF7eQ3eDS3nSfseYGK8j32Fs2Tmy4XxsAoH6FdZRMDTe
	 5Ef6OocUsRPhfhRefoWRLom0HPUWoWUKp5+fN5yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.19 125/378] gpib: lpvo_usb: fix unintended binding of FTDI 8U232AM devices
Date: Tue, 17 Mar 2026 17:31:22 +0100
Message-ID: <20260317163011.613841642@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 163cc462dea7d5b75be4db49ca78a2b99c55375e upstream.

The LPVO USB GPIB adapter apparently uses an FTDI 8U232AM with the
default PID, but this device id is already handled by the ftdi_sio
serial driver.

Stop binding to the default PID to avoid breaking existing setups with
FTDI 8U232AM.

Anyone using this driver should blacklist the ftdi_sio driver and add
the device id manually through sysfs (e.g. using udev rules).

Fixes: fce79512a96a ("staging: gpib: Add LPVO DIY USB GPIB driver")
Fixes: e6ab504633e4 ("staging: gpib: Destage gpib")
Cc: Dave Penkler <dpenkler@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260305151729.10501-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c
+++ b/drivers/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c
@@ -38,8 +38,10 @@ MODULE_DESCRIPTION("GPIB driver for LPVO
 /*
  * Table of devices that work with this driver.
  *
- * Currently, only one device is known to be used in the
- * lpvo_usb_gpib adapter (FTDI 0403:6001).
+ * Currently, only one device is known to be used in the lpvo_usb_gpib
+ * adapter (FTDI 0403:6001) but as this device id is already handled by the
+ * ftdi_sio USB serial driver the LPVO driver must not bind to it by default.
+ *
  * If your adapter uses a different chip, insert a line
  * in the following table with proper <Vendor-id>, <Product-id>.
  *
@@ -50,7 +52,6 @@ MODULE_DESCRIPTION("GPIB driver for LPVO
  */
 
 static const struct usb_device_id skel_table[] = {
-	{ USB_DEVICE(0x0403, 0x6001) },
 	{ }					   /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, skel_table);



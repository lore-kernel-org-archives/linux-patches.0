Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1453B995D;
	Tue, 21 Jul 2026 21:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667957; cv=none; b=FDXjxXdB5x+PGRRh2GgISR6fiPrNCajKfR5I4nbBs5EFeT6qgNTTZOl/zQAcaggEnhZ1mg7cmAzE+2k+kpiQ55cuqHl0L3fAO3lLFCbXsbIXxaLm7mPY7m2RcUQ0p/2UvfWPc4bymUACZZA07V4k26VNmfBSrTYP8kfaD0BOwZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667957; c=relaxed/simple;
	bh=OCGl4LE4xua+sihvrhTWD45+mNvkodzRLcMwL1vSfZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5akZAUQO3X311YvGIACiSR1zgvh0/2spBAQB61AE/HRVUtY3xjyh1Mh/8+Fy/3G4ndAyFfOXUn/saox76CJIbdzvIub75zJMjbq+9jXUlPbzF1MNiiyr+BIVfzETQNcH2Y95NWswNG4yz6/PjkFHpSAHgInIVaBGTdTPqIUjeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hnb5yBTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hnb5yBTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B1F1F000E9;
	Tue, 21 Jul 2026 21:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667956;
	bh=+yuxtX2qzkAmws4pmI+n5QAAt3eXPq9L9kmW4DMbA7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hnb5yBTr8ZFWMJiABkbsHpGd6fPIFBzXAmniemnnCqKufHnVdJ+xsL3nlW25nFs3T
	 lATV4JwYFRre6H2P8m5qvTblW1SiaHU0maO0IdPrHyJ/8rD5CqFxDT7+lo2XXRvSzD
	 t+sUPz3edIcN0M9vyugQXJoih40H7AkSRyJuqsg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1258/1266] Bluetooth: btmtk: Fix btmtk.c undefined reference build error harder
Date: Tue, 21 Jul 2026 17:28:15 +0200
Message-ID: <20260721152509.974947466@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 61f7a8f975456d7be21100ee0936389142b95a81 upstream.

The previous fix was incomplete as the link failure still persists
with CONFIG_USB=m when the sdio or serial wrappers for btmtk.c
are build-in:

btmtk.c:(.text+0x468): undefined reference to `usb_alloc_urb'
btmtk.c:(.text+0x488): undefined reference to `usb_free_urb'
btmtk.c:(.text+0x500): undefined reference to `usb_anchor_urb'
btmtk.c:(.text+0x50a): undefined reference to `usb_submit_urb'
btmtk.c:(.text+0x92c): undefined reference to `usb_control_msg'
btmtk.c:(.text+0xa92): undefined reference to `usb_unanchor_urb'
btmtk.c:(.text+0x11e4): undefined reference to `usb_set_interface'
btmtk.c:(.text+0x120a): undefined reference to `usb_kill_anchored_urbs'

Disallow this configuration.

Fixes: f0c83a23fcbb ("Bluetooth: btmtk: Fix btmtk.c undefined reference build error")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -412,6 +412,7 @@ config BT_ATH3K
 config BT_MTKSDIO
 	tristate "MediaTek HCI SDIO driver"
 	depends on MMC
+	depends on USB || !BT_HCIBTUSB_MTK
 	select BT_MTK
 	help
 	  MediaTek Bluetooth HCI SDIO driver.
@@ -424,6 +425,7 @@ config BT_MTKSDIO
 config BT_MTKUART
 	tristate "MediaTek HCI UART driver"
 	depends on SERIAL_DEV_BUS
+	depends on USB || !BT_HCIBTUSB_MTK
 	select BT_MTK
 	help
 	  MediaTek Bluetooth HCI UART driver.



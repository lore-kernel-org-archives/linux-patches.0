Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF81F3B7B7B;
	Fri,  4 Sep 2026 05:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499212; cv=none; b=siS9YjTo2YtT2wwpPZPancUhhtvLgkACXUnviu33EaJARH17YsWgLUcwaKyBuDlGtFKB8QMtQKeVnK6MWqIJMW3OGGMfCMJFUtZseYs8NoYtqwvyuConbIffBN4tEDzMl2fFiTu+nSH5tjpUaDxQaTQWHeapc1a+KyBlJHC/N+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499212; c=relaxed/simple;
	bh=60KHFZCwct36KsIRdKlfDwiLvdkBj4zIS1N3wRSJUQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXgrkRr7b9f3L8/7ZXxIePLCWdPoCReexXObpPqqijv+Fy6O1ZSNzT4OdZkY9uC6qePeyXUR13UuSYhP7IZrd4aX0pa66OD42+TULNw/Q3q1xrObByeI1k5uutWrCMoLVUt2L+0QSrO6xUbD9nrwdAVvVeXdkfYbiY+A/BXAlsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksJdJhXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksJdJhXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D121F00A3D;
	Fri,  4 Sep 2026 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499210;
	bh=vgQBg2F25678XME3Tmu2h+43LKas6Ofx7Ud/LxnEeyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksJdJhXJF5sLiTAQbrvopPJ/PEcEE3G1xq3MVB0fucmtYkllSCYHP2GnHTiEgi16M
	 +LdJZHQ0c+8pKNPmDtP7HRLIctRoURIDpg0eTyGPT4AyqLC/sxNI/p4rVqyEJ2sAfJ
	 V7kxiw+t2bMoUvanYwN7/JWbXoQPmyq8tdZeuoJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Sven Peter <sven@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 337/713] Bluetooth: hci_bcm4377: Ignore reserved PHY in ext adv reports on BCM4378
Date: Fri,  4 Sep 2026 06:55:05 +0200
Message-ID: <20260904045811.381047735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit aec6a8d80e3da0ab5c9303a0281fd06d077f8716 upstream.

Commit ed2a2ef16a6b ("Bluetooth: Add quirk to ignore reserved PHY bits in
LE Extended Adv Report") added a quirk to handle creative use of the
reserved bits in the PHY fields for 4388 controllers in Apple silicon.

I observed the same issue with the BCM4378 Bluetooth controller (14e4:5f69,
rev 05) on an Apple MacBook Pro (13-inch, M2, 2022):

> HCI Event: LE Meta Event (0x3e) plen 51
      LE Extended Advertising Report (0x0d)
        Num reports: 1
        Entry 0
          Event type: 0x2513
            Props: 0x0013
              Connectable
              Scannable
              Use legacy advertising PDUs
            Data status: Complete
            Reserved (0x2500)
          Legacy PDU Type: Reserved (0x2513)
          Address type: Random (0x01)
          Address: EA:C1:82:F0:24:C6 (Static)
          Primary PHY: Reserved
          Secondary PHY: No packets
          SID: no ADI field (0xff)
          TX power: 127 dBm
          RSSI: -57 dBm (0xc7)
          Periodic advertising interval: 0.00 msec (0x0000)
          Direct address type: Public (0x00)
          Direct address: 00:00:00:00:00:00 (OUI 00-00-00)
          Data length: 25

This results in the firmware rejecting connection attempts with
"Unsupported Feature or Parameter Value" (0x11).

Fix the issue by using the same quirk for BCM4378 devices too.

I tested this locally and confirmed that the issue is resolved.

This was observed when attempting to connect a Kinesis Advantage 360
keyboard to the MacBook.

Assisted-by: Claude:claude-fable-5
Fixes: 2e7ed5f5e69b ("Bluetooth: hci_sync: Use advertised PHYs on hci_le_ext_create_conn_sync")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm4377.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/hci_bcm4377.c
+++ b/drivers/bluetooth/hci_bcm4377.c
@@ -2490,6 +2490,7 @@ static const struct bcm4377_hw bcm4377_h
 		.has_bar0_core2_window2 = true,
 		.broken_mws_transport_config = true,
 		.broken_le_coded = true,
+		.broken_le_ext_adv_report_phy = true,
 		.send_calibration = bcm4378_send_calibration,
 		.send_ptb = bcm4378_send_ptb,
 	},



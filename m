Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9DF1A08CA;
	Mon, 12 May 2025 17:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072229; cv=none; b=n3BVvjqIVds63/IaBTTmhIL5fxwtyBMyXgyhar0AcHBfBhTzoMQ3cZF7ybL/5DItbeBkbb9t6IT7IzLcyZEBjKXoUVoecynbQugq2mzAW+PcNQt10vhV3x9zbL+HZM3PGVmvkE/L1sxQK6TmfNk7OeTyMAQucJ2D1TOy3rU8tVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072229; c=relaxed/simple;
	bh=4zhWYaRvcWMA/Ou5tUdLdiuKNdPpti21wKp67uc7QRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbFViS6L7fJPqMr9TaJ4LMfkt9JkxDStIOsF43199kPC5WlNyuICB9Eu45nbOsF7FKQXr3L2np5ySyqbJyehLolMADUATPCzarLvubvKRBgDF3fIf1eWInBbqdHuMapBT0uy0/ShbQz4TCybsGl9eXkLj9F6kWGZfdliMR7I+ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwiHSIC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwiHSIC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810D3C4CEE7;
	Mon, 12 May 2025 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072229;
	bh=4zhWYaRvcWMA/Ou5tUdLdiuKNdPpti21wKp67uc7QRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwiHSIC23wZkfYsVW4KxEBjNr1RRRLEzjnK2kTJBY2DSt1f4G5Bg5hLCYL9a7RhSz
	 mpOzQzQUwqy7OD9px3+vqSI5N71A7DGFp8N2SZnZY7ETs3L1V71wd+XmHqzCrFGMgb
	 EFOb1Bzy9Cqnes3aE53imtPZcvvlAzFZNx3yDwVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Qin <hao.qin@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	"Geoffrey D. Bennett" <g@b4.vu>
Subject: [PATCH 6.14 175/197] Bluetooth: btmtk: Remove the resetting step before downloading the fw
Date: Mon, 12 May 2025 19:40:25 +0200
Message-ID: <20250512172051.513389579@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Qin <hao.qin@mediatek.com>

commit 33634e2ab7c6369391e0ca4b9b97dc861e33d20e upstream.

Remove the resetting step before downloading the fw, as it may cause
other usb devices to fail to initialise when connected during boot
on kernels 6.11 and newer.

Signed-off-by: Hao Qin <hao.qin@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: "Geoffrey D. Bennett" <g@b4.vu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtk.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1330,13 +1330,6 @@ int btmtk_usb_setup(struct hci_dev *hdev
 		break;
 	case 0x7922:
 	case 0x7925:
-		/* Reset the device to ensure it's in the initial state before
-		 * downloading the firmware to ensure.
-		 */
-
-		if (!test_bit(BTMTK_FIRMWARE_LOADED, &btmtk_data->flags))
-			btmtk_usb_subsys_reset(hdev, dev_id);
-		fallthrough;
 	case 0x7961:
 		btmtk_fw_get_filename(fw_bin_name, sizeof(fw_bin_name), dev_id,
 				      fw_version, fw_flavor);
@@ -1345,12 +1338,9 @@ int btmtk_usb_setup(struct hci_dev *hdev
 						btmtk_usb_hci_wmt_sync);
 		if (err < 0) {
 			bt_dev_err(hdev, "Failed to set up firmware (%d)", err);
-			clear_bit(BTMTK_FIRMWARE_LOADED, &btmtk_data->flags);
 			return err;
 		}
 
-		set_bit(BTMTK_FIRMWARE_LOADED, &btmtk_data->flags);
-
 		/* It's Device EndPoint Reset Option Register */
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_EP_RST_OPT,
 					      MTK_EP_RST_IN_OUT_OPT);



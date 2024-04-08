Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D6D763F1;
	Mon,  8 Apr 2024 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582515; cv=none; b=HoMkRQJiq5VBeOhI3JduWARQ7tIXOnRwvSGu6G7qhO0wrQgX27scTVouzTcU+dookoslIqapuExNizLGxZ8ouhc2pVpmyVvCPB6mFe2LYCsLHI5m+KXSSQobsKQa/wmd4uCWHwW5lxvm5xzhEVtt45mvCTpOp2lD8JFT4M9TBzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582515; c=relaxed/simple;
	bh=46rNilz9F7LBQqUEog4kgx6swTz2eNmNxoNMv6p/NIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2JTDcqXXDUYSWYKBdjQ+O9QNukuCgPwqVfwqvK9v1BvSJM8XKEBbyqLjEHGGQPMjj+aqqjW4u933giIXZfQ+QMwUBV91MmV8JLSBduxOsSk9BJ9bK4ArDiETFEdHLYDXZXGkP3y5ogL8NYAx+6KGpnXxBnwYTwkrs7tKoThIoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ef3NXWYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ef3NXWYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC412C433F1;
	Mon,  8 Apr 2024 13:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582515;
	bh=46rNilz9F7LBQqUEog4kgx6swTz2eNmNxoNMv6p/NIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ef3NXWYMKC005me7ELRLYTvFiOJvmP7809XNd+I483EhrcSDg4L0mqF/jaRCgE7Sr
	 QxGdcEwy/JAFTGGJPmAX9cjw30WZdNiQT5mzBTsby1Nyeh1/cxL08m9QPZlc4B+qsj
	 /Vo5mr9h4CS4crBKSgnavyhDTr05FWgxWY/zZ/S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
	Matthias Kaehlcke <mka@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Nikita Travkin <nikita@trvn.ru>
Subject: [PATCH 6.8 075/273] Bluetooth: qca: fix device-address endianness
Date: Mon,  8 Apr 2024 14:55:50 +0200
Message-ID: <20240408125311.633682004@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 77f45cca8bc55d00520a192f5a7715133591c83e upstream.

The WCN6855 firmware on the Lenovo ThinkPad X13s expects the Bluetooth
device address in big-endian order when setting it using the
EDL_WRITE_BD_ADDR_OPCODE command.

Presumably, this is the case for all non-ROME devices which all use the
EDL_WRITE_BD_ADDR_OPCODE command for this (unlike the ROME devices which
use a different command and expect the address in little-endian order).

Reverse the little-endian address before setting it to make sure that
the address can be configured using tools like btmgmt or using the
'local-bd-address' devicetree property.

Note that this can potentially break systems with boot firmware which
has started relying on the broken behaviour and is incorrectly passing
the address via devicetree in big-endian order.

The only device affected by this should be the WCN3991 used in some
Chromebooks. As ChromeOS updates the kernel and devicetree in lockstep,
the new 'qcom,local-bd-address-broken' property can be used to determine
if the firmware is buggy so that the underlying driver bug can be fixed
without breaking backwards compatibility.

Set the HCI_QUIRK_BDADDR_PROPERTY_BROKEN quirk for such platforms so
that the address is reversed when parsing the address property.

Fixes: 5c0a1001c8be ("Bluetooth: hci_qca: Add helper to set device address")
Cc: stable@vger.kernel.org      # 5.1
Cc: Balakrishna Godavarthi <quic_bgodavar@quicinc.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Tested-by: Nikita Travkin <nikita@trvn.ru> # sc7180
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c   |    8 ++++++--
 drivers/bluetooth/hci_qca.c |   10 ++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -826,11 +826,15 @@ EXPORT_SYMBOL_GPL(qca_uart_setup);
 
 int qca_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr)
 {
+	bdaddr_t bdaddr_swapped;
 	struct sk_buff *skb;
 	int err;
 
-	skb = __hci_cmd_sync_ev(hdev, EDL_WRITE_BD_ADDR_OPCODE, 6, bdaddr,
-				HCI_EV_VENDOR, HCI_INIT_TIMEOUT);
+	baswap(&bdaddr_swapped, bdaddr);
+
+	skb = __hci_cmd_sync_ev(hdev, EDL_WRITE_BD_ADDR_OPCODE, 6,
+				&bdaddr_swapped, HCI_EV_VENDOR,
+				HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		err = PTR_ERR(skb);
 		bt_dev_err(hdev, "QCA Change address cmd failed (%d)", err);
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -225,6 +225,7 @@ struct qca_serdev {
 	struct qca_power *bt_power;
 	u32 init_speed;
 	u32 oper_speed;
+	bool bdaddr_property_broken;
 	const char *firmware_name;
 };
 
@@ -1842,6 +1843,7 @@ static int qca_setup(struct hci_uart *hu
 	const char *firmware_name = qca_get_firmware_name(hu);
 	int ret;
 	struct qca_btsoc_version ver;
+	struct qca_serdev *qcadev;
 	const char *soc_name;
 
 	ret = qca_check_speeds(hu);
@@ -1904,6 +1906,11 @@ retry:
 	case QCA_WCN6855:
 	case QCA_WCN7850:
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
+
+		qcadev = serdev_device_get_drvdata(hu->serdev);
+		if (qcadev->bdaddr_property_broken)
+			set_bit(HCI_QUIRK_BDADDR_PROPERTY_BROKEN, &hdev->quirks);
+
 		hci_set_aosp_capable(hdev);
 
 		ret = qca_read_soc_version(hdev, &ver, soc_type);
@@ -2284,6 +2291,9 @@ static int qca_serdev_probe(struct serde
 	if (!qcadev->oper_speed)
 		BT_DBG("UART will pick default operating speed");
 
+	qcadev->bdaddr_property_broken = device_property_read_bool(&serdev->dev,
+			"qcom,local-bd-address-broken");
+
 	if (data)
 		qcadev->btsoc_type = data->soc_type;
 	else



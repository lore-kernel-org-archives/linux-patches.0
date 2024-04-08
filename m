Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88C670CDA;
	Mon,  8 Apr 2024 13:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582249; cv=none; b=jENP85DBCptbIrNsYQBGsLME5AN7pChbG0Ucpwt+d19QuyxR5znS4SU4B5l9ciyTT2wpE9tTmCcF0hFl7AAsonZV7QtvJbVrjj9kRuFz3u+KP0y3KUbW7j5yWRfOd5MGmtD9OjUzt+91sGCGfVG3ETByeOBA8mv3DA3bokoNFTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582249; c=relaxed/simple;
	bh=U0/HVNlJl2RIz7ukhfD3Tm3NZwSL0/E+5OFF9WbeiXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUtWXC0419kXMp5fKDMY9AoWisN0SW6K9mns2O64vmnezzuCV66Nezo5OuuNyeQc9DXUdVxINyHxgwJjUTcRpz5ORC8HUeGmnM9c7fapaiGjbvTjx6QkDkr3kvafkWKK8q1e7JU5lFEpQt5g0NTYpePs15sOmkkmoInj6s0akLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i483n418; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i483n418"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F34AC433F1;
	Mon,  8 Apr 2024 13:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582249;
	bh=U0/HVNlJl2RIz7ukhfD3Tm3NZwSL0/E+5OFF9WbeiXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i483n418GZdU13AlhafmTTnKW/1mSx++0azZQNNPceq7FiirKOZLNg/LnH9YZYTqv
	 8g8zk5F3S6neeHMj/8IIEsql0cZqC4TJG3bXLheAAEqEWUKAn9nykRaDMebz+jMJtj
	 jG52ROEnF+seF/ThcZ8rzhB5WHJT1dIQs7SrAjts=
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
Subject: [PATCH 6.6 078/252] Bluetooth: qca: fix device-address endianness
Date: Mon,  8 Apr 2024 14:56:17 +0200
Message-ID: <20240408125309.060040158@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -758,11 +758,15 @@ EXPORT_SYMBOL_GPL(qca_uart_setup);
 
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
 
@@ -1824,6 +1825,7 @@ static int qca_setup(struct hci_uart *hu
 	const char *firmware_name = qca_get_firmware_name(hu);
 	int ret;
 	struct qca_btsoc_version ver;
+	struct qca_serdev *qcadev;
 	const char *soc_name;
 
 	ret = qca_check_speeds(hu);
@@ -1882,6 +1884,11 @@ retry:
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
@@ -2253,6 +2260,9 @@ static int qca_serdev_probe(struct serde
 	if (!qcadev->oper_speed)
 		BT_DBG("UART will pick default operating speed");
 
+	qcadev->bdaddr_property_broken = device_property_read_bool(&serdev->dev,
+			"qcom,local-bd-address-broken");
+
 	if (data)
 		qcadev->btsoc_type = data->soc_type;
 	else



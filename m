Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ED355E4C;
	Tue,  9 Jul 2024 11:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524694; cv=none; b=ETzbs9cVAfoZ+mMCMk/B4RAUsSL8U9aUcnyw3U/jcZHAdbxeYsVqx37cNnauHcB93/dgx73+G7zJ2eJIuFQjnFnxOhyZVC6Urs/DoRXMaa0ht7c4tZQUytdwpvAcNuApK1bw7Up/qN/CE5w65htzg2HQ7GPcP0mqiSvFQHWYGPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524694; c=relaxed/simple;
	bh=JgJTA/HmDmvmbnDXzmQNZQX7oqi3LF94LUMpG6t6zZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQ4Bpq9YRx3vGvirIyLHiIdVfG+du0zAth2Rw5Tv2PoTfnaiCvEiK/UyemvgWSM+Swrx5k1py4L4ir2DGjn8Okl/L1CFM8TtF0I5uCaGcalsp5TS95XzHwPGPgnm8tGa4YQ2cbdZ2tZv5IGUghnx1d7bjlcWA4+xDxEWI1PalBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJvMUKvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJvMUKvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00F3C3277B;
	Tue,  9 Jul 2024 11:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524694;
	bh=JgJTA/HmDmvmbnDXzmQNZQX7oqi3LF94LUMpG6t6zZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJvMUKvCfPpxfcQmTZ3SywRombeYqVG/mNldtMvi6w4xpLDp0hGfivUCj3DYpMsbn
	 Br9AhR7pKkl/P7Z9rsAznlr30djMg2qwXUHrjibLviKJS6zqrNWhmSye9JVEohA5Rg
	 MAashii4Fy/fCIx73ooGKoIWg36NK9kJ0jL8BQH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wren Turkal <wt@penguintechs.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 070/102] Bluetooth: qca: Fix BT enable failure again for QCA6390 after warm reboot
Date: Tue,  9 Jul 2024 13:10:33 +0200
Message-ID: <20240709110654.104349057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 88e72239ead9814b886db54fc4ee39ef3c2b8f26 upstream.

Commit 272970be3dab ("Bluetooth: hci_qca: Fix driver shutdown on closed
serdev") will cause below regression issue:

BT can't be enabled after below steps:
cold boot -> enable BT -> disable BT -> warm reboot -> BT enable failure
if property enable-gpios is not configured within DT|ACPI for QCA6390.

The commit is to fix a use-after-free issue within qca_serdev_shutdown()
by adding condition to avoid the serdev is flushed or wrote after closed
but also introduces this regression issue regarding above steps since the
VSC is not sent to reset controller during warm reboot.

Fixed by sending the VSC to reset controller within qca_serdev_shutdown()
once BT was ever enabled, and the use-after-free issue is also fixed by
this change since the serdev is still opened before it is flushed or wrote.

Verified by the reported machine Dell XPS 13 9310 laptop over below two
kernel commits:
commit e00fc2700a3f ("Bluetooth: btusb: Fix triggering coredump
implementation for QCA") of bluetooth-next tree.
commit b23d98d46d28 ("Bluetooth: btusb: Fix triggering coredump
implementation for QCA") of linus mainline tree.

Fixes: 272970be3dab ("Bluetooth: hci_qca: Fix driver shutdown on closed serdev")
Cc: stable@vger.kernel.org
Reported-by: Wren Turkal <wt@penguintechs.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218726
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Tested-by: Wren Turkal <wt@penguintechs.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2385,15 +2385,27 @@ static void qca_serdev_shutdown(struct d
 	struct qca_serdev *qcadev = serdev_device_get_drvdata(serdev);
 	struct hci_uart *hu = &qcadev->serdev_hu;
 	struct hci_dev *hdev = hu->hdev;
-	struct qca_data *qca = hu->priv;
 	const u8 ibs_wake_cmd[] = { 0xFD };
 	const u8 edl_reset_soc_cmd[] = { 0x01, 0x00, 0xFC, 0x01, 0x05 };
 
 	if (qcadev->btsoc_type == QCA_QCA6390) {
-		if (test_bit(QCA_BT_OFF, &qca->flags) ||
-		    !test_bit(HCI_RUNNING, &hdev->flags))
+		/* The purpose of sending the VSC is to reset SOC into a initial
+		 * state and the state will ensure next hdev->setup() success.
+		 * if HCI_QUIRK_NON_PERSISTENT_SETUP is set, it means that
+		 * hdev->setup() can do its job regardless of SoC state, so
+		 * don't need to send the VSC.
+		 * if HCI_SETUP is set, it means that hdev->setup() was never
+		 * invoked and the SOC is already in the initial state, so
+		 * don't also need to send the VSC.
+		 */
+		if (test_bit(HCI_QUIRK_NON_PERSISTENT_SETUP, &hdev->quirks) ||
+		    hci_dev_test_flag(hdev, HCI_SETUP))
 			return;
 
+		/* The serdev must be in open state when conrol logic arrives
+		 * here, so also fix the use-after-free issue caused by that
+		 * the serdev is flushed or wrote after it is closed.
+		 */
 		serdev_device_write_flush(serdev);
 		ret = serdev_device_write_buf(serdev, ibs_wake_cmd,
 					      sizeof(ibs_wake_cmd));



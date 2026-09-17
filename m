Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D18C522EFC;
	Thu, 17 Sep 2026 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665986; cv=none; b=CE5JgzsC0wDRyyxomooyM3zHn+F/8rfDEWqo2aRaNrcnk55LsRSaQO0whkp5VsqMRlliFBX+kFm++S4aV900sX8sL+oKU+Ym4aXLeIDnJD7G6ROjGMei78eWunTxikscimlrFZDCHKaA8wRQ8w/P/+HEHb3Ql2cVzPXiHcp8Ros=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665986; c=relaxed/simple;
	bh=L/R/DRFejrHXH1Vr5GTPG22XRJQZ/QM8E5FgiU1qMvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/NiQek04oc4Vd+YcpmBHGpftwO9mzpn4fqWAk8tSLYCKECbxbyeRe7VbCYDj25hlLWSc5TgiZmn03nb1ej4FtotNvVnt12+H7EEoBguIEI5ZzEuKhIYmmLs4aZvAbrhiVtl/Bp6R/lA4x0b8GOjmnOMPRd4AoL4RqdRp14ndes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyHLBYF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyHLBYF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841CC1F0089A;
	Thu, 17 Sep 2026 17:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665985;
	bh=992YupAdQ6U3gvI6SGvpfEUMdxqAc+7l8UtKn53kwrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyHLBYF4gtOrxthDttAq1Y4EKHk0DN0RW85HoYvUdRtqblAz9NP+UxGo1ems86ko6
	 7wKid3R6t8n5ARkIfsylVBRsuOwXrQFFg8+Rs9g6JL/M8OSSN/7NtBeVt4lq+u7g6v
	 LMrSmCZcZOkGyePF5VjK8aZ7ublI8WZJ3Up6dHLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0885/1250] Bluetooth: btusb: Fix leaked runtime PM reference in btusb_reset
Date: Thu, 17 Sep 2026 16:11:20 +0100
Message-ID: <20260917151615.969766039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiajia Liu <liujiajia@kylinos.cn>

[ Upstream commit c93922dd316b7273a8667d29084632066fa8a2d3 ]

btusb_reset calls usb_autopm_get_interface to resume the device
before queuing a reset of it, but never calls the matching
usb_autopm_put_interface.

usb_queue_reset_device ends up in usb_reset_device(), and since
btusb provides no pre_reset/post_reset callbacks the interface is
merely unbound and rebound: the interface device object survives
this cycle, and so does its PM usage count, which is not cleared
when the driver is unbound.

As a result every reset permanently leaks a PM usage reference,
preventing the interface from being runtime suspended again until
it is unbound.

Set BTUSB_RESET flag before usb_queue_reset_device so that
btusb_disconnect drops the reference. If the flag is already set,
drop one reference.

Fixes: c9209b269afd ("Bluetooth: btusb: Introduce generic USB reset")
Assisted-by: Claude:qwen3.8-max
Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index b71486097b1ad..81b25c0231c4b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1013,13 +1013,15 @@ static void btusb_reset(struct hci_dev *hdev)
 	int err;
 
 	data = hci_get_drvdata(hdev);
-	/* This is not an unbalanced PM reference since the device will reset */
 	err = usb_autopm_get_interface(data->intf);
 	if (err) {
 		bt_dev_err(hdev, "Failed usb_autopm_get_interface: %d", err);
 		return;
 	}
 
+	if (test_and_set_bit(BTUSB_RESET, &data->flags))
+		usb_autopm_put_interface_no_suspend(data->intf);
+
 	bt_dev_err(hdev, "Resetting usb device.");
 	usb_queue_reset_device(data->intf);
 }
-- 
2.53.0




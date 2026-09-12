Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0E034DB6D;
	Sat, 12 Sep 2026 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226158; cv=none; b=TTteNZmX3b/H8ywOw1GD12ZozE1Unfzlpy4TJOx93FrFyafys3+jzIJaSySoW8ap77gG40BcEPGOz0nZJK4LPWSSM2g08myo2fnBZ0d8tn61sINn3oi/1fy/82Y42Kv5ypXuq7IKLbDVPbjKW9WOAbfOxoaiDl3Xc/68AoslTSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226158; c=relaxed/simple;
	bh=ir1cfmIeicyE5mM5PLcVjgfDva1MFE2g2JBU4tqh83I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVNe0bAZZdNvx6FTz8Todnrfx0h5bgpa19s/HKUIjdGC5c9vGmjOVOSNp5b6kwoHF2OoHoIsG2YHAaUakeYzqV0aVELetG3+1+hsFPBgza32WkWaG/FOaQ3e6y67eZoZ+vfV86+IB69wn+aNexA2lWV1kvh9ZYC2EQBH/WpG/sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yT0nFpZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yT0nFpZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4334F1F000FF;
	Sat, 12 Sep 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226157;
	bh=D0+uDRlMR+C/3MrGy1DANWl21Y7tPwBIAX+b2gdI6jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yT0nFpZEwM4t+YjU3Yy1Dp2EG95EI8/74Lt4dJORo043SF5rv+06jzjzxjb73jRKy
	 SVPqXq3OYdN6LrTiEUX2kY2YnrVxWuAzaZt5zqyBkASfG2KBEnmVScv/rAJvomvmvw
	 vDKo+2ktAP33Vr6vSFRjIJrd5syho8xtjNux7G/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismail Tarim <ismailtarim7@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1345/1424] Bluetooth: btmtk: Do not discard the subsystem reset timeout
Date: Sat, 12 Sep 2026 09:02:57 +0200
Message-ID: <20260912065637.381507521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ismail Tarim <ismailtarim7@gmail.com>

[ Upstream commit 21b50c24843b51f88ac4316dd470d2803da0c42f ]

When the MTK_BT_RST_DONE poll times out, btmtk_usb_subsys_reset() logs
"Reset timeout" and keeps the error in err, but err is then overwritten
by the return value of the following btmtk_usb_id_get() call, so the
timeout is never reported to the caller.

Commit 25b6d7593a3a ("Bluetooth: btmtk: introduce btmtk reset work")
discarded the return value of the chip id read, so the function returned
the timeout error as intended. Commit 3dcb122b3064 ("Bluetooth: btusb:
mediatek: return error for failed reg access") started assigning err at
that call and silently dropped it.

Keep the timeout in a separate variable and return it, restoring the
original behaviour without changing the control flow.

Fixes: 3dcb122b3064 ("Bluetooth: btusb: mediatek: return error for failed reg access")
Signed-off-by: Ismail Tarim <ismailtarim7@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index d424c6a9be3a2..fe9710a236d9d 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -822,6 +822,7 @@ static u32 btmtk_usb_reset_done(struct hci_dev *hdev)
 
 int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 {
+	int reset_err = 0;
 	u32 val;
 	int err;
 
@@ -920,8 +921,10 @@ int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 
 	err = readx_poll_timeout(btmtk_usb_reset_done, hdev, val,
 				 val & MTK_BT_RST_DONE, 20000, 1000000);
-	if (err < 0)
+	if (err < 0) {
 		bt_dev_err(hdev, "Reset timeout");
+		reset_err = err;
+	}
 
 	if (dev_id == 0x7922) {
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_UDMA_INT_STA_BT, 0x000000FF);
@@ -933,7 +936,7 @@ int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 	if (err < 0 || !val)
 		bt_dev_err(hdev, "Can't get device id, subsys reset fail.");
 
-	return err;
+	return reset_err;
 }
 EXPORT_SYMBOL_GPL(btmtk_usb_subsys_reset);
 
-- 
2.53.0




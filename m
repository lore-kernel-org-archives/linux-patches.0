Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3108C47CA71;
	Sat, 12 Sep 2026 13:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219100; cv=none; b=rwv5kiJ5LurHtJDDII+ZhiOdlW0opdNOdwKJk3TqehzJjRlsRWfA+qihxXeSkK6OZXQ3geH9EB0S6f3V6b4ImIYRl4cyxQ0nLrLCO26kNtPJiMdjjDHBlSexhfe4KgLWQY9cbEDQz/bqFdmOf5zcnR/Hr9yOWvgPHkbDVk8i3vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219100; c=relaxed/simple;
	bh=nx7vC+4WrQ3Kt3HF+4zTSjL7mqQcao4icuAzUkQfbpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFKekU0YLMLJSQnqTxoKl0Rus/QzvH9RwH5qjCxCL/H2SZnyBT7SSMax8lj/XQXtMJ8uMXXfM9eVy9b6xlg9twWAeDPh1KStRka5Ewb4o4oX3YKx22ddKi2yo3fvSR6yAzWt8TrEsWKPyttKd56OuNtC0PNzUDtU9lg/x5PqNFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hT/T+REd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hT/T+REd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF851F000FF;
	Sat, 12 Sep 2026 13:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219097;
	bh=0eGTrWXcdYeLZFgI95SxRUDvAF8LnSiGh8po5JepGp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hT/T+REd8i4v1emxkWgDFbwATrvjowmaOy98oeEQK8ASedcMGjYzLIlciktqA7Wnn
	 Jdt+xXAZ/OTjqznK1JJZzPbPJtyXGEzkjVhOjcM7bGqvaE1acpkg6hd7ska5TczVol
	 7T/Ylxh3OBp/PAvov8r1mm9tsde5D837Sg/lL5IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismail Tarim <ismailtarim7@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1280/1376] Bluetooth: btmtk: Do not discard the subsystem reset timeout
Date: Sat, 12 Sep 2026 09:01:46 +0200
Message-ID: <20260912065636.068307826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9f35ca1c60d76..7e7ce595d5923 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -848,6 +848,7 @@ static u32 btmtk_usb_reset_done(struct hci_dev *hdev)
 
 int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 {
+	int reset_err = 0;
 	u32 val;
 	int err;
 
@@ -946,8 +947,10 @@ int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 
 	err = readx_poll_timeout(btmtk_usb_reset_done, hdev, val,
 				 val & MTK_BT_RST_DONE, 20000, 1000000);
-	if (err < 0)
+	if (err < 0) {
 		bt_dev_err(hdev, "Reset timeout");
+		reset_err = err;
+	}
 
 	if (dev_id == 0x7922) {
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_UDMA_INT_STA_BT, 0x000000FF);
@@ -961,7 +964,7 @@ int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 		return err ? err : -ENODEV;
 	}
 
-	return err;
+	return reset_err;
 }
 EXPORT_SYMBOL_GPL(btmtk_usb_subsys_reset);
 
-- 
2.53.0




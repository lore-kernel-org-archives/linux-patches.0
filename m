Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65936438487;
	Thu, 30 Jul 2026 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421639; cv=none; b=qz+mqliOvZki2envJnTynSvEgb/MYLL+Qc7Hfg6LmeJIpmo0eUdYHhRQRjH36I2AHiJj8SmT7TbZbwDmKpLpUOZkcVdTVLXbpKtjUkuiyWRcd1d3CSBc6N7h3nlx4Ch0dMWwvLCCx206ZaHD+r0i+8IzmF28thD52fl2547PJ70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421639; c=relaxed/simple;
	bh=OXu1K4PdivBPJAU6BdBgswcoHnuogj4dKN9deHzDWDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F6a99LPeTyf0WclrcQ80iGAdzFTyEFnTtLdGCq/qKK8juWq42xVwhF32gPgr2o1BieWwc2MjV0CiCWFYHpxTyW1vXwWbL0c3rjBhQo3upURyvHmWn/LuAZ+Q+nNC0rH5+swB3/SNlN1sOBmnrrucRtyoBen908lGllk371qJfBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAEkASuw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAEkASuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F4D1F000E9;
	Thu, 30 Jul 2026 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421637;
	bh=HHS0k3XF6eXmL87jxiQMJMzIAz8RHndTiflb2I1y4ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAEkASuw+H/VqoHkTVI97RltWMoQOnz9a6EwC3BUx0K21IRa/YgI/cWVJzf+tMCPq
	 gJuzHixAx9LxyxQs5hBB5YSXo04ToOTtoW/OTcvMw/qbi5hgv6KcGHTSIP2xrMxRxL
	 Bql8k3uRU8KsyWsnwyZiPyqg5R3RsQhZfw4c0EOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+50122cbc2874b1eb25b0@syzkaller.appspotmail.com,
	Cheng Yongkang <teel4res@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 169/744] wifi: ath9k: hif_usb: dont dereference hif_dev after re-arming firmware request
Date: Thu, 30 Jul 2026 16:07:22 +0200
Message-ID: <20260730141447.883970562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Yongkang <teel4res@gmail.com>

[ Upstream commit dad9f96945d77ecd4708f730c06ef54dcd8cc057 ]

ath9k_hif_request_firmware() re-arms an asynchronous firmware load via
request_firmware_nowait(), passing hif_dev as the completion context, and
then still dereferences hif_dev:

	dev_info(&hif_dev->udev->dev, "ath9k_htc: Firmware %s requested\n",
		 hif_dev->fw_name);

The re-armed callback ath9k_hif_usb_firmware_cb() runs on the "events"
workqueue and, when the firmware is missing, walks the retry chain into
ath9k_hif_usb_firmware_fail() -> complete_all(&hif_dev->fw_done). That
releases the wait_for_completion(&hif_dev->fw_done) in a concurrent
ath9k_hif_usb_disconnect(), which then kfree()s hif_dev. The trailing
dev_info() in the frame that re-armed the request can therefore read freed
memory (hif_dev->udev, the first field of struct hif_device_usb):

  BUG: KASAN: slab-use-after-free in ath9k_hif_request_firmware
  Read of size 8 ... by task kworker/...
   ath9k_hif_request_firmware
   ath9k_hif_usb_firmware_cb           drivers/net/wireless/ath/ath9k/hif_usb.c:1247
   request_firmware_work_func
  Allocated by ...:
   ath9k_hif_usb_probe                 drivers/net/wireless/ath/ath9k/hif_usb.c
  Freed by ...:
   ath9k_hif_usb_disconnect -> kfree   drivers/net/wireless/ath/ath9k/hif_usb.c

The fw_done barrier only makes disconnect wait for the firmware chain to
*terminate*; it does not protect the outer ath9k_hif_request_firmware()
frame that re-armed the request and keeps touching hif_dev afterwards.

Drop the post-request dev_info(): it is the only use of hif_dev after the
async request is armed, and it is purely informational (the dev_err() on the
failure path runs only when request_firmware_nowait() did not arm a callback,
so hif_dev is still alive there).

This was first reported by syzbot as a single, non-reproduced crash that was
later auto-obsoleted, and was independently rediscovered by the reFuzz fuzzer,
which produced a C reproducer (USB-gadget connect/disconnect of an ath9k_htc
device whose firmware download fails). The vulnerable code is unchanged and
still present in v7.1-rc6, where the slab-use-after-free reproduces under KASAN
once the (sub-microsecond) race window is widened.

Fixes: e904cf6fe230 ("ath9k_htc: introduce support for different fw versions")
Reported-by: syzbot+50122cbc2874b1eb25b0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=50122cbc2874b1eb25b0
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260605153210.20471-1-1020691186@qq.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 821909b81ea917..44855ec5be7453 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1225,15 +1225,10 @@ static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
 	ret = request_firmware_nowait(THIS_MODULE, true, hif_dev->fw_name,
 				      &hif_dev->udev->dev, GFP_KERNEL,
 				      hif_dev, ath9k_hif_usb_firmware_cb);
-	if (ret) {
+	if (ret)
 		dev_err(&hif_dev->udev->dev,
 			"ath9k_htc: Async request for firmware %s failed\n",
 			hif_dev->fw_name);
-		return ret;
-	}
-
-	dev_info(&hif_dev->udev->dev, "ath9k_htc: Firmware %s requested\n",
-		 hif_dev->fw_name);
 
 	return ret;
 }
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32A424EA90;
	Mon, 17 Aug 2026 14:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976713; cv=none; b=m5jP/LAyul0NooTp06xZvuwy7IVlGPoomTtFJCm3Q5nyKFVyTz9+8FkBaINGGMfrl4uXPx4A+H15FtcaFh1tu5R68gnzMgo6yGrK2WpnfG0ZqvWl3IanrMIg3p+IeeRqTHDuWL8jHGBmW163SKKk5udQksmv3+QUIjZz7R1gIi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976713; c=relaxed/simple;
	bh=Lj1zuAT1TJtCFrC7wY19wOA5cEB8flQSDtXuRY+XiEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rM2q7YDwI4plhPgb9JRKySFHgOUbYB/jm8o1aXnRPV4CxYF0q3NjZo+bb1CEZ+E4pKLvFRwskQrH5lw98jmSVQo1xGGa3Adq86yQjvg+UxwutXXyy7J3fKcAiqY+My6EU1wlrxsGgJJCSP+d26mgQqTsvFkRoh+kokPPg3jkuTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muUGBnTg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muUGBnTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190351F000E9;
	Mon, 17 Aug 2026 14:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976711;
	bh=DU6JrJEpd2ZAFdEyzGL4VD/QedJ1RQRUhbaufuwat+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muUGBnTgzOVHhCtwpcdAauNBSsUY9ZC3dDpyuGYJwXGmHFD4C7cfGlF2BmC1XUwf8
	 FV700LP5rXjc0vr6HcY91oMpiQJmeP+PwnD7EpDrvW2JJToPBsV/zYGc0Giv/g+a7v
	 nQQOT2oZjKu8OZtI565ewfgMtTHB8GBWpSZxAF2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+50122cbc2874b1eb25b0@syzkaller.appspotmail.com,
	Cheng Yongkang <teel4res@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/456] wifi: ath9k: hif_usb: dont dereference hif_dev after re-arming firmware request
Date: Mon, 17 Aug 2026 15:27:48 +0200
Message-ID: <20260817132543.132990486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6c73c0c0b82a99..7650f14dca8dad 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1227,15 +1227,10 @@ static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
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




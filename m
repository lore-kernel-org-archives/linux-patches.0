Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557484F3939;
	Thu, 17 Sep 2026 15:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659823; cv=none; b=LB2Jf6EFSfLkATDNlJ6We8DVM/c/EjKa25cUPFAAUceqaYXlurA7SSJRLMOF83rS0ozGsHaoeUleqa3mUQ+Z2xq64fHfqSxlatqWz7Mv2ZTUbTDlHwvM3nTw36s7YjolCnXBbkIOl6OhPZru7zqB/WnbLcAx9EM2a8e0aC0o6Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659823; c=relaxed/simple;
	bh=X2X8xo6gUg3rTg91M78e0FBPUKgOOCcoAuvPwCkHEMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyIa+s+qMXNMEmPAQ7I3JULHMVhVbcjyW99a3AeVGyncL77ArNu65JtrgxbGQBS6+87sGzfBA3wQXA5v45nxq0z65dzj0FS9k/ur3GJrEwg6m8YtirxkVhrc3nonh23zEKiQSxAvBZbv1SwdWSZ5Uq1r0S8jJ8RGCkEDVYwtyO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiFG2uri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiFG2uri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BD91F0089A;
	Thu, 17 Sep 2026 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659809;
	bh=VE7qEASRGEGylF0wNmQU3eSR+PaHOD4SkGzJiGOUCIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiFG2uriPkpFbusn320EdGThqYhr7fXqxyRm7IN25uOZm1pJRoZuyzd7nHNd+IMgt
	 rjKd9yHPkm2yogCvSf63zfSXhkKSzTWf7HGxsnQNNLgD6N1kIasqtyz3VTdMLI/sTa
	 z4CsmR7+wmCTa+ApbnEnctwGpDKjDgn4dkvJNibQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 382/733] Bluetooth: btusb: Fix leaked runtime PM reference in btusb_reset
Date: Thu, 17 Sep 2026 16:11:30 +0100
Message-ID: <20260917151401.202336817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index f91a828f4b23b..84f55f67523e0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1047,13 +1047,15 @@ static void btusb_reset(struct hci_dev *hdev)
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




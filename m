Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC86C3CB57B;
	Thu, 17 Sep 2026 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670706; cv=none; b=hLjUNlJiLxnGPcaQXlYuY7OiRfEncfEyvJcrE/X/Fu7R3kEV2ckCwgKDeYw9dHXww1PF3LTp9V7AsvEwq2+2+a6zz9w0T6rc5NYKrda6o7d/2D6RTYMvtvwW3cEywHvtp9uSvY9MCBGsQoSVWTplrdVOiI6aRza5Clf9oiGbB8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670706; c=relaxed/simple;
	bh=YDCXIJhITTkyWWgNATn1MGI4PU1rcU3UcMAXv2T8CD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbjGXzhkEBGjYeBnVlRfJbxM3bRfe2Kb2vsznJ7At3Q+Xc8pJpblRQUEYV4RUyLrRQmKQyu5giltlX7sa2+yUuIECq7jnvd4XZO1UxmvtEOrdvOFHWoYulkT9xKU7ofAfS2ovyhlPs6RTu3xW4EF6H9qWI0drCA97SeYkHwARzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPQ4qNRB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPQ4qNRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9F01F000FF;
	Thu, 17 Sep 2026 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670705;
	bh=8rH9KLAkSsjy71PX6UAfJFw19btHvfPEKnvNA5GV8sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPQ4qNRBJVteSEOTx24+VXMgqwgTDTBcoGdBh3C4/YR0PKn50vr9RTHvuQjdAVfMf
	 +R00viy8EC2KtI8Sad6rW7GWLYqpEuFwh/1DfQhnvGtFK1RkZ/rjx41u/kw2bUMG/l
	 mx+ATzp82oRxP8giB8qu6EGh17Af/vpzdTD/aMsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0744/1102] Bluetooth: btusb: Fix leaked runtime PM reference in btusb_reset
Date: Thu, 17 Sep 2026 16:11:27 +0100
Message-ID: <20260917151559.088576450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 6f9b9084c4ddf..3afb36a84c640 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -994,13 +994,15 @@ static void btusb_reset(struct hci_dev *hdev)
 	}
 
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




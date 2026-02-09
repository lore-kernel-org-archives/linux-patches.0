Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64C52222B2;
	Mon,  9 Feb 2026 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648176; cv=none; b=i6Zw9MWxDWiwIl+xqzVT4jXyCOAYAc1Dr/KBYqCsGKVkniLOWMCyivIlOBfu81E9SumRksZskmtZ+uIh9jlHDYUXhUvJJeInio4Vwqryp4XWJUdFd5vbybc9gAObmel+7dgkNLaQ1cM2UQTfSbg8iQr1Kqsqbvw2/FjEpY1G6Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648176; c=relaxed/simple;
	bh=1Uo7lxIhos3gXIm6m3HRoxMx4p8SO/k5FSBbCPR6dKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig/EdVgGYpuWW2Ow7KoBZjT2FbrOlqfIBd1tK2Uh9XHhuBn0qYpBiuheHTtgl5RXhQJesS2Xqi+zfIF/zoqWzqQ6VHiNfxDCaj4wy2gJH0wsFcEKwt8ui/P8W3Plag6B4RdItq304kDX7tb1cYDF5KVZEOkFC8ZUC20MnvnXcdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/HI28U2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/HI28U2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A64C116C6;
	Mon,  9 Feb 2026 14:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648176;
	bh=1Uo7lxIhos3gXIm6m3HRoxMx4p8SO/k5FSBbCPR6dKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/HI28U2/0rljdPF82WNYcHdzZd6NVLq9jA6HOCqLADxfIeHLXR2l8z8ZkSqgCSN8
	 CK2QXv3B7rv4nmyOhrfveyJDEVSnciqPhPdHcia6/F7bgamWDNske8SssEgQD0Xzh+
	 hH9apukF+YjfqkhAKKIOI4njijLsbXrXwW6QpHA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siarhei Vishniakou <svv@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/69] HID: playstation: Center initial joystick axes to prevent spurious events
Date: Mon,  9 Feb 2026 15:23:57 +0100
Message-ID: <20260209142302.975811953@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siarhei Vishniakou <svv@google.com>

[ Upstream commit e9143268d259d98e111a649affa061acb8e13c5b ]

When a new PlayStation gamepad (DualShock 4 or DualSense) is initialized,
the input subsystem sets the default value for its absolute axes (e.g.,
ABS_X, ABS_Y) to 0.

However, the hardware's actual neutral/resting state for these joysticks
is 128 (0x80). This creates a mismatch.

When the first HID report arrives from the device, the driver sees the
resting value of 128. The kernel compares this to its initial state of 0
and incorrectly interprets this as a delta (0 -> 128). Consequently, it
generates EV_ABS events for this initial, non-existent movement.

This behavior can fail userspace 'sanity check' tests (e.g., in
Android CTS) that correctly assert no motion events should be generated
from a device that is already at rest.

This patch fixes the issue by explicitly setting the initial value of the
main joystick axes (e.g., ABS_X, ABS_Y, ABS_RX, ABS_RY) to 128 (0x80)
in the common ps_gamepad_create() function.

This aligns the kernel's initial state with the hardware's expected
neutral state, ensuring that the first report (at 128) produces no
delta and thus, no spurious event.

Signed-off-by: Siarhei Vishniakou <svv@google.com>
Reviewed-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-playstation.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 2228f6e4ba23f..38d5171dd25b2 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -487,11 +487,16 @@ static struct input_dev *ps_gamepad_create(struct hid_device *hdev,
 	if (IS_ERR(gamepad))
 		return ERR_CAST(gamepad);
 
+	/* Set initial resting state for joysticks to 128 (center) */
 	input_set_abs_params(gamepad, ABS_X, 0, 255, 0, 0);
+	gamepad->absinfo[ABS_X].value = 128;
 	input_set_abs_params(gamepad, ABS_Y, 0, 255, 0, 0);
+	gamepad->absinfo[ABS_Y].value = 128;
 	input_set_abs_params(gamepad, ABS_Z, 0, 255, 0, 0);
 	input_set_abs_params(gamepad, ABS_RX, 0, 255, 0, 0);
+	gamepad->absinfo[ABS_RX].value = 128;
 	input_set_abs_params(gamepad, ABS_RY, 0, 255, 0, 0);
+	gamepad->absinfo[ABS_RY].value = 128;
 	input_set_abs_params(gamepad, ABS_RZ, 0, 255, 0, 0);
 
 	input_set_abs_params(gamepad, ABS_HAT0X, -1, 1, 0, 0);
-- 
2.51.0




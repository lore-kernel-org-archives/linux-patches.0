Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0300713DB92;
	Tue, 27 Feb 2024 14:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043263; cv=none; b=YFMRU0fh6skrxkLmE33uMAsXnnFzDM2AQ0vryCBoDBIENEuSKbup4VClMsngHRABuV4qdIMJ1LQS5Up04eOroINPIdxUqvCw3nNWGS8wKvOblg9Glk/9q3rwLnj4IboeG4MsPE2LG/xj86pdyzDpNAQFB1/nFEIaHK+UQAwADYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043263; c=relaxed/simple;
	bh=+GxQgIjXA9YrihOIYqpiEZxLM0PbH38bAFv5a/efKq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0lWvQ7fOSaQOfGzegYg1fTjoGow+Axt/+FNZvrFLpDyBOptQ+zwJeiSRWuXOSXJeAeQPyS9jTq656G/y2IesLgFhmLVehAi35W0lZQZO9E99OPKDIaZ2HJApvXXjJY9uxtoVXpWDY7xtIqr6fFddDWaS+JBeJkEhz7OIXV0X/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hr7Zz8XP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hr7Zz8XP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88875C433C7;
	Tue, 27 Feb 2024 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043262;
	bh=+GxQgIjXA9YrihOIYqpiEZxLM0PbH38bAFv5a/efKq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hr7Zz8XPFT/56DWTcu8JNTryDC8acktPzJnqalNUVCceTPLDYymqLUxHJY9NxGA8n
	 x1TAkmvOXhrygH+6JQ+iW6YB4BUH+2+wFFG+Yxhh7aZX26+KDLzOcfJIGufBKZG+LQ
	 yOVDB7TkSUqfEUzkpJ54lLmQGUwCbaetksHWtnHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brenton Simpson <appsforartists@google.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/195] Input: xpad - add Lenovo Legion Go controllers
Date: Tue, 27 Feb 2024 14:24:58 +0100
Message-ID: <20240227131611.616571927@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Brenton Simpson <appsforartists@google.com>

[ Upstream commit 80441f76ee67002437db61f3b317ed80cce085d2 ]

The Lenovo Legion Go is a handheld gaming system, similar to a Steam Deck.
It has a gamepad (including rear paddles), 3 gyroscopes, a trackpad,
volume buttons, a power button, and 2 LED ring lights.

The Legion Go firmware presents these controls as a USB hub with various
devices attached.  In its default state, the gamepad is presented as an
Xbox controller connected to this hub.  (By holding a combination of
buttons, it can be changed to use the older DirectInput API.)

This patch teaches the existing Xbox controller module `xpad` to bind to
the controller in the Legion Go, which enables support for the:

- directional pad,
- analog sticks (including clicks),
- X, Y, A, B,
- start and select (or menu and capture),
- shoulder buttons, and
- rumble.

The trackpad, touchscreen, volume controls, and power button are already
supported via existing kernel modules.  Two of the face buttons, the
gyroscopes, rear paddles, and LEDs are not.

After this patch lands, the Legion Go will be mostly functional in Linux,
out-of-the-box.  The various components of the USB hub can be synthesized
into a single logical controller (including the additional buttons) in
userspace with [Handheld Daemon](https://github.com/hhd-dev/hhd), which
makes the Go fully functional.

Signed-off-by: Brenton Simpson <appsforartists@google.com>
Link: https://lore.kernel.org/r/20240118183546.418064-1-appsforartists@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index e8011d70d0799..02f3bc4e4895e 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -294,6 +294,7 @@ static const struct xpad_device {
 	{ 0x1689, 0xfd00, "Razer Onza Tournament Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfd01, "Razer Onza Classic Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfe00, "Razer Sabertooth", 0, XTYPE_XBOX360 },
+	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
@@ -489,6 +490,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x15e4),		/* Numark X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x162e),		/* Joytech X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x1689),		/* Razer Onza */
+	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harminix Rock Band Guitar and Drums */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA Controllers */
-- 
2.43.0




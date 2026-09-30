Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB714B95CC;
	Wed, 30 Sep 2026 15:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783726; cv=none; b=t/epZwRy0vIOF6xG/9WJ0blGRulNfeHP93cKUz7G3AFUHcWh2XGTCqjR340bjObDt91MrJ1jtnsJZQfOTYLZeyLCW9V6T8jELCnGYFASlpGrGnh2Cvch8Abb1mHJgIqamW8g6Wj0u+eKbgiaa1cyaZP0+4zDcMNp53fZQYqAotM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783726; c=relaxed/simple;
	bh=TtSsXHHID/MXYSvQecd4zlztJEDGlWwjCE4fukDaSYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPcXg/pfMprmKMLELy7VKcfpHdFLgExMqazDKY2UiwVpMheDPaa+yBIUsvYBxNboHwDrs8yF1YBKRay6R4m0xBHdYsDVHn51kkx36Jdq+ekOJryu2mNAMYg7qxN6kkhSdyx2655NkhhAG4OFlEVBw26zRBpNNex55zvbN6KakD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEZVt7gk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEZVt7gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462CB1F00898;
	Wed, 30 Sep 2026 15:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783721;
	bh=ftid8vYA+uvU6qeZFKGiNQ1ztWLMHmnSbRBn1hMqEK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEZVt7gk0OTdteeIMYWGRYwQe9/ieSvJbeMTO1agx3bUtoyvcS5J8vIcG1g9Xo41l
	 SOxjW9ozJVGR9N4YgT4tijW/S6RHQ6/mjT3dIMRnALbPcGOMGqOZiNuKx+k3A9eBbJ
	 Bs079XBOB1vFihiqoWEtnl8KYYcmeMgZqSqz5ZdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rapha=C3=ABl=20Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 454/595] Input: synaptics - disable InterTouch on ThinkPad T440p (board id 2722)
Date: Wed, 30 Sep 2026 17:25:47 +0200
Message-ID: <20260930152357.447896063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphaël Larocque <rlarocque@disroot.org>

commit 26eb3d92c7a4d7adb1ae1740ca6e8e100b11d1ec upstream.

The Lenovo ThinkPad T440p (PNP ID LEN0036, board id 2722) has a
Synaptics touchpad whose SMBus companion is not ready at boot and
takes roughly 200 seconds to appear. During this window the touchpad
and TrackPoint are completely unresponsive on approximately 50% of
boots, making the machine unusable until the companion finally
registers.

The device is in the topbuttonpad_pnp_ids[] SMBus allowlist, so the
kernel attempts to use SMBus/RMI4 mode by default. When the companion
is not ready, psmouse_smbus_init() leaves breadcrumbs and returns
-EAGAIN, the PS/2 fallback path is taken, but the device does not
function properly until the companion appears and RMI4 takes over.

Disable SMBus InterTouch for board id 2722 so the touchpad and
TrackPoint work immediately via PS/2 from boot. Users can still force
SMBus with psmouse.synaptics_intertouch=1 if needed.

Tested-by: Raphaël Larocque <rlarocque@disroot.org>
Signed-off-by: Raphaël Larocque <rlarocque@disroot.org>
Link: https://patch.msgid.link/20260910164425.12832-1-rlarocque@disroot.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1804,6 +1804,14 @@ static int synaptics_setup_intertouch(st
 
 			return -ENXIO;
 		}
+
+		/* Disable intertouch on known-broken board revisions */
+		if (info->board_id == 2722) {
+			psmouse_info(psmouse,
+				     "Disabling intertouch for board id %u\n",
+				     info->board_id);
+			return -ENXIO;
+		}
 	}
 
 	psmouse_info(psmouse, "Trying to set up SMBus access\n");



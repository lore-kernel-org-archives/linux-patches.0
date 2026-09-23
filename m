Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F147C521219;
	Wed, 23 Sep 2026 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175041; cv=none; b=aRypAuw2T/ap6hw3XiSpeFBpGbMBocXiQQlDakQcsMViPiW98J5zIzZKzOU0XzmYOTjBPa8Tf41aiL4YhE0UTNrZkrfiRYWd99Qph8bUGGL0w/DjrxE68Xk2X6NxB0jnnO1VXsnouGNV1j4EZFkRBdBqcB4J8RqcvinC99sbOrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175041; c=relaxed/simple;
	bh=1doGfh1QIc4k7rzgGLLZ83XpjqHPnJSGtz02hvkRbiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DeM5UKlKy1TSUpO+N6ORXCCuORi7177ooLeunaHdHISPaDOO+gmAXr+l0cO3Ds6sUf7o9gtqZoyINofoXMvpJfA1fpqXETCyxpcfHqN1pA+DBZ13+xsu8MnVEvrzHuQfGh6PnkAa0geEcb08cawCIPohGQsCZvnSGUGIFDIV9YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=airo+hfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="airo+hfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5428D1F00898;
	Wed, 23 Sep 2026 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175039;
	bh=wIN7ZhmbFrMgGR1WpQR0vbMs8kpdlMNFOQsaXOj5b5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=airo+hfLyJAqtdU+EdUn2wzi+Ma6Uvu4fY7frpwKmAiunUQWbwOh1OuvrOZD1AuVr
	 nkDz6MCw91nRZtFephsIZ0DUb2ja07n6umn4XFntnqd1WXHTjPQKAIOQTukCr9i+79
	 VbNl4teRQDgje44fpHwHNjgQrXo0KQshbJ67lKdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rapha=C3=ABl=20Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 303/398] Input: synaptics - disable InterTouch on ThinkPad T440p (board id 2722)
Date: Wed, 23 Sep 2026 16:06:17 +0200
Message-ID: <20260923140651.274430576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1837,6 +1837,14 @@ static int synaptics_setup_intertouch(st
 
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



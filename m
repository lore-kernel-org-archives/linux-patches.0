Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D1B3161A2;
	Wed, 23 Sep 2026 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173849; cv=none; b=n9XNQbVHPPhMVcyUtR2iCOwSi9Ep4nMW/cFY/w+WaVGG0cC6OYQmT4Pod8fD8kJHzeX4ZcL9DYoTpfX6Pv9XI1j5nT9IMHJvi3ovXLpaBsI2YViIvNY++Jez8kRdtf/zfUUVBnhmA3ZR8OqzooJ+CLkEZ26cQscPRciRlw/TGMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173849; c=relaxed/simple;
	bh=dKMrJYzqRPTjdsLNK5Nwu/cSEYCCw7jcvQl+DEGBtDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMDsaxX2gnQWLX/qXpyhbmh5LLmsmaIggns/fyiWZvgb5Rh5HcxvcalnIgTyEQGhkcg/82/Qj4goLGCLCnZF/lZkOLIFoGpFHSk90CK9LoD7SNdMekTQFA3+GHdJ1DueQvbqglij02Lox2iCDhXGfJEDSPZxXLWFDxbyWH7/Fio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIeHkEmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIeHkEmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCD01F000FF;
	Wed, 23 Sep 2026 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173848;
	bh=ncXMqBBcJLmxPj9ASzYuEWPhJAiEpLPE3AYeGuclBNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIeHkEmvXRuQiMHgnis8cZL3zK6UcvHQZU43GNpNg+YKZah+YD7dXXSCLmz3KlY+S
	 /4oVqF7aFlOIQUdVtiYm41L4kH9A4zUlEJsGprTjlCDjuW5CxjsSIUwqmqOk6MEJnt
	 MD/Hs5QP2IV6X6QmfdlsXZ1PS8xRItlJQVprxBz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rapha=C3=ABl=20Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 362/438] Input: synaptics - disable InterTouch on ThinkPad T440p (board id 2722)
Date: Wed, 23 Sep 2026 16:06:23 +0200
Message-ID: <20260923140654.234729124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



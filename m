Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324633749F6;
	Wed, 30 Sep 2026 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786108; cv=none; b=jyOvy2dKJS+vgeptpr7vcTdhn2GpYSeizLtnZ5zXAPHOGu5p2vySGZ6N84bqUC0FlENCdmyjLBj9aNj2RnfDr5KBJyoINvqE4yEkfjOQPRi+13TgpXFT8IWvnqcmUDGZE2B4MyEZUA430tslIqUNY8mFSgeWkWK9Bk2tTcIiHoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786108; c=relaxed/simple;
	bh=0i5JPlwfz6jIPpw7oKanGUA3ErT/NRHeYAlDOER7C0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/vSeULRna2f1c35ulum3VCcx3N4wN0eqGY0eWv8RK0dDZjkjImvcXJ60k3hW8x8JXT1azmpRmjOQKxQWQVvtopzlVseLb4Rk+iArlUVey28T7B+16JvD1yLKSfGYCrq6um9Li66KCd1oaEOI9jSCtIgJgVQp0nl3XXdDGrsemg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mc0Hud99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mc0Hud99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9151F000FF;
	Wed, 30 Sep 2026 16:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786107;
	bh=/mSQr3tcEqkpJw4w6ZMQA/+nHEEOox5WL9iV1WdlSJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mc0Hud99nwzNVCmPJMew49XdPRCcv2NiJjVXbomtdfX6RHZOArVT+aTSKMw04T1Et
	 iA2tJIWjuw+lJ8RUYMoF2BB7CWQhuC9iIErOoDZufz3OfO09rBI5ELGQ3XfHPH0mZg
	 jK6UVsj32CLZ2UEiyDTiPDPmEfNC2jCy9XDfeEts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rapha=C3=ABl=20Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 746/982] Input: synaptics - disable InterTouch on ThinkPad T440p (board id 2722)
Date: Wed, 30 Sep 2026 17:24:42 +0200
Message-ID: <20260930152432.779084470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1809,6 +1809,14 @@ static int synaptics_setup_intertouch(st
 
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



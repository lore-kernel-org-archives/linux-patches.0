Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E3742586B;
	Sat, 12 Sep 2026 13:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218376; cv=none; b=fth/f/xEIAkM/yV7BkcTLz/encmJ9Ec5AtcCxhRR+vaWZ3XQ3RyqAVie4lCUry1rs9Kd8YRr26idkvDp2mDRtSAYLTc1VZIWxzenqiNA01bh0lGGCJtInhd7hm6fvs5O2E95oZsx4j00fb/vE6FExCpoSYRdCZNfCnj9GtiBrVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218376; c=relaxed/simple;
	bh=U9DBxeNiIKPX6MXkvd4tM4xKdaaiU/6fVefK/Oiwiq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGFUmOAx/hfE9gRp5oisg3lJPwI259IqC+yodDfGGRI+44RUxgRB6LoV0sjDtd4fhYTEbfMWtGlORGSQeUSuEFQAlGizfWOnpl3HOCoONlrgaSI9cEOSrrJR4vaNRvBDTdNr/ab0CddXrFpA3bDWK9uj8rjFpVhcl0iaqc00dPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJLdYpGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJLdYpGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C2D1F000FF;
	Sat, 12 Sep 2026 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218375;
	bh=xMdnc9E073kBTyJebzjOuVnPPMLZGzaZbLGuQZ5bdAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJLdYpGEFKpNvA4fInCTYHoz6Szax2LnUAZY9wDgAmgf2xk/2SwG8p6OQnx7GBbaY
	 hv2m3ecvwbiCL+aIQsf91hiQnw7uvasgPgnkxQ7Hoh8LAqAHwceaYWyytt7Sue/X7L
	 yIS9lroJtHpXjpPMg3ZEc8GpXH80vA2i49EJoOOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglin Lin <1021538027@qq.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1132/1376] HID: multitouch: reclassify HTIX5288 to WIN_8_FORCE_MULTI_INPUT_NSMU
Date: Sat, 12 Sep 2026 08:59:18 +0200
Message-ID: <20260912065632.791907229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Xianglin Lin <1021538027@qq.com>

[ Upstream commit 69226cd6fad7a07370ec9a009af1c174de7635c5 ]

Commit b5e65ae557da ("HID: multitouch: Add quirk for Hantick 5288
touchpad") assigned MT_CLS_NSMU to the HTIX5288 (0911:5288).  This was
necessary because the device sometimes fails to send touch release
signals when transitioning from >=2 fingers to <2 fingers, and
MT_QUIRK_NOT_SEEN_MEANS_UP fixes stuck touches by treating missing
contacts as released.

However, MT_CLS_NSMU only carries MT_QUIRK_NOT_SEEN_MEANS_UP.  It
lacks MT_QUIRK_CONTACT_CNT_ACCURATE and MT_QUIRK_IGNORE_DUPLICATES.
As a result, after a two-finger scroll finger lift, the device still
reports stale coordinates from the released contact in subsequent
frames, and the driver overwrites the remaining active slot with
those frozen coordinates.  The remaining finger appears stuck at the
lift position until all fingers are lifted.

This was confirmed via evtest on Arch Linux 7.1.3: after
TRACKING_ID=-1 for the released slot, every subsequent frame contained
duplicate position pairs -- the real moving finger's coordinates
followed by the lifted finger's frozen position, both attributed to
the active slot.

Reclassify the device to MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU
(0x0018), which preserves the original MT_QUIRK_NOT_SEEN_MEANS_UP
fix while adding the necessary Win8 quirks (CONTACT_CNT_ACCURATE,
IGNORE_DUPLICATES), preventing stale coordinate contamination.

The additional FORCE_MULTI_INPUT flag is harmless here: it separates
the mouse and touchpad collections into distinct input devices,
which is the standard behavior libinput already expects.

Fixes: b5e65ae557da ("HID: multitouch: Add quirk for Hantick 5288 touchpad")
Signed-off-by: Xianglin Lin <1021538027@qq.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index b8e6cc67c6b64..80423adf2c657 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2426,7 +2426,7 @@ static const struct hid_device_id mt_devices[] = {
 			HID_ANY_ID) },
 
 	/* Hantick */
-	{ .driver_data = MT_CLS_NSMU,
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			   I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288) },
 
-- 
2.53.0




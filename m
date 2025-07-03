Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6A42EFD80;
	Thu,  3 Jul 2025 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554320; cv=none; b=WxFKUx7b+I2pWKQiTXgWdWEI54RbPtW2GiC4O1Hjfge72LpxoZd5pM+Wdti/EwHZ+m+gbGlFaQEr8prQ8GEBhsqMWtd7Lvid1KCmMO4CNpyteFLp4a5majrsPjyGQqEiczIYktT6rUcgQRWWHtiMKO0E8MCVO5Hfj/PUhPtQwDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554320; c=relaxed/simple;
	bh=iC2HhdSMp5MWXp5rAtcsMswtTcm05lCFZexuMKNkkcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCh4LcuuS5tMzdHgNRu5scH1kPNXKnRl0XfuUjtKT7ubJiJiDib3TUuZ2vhBu1HbtpFsVMpRWxv2m0PVWHzwvTbvAiS/UpZ8VtCRCfGYkwV9x3sGUflsnJn2v+MgW84mBFlu5dQ/l2B62EtSs5po5xrxGMxgMqWzIyc7v8/5Sfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIgzOrF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIgzOrF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA5DC4CEED;
	Thu,  3 Jul 2025 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554320;
	bh=iC2HhdSMp5MWXp5rAtcsMswtTcm05lCFZexuMKNkkcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIgzOrF/L7eJxCaY1K+gBK+mSBU0VEZ24+vg9Bl2rehulOCPbH6S8XmyjN/q9zYJo
	 JwQDNkBmRoGdQM1EimR9dmgbYD8qGpGdgr/Ub/m4Q+qAo3Ha5Rci4bNETtEoR7mFCi
	 DVyP6HbgBKNzYxNd3DJ4RQXZii6Od+nDwSEUOyYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Adam Jackson <ajax@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 6.12 149/218] drm/cirrus-qemu: Fix pitch programming
Date: Thu,  3 Jul 2025 16:41:37 +0200
Message-ID: <20250703144002.098731241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 4bfb389a0136a13f0802eeb5e97a0e76d88f77ae upstream.

Do not set CR1B[6] when programming the pitch. The bit effects VGA
text mode and is not interpreted by qemu. [1] It has no affect on
the scanline pitch.

The scanline bit that is set into CR1B[6] belongs into CR13[7], which
the driver sets up correctly.

This bug goes back to the driver's initial commit.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Link: https://gitlab.com/qemu-project/qemu/-/blob/stable-9.2/hw/display/cirrus_vga.c?ref_type=heads#L1112 # 1
Fixes: f9aa76a85248 ("drm/kms: driver for virtual cirrus under qemu")
Cc: Adam Jackson <ajax@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v3.5+
Link: https://lore.kernel.org/r/20250328091821.195061-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/cirrus.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/tiny/cirrus.c
+++ b/drivers/gpu/drm/tiny/cirrus.c
@@ -318,7 +318,6 @@ static void cirrus_pitch_set(struct cirr
 	/* Enable extended blanking and pitch bits, and enable full memory */
 	cr1b = 0x22;
 	cr1b |= (pitch >> 7) & 0x10;
-	cr1b |= (pitch >> 6) & 0x40;
 	wreg_crt(cirrus, 0x1b, cr1b);
 
 	cirrus_set_start_address(cirrus, 0);



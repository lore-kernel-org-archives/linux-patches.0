Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF52B3A961E;
	Fri,  4 Sep 2026 05:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499214; cv=none; b=LyO1SvmuPJ63sbLLz3dHcXc7nGy+6riKIJyjKL1N7heGaziH7TGvVl6I66Wl79F+niztfvOtwyr+8vZp4i5lbQqWVeV6EQ1JlAmF/fdu3tfrFwL21LK7sBDM6SraVB3YSYVj/RDKyoIOlU0lrlNhCbE8IB4dUIq/DA/BxmLc3XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499214; c=relaxed/simple;
	bh=3mBCLHh3MaLHQ3LPBnWjn1klRMnYJZJHUpInhBSCYI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYcd7rV416fzl6P38uYEDwcqNztXE+B+4nmiSk5OcAbfS5XcsRC3oup9+ws7S0j3UedcB3tcm5KWN7Uu0iQemf+Q7b5GR4d976PS80chjuAjZSgkfdBKepBeWE84nQ612RbOwwoNekbr4H6NgcWGD/mSzYADH0V1JxXRwEOLrjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETl65vxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETl65vxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C951F00A3D;
	Fri,  4 Sep 2026 05:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499213;
	bh=M5O54+bY46QGQsqAZeezfMb7Lm0lhf8/fnMF3jbPwcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETl65vxYL3m25SPKFfQqsm9KbcBpX2pXcgz6KTlTePOUYjTV0TQRKt35tnbpIVtvO
	 rrdS0LHe3yj1/nPKT5XJQi/jodN0ni7oj7B60G1x/tEoLdNzUw47AX9SSCdz6VFkP0
	 FpQ+N0eKar0gXZ1bbH/tu7sbQXLxiV/uXDnu6ppA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@linux.dev>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.2 311/713] backlight: aw99706: Honor the core blank state in update_status()
Date: Fri,  4 Sep 2026 06:54:39 +0200
Message-ID: <20260904045810.806911168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Junjie Cao <junjie.cao@linux.dev>

commit fbf8b5d251e8b4e1b01c591be313c63cb9e1526a upstream.

update_status() passes props.brightness straight to the hardware and
ignores the power/blank state tracked by the core. Writing 4 to the
bl_power sysfs attribute or blanking the framebuffer therefore leaves
the backlight lit.

Use backlight_get_brightness(), which returns 0 while the device is
blanked.

Fixes: 147b38a5ad06 ("backlight: aw99706: Add support for Awinic AW99706 backlight")
Cc: stable@vger.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@linux.dev>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260804030255.1934470-4-junjie.cao@intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/aw99706.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/backlight/aw99706.c
+++ b/drivers/video/backlight/aw99706.c
@@ -335,7 +335,7 @@ static int aw99706_bl_update_status(stru
 {
 	struct aw99706_device *aw = bl_get_data(bl);
 
-	return aw99706_update_brightness(aw, bl->props.brightness);
+	return aw99706_update_brightness(aw, backlight_get_brightness(bl));
 }
 
 static const struct backlight_ops aw99706_bl_ops = {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC1018801A;
	Tue, 30 Jul 2024 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358692; cv=none; b=Chdox/5ewEZQI9kQX5bxXtWdlzhbfIP+HpptGnZtIBKw843QARz7/dgX0W4C0WVU+rm94oFg8tQPfuVFKBXpHDT0epplkM6+xWIWzAUgbtV+TQikUba3ERJloN/dw9Ppr/hm2cB7Z0OPgQ4eJoeVaBiQ7oEQLbNsB/WNDwtkIJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358692; c=relaxed/simple;
	bh=TIKWnp+mX79eexpzDu2fsCUYyFqtX9WmjSJJYCkgqF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGUr0DiLcxb9PqiI73bm2krP8ap485X2nEEsGHhpBsldDdMggt05B3jP0bj98jsfitcKUYwEle1RgHvT2hIEK/Id5PxHCXiZjABp3vbZgTVUYcUa5ovnIUsd6kpAkogzuercvmJoLOFkaAj4o/s9BdRl6rPXQsiBAJ/ZBb+CsN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeXn2u/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeXn2u/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A88C4AF0A;
	Tue, 30 Jul 2024 16:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358692;
	bh=TIKWnp+mX79eexpzDu2fsCUYyFqtX9WmjSJJYCkgqF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VeXn2u/o1aIShgUngKnVxa6H8QKI9CRFXOqQJG0723T+nAfdFEfSW1n7M6j7PsSdM
	 6YEflbdC8XLay1+wTUz1QiMcKsdWxabOhhaYWtlV4awDtP2JdsPtvIUDnS03EDqXw/
	 SS99sYSO3iXP5PZR9Qu17msyQ8fHbZAjbLRRK0ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.6 386/568] drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes
Date: Tue, 30 Jul 2024 17:48:13 +0200
Message-ID: <20240730151654.953294221@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 2df7aac81070987b0f052985856aa325a38debf6 upstream.

In psb_intel_lvds_get_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 89c78134cc54 ("gma500: Add Poulsbo support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709092011.3204970-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/psb_intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -504,6 +504,9 @@ static int psb_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}



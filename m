Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75DB54765;
	Wed,  6 Nov 2024 13:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898932; cv=none; b=C5z8+7zmRNKQgwTy4a8k1CXTMM2KZxEf+Yg87Q/IvbAOQKVY5x8JEwIWfx0mtuQWeQSFLdQgKvjoB6MgBkiSE1RDiD3SFFje8G3R/jyTGi7FEL7SP9+P9FcUbliH/l61ePI847aGdM2sy7bQY8VzFzPLQepWcyvCf8G8cgVxonk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898932; c=relaxed/simple;
	bh=YpCiS3w6L6X74sVIJwsIYA70t2fCE8dcn7Wploo/X5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbjgthgxVj0+gxxBoh/UXq3lrgNCkaM/Jz/2gNLc3vlsr6iGqSPpRvpx7XbPYgOfha0VsavLjOrztBqYucVG6/g9RfvDKmj++01jsnL1g5dSLuLpI/kgikFKpXB+R1nIyE7Bbz2KduCI03QLLA04jqcQDffphkRndVCCqjxYcto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgWkQLDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgWkQLDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC067C4CECD;
	Wed,  6 Nov 2024 13:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898932;
	bh=YpCiS3w6L6X74sVIJwsIYA70t2fCE8dcn7Wploo/X5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgWkQLDatjhmuVR0JRScUBZxaZTYbJJ67/Sd6i7VgbY4QRedecvpUWtf9Hk+t244k
	 VIYEf24r7U/Bsuv0OT/ZD97D8GATbMJJSTrHwVibFJby/FZY3kDpnF8sNDdN2Xn1zI
	 2ZnmJ0tOX1Ze6W/NlWVONuAYoqJb2jlMwamaMUno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 404/462] drm/vboxvideo: Replace fake VLA at end of vbva_mouse_pointer_shape with real VLA
Date: Wed,  6 Nov 2024 13:04:57 +0100
Message-ID: <20241106120341.501589716@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d92b90f9a54d9300a6e883258e79f36dab53bfae ]

Replace the fake VLA at end of the vbva_mouse_pointer_shape shape with
a real VLA to fix a "memcpy: detected field-spanning write error" warning:

[   13.319813] memcpy: detected field-spanning write (size 16896) of single field "p->data" at drivers/gpu/drm/vboxvideo/hgsmi_base.c:154 (size 4)
[   13.319841] WARNING: CPU: 0 PID: 1105 at drivers/gpu/drm/vboxvideo/hgsmi_base.c:154 hgsmi_update_pointer_shape+0x192/0x1c0 [vboxvideo]
[   13.320038] Call Trace:
[   13.320173]  hgsmi_update_pointer_shape [vboxvideo]
[   13.320184]  vbox_cursor_atomic_update [vboxvideo]

Note as mentioned in the added comment it seems the original length
calculation for the allocated and send hgsmi buffer is 4 bytes too large.
Changing this is not the goal of this patch, so this behavior is kept.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240827104523.17442-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vboxvideo/hgsmi_base.c | 10 +++++++++-
 drivers/gpu/drm/vboxvideo/vboxvideo.h  |  4 +---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vboxvideo/hgsmi_base.c b/drivers/gpu/drm/vboxvideo/hgsmi_base.c
index 361d3193258ea..7edc9cf6a6069 100644
--- a/drivers/gpu/drm/vboxvideo/hgsmi_base.c
+++ b/drivers/gpu/drm/vboxvideo/hgsmi_base.c
@@ -135,7 +135,15 @@ int hgsmi_update_pointer_shape(struct gen_pool *ctx, u32 flags,
 		flags |= VBOX_MOUSE_POINTER_VISIBLE;
 	}
 
-	p = hgsmi_buffer_alloc(ctx, sizeof(*p) + pixel_len, HGSMI_CH_VBVA,
+	/*
+	 * The 4 extra bytes come from switching struct vbva_mouse_pointer_shape
+	 * from having a 4 bytes fixed array at the end to using a proper VLA
+	 * at the end. These 4 extra bytes were not subtracted from sizeof(*p)
+	 * before the switch to the VLA, so this way the behavior is unchanged.
+	 * Chances are these 4 extra bytes are not necessary but they are kept
+	 * to avoid regressions.
+	 */
+	p = hgsmi_buffer_alloc(ctx, sizeof(*p) + pixel_len + 4, HGSMI_CH_VBVA,
 			       VBVA_MOUSE_POINTER_SHAPE);
 	if (!p)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/vboxvideo/vboxvideo.h b/drivers/gpu/drm/vboxvideo/vboxvideo.h
index 0592004f71aa0..a03695939c62a 100644
--- a/drivers/gpu/drm/vboxvideo/vboxvideo.h
+++ b/drivers/gpu/drm/vboxvideo/vboxvideo.h
@@ -351,10 +351,8 @@ struct vbva_mouse_pointer_shape {
 	 * Bytes in the gap between the AND and the XOR mask are undefined.
 	 * XOR mask scanlines have no gap between them and size of XOR mask is:
 	 * xor_len = width * 4 * height.
-	 *
-	 * Preallocate 4 bytes for accessing actual data as p->data.
 	 */
-	u8 data[4];
+	u8 data[];
 } __packed;
 
 /* pointer is visible */
-- 
2.43.0




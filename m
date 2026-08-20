Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C420381B0A;
	Thu, 20 Aug 2026 15:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239289; cv=none; b=Q5VzGJAuIUXMIfzgT1BFguE7vzAnm02KV6bs8/fZMPtDM3e7PCA7e/IADXc4Dd7WboIPBDtOI6qaZVHPSwi/ZWr1L6iemhhk59c4/4sahCm8rJVt/uQsQOvmuhCJRweO301t2dPlo/zdbh9/GJ0AQeEkOyhgCc7dqpEsDC58qN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239289; c=relaxed/simple;
	bh=qm6+K05jrKP15m6zNepIQ1NFlMQ5IRKPtITiwGPXn9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnU6dWP6+vg64vnL0yV4bD0TbUlb6/37FWTtE6aFHzt49yUrQEb1LNCgWmo6NJWhGyFHJyH435ePrnlLEU8xRYN5LGgq18UUMOjKNze/u/ADSABj9lgdYF1My5tj458zz8XtpG3t8tWLzOwA9Zm3oH/LxdEccCI88qxj0p80k8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTVztB84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTVztB84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD03E1F000E9;
	Thu, 20 Aug 2026 15:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239288;
	bh=D9DG7FoEiooGK7hyk/HwAdOzDMMcTkcyVcaH/1RAnrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTVztB8441eGO+sqTHIAyZFBHE/ctvMNHpW8JbeLaS0fmGdab2SojpAciNrL2cTIY
	 /6Hw2a06vG4ffsxqnJzhbvXeOYyaVJwrQKhAUYtnYuZaoaslVlVVRfnslqg4V0Knd8
	 tv1VTZaQP0i5N2iA7oS/SsY1ByicqnpohZbvTHsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.18 216/217] drm/vmwgfx: Set surface-framebuffer GEM objects
Date: Thu, 20 Aug 2026 16:56:24 +0200
Message-ID: <20260820145244.183731644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 9942d36a73c2d46c52fdd6f37cf698f3cb09ce5c upstream.

Set struct drm_framebuffer.obj[0] to the allocated GEM buffer object
for surface framebuffers. Avoids a NULL-pointer deref in the client's
vmap helpers.

[   22.640191] Console: switching to colour frame buffer device 160x50
[   22.641788] Oops: general protection fault, probably for
  non-canonical address 0xdffffc000000001f: 0000 [#1] SMP KASAN NOPTI
[   22.641795] KASAN: null-ptr-deref in range
[0x00000000000000f8-0x00000000000000ff]
[...]
[   22.641809] Hardware name: VMware, Inc. VMware20,1/440BX Desktop
  Reference Platform, BIOS VMW201.00V.24928539.B64.2508260915 08/26/2025
[   22.641812] Workqueue: events drm_fb_helper_damage_work
[   22.641824] RIP: 0010:drm_gem_lock+0x25/0x50
[   22.641831] Code: 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 48 b8
  00 00 00 00 00 fc ff df 53 48 89 fb 48 81 c7 f8 00 00 00 48 89 fa 48
  c1 ea 03 <80> 3c 02 00 75 0f 48 8b bb f8 00 00 00 31 f6 5b e9 16 2e 15
  01 e8
[...]
[   22.641889] Call Trace:
[   22.641891]  <TASK>
[   22.641894]  drm_client_buffer_vmap_local+0x78/0x140
[   22.641903]  drm_fbdev_ttm_helper_fb_dirty+0x20c/0x510 [drm_ttm_helper]
[   22.641913]  ? __pfx_drm_fbdev_ttm_helper_fb_dirty+0x10/0x10 [drm_ttm_helper]
[   22.641918]  ? __raw_spin_lock_irqsave+0x8c/0xf0
[   22.641924]  ? __pfx___raw_spin_lock_irqsave+0x10/0x10
[   22.641928]  ? __pfx_mutex_lock+0x10/0x10
[   22.641936]  drm_fb_helper_fb_dirty+0x29a/0x5e0
[   22.641942]  ? __pfx_drm_fb_helper_fb_dirty+0x10/0x10
[...]

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: ea39f2e66e61 ("drm/client: Deprecate struct drm_client_buffer.gem")
Reported-by: Ian Forbes <ian.forbes@broadcom.com>
Closes: https://lore.kernel.org/dri-devel/CAO6MGtjg8PiRiSLomJQRBduTBSC0WkqX67tEZwA9qwOgRzchpw@mail.gmail.com/
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Tested-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20251104103611.167821-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -553,6 +553,9 @@ static int vmw_kms_new_framebuffer_surfa
 	memcpy(&vfbs->uo, uo, sizeof(vfbs->uo));
 	vmw_user_object_ref(&vfbs->uo);
 
+	if (vfbs->uo.buffer)
+		vfbs->base.base.obj[0] = &vfbs->uo.buffer->tbo.base;
+
 	*out = &vfbs->base;
 
 	ret = drm_framebuffer_init(dev, &vfbs->base.base,



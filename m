Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5E117C220;
	Fri, 15 May 2026 16:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862227; cv=none; b=AHwX+M8+yUycdt1IahUW+Yrgax/X44Kh4Y9doCtunNBzo098ZqN29Yd+4chuBILStL+HayNiEAbnmBRqm7zx3YotoSvI0qm0r0kjX9bydbtDU6VBytmVFHMk9pNJHGlRersKXmTtxXQRwwrmmDyMEounfSBIvBoHKWWPZ2syaOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862227; c=relaxed/simple;
	bh=bS4Pa5n1u9RBEeWnI9IYlAxeQ5PQYBKs+uni54aNaNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAeGJANSpidqLGpOn/+a3pwVIJaIm4ulfgtLwsa1UukJU43fmrpuatIMoMPMA6FIcu9i0gDvdTLvkfkNDFQMIvLM2hNYwc3tJGSalj6S/RKpRk+Id7JN1g8H0GM9qmkjQWwmn78q3NvNDuqSc+iitemeT1uE+5fJw1/PlkORIZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zy2/AiZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zy2/AiZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8914C2BCB0;
	Fri, 15 May 2026 16:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862227;
	bh=bS4Pa5n1u9RBEeWnI9IYlAxeQ5PQYBKs+uni54aNaNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zy2/AiZ3PrZrMxoMU45a4dLsOxmgejQ8OMOezA+EdcbPfNwmeWtWpd9X8RyRheHLv
	 cE4vGVsRxHauZOJOIf5azF5b5NJq/6P9nca2ImImmuIWhlkmDCJCdM8s1QmLPiOU1a
	 DhK2m+dVT1AvZh8OLL7F+4lMocEPW6V0YrBlS4Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.18 115/188] drm/udl: Increase GET_URB_TIMEOUT
Date: Fri, 15 May 2026 17:48:52 +0200
Message-ID: <20260515154659.824991066@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Shixiong Ou <oushixiong@kylinos.cn>

commit ac2c996675755c725a0065dbe3e2ebffded9080b upstream.

[WHY]
A situation has occurred where udl_handle_damage() executed successfully
and the kernel log appears normal, but the display fails to show any output.
This is because the call to udl_get_urb() in udl_crtc_helper_atomic_enable()
failed without generating any error message.

[HOW]
1. Increase timeout of getting urb.
2. Add error messages when calling udl_get_urb() failed in
udl_crtc_helper_atomic_enable().

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 5320918b9a87 ("drm/udl: initial UDL driver (v4)")
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v3.4+
Link: https://patch.msgid.link/20260424124427.657-1-oushixiong1025@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/udl/udl_main.c    |    3 +--
 drivers/gpu/drm/udl/udl_modeset.c |    5 ++++-
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/udl/udl_main.c
+++ b/drivers/gpu/drm/udl/udl_main.c
@@ -285,13 +285,12 @@ static struct urb *udl_get_urb_locked(st
 	return unode->urb;
 }
 
-#define GET_URB_TIMEOUT	HZ
 struct urb *udl_get_urb(struct udl_device *udl)
 {
 	struct urb *urb;
 
 	spin_lock_irq(&udl->urbs.lock);
-	urb = udl_get_urb_locked(udl, GET_URB_TIMEOUT);
+	urb = udl_get_urb_locked(udl, HZ * 2);
 	spin_unlock_irq(&udl->urbs.lock);
 	return urb;
 }
--- a/drivers/gpu/drm/udl/udl_modeset.c
+++ b/drivers/gpu/drm/udl/udl_modeset.c
@@ -21,6 +21,7 @@
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_gem_shmem_helper.h>
 #include <drm/drm_modeset_helper_vtables.h>
+#include <drm/drm_print.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/drm_vblank.h>
 
@@ -342,8 +343,10 @@ static void udl_crtc_helper_atomic_enabl
 		return;
 
 	urb = udl_get_urb(udl);
-	if (!urb)
+	if (!urb) {
+		drm_err_ratelimited(dev, "get urb failed when enabling crtc\n");
 		goto out;
+	}
 
 	buf = (char *)urb->transfer_buffer;
 	buf = udl_vidreg_lock(buf);



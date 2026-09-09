Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A220583AD0;
	Wed,  9 Sep 2026 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964137; cv=none; b=qFPC5hYVhctu2ktheHZgk/ASt6CH8XnorG/MtT0JHhOGieV4fA04DbaI73PS+Co7dLOozoQl8BldPcYqD3tav6xtVeXHnTbRZxsbrS2xBINbdD6E/mLQdDIm36WKbE6qUS+n2ay2U06RuBEtFVPIK5w1j5pBBx2/uCWPOX7jSGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964137; c=relaxed/simple;
	bh=3FoM/HZDjU4k53JLGQ09PEopTm7jw4IADglK/OGP6PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVcRXoHBeQicDnEy4JUjrrs0mQY1vDzpk5fS/sLyJ5MwrWMkwucp+YgDXmfmDPGU1z9v+3Cio30evsIYEGRHsjSI8kssxh4+TCmyKuo43cL5Bjm7+sxHChwMByXmIEOyO3vGCsvbQx+NVi3IrQL5LwnqjI7Oz3efTB0Yv9o/nA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMiW/g/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMiW/g/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E11B1F00A3A;
	Wed,  9 Sep 2026 14:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964136;
	bh=2lRE0+LU7lRKv8tMWZchw+u2TAaw2DIHdx7hWXyio9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMiW/g/GYVk0LqgvA7eMbnMO1RkQiySnLNO3bDbQREvAKpYVMnw8W1PpnWJCOd73m
	 Vvrt4ITBoIOP9CoAEQeuqRePE50XKn/IG4eaGkwW+U3dFJ8u8KLJcP+/5azXz1cbd8
	 04x8TiyGQfN3Lmj6cttkYvc+VcICw86PiN1hm59M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 276/583] media: cec: core: Fix kmemleak due to missed rc_free_device() call
Date: Wed,  9 Sep 2026 15:39:21 +0200
Message-ID: <20260909134247.628962423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

commit a24ba0653f7154e671dc8d2bf64682ab2d042792 upstream.

The commit dccc0c3ddf8f ("media: rc: fix race between unregister and
urb/irq callbacks") removed the implicit call to rc_free_device() from
rc_unregister_device(). However, the commit missed to remove the NULL
assignment of adap->rc that is now causing rc_free_device() to never be
called on an allocated rc device.

kmemleak reports following after e.g. dw-hdmi unbind:

unreferenced object 0xffff00010ac10000 (size 4096):
  comm "kworker/u16:1", pid 39, jiffies 4294897739
  hex dump (first 32 bytes):
    20 23 4b 0a 01 00 ff ff 08 00 c1 0a 01 00 ff ff   #K.............
    08 00 c1 0a 01 00 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc e11baccc):
    kmemleak_alloc+0x38/0x44
    __kmalloc_cache_noprof+0x4a8/0x5e0
    rc_allocate_device+0x48/0x2a0
    cec_allocate_adapter+0x3ac/0x800
    dw_hdmi_cec_probe+0x264/0x634
    platform_probe+0xc0/0x188
    really_probe+0x4a4/0x8e0
    __driver_probe_device+0x2f8/0x440
    driver_probe_device+0x60/0x160
    __device_attach_driver+0x1a0/0x2a0
    bus_for_each_drv+0x100/0x1a0
    __device_attach+0x174/0x350
    device_initial_probe+0x90/0xb0
    bus_probe_device+0x4c/0x120
    device_add+0xdec/0x116c
    platform_device_add+0x354/0x598

Remove the assignment of adap->rc to NULL to let cec_delete_adapter()
free the allocated rc device after last user of the cec device exits to
fix the kmemleak.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/cec/core/cec-core.c
+++ b/drivers/media/cec/core/cec-core.c
@@ -371,9 +371,7 @@ void cec_unregister_adapter(struct cec_a
 		return;
 
 #ifdef CONFIG_MEDIA_CEC_RC
-	/* Note: rc_unregister also calls rc_free */
 	rc_unregister_device(adap->rc);
-	adap->rc = NULL;
 #endif
 	debugfs_remove_recursive(adap->cec_dir);
 #ifdef CONFIG_CEC_NOTIFIER



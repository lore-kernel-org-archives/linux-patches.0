Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8344A2EE993;
	Thu,  3 Jul 2025 15:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556196; cv=none; b=ijL8YdA+3Wm3pv1GHzTiqRz8InI6/hkAJwlIl1sgXVs31fnWK+tOb/t/36MyFSESFGNRAmZHeJ88GG3aBwcmSKJ9Lo846uXc9/ogu9enAfRMd35G47KG5Rf5nywRWVU4Ld3b5Dg7QUHTB/1K4ytAhBIbVb+hHd8lhp7PY/Yau2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556196; c=relaxed/simple;
	bh=bo4JHpO+8H54Gh16GSwsQyZr4wWQhvoO3EF9S440kW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5oRYxfKrDm6GLJ+R2+KPPy9v9/+ai1CZxQMdaq/j5wzmjPzOpAnFKur+pvRpKA2jkHZUmMuLTlqA9KNR4walgu8unC4hb8LQSItbnbBmLdNocUhRsi+1UpN4VAoZ52bQuelJCIYY/HTYX3hX11Nib/klu5NXOTD4+T8vzeFLcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vb3z/WuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vb3z/WuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93CCC4CEE3;
	Thu,  3 Jul 2025 15:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556196;
	bh=bo4JHpO+8H54Gh16GSwsQyZr4wWQhvoO3EF9S440kW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vb3z/WuUDna3BSrmtw/yTq+RI5geM05ic9DyPXntdRI/bmgrs3deu5Oq1KgQJFzBo
	 08vdF0dCN9QvvecbDYVU3HzpyDjV8FgfPvmSnC+T5xGsHJfawEMhx6SyAg4o+61Zsp
	 DoEs6XSbQd2LPLMMlGVexkeQc9IuBsEC6hjnn3Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.1 105/132] drm/udl: Unregister device before cleaning up on disconnect
Date: Thu,  3 Jul 2025 16:43:14 +0200
Message-ID: <20250703143943.512999170@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit ff9cb6d2035c586ea7c8f1754d4409eec7a2d26d upstream.

Disconnecting a DisplayLink device results in the following kernel
error messages

[   93.041748] [drm:udl_urb_completion [udl]] *ERROR* udl_urb_completion - nonzero write bulk status received: -115
[   93.055299] [drm:udl_submit_urb [udl]] *ERROR* usb_submit_urb error fffffffe
[   93.065363] [drm:udl_urb_completion [udl]] *ERROR* udl_urb_completion - nonzero write bulk status received: -115
[   93.078207] [drm:udl_submit_urb [udl]] *ERROR* usb_submit_urb error fffffffe

coming from KMS poll helpers. Shutting down poll helpers runs them
one final time when the USB device is already gone.

Run drm_dev_unplug() first in udl's USB disconnect handler. Udl's
polling code already handles disconnects gracefully if the device has
been marked as unplugged.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: b1a981bd5576 ("drm/udl: drop drm_driver.release hook")
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250303145604.62962-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/udl/udl_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -126,9 +126,9 @@ static void udl_usb_disconnect(struct us
 {
 	struct drm_device *dev = usb_get_intfdata(interface);
 
+	drm_dev_unplug(dev);
 	drm_kms_helper_poll_fini(dev);
 	udl_drop_usb(dev);
-	drm_dev_unplug(dev);
 }
 
 /*



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474252E5B39;
	Tue, 15 Jul 2025 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587663; cv=none; b=SlNnEuwV2x7dApluW9Otm/g90Jk1/eJHPN29AFVy6dNpl77FH4ZrFDF7lna9+pRd5dyvaNziVsEtmuzZdC6Bff3O/Sp3bgruP7vKR7hkEDxFcmXItoPk6fWMRu5eBtlb1i3SLsuraGBa9Jhi354NbASyEUy4lXkQg5y4MImyQjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587663; c=relaxed/simple;
	bh=h//pkb/TrtJiMs4uc1hwJ7mvR/U/cQmrFantLR8SKLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNWWKGlAi1PRcj8kdSV61umrreYPOv2JTGTB0Bg9CbwQcNKcmnv19NheFSyfueci2lvRH5RciPxuUT0ljZFI5/NsvvdTdc5IluOKJKmDKIa52f/NIZSqulFufDnwg8p2mg65yWakB1bZqjLdEF+lSuxxNgexOshYw20YO65mYMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQIemzrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQIemzrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA11BC4CEE3;
	Tue, 15 Jul 2025 13:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587663;
	bh=h//pkb/TrtJiMs4uc1hwJ7mvR/U/cQmrFantLR8SKLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQIemzrlLFNe9Btrki89iN1AQNf1zU2Tzy9wtgo7m8eK8o7ATdcOdkMR4byhIXJXf
	 8i0cdypc+JGhcWZDmqpQRu/ARGLVoqDqiYqnMzBOc6fqMnV5FskGh0AKifpKuN0Ymm
	 CpENIjzdfszbHvyohh7bExQeYS8o9wtIAIOEwnXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.10 065/208] drm/udl: Unregister device before cleaning up on disconnect
Date: Tue, 15 Jul 2025 15:12:54 +0200
Message-ID: <20250715130813.557353171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -115,9 +115,9 @@ static void udl_usb_disconnect(struct us
 {
 	struct drm_device *dev = usb_get_intfdata(interface);
 
+	drm_dev_unplug(dev);
 	drm_kms_helper_poll_fini(dev);
 	udl_drop_usb(dev);
-	drm_dev_unplug(dev);
 }
 
 /*



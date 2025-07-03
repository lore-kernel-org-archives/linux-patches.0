Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAD92EF29C;
	Thu,  3 Jul 2025 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554337; cv=none; b=FUYye20olD6tJszYBtfWV8g71I0ZkAVIsCjZMQpoyrzqjrNmA88N6YSqC9eO8IGLSF2jLWW6HBzodV+wvc8AdwVy/sGoSuJ3KukXA0KhhSpFBpw2ynz8l7LXKUE2vgkc7M97bIn0sQMWoqTk5nbPnWVUx+k4kNc5fNYR5D+bKvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554337; c=relaxed/simple;
	bh=5+wj4n+tiLJiMQbvNLOZaDRccKn/1ag9CrvSt5VYvl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+qpyhDhxZwg6tvaC9ss9OeAaMx7x2pfPlPz2RRq5UDSkStoKa05UpUW7YWsQvm8Ky4ohiFZiMS5aL9fVVe4YU2b5kT1SZTU5bdhJxrjNanOJgXhD+Z91UE4S/FtrotvGOg3/dQL73ylkINFA+Aq7AnpU1wjTwe0ur0YJKS1DY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWpHACwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWpHACwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0997FC4CEE3;
	Thu,  3 Jul 2025 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554336;
	bh=5+wj4n+tiLJiMQbvNLOZaDRccKn/1ag9CrvSt5VYvl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWpHACwWsLR8yH2t5k+NUBJE9KVRQvAHchK5+DgKBO48lduPhGqdJte8FR0WNcZCz
	 LcPIJoBTcMf3/ebfFVCt3W509GAFFDk4RFcFtp1dG7QvT3y7am/1lv6unDqAHXrHnG
	 lQP5MMLplwbd37irK3vZtd7j4UBZ6wNiOr7myJ4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.12 153/218] drm/udl: Unregister device before cleaning up on disconnect
Date: Thu,  3 Jul 2025 16:41:41 +0200
Message-ID: <20250703144002.269762376@linuxfoundation.org>
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



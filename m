Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EB81C32FF;
	Mon, 12 May 2025 17:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071987; cv=none; b=r4gCBKUBFGR/Tj8gTfWm7uiUzrf9czP00lSzfOSaZT3ncV0oEc9pSr3qJQLawT2eHRNZBzUU+pIFSCY+5e3JTodlFVRtgXTyNW3EKJOl7zsQYZvnIX8+pNXf+23X/WrHXeFEY6hmvlunj8zOx23b47nCFqeYypICmM1L20UxaRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071987; c=relaxed/simple;
	bh=LpfTkWM3MB+MsFsVeoNDovA6jinhNpVd2mGxBV0nxqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoXjUNnBI3tRtDwKhVSwg0QMdwjMi0ZwvHX/IFAfQVx4wpLE0H9+OLHA70+0FddariTq/HxtGiHFcGtyog4ZLt2lW7HyM+P1P9RufVzXmum86NFzZ+mqSJmTzCyu6euGoMGSBRAAKAqBFXT00uCkT7004nB9vLl30nHYabFIU5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnyZ3DwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnyZ3DwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A94C4CEE7;
	Mon, 12 May 2025 17:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071986;
	bh=LpfTkWM3MB+MsFsVeoNDovA6jinhNpVd2mGxBV0nxqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnyZ3DwSQjt1arDNZE7ol5h9Xi5hHQ42CiP4IcTAynFwMgv2kJ82K9RJ4Qs4re+W3
	 k8soqQ+tZyXNkZBQLRJ98j8PNuAVTCIThhSpP3+1hD5uz0jKAsDXL2bPHwQXz5n1Zt
	 M/NPcl6pBLxmMT4CC6w1eDS0yQUP8DaUk3FfWm78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.14 070/197] staging: bcm2835-camera: Initialise dev in v4l2_dev
Date: Mon, 12 May 2025 19:38:40 +0200
Message-ID: <20250512172047.233240401@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

commit 98698ca0e58734bc5c1c24e5bbc7429f981cd186 upstream.

Commit 42a2f6664e18 ("staging: vc04_services: Move global g_state to
vchiq_state") changed mmal_init to pass dev->v4l2_dev.dev to
vchiq_mmal_init, however nothing iniitialised dev->v4l2_dev, so we got
a NULL pointer dereference.

Set dev->v4l2_dev.dev during bcm2835_mmal_probe. The device pointer
could be passed into v4l2_device_register to set it, however that also
has other effects that would need additional changes.

Fixes: 42a2f6664e18 ("staging: vc04_services: Move global g_state to vchiq_state")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250423-staging-bcm2835-v4l2-fix-v2-1-3227f0ba4700@raspberrypi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -1902,6 +1902,7 @@ static int bcm2835_mmal_probe(struct vch
 				__func__, ret);
 			goto free_dev;
 		}
+		dev->v4l2_dev.dev = &device->dev;
 
 		/* setup v4l controls */
 		ret = bcm2835_mmal_init_controls(dev, &dev->ctrl_handler);



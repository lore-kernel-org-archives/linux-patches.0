Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7124D175BF;
	Mon, 12 May 2025 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072926; cv=none; b=PA9vFNVLd6IHXWhE9tQkk3jaYcwna4hyqMnc2wG+DnySyep/9OUABBB90KfHsaCQ9o1EcWn7MqGq3BM6iRbFmdtS4MrTOgWQbJT5jPadMx8PiO8a9jLjwQlveqa1452oQ7260e4YSUOuWa07aARqfftsLpMCHETPAAJV9j0JG2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072926; c=relaxed/simple;
	bh=N9a72ETdxXtnmcv2PR01/fKY2/JY4tnifqjZyHX1HJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIpzJznG0Zowyf91VhWG5HyLWhk+QnyeBGEp4DUok1jvLuFxU6q0sxBvK9w2sjQ4WvtkAqUgWAeSpL8wViGsZzC4dUPAb3cAiBrVCqh6OnLpQfyFSvGD8hsViNteCqLSWcnGKrdnw71Ed3hOkNUfxAr10v5JhFrtOW24BF35w14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIHeig5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIHeig5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D1CC4CEE7;
	Mon, 12 May 2025 18:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072926;
	bh=N9a72ETdxXtnmcv2PR01/fKY2/JY4tnifqjZyHX1HJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIHeig5X8k9iO4t724V6Oor1ajSEXe6Y3KN9G+ITZj9U6vhVr4lYhc1SEiHI+snV8
	 m9LO7wdtxjvkTse2NYdfqMH+VM6P8b/tIdrpjKphN2mSKxCPDjpG8eSydl98LRlpy+
	 qbyO6nos8+4fTn/EuyeQlZOIuROK8rlFsv83IJKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.12 069/184] staging: bcm2835-camera: Initialise dev in v4l2_dev
Date: Mon, 12 May 2025 19:44:30 +0200
Message-ID: <20250512172044.646254972@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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



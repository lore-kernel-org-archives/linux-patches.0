Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F11A345EB9;
	Sat, 12 Sep 2026 19:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239688; cv=none; b=ENMZ7H7wblKKo5nUXjvdk+/9YYCe6PtJFtQwBVQPskv11MdnOk3iZ1rpzolU1Mi9i6TJbTa0OEV9Jcg0HsOIvbxB0ruslBmK3uN0NK6sLbEB73/Es9Z47V2deRzY3nIDcrCDJBZ40M901VpMPIRHlvr0glw2fJBMlKETjpEx/2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239688; c=relaxed/simple;
	bh=8dweqkyG2yIe5VVcnd+BOenbzNJgMAWsAHoIUPHlnlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPU642ahpnjn71jFl0yyIWGayTsvBsxaY5pClb5vW4VkeGbcOMpa/Nimsm7cPDgnNtS77Xqm2uoDvorUA+SxxROG2P3afrFYiKt2gOnQE7zC4+ZPjKqO/vF83QaVpZVhpZYveg/w6DFBb/48DJLPwL0sdmq1B2hJru4570F6rTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qs/OcCX1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qs/OcCX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5582D1F00898;
	Sat, 12 Sep 2026 19:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239687;
	bh=dVW5IKxdQU3YT7oj/AHlX5C7vPSTELDW5dpoTDrgZDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qs/OcCX1ADf1eN5LUeLYkBq67nNBD4ONk/7JRrqx84JULJcPrKXWhSuFpyFHUo+R7
	 etRD05aM/f9Z+dNs9qdt6NvuY6tTAW/M+BwZTeOeF9spjw7vkWnrwr2VqIRQS3dNTh
	 iE1AgXQN0i47/kFtJHSrolg9XcqwKUj8g89QlkCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 713/935] drm/sun4i: crtc: Propagate layer initialization error
Date: Sat, 12 Sep 2026 09:02:23 +0200
Message-ID: <20260912065543.187693926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 7061ff05ed4a3cf16e83f7e3ad09cbd212508a32 ]

sun4i_crtc_init() returns plain NULL when layer initialization fails,
while all its other error paths return an error pointer. The only
caller, sun4i_tcon_bind(), checks the result with IS_ERR() and happily
continues with tcon->crtc set to NULL. sun4i_rgb_init() and
sun4i_lvds_init() then dereference it in drm_crtc_mask(), which
oopses.

Return the error pointer instead.

Fixes: dcd215801b02 ("drm/sun4i: Drop primary layer pointer from sun4i_drv")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/b26a0d427d9dfae9c82e3ca90a67d24d8ece5a28.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_crtc.c b/drivers/gpu/drm/sun4i/sun4i_crtc.c
index 45d9eb552d869..01f38a45bde98 100644
--- a/drivers/gpu/drm/sun4i/sun4i_crtc.c
+++ b/drivers/gpu/drm/sun4i/sun4i_crtc.c
@@ -207,7 +207,7 @@ struct sun4i_crtc *sun4i_crtc_init(struct drm_device *drm,
 	planes = sunxi_engine_layers_init(drm, engine);
 	if (IS_ERR(planes)) {
 		dev_err(drm->dev, "Couldn't create the planes\n");
-		return NULL;
+		return ERR_CAST(planes);
 	}
 
 	/* find primary and cursor planes for drm_crtc_init_with_planes */
-- 
2.53.0




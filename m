Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823631F6698;
	Tue,  3 Dec 2024 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238534; cv=none; b=TtDfzLDMtqyECdo0IruXaXJcfJgPKywc03plSp9AcwMSGfOYsTdYM67On+wepa3z2myRkD2FkxNS1wxb8t9TG1w8sNJLYOS+uEiDuRDKgF/vIEyMjX51ktiI/SN5sleaGn9rDjz3+ZTC8MHCv/eWOjU4GS6kEYneaSAJz2oeHU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238534; c=relaxed/simple;
	bh=XB9usfeA0bTK9OyNQR0NxxGrk4wdmcf1VAIrj5fSbcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GWsgH+GwLhxsmuowUgFma3K2kCzl1alU1DRuJlD2bLVdJCw0pu2dRXPp5l9fkRcR8Sb7HvjJUTIDxNx/VFXrucOEE8/YPyp15caEaUgC1Fax/uSvscUOKaKDHPplXg9tVi5LhR31+Um+epLvHXnEudv15g7lkUeaZfQ9pG1PAEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwhyT6vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwhyT6vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10108C4CECF;
	Tue,  3 Dec 2024 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238534;
	bh=XB9usfeA0bTK9OyNQR0NxxGrk4wdmcf1VAIrj5fSbcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwhyT6vdU+xspgMgiSckLqQoKCU3hIwGu28wbccqsfWgaU1GXdqWgMtqTIe6ofXpS
	 mXc08NXQc2djTfIgv32yLc3FPCQRJI+xoa3i7QRuHbOb6Sxg0H4Ep9pHzEZOaSiP9s
	 uDZ49vRJ4M2IYpglZHbnuwUJwQtaHOt8bki8dQYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 269/817] drm/vc4: Match drm_dev_enter and exit calls in vc4_hvs_atomic_flush
Date: Tue,  3 Dec 2024 15:37:21 +0100
Message-ID: <20241203144006.296303737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 6b0bd1b02ea24b10522c92b2503981970b26d1a2 ]

Commit 92c17d16476c ("drm/vc4: hvs: Ignore atomic_flush if we're disabled")
added a path which returned early without having called drm_dev_exit.

Ensure all paths call drm_dev_exit.

Fixes: 92c17d16476c ("drm/vc4: hvs: Ignore atomic_flush if we're disabled")
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008-drm-vc4-fixes-v1-2-9d0396ca9f42@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index ad2d8f6f1e9ef..50bfc514943a1 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -584,7 +584,7 @@ void vc4_hvs_atomic_flush(struct drm_crtc *crtc,
 	}
 
 	if (vc4_state->assigned_channel == VC4_HVS_CHANNEL_DISABLED)
-		return;
+		goto exit;
 
 	if (debug_dump_regs) {
 		DRM_INFO("CRTC %d HVS before:\n", drm_crtc_index(crtc));
@@ -667,6 +667,7 @@ void vc4_hvs_atomic_flush(struct drm_crtc *crtc,
 		vc4_hvs_dump_state(hvs);
 	}
 
+exit:
 	drm_dev_exit(idx);
 }
 
-- 
2.43.0




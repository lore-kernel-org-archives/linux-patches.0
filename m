Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C659A231A2D;
	Mon, 10 Mar 2025 17:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626974; cv=none; b=erXAfbs8C3EF39rYZm3sV3p5iYBxaseUwMZgTrfuHfTN94RiakWrHP2xH7tH3tftMiZgf7qjBTQS0ExMDbXu/ZFSdMmVcPD9gkNDaynntFdTWJYrVScAF59c6fuwk8MZW9OSbgregRtdoX02b2MLTMRvs8nag2Q9hJA1/PSf5rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626974; c=relaxed/simple;
	bh=1eWag9KY0Ryz964/FpUyH6+B48eI31nyllL8FBMjKzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw6X3ZSdPRdz4VcoE+FRsVktm01mwtORtKL+agPduW2nZq/e9hqzpZAMJwl5k0GILcQ7PGRi7iv7tZot+AJn9I5jaQVQn0MfR26ZOEqlwcc+vguZjHSn3N3UX4XgTIlwl/q8u3kzrgsbnzgaIxqBvYQa7As5q7SPj+9ShRR+v0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCd5+ez+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCd5+ez+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EE7C4CEEB;
	Mon, 10 Mar 2025 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626974;
	bh=1eWag9KY0Ryz964/FpUyH6+B48eI31nyllL8FBMjKzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCd5+ez+dNPiixDARQFTuSdjPNnGnx+DhSBOV2RltNeqWuVwKZPdg4C54Xeq27Cuv
	 KPba99KrGQ2wkivUfEtkBQ8+B9xNsgM4kE9Af1kugVstffV6Yh2VpX+qfjv1BURzIW
	 p0B0F132b6LfunO7qcn1RUj6RKpDwg0BCv0kWL8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 146/207] drm/bochs: Fix DPMS regression
Date: Mon, 10 Mar 2025 18:05:39 +0100
Message-ID: <20250310170453.600026838@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 80da96d735094ea22985ced98bc57fe3a4422921 ]

The recent rewrite with the use of regular atomic helpers broke the
DPMS unblanking on X11.  Fix it by moving the call of
bochs_hw_blank(false) from CRTC mode_set_nofb() to atomic_enable().

Fixes: 2037174993c8 ("drm/bochs: Use regular atomic helpers")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1238209
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250304134203.20534-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/bochs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tiny/bochs.c b/drivers/gpu/drm/tiny/bochs.c
index 6f91ff1dbf7e2..4e7d49fb9e6e6 100644
--- a/drivers/gpu/drm/tiny/bochs.c
+++ b/drivers/gpu/drm/tiny/bochs.c
@@ -335,8 +335,6 @@ static void bochs_hw_setmode(struct bochs_device *bochs, struct drm_display_mode
 			 bochs->xres, bochs->yres, bochs->bpp,
 			 bochs->yres_virtual);
 
-	bochs_hw_blank(bochs, false);
-
 	bochs_dispi_write(bochs, VBE_DISPI_INDEX_ENABLE,      0);
 	bochs_dispi_write(bochs, VBE_DISPI_INDEX_BPP,         bochs->bpp);
 	bochs_dispi_write(bochs, VBE_DISPI_INDEX_XRES,        bochs->xres);
@@ -506,6 +504,9 @@ static int bochs_crtc_helper_atomic_check(struct drm_crtc *crtc,
 static void bochs_crtc_helper_atomic_enable(struct drm_crtc *crtc,
 					    struct drm_atomic_state *state)
 {
+	struct bochs_device *bochs = to_bochs_device(crtc->dev);
+
+	bochs_hw_blank(bochs, false);
 }
 
 static void bochs_crtc_helper_atomic_disable(struct drm_crtc *crtc,
-- 
2.39.5




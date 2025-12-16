Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F891342505;
	Tue, 16 Dec 2025 11:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884869; cv=none; b=bDCmSMuzxCn7dmgbi2XE1vx29H90hu63ArT8YerK/F9MvdSIX22Q6hAPzDPmnbnYajFqma6QJ9eRQ+svzC1By6c0K0PtrFsnk/53fKKnBFVXJ4N5QWICaZoOS//RNFoQxdDfd/ZTUqBag6s4OJjhsi10aDtBgNuuR2LsdQN+8GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884869; c=relaxed/simple;
	bh=/KIKthTFQJ4ghJSUpYcj8gaGCef/Kj2Bpgzo0lURMbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA1XbMrKLqVT4puFA0l+8dM4/hmRPCaDK4riXmh+ul9ZzHg/C9BG68ySOK4UpDEhThcuSHhEzmHaojd+OmGkENbS6C2hQ7WGofvD8KuD5GrIzZ57i1MZ2SFUot1n8bcyXleK1yshzmCP1hmivOy7XY6oEDOnzfS0zy+WvyPowKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8ghUOYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8ghUOYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88767C4CEF1;
	Tue, 16 Dec 2025 11:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884868;
	bh=/KIKthTFQJ4ghJSUpYcj8gaGCef/Kj2Bpgzo0lURMbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8ghUOYzTZnEtfcLco9P92ZApPnwUw6Fr+2l+jnAy15MzKFgcNJGuXacEU6QrAzE2
	 Vo//z5L9D74a7mZjkauqV91/IPq663n/jjElQQ4H+ppQJ1qZxKomF5j/Ubk6MWdyW/
	 ZM3AnWvNrzqGx2cX9fgpJTeWFbpsFMqU2Mo65JAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/354] drm/plane: Fix IS_ERR() vs NULL check in drm_plane_create_hotspot_properties()
Date: Tue, 16 Dec 2025 12:14:51 +0100
Message-ID: <20251216111332.647567825@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 479acb9db3199cdb70e5478a6f633b5f20c7d8df ]

The drm_property_create_signed_range() function doesn't return error
pointers it returns NULL on error.  Fix the error checking to match.

Fixes: 8f7179a1027d ("drm/atomic: Add support for mouse hotspots")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/aTB023cfcIPkCsFS@stanley.mountain
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_plane.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
index a28b22fdd7a41..4fcb5d486de67 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -328,14 +328,14 @@ static int drm_plane_create_hotspot_properties(struct drm_plane *plane)
 
 	prop_x = drm_property_create_signed_range(plane->dev, 0, "HOTSPOT_X",
 						  INT_MIN, INT_MAX);
-	if (IS_ERR(prop_x))
-		return PTR_ERR(prop_x);
+	if (!prop_x)
+		return -ENOMEM;
 
 	prop_y = drm_property_create_signed_range(plane->dev, 0, "HOTSPOT_Y",
 						  INT_MIN, INT_MAX);
-	if (IS_ERR(prop_y)) {
+	if (!prop_y) {
 		drm_property_destroy(plane->dev, prop_x);
-		return PTR_ERR(prop_y);
+		return -ENOMEM;
 	}
 
 	drm_object_attach_property(&plane->base, prop_x, 0);
-- 
2.51.0




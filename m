Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24E339B6CE;
	Tue, 16 Dec 2025 12:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888655; cv=none; b=Th9+ISHodrmx1GiLgHcUB9/5OYOwOqgBrtvvhaCjROWzb549rZp8j9ZYY2uQAl6ZO077/LIMhYbQlCN5EzELU3AnfXPiKy2QawWyUva98f/32Xp62arPtgVZCtCjZD2kXfDXeRyiZqwbhZ//7N3uRiWG0h3n64ZwwobYlkXyH3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888655; c=relaxed/simple;
	bh=G9BKLI9LT8kabUxiPhl0JQCI6bEDqkh4iF1LTfH+KUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSXRYKWttYTLcdzD25JxRn44UJwghGOK8sLQMgfmCur5NxkvKLBKG91TJX7fP77Eiy0WfJF6qTs0+WObT6ui4RTrQOVNt1MYKwo7gOK0t7hhq2XqWKDziHNBOhepzni9Bp89Gyv8NbQ/rBn9UVx4qUx1L5YzRIBl85ekhsVpHEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhQTX++I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhQTX++I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E7DC4CEF1;
	Tue, 16 Dec 2025 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888655;
	bh=G9BKLI9LT8kabUxiPhl0JQCI6bEDqkh4iF1LTfH+KUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhQTX++I7ECf7EycJJmoskmXbTmPj9xzXb5/bTbA05yo8jh330pJoMKvlSqJHIpwK
	 wo2dsV+1p5T4cdnxS331WrlyZNp+9/CPPYJIT+fYJQsoZwrWLnCftmN4TnzI6ykx83
	 9I0h0OmF/c3ICsMG7/oYop4t7PvmL46mrTFs79GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 565/614] drm/plane: Fix IS_ERR() vs NULL check in drm_plane_create_hotspot_properties()
Date: Tue, 16 Dec 2025 12:15:32 +0100
Message-ID: <20251216111421.855441475@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index a30493ed97157..4cadea997129d 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -338,14 +338,14 @@ static int drm_plane_create_hotspot_properties(struct drm_plane *plane)
 
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




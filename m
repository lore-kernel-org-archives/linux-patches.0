Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB831A5B84;
	Mon, 23 Mar 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277248; cv=none; b=YxXszVqdDs/v/+7tr9E5ZkcAWezjhWPukPznTZ36By8iAYFsp1EdFzO94/n94qHR+cQ+oDv8YL0rHfAp2SzTbti3MXCvYmbezTeGSWb3OO14YAxGQ/OeBCZnJriInaKAtYSLxLNwvHJU+WzsjHNLZ7+ckFiNk6uxCe83eaAVuUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277248; c=relaxed/simple;
	bh=3Z4xaFDWhsIOF+VurN1BF2aBY78FX2NIzYXZ+8sLFOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwRrou6R2cL+Y0oSlD6E0UMM9DheA12tNd85jRe3dIXYBUwSTTnwcVPhKAxSjDRjjj/RpitGRmG0f6Y2FlMjyAMaFfOjYu7ToEGBZA6V/VKQMSCqJYlcc3o5QXDIeNnlWuOyoAbDuK4aZwBCbM04It0gVVdjdEkVhawpzIgIb5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giHaf6U4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giHaf6U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612A9C4CEF7;
	Mon, 23 Mar 2026 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277248;
	bh=3Z4xaFDWhsIOF+VurN1BF2aBY78FX2NIzYXZ+8sLFOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giHaf6U4Kvf8McI4kFv4yRwey1GQykWMnrtz6YkTlLz0iK4QQfVTfxOnYk4VDk3/f
	 FMiHzQ6TVmSDxNPS9nXRaYra9geGYpdf+mccB8xeC7164h6ka7I+pISNrg+hawHuuV
	 eR3UiPgSXY82WdpsYscHThJ8sHUer/W2W6Fl3i94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 369/460] cache: starfive: fix device node leak in starlink_cache_init()
Date: Mon, 23 Mar 2026 14:46:05 +0100
Message-ID: <20260323134535.632107525@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 3c85234b979af71cb9db5eb976ea08a468415767 ]

of_find_matching_node() returns a device_node with refcount incremented.

Use __free(device_node) attribute to automatically call of_node_put()
when the variable goes out of scope, preventing the refcount leak.

Fixes: cabff60ca77d ("cache: Add StarFive StarLink cache management")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cache/starfive_starlink_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cache/starfive_starlink_cache.c b/drivers/cache/starfive_starlink_cache.c
index 24c7d078ca227..3a25d2d7c70ca 100644
--- a/drivers/cache/starfive_starlink_cache.c
+++ b/drivers/cache/starfive_starlink_cache.c
@@ -102,11 +102,11 @@ static const struct of_device_id starlink_cache_ids[] = {
 
 static int __init starlink_cache_init(void)
 {
-	struct device_node *np;
 	u32 block_size;
 	int ret;
 
-	np = of_find_matching_node(NULL, starlink_cache_ids);
+	struct device_node *np __free(device_node) =
+		of_find_matching_node(NULL, starlink_cache_ids);
 	if (!of_device_is_available(np))
 		return -ENODEV;
 
-- 
2.51.0




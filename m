Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A12B3939A4;
	Sat, 17 Oct 2026 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257372; cv=none; b=MCVqv6+FlgxXdARXja0V3KfBD348aNWuDks1c2SH9Ze8HpQad73JgYHlYtmuMir5AYtAu13n+9yqxb5spGpymfG8yDrdiGS1f4SPgTDOWeNS1EyyfrhbQ1twsukPq9gUyGMKqTOWKcMhkEkjaWg4psUsf/8GKcEgtTFOtOEq+CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257372; c=relaxed/simple;
	bh=rvm0NBlA1G1Oz2YvEBdnKHoncaHfUP2F858QuD6hCGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B673jKYDiYQEDlOLfWmF3c7sTmmUR6kRTltagtLXPqhNnM51j0oegrHPwvL9qrkDwRs8QdgSUC1hiJqXUyWRtiBwaOXQsqGo9ufqnJiFEGTteHExDIhxS9XsLog8eqcITKF5InaOgujvEBD2K5UyxezIfQRw71k26/aThUBygRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eU2E76hP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eU2E76hP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F12C1F000C4;
	Sat, 17 Oct 2026 17:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257370;
	bh=XqGWf6T1clTBOzbnP74VXzoNau9SKq3T6aS+BibgMLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eU2E76hPlGvwohG+xGFqq2EL3rjeeSn6D5ZcPGbm3y6zpEmvIFmZMS6EjVBzuMHWo
	 Gkfrr6JE2zowWXJtzzCRHkl6CYyTeHm+k/tlhtl6Hf895DBnMzJif/9hmv+AFhu8Lf
	 AK15VVwb8yzOZlvEu4li5/PwMER4z9zBgKwOme8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0539/1674] drm/vc4: Free the BO cache size list on teardown
Date: Sat, 17 Oct 2026 17:46:51 +0200
Message-ID: <20261017160444.936456701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit b41ff8b529278216cba22a5dcdc93fea2a3a9619 ]

vc4_bo_cache_destroy() purges the cached BOs but never frees the size
list, leaking it on every unbind.

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Assisted-by: LLM
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20260930190721.1897264-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index cd4f528a93ced..99b4e3c9474a3 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1054,6 +1054,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
+	kfree(vc4->bo_cache.size_list);
 
 	for (i = 0; i < vc4->num_labels; i++) {
 		if (vc4->bo_labels[i].num_allocated) {
-- 
2.53.0




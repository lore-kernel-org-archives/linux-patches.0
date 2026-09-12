Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C90B35DA40;
	Sat, 12 Sep 2026 18:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237979; cv=none; b=mOhSx2SKRkDoUCWZtAEYscyeXJD7/6xXTJAygwUdxE6epp1FSpLlcRjlSULY+Oip+NXPenku49eQS7uM8TmFp/Ibkk6mreXMnBlDUH3bU9rhXV6Q/CuVJQMjLgyKALLgzsR9IPTdqmc0cKWI0iAmFqvPooJptEZtUJU3AgqVdnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237979; c=relaxed/simple;
	bh=fW51Gu6+qqXkK3lqIloI8p1zOB8FJbN4yaaRzgtxWa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEqLIv2n8jRv5sY+GCxNcpPW2yc9hkGqR9NxhrKOELXslN98gDvpN+dcFUbv2GdO2rvIHi/fTKyra53D8L/fmRJX4sdYGDiUI0ZpKs/ssY6Xekt4NXfZSF8Bi+RQUbW6C2EWWbQuwkUQdVcmExYkyKRiDn8xRBpINsj5VbH2bOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gH+XN5Vn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gH+XN5Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C3E1F00899;
	Sat, 12 Sep 2026 18:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237977;
	bh=BXN91dwqcPiPE9RZg3jGNXgN0+VHUjRzh+R7TRH47Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gH+XN5Vn/xdX1sufLL+Vvep87WtDEuCjG7C8m4UYp1CjVGKkKKCca3jG3MYPYg90B
	 VNLvwFlB7YJ+iLTd4O2SoRAozfGWmQjRbmGsz9qwuy+uTNwalzUuHyrZrd5Jrc4QvZ
	 Gb6vK9zR4uRE0Nea+d+6Z0Zq3stD6C/sGZUbgNIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.15 369/935] drm/nouveau: Use write-combined maps for coherent
Date: Sat, 12 Sep 2026 08:56:39 +0200
Message-ID: <20260912065535.271400993@linuxfoundation.org>
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

From: Faith Ekstrand <faith.ekstrand@collabora.com>

commit 774b73428e6eabb4f0382aeeb76e569c7b106a29 upstream.

On Tegra devices, uncached maps translate to device memory, causing
unaligned accesses by userspace resulting in a SIGBUS. Instead, use
write-combined maps to ensure proper access.

This would also affect discrete cards on any Arm device. It was
determined that discrete cards regardless of cpu arch should use
write-combined maps for coherent anyways. Thus this change is made for
all gpu types.

Cc: stable@vger.kernel.org
Signed-off-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Co-developed-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Fixes: 1b4ea4c5980f ("drm/ttm: set the tt caching state at creation time")
Link: https://patch.msgid.link/20260821-tegra-coherent-wc-v2-1-2b1ddb67bf18@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -73,9 +73,7 @@ nouveau_sgdma_create_ttm(struct ttm_buff
 	struct nouveau_sgdma_be *nvbe;
 	enum ttm_caching caching;
 
-	if (nvbo->force_coherent)
-		caching = ttm_uncached;
-	else if (drm->agp.bridge)
+	if (nvbo->force_coherent || drm->agp.bridge)
 		caching = ttm_write_combined;
 	else
 		caching = ttm_cached;



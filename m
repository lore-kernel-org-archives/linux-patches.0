Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D780358F065;
	Wed,  9 Sep 2026 14:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964403; cv=none; b=c1bLSsPIq7fA/XBoWHtYSO6vUhSTcQXlwACUay+ZlgB4tG47kgywZn0jA0d24LJlrIIMwnUjXQX497vB27n4HgtNBoXhqlZ1b4TNMS5vLRgpvHIvloBKvQxn4L+gdrGg2bYjJwZKA4CFMvQ9RLlNqz+fid3Eu6xl3FAwgMwk+UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964403; c=relaxed/simple;
	bh=gYGg2BEnDKxp9bLeSge1cbTnT1vN33Z4SBdPN+DKSuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0+dMmBQKwa8wGd/3PNkRFM7QxyfOv1oHSg9JsLNY9JxzE2YmhqeW9IRFP1JDF6Qj6sdJwvJibtQCLBsLnWK7gSdFkAsUp5I+v8xmKwobxFkO5g8a4RZP1ACW4PD7ZR7UN5nlOMWcX7KncmzqXvIfJvPVrC/l1Z3bisqgc5PkZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVftC8pZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVftC8pZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC3F1F00A3A;
	Wed,  9 Sep 2026 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964401;
	bh=Ge9ckRlcl1+nSTft4rNUsYE2g0E7aH+AMU5Yz70MaDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVftC8pZC8DutHZt6eSS6kiveN2RqqufNFSrHKPJgRaYJcGGNdt1pW0lCoWXEiq7r
	 hdM4R5NTjWsA3KhA2wE4cqO2qulXdvZOqBityH2M8MBn1VS90X9pdBCQ3g56xAgo27
	 Iay+F3RaXYKG4EtyW7kwF/fFaYsiXLO8FGxJY9Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 411/583] drm/nouveau: Use write-combined maps for coherent
Date: Wed,  9 Sep 2026 15:41:36 +0200
Message-ID: <20260909134252.219475083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -72,9 +72,7 @@ nouveau_sgdma_create_ttm(struct ttm_buff
 	struct nouveau_sgdma_be *nvbe;
 	enum ttm_caching caching;
 
-	if (nvbo->force_coherent)
-		caching = ttm_uncached;
-	else if (drm->agp.bridge)
+	if (nvbo->force_coherent || drm->agp.bridge)
 		caching = ttm_write_combined;
 	else
 		caching = ttm_cached;



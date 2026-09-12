Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA09C37FF60;
	Sat, 12 Sep 2026 11:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214227; cv=none; b=Y+qZZzIDJhAVy0g0gSjTSPlck0ZNu9i8O/uvYHJ3x/1a7rlYsdffsWHv1N2t8KKTMrIoDlq8fU1KN7lMkcGaasYQ2xYleLhHsSp1TnzFiEA/AxzK0ekZJWBvglyuczqHDaldEpWvccwVsPRSkjxAaQ60+HyPbeijLS64Etbnv9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214227; c=relaxed/simple;
	bh=u9uelNqVq+UuAMedOQNJntFn6GPM5HJTfyg2Sh0f9AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMa0cHHI4eRyZq7KExlSIJrwnrRQE4Q8TSD7UQYrfESkvv2zNa5CKHFsvkeWVDga/nea7GXBuCNicAJc1iq8wbK1msHOJYM9mInd8ur1vKlPAl1jBTqREatFRCQ08bLDmqEnehr9y3wmMRq/6iqYvvqgzCh2pK1/l3yEiFLVlAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeCJIuXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeCJIuXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5FF1F000FF;
	Sat, 12 Sep 2026 11:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214226;
	bh=hPkmcY6ICE18gZ/KnZUEqTAdbF70hFRhn+xrsReTEwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeCJIuXfL2c2P7TUa8YoEi4gHxlYmeGTdqnNChCtS91UfiTZjY7fnof6GhSnxoO0y
	 dmK35dGO+axMfqSs8HMrSMhHcfoIzimVnI8xcLkB95n4dUK7EPvxsf6yHbp+w1eltz
	 rD9/K8RRtHfCL6PhiAzPbb1nTIYgTHdY1ZL0VlN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 0282/1376] drm/nouveau: Use write-combined maps for coherent
Date: Sat, 12 Sep 2026 08:45:08 +0200
Message-ID: <20260912065613.831386946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E5A2D23A6;
	Sat, 12 Sep 2026 14:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222137; cv=none; b=OAs52g3Pn9Ot2520jCu4MsrSSOFwj+L5x9HYeFlwyavUC/phxB4WduJQ6SBHlcqG4wvgiE4FX8Cux9fwKRe1MwySFxUI44Xzq9CWf4LPDNdC75uwoiawDOXfm1+iDrNndtrlioupf9Tp4M6FEVWCJAMeZw6Py0a6CTe+7wxDFl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222137; c=relaxed/simple;
	bh=DPqwC7v30NBZ7HUQoYsFtfvu411NnFf1b+c0R7HQwOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPRvzrh7SpOpRr0LtAAqydszj6SS/rlCVLOnY55URJl1HPBzoprP2znN4iAxbAIT0lasmVSP0xVmnJAKZzzky5YulVYMc+HiA8mOHqpUoWHPPT5qBvkAcX5SpluagRZ+srUEJx4m6zUP8Hf9yySDZP7B7N4EcnBvsoZ5qRhf4M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAFrhRal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAFrhRal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FB01F000FF;
	Sat, 12 Sep 2026 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222135;
	bh=yjLYnC8qzvIBP6N8oPvkA88o8PPTgCZjfJC8FefU1rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAFrhRalNlACg6YTTodSerlMWY2ALxGdcL5xpnL1U56QSUoE8HQ/QD8bHGxvk55dr
	 yMjN5c1mAsUzzYuU3esthYRL0Q+NNqfFj/siHQZqnoJCizFoxz0kWoM2Sfd21nCFZ+
	 3tESmFXy3E0kJqaJ2WniIzVQ7LOiC9pp2aLvApGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 0525/1424] drm/nouveau: Use write-combined maps for coherent
Date: Sat, 12 Sep 2026 08:49:17 +0200
Message-ID: <20260912065619.049784145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



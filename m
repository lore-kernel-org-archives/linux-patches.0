Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215752;
	b=qFXfHHBeCMj/16OR15jbQ72GM2Srxrxl2DiLCNAHwwgSDhKq2tWMnZ3XrVAZ69whmj+7
	 xuBizA6OKVwRnN7OfBn5/5i6ARUb+SQFJkTaoyDKn83UwGCSzDbFq3EPb5Rw4KuNmCbUZ
	 0SXPFLH1h7NqMSz60hTjlijn2Po0cBlAy/cWJnx3/tSaV3+shjKwR8XQFYF+d8mrBjFf9
	 BtyLhp9IZPvdxjvPRlUB5XzgAfAEXBaVSm/TxkrEj2BMXoGo/qHYpOEA6burTgVQuzEw5
	 8mr74278OD8NUPseyl5OJRAKT5OQpINJqlyIkozEfhU+d8X9DUrZlv+QY3qskQB2KcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+RgJoaC02YmWai7iGH4QFE++cvOn+90nrbMtU0Ep1l0=;
	b=Wnm3w1IWAG0dTdQVyHZE2i87uyssbBx0Zd9lrTV5fNQIhtlKpuaoL9np7K6s9m3+XzpM
	 l/H2jmkOw9dSzr8aexzTuRq0yA2Oi/uKXTKEfJwbkoLxv7yWSXdl1JOkE3K2RZnu3CdH1
	 2YWwLDZhSDgqbQCHWpP/Ax16lxOZioDcWsrzzQzjo6QtDTOhvK48/BGt+0bmn5TghjABK
	 DZMRLSbi3kfVN5F86Vrb74NDWx4oW4DxPRDZKS0bnYLIxwVYe7CaZ63jp1/kGKK7SjGfF
	 4UlHcCLB+0hg7VIBzRfAySJf0CXq9DpAR0SdVJB5UfOVtJDgtViMSjheTnlRr8Zh9nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LBu8GSN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E58606A320;
	Wed, 28 Oct 2026 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LBu8GSN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39FC1F01825;
	Wed, 28 Oct 2026 19:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215751;
	bh=+RgJoaC02YmWai7iGH4QFE++cvOn+90nrbMtU0Ep1l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LBu8GSNU8RYmCrsru1m98vcVYTWfqaqStbBcF2eRYcbSVcXokfFbpZJcAhcxlsT0
	 oKlJAaGOYtlomtTD5WIBx8OHju+tPv7ORYeLVZld6jll70NtDCglNRzlvPHR+3PKij
	 nrYHYt04PVQOIBH6BiNh/Nub/MO2ssfnruTM2cao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Kasselman <werner@verivus.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1277/1887] drm/radeon: fix integer overflow in radeon_align_pitch()
Date: Wed, 28 Oct 2026 17:56:13 +0100
Message-ID: <20261028170528.482836028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Kasselman <werner@verivus.ai>

[ Upstream commit ce3b24eb3ee8f82de851535f516bf21f83e82259 ]

radeon_align_pitch() has the same kind of overflow issue as the old
amdgpu helper: both the alignment round-up add and the final
'aligned * cpp' calculation can overflow signed int.

If that wraps, radeon_mode_dumb_create() can end up returning an
invalid pitch or creating a zero-sized dumb buffer.

Fix this by using check_add_overflow() for the alignment round-up and
check_mul_overflow() for the final pitch calculation, returning 0 on
overflow. Also reject zero pitch and size in
radeon_mode_dumb_create().

Found via AST-based call-graph analysis using sqry.

Fixes: ff72145badb8 ("drm: dumb scanout create/mmap for intel/radeon (v3)")
Signed-off-by: Werner Kasselman <werner@verivus.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_fb.c  | 9 +++++++--
 drivers/gpu/drm/radeon/radeon_gem.c | 4 ++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 6ccea51d40722..46800703cd20f 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
@@ -91,6 +92,7 @@ int radeon_align_pitch(struct radeon_device *rdev, int width, int cpp, bool tile
 	int aligned = width;
 	int align_large = (ASIC_IS_AVIVO(rdev)) || tiled;
 	int pitch_mask = 0;
+	int pitch;
 
 	switch (cpp) {
 	case 1:
@@ -105,9 +107,12 @@ int radeon_align_pitch(struct radeon_device *rdev, int width, int cpp, bool tile
 		break;
 	}
 
-	aligned += pitch_mask;
+	if (check_add_overflow(aligned, pitch_mask, &aligned))
+		return 0;
 	aligned &= ~pitch_mask;
-	return aligned * cpp;
+	if (check_mul_overflow(aligned, cpp, &pitch))
+		return 0;
+	return pitch;
 }
 
 static void radeonfb_destroy_pinned_object(struct drm_gem_object *gobj)
diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index 3388a3d21d2c0..5e5d4de65bf77 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -831,8 +831,12 @@ int radeon_mode_dumb_create(struct drm_file *file_priv,
 
 	args->pitch = radeon_align_pitch(rdev, args->width,
 					 DIV_ROUND_UP(args->bpp, 8), 0);
+	if (!args->pitch)
+		return -EINVAL;
 	args->size = (u64)args->pitch * args->height;
 	args->size = ALIGN(args->size, PAGE_SIZE);
+	if (!args->size)
+		return -EINVAL;
 
 	r = radeon_gem_object_create(rdev, args->size, 0,
 				     RADEON_GEM_DOMAIN_VRAM, 0,
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FF0377A82;
	Thu, 20 Aug 2026 16:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244056; cv=none; b=ojgDDK1A9BIuM+7rWeXviGu40ikVL6SsZfut5PVPPTJyeRmWUTaDaq0Ut5V6JjUbFFk4/GtbML+09I8HmuPSOGIuus2CigR8ZHY7NIYui2f9fyt+YOGZnWFmmRka9Vk6L1Q6Hqg0QhS82IMnYQ67XJxo3Uy2Fy9Rj9sp5F8Pfxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244056; c=relaxed/simple;
	bh=bJ9gOxdIWe2iTV8/I6JVPHM3zCKGVgbMpIY8q7cJNtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IPYl6gVmnQ29KUZS9oT//t47i5gxcc1U+G3BmoZTp49rQtIsGZUgwH8Vy7rMZfvngJR8RkNZmvOpb8BxsR7tASG3ie8CTYXk7EFdbgs7QWaRSyOrZQM2j8xaRXJ8TcFm23a3HfVIAryRWKiBGSre+gqJ2xR78Mq6YhgQwC1LIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fR3ff/77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fR3ff/77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410501F000E9;
	Thu, 20 Aug 2026 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244054;
	bh=Pz055Lm4obwVgmZK5LgJQdnFMS6q2d4nhFjcvn9ecFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fR3ff/77+loce7tZ3UHZwe4cqOZJwtRNbFnHTJzycUsGw13fOZZ+i1A6/fhkA1xKh
	 yTfJ78NntPFkz8Fn5JPL2YDKPuV3RKUFKu3dpVv+Pcf+/3EWeUbLU4hVwY/XqJSdx8
	 lpG9VkPkQy6ETYRcs4tCb1s5ShW/G1Vwzur5Etuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 036/235] drm/amdgpu: validate GEM_CREATE domain combinations
Date: Thu, 20 Aug 2026 16:54:32 +0200
Message-ID: <20260820145217.526840550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

commit 5e9d136ad74df4edec67e502ce267597064d8f86 upstream.

AMDGPU_GEM_CREATE checked domain bits against AMDGPU_GEM_DOMAIN_MASK,
but did not validate domain combinations. Userspace could combine
CPU|GTT|VRAM with DOORBELL, GDS, GWS, or OA, making
amdgpu_bo_placement_from_domain() exceed AMDGPU_BO_MAX_PLACEMENTS and
hit BUG_ON().

Allow combinations only within CPU/GTT/VRAM, and require non-CPU/GTT/
VRAM domains to be specified one at a time. Return -EINVAL for invalid
combinations in amdgpu_gem_create_ioctl().

v2: Rename helper from amdgpu_gem_domain_valid() to
    amdgpu_gem_are_domains_valid() (Christian)

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit db39852d0c39843cb02048dfb47e4b8c703e9080)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -197,6 +197,25 @@ out_unlock:
 	ttm_eu_backoff_reservation(&ticket, &list);
 }
 
+static bool amdgpu_gem_are_domains_valid(u32 domains)
+{
+	u32 normal = AMDGPU_GEM_DOMAIN_CPU |
+		     AMDGPU_GEM_DOMAIN_GTT |
+		     AMDGPU_GEM_DOMAIN_VRAM;
+	/* Treat all non CPU/GTT/VRAM domains as special domains. */
+	u32 special = AMDGPU_GEM_DOMAIN_MASK & ~normal;
+	u32 normal_mask = domains & normal;
+	u32 special_mask = domains & special;
+
+	if (!special_mask)
+		return true;
+
+	if (normal_mask)
+		return false;
+
+	return !(special_mask & (special_mask - 1));
+}
+
 /*
  * GEM ioctls.
  */
@@ -228,6 +247,8 @@ int amdgpu_gem_create_ioctl(struct drm_d
 	/* reject invalid gem domains */
 	if (args->in.domains & ~AMDGPU_GEM_DOMAIN_MASK)
 		return -EINVAL;
+	if (!amdgpu_gem_are_domains_valid(args->in.domains))
+		return -EINVAL;
 
 	if (!amdgpu_is_tmz(adev) && (flags & AMDGPU_GEM_CREATE_ENCRYPTED)) {
 		DRM_NOTE_ONCE("Cannot allocate secure buffer since TMZ is disabled\n");



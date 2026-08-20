Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E49B38A70B;
	Thu, 20 Aug 2026 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239543; cv=none; b=SV6lHZd5jZfk4bm2SVTQioECPF8UmamKxgqvxjfmydKIu0nKofcPVBHv7CV/PEoOgSAvgFDAXLJl9HgCH4Q4p9u0mvpY+JRmA+94E82XwMzAj4c1WQ+sIVLcD2e4qqJJv2OzFo6wWpfbsSjRgUpkao9syBFzk7BK0mV+lIN6PyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239543; c=relaxed/simple;
	bh=mSt2dK+PmzgzrYQZiT2t8/imr2vUjLaixSkdi3ydQos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K3W5MP7J2l0sevoYoL66ZICZ9Ex8UKahOULThcPI4BlxwGJroG77GZZZ2uECXjsZIKY0EMIAcOFgml/RL7YsgZaL8A+ygQ3Wwb3KMicv5mQPZIOqGZ4MDv5BrmS5S3/ZZPOsb9z8tzsACeuLW0sOn2PaGZ+/8jLeK1Wr6UO1F5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhllQX0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhllQX0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E751F000E9;
	Thu, 20 Aug 2026 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239542;
	bh=4YBbCRw1WiNlpcR7FO7inx2QTdqZsCIue44ew3NcbXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhllQX0JW6NoXc5P1rWviYArDkzkf5I33awLLS8LJwif+tIJaC6pE1JsejD/Bjuef
	 RpOnKdGXs8asLV34hT9NGl3gVc+btwT293ougx9J6PdIBc2koIya8cKVd4C72EdeQI
	 hVdAxgVWUohzQh1dnHvrt8HABLJ37qRlCKUrKzrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 085/220] drm/amdgpu: validate GEM_CREATE domain combinations
Date: Thu, 20 Aug 2026 16:54:35 +0200
Message-ID: <20260820145226.037943167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -304,6 +304,25 @@ const struct drm_gem_object_funcs amdgpu
 	.vm_ops = &amdgpu_gem_vm_ops,
 };
 
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
@@ -340,6 +359,8 @@ int amdgpu_gem_create_ioctl(struct drm_d
 	/* reject invalid gem domains */
 	if (args->in.domains & ~AMDGPU_GEM_DOMAIN_MASK)
 		return -EINVAL;
+	if (!amdgpu_gem_are_domains_valid(args->in.domains))
+		return -EINVAL;
 
 	if (!amdgpu_is_tmz(adev) && (flags & AMDGPU_GEM_CREATE_ENCRYPTED)) {
 		DRM_NOTE_ONCE("Cannot allocate secure buffer since TMZ is disabled\n");



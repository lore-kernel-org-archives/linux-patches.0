Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAF037F8A0;
	Thu, 20 Aug 2026 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238947; cv=none; b=KUkIuT/SsWdXHyJSht1qqRVumWCKHH1FO8UPj1ByfNysfz1yOtWJX0Fjr1lr+uOEr7WUPx0zwGvnMcbCDMFGABYbqfSUJVHbNQyPt5vPGZWQ0/IrfB4Q5Zrgio46KUIVln9ND5jNTd9u9DlKqhA9UMFq7xkNvJ9HTSwVJkjPTbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238947; c=relaxed/simple;
	bh=mkCOdEYyQmoRZVljOtglOqq+Mp7EWl+LJeswVA98xfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n50zom/h8ipe1hy50D5hbiWVe8UVN6yWHWZyzcQyib/hsdp4R7rRkRT1ZTqIwgFAtkIkb0wJDjQgcQjDmKG9mUlvVuW4aWomvIs1iHGmkL9bHmnyAdH8QeA2eRquMQJ4DhTZuYaKD9cZgAF8gHB/NVG94/NbEM5BIdH8BRqwyHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwKGIzCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwKGIzCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ADC1F00A3D;
	Thu, 20 Aug 2026 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238946;
	bh=2uMObdnrMqWO3r1RHOzwPgAYI6Sq4o6g596cBVT0fRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwKGIzCM5SjKldqDj0tkRPL5fxEnL+lTzfDJkucbHCVuIkFrUiR6C34uhxJtSeGWv
	 ZpnboOET8Qd3Y5peQadFBkRAZx8EP2UOLAqcU3DYZLyLjvZZr9af2cZ0CtK7Vwmt1/
	 zKE9iFFGk3in/wHjP4Plb8gUAMY2WfQP6YjVc77s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 096/217] drm/amdgpu: validate GEM_CREATE domain combinations
Date: Thu, 20 Aug 2026 16:54:24 +0200
Message-ID: <20260820145240.640441798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -385,6 +385,25 @@ const struct drm_gem_object_funcs amdgpu
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
@@ -409,6 +428,8 @@ int amdgpu_gem_create_ioctl(struct drm_d
 	/* reject invalid gem domains */
 	if (args->in.domains & ~AMDGPU_GEM_DOMAIN_MASK)
 		return -EINVAL;
+	if (!amdgpu_gem_are_domains_valid(args->in.domains))
+		return -EINVAL;
 
 	if (!amdgpu_is_tmz(adev) && (flags & AMDGPU_GEM_CREATE_ENCRYPTED)) {
 		DRM_NOTE_ONCE("Cannot allocate secure buffer since TMZ is disabled\n");



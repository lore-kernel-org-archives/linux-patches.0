Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5412527055F;
	Wed, 23 Apr 2025 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420955; cv=none; b=n1AS024EraBgga2QuelMNpsZ9XvIhrTosQJPzaoG91698oPyP08Si6V2xgbcOP6VNW17Kg+TP2B3lXb8bDJ2ETjdaFamvhdef5QBKfZA+joBG82a1mnXofgCdV2x+ojFuV6VHincla8/puXanDhBlvlpZNvdDUFiT5SERm5RhCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420955; c=relaxed/simple;
	bh=F5t2kHw44PmkjDfPgBRfQRwiIaXP+NE5AP6B4I22Uyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PbYBD1MUOfNWAqwtlYGJNP4J6krUX0oYD/yx0aGXwI2DxFtVwT7JmGX0H+1GvsXyy8r7yPndlJmK6XR8elGauX8Kw3jPgZyUJIrt2aHGyxC7wThsdcgd/uwx7pJRhBTA9ylsI7wRtFx9DRGjzrbPeoVbBMuB5ebrXXWU6wOE8/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJkdcwSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJkdcwSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A78C4CEE2;
	Wed, 23 Apr 2025 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420955;
	bh=F5t2kHw44PmkjDfPgBRfQRwiIaXP+NE5AP6B4I22Uyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJkdcwSnUHZjka1UYGf6LWhvG/n6k0BxBHo/v32tLvxdgwiIxX7whVcSbeA3U8CKc
	 Su1nQUJ9CAC4mo6V+EuB/ey3r0+dOmI9S4VC1mFCBbX8bADycXgn1gGbIyecyF/RPN
	 fSyS3emrTaFamnW5IqXSDrgZ/5HbTV3nQiwPc78Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 177/223] drm/amdgpu: immediately use GTT for new allocations
Date: Wed, 23 Apr 2025 16:44:09 +0200
Message-ID: <20250423142624.381396878@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christian König <christian.koenig@amd.com>

commit a755906fb2b8370c43e91ba437ae1b3e228e8b02 upstream.

Only use GTT as a fallback if we already have a backing store. This
prevents evictions when an application constantly allocates and frees new
memory.

Partially fixes
https://gitlab.freedesktop.org/drm/amd/-/issues/3844#note_2833985.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 216c1282dde3 ("drm/amdgpu: use GTT only as fallback for VRAM|GTT")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -161,8 +161,8 @@ void amdgpu_bo_placement_from_domain(str
 		 * When GTT is just an alternative to VRAM make sure that we
 		 * only use it as fallback and still try to fill up VRAM first.
 		 */
-		if (domain & abo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM &&
-		    !(adev->flags & AMD_IS_APU))
+		if (abo->tbo.resource && !(adev->flags & AMD_IS_APU) &&
+		    domain & abo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM)
 			places[c].flags |= TTM_PL_FLAG_FALLBACK;
 		c++;
 	}



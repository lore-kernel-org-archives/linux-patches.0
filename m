Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8E03D3D04;
	Fri, 24 Apr 2026 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037693; cv=none; b=qPh60C++txR0QW/cMVHG1GnV/reOGRy2jI6IC+sfnOY/ozsTEH1G7Dem53vrLdW3LRC8J66+WvzBzbMl4kLwxzv13YrZwov2Nfxe+MZGDFMT4B0UKak8pQz7DuKYh2yyqfCT40hfM9oph9TAJH+Mqsp6LVQZCQbVNfq3rzWzLIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037693; c=relaxed/simple;
	bh=RidSOiKstmbHqNxaAT2Vxl6fNOZACTojQJ/mqg5b6yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LB95DFxW0gJQkLUovdZ1Hz1a3XjzNLMWd02puOrvEyDOx6KjQGQxo0GCDhVf8rOLPMaV/FU9bohURR9N6v5tCL/PhgM4YCP1ilpIeTAdNV+1xoypCe5lPf4AceR+CMUzh8XYsxDyqjadDIxgQ8aZzmeZ78PTx46eSKn+nxjQew8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ani2phn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ani2phn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B87C19425;
	Fri, 24 Apr 2026 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037693;
	bh=RidSOiKstmbHqNxaAT2Vxl6fNOZACTojQJ/mqg5b6yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ani2phn61UMmC0Q0SCFabuyuvzlDyqNpdL9tsGAATdoI3ngO1TLmQpicfluNgxcCR
	 ht7bq+fElsNCGTziSjPS9JW6oEKGVAYKLBHB1xxpkrIlZWvCH7a4mDx8c/dxk0hl2x
	 BgQTM6FbtCu8zx+QJUCRaT3ZHuuA9OZbJwa8Ntrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/166] drm/vc4: Protect madv read in vc4_gem_object_mmap() with madv_lock
Date: Fri, 24 Apr 2026 15:29:07 +0200
Message-ID: <20260424132539.826972862@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

[ Upstream commit 338c56050d8e892604da97f67bfa8cc4015a955f ]

The mmap callback reads bo->madv without holding madv_lock, racing with
concurrent DRM_IOCTL_VC4_GEM_MADVISE calls that modify the field under
the same lock. Add the missing locking to prevent the data race.

Fixes: b9f19259b84d ("drm/vc4: Add the DRM_IOCTL_VC4_GEM_MADVISE ioctl")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-4-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 86d629e45307d..84ad6a952b5d3 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -738,12 +738,15 @@ static int vc4_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struct
 		return -EINVAL;
 	}
 
+	mutex_lock(&bo->madv_lock);
 	if (bo->madv != VC4_MADV_WILLNEED) {
 		DRM_DEBUG("mmapping of %s BO not allowed\n",
 			  bo->madv == VC4_MADV_DONTNEED ?
 			  "purgeable" : "purged");
+		mutex_unlock(&bo->madv_lock);
 		return -EINVAL;
 	}
+	mutex_unlock(&bo->madv_lock);
 
 	return drm_gem_dma_mmap(&bo->base, vma);
 }
-- 
2.53.0




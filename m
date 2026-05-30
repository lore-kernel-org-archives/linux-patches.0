Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC6E32B11F;
	Sat, 30 May 2026 17:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162644; cv=none; b=cAxRnE3wbbvnz6/I0GtbZY4FQ6XAqjMx3u+yuVebbSHjeqT2gduJLumoos4cokdDEDp2kXZdwoRpP8ltV2RAkxcNwLw/Wz4FUL8P+XqA2VLKD3cEL5N68IFx+xTJBZE/poauHkFRgvMjXQf5iAo1tJKheoFq0JCh3Mqpq+pC7c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162644; c=relaxed/simple;
	bh=MvbredatniRebKRFCq8yBio7uOoyy7M7abualZQg8/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P7F66/KgkUrzGKEU4CrFYRJqxuIk7J8HP9B57VhADTc1AU637fEjZL3EqXKPGDlaA0ugBcDArkFkelIu8U4HxRNxIYLD5LhlO0T7s0b+eMJGLsoqdKE9JGlzLCRCOg8lVnppHKl5WnlerJavt2Ig+IGnsEIeKJ12CIWQ3lSteHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p52ytLIq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p52ytLIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E121F00893;
	Sat, 30 May 2026 17:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162643;
	bh=6KgGrjkyCAlO+MEcj9nl8FL7NL7SMYJsjKsdutooIDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p52ytLIqo4jUkooGRr1EtBnNUG8jkgpK8T9HE3IfqyTuYgWYEaslpNX/9Y0RbpzQ8
	 ugNwBE2GqSdfBYckE+5zvORHPYAz7i+6T4ebdXND9uWUXEutioxWFT54JbC5gj69/7
	 YuYBWb2zEKvr4vwY78NqyqbDdTXvJVIuXh5z50TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/776] drm/vc4: Protect madv read in vc4_gem_object_mmap() with madv_lock
Date: Sat, 30 May 2026 17:55:36 +0200
Message-ID: <20260530160240.837961841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f642bd6e71ff4..4703f180cde60 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -713,12 +713,15 @@ static int vc4_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struct
 		return -EINVAL;
 	}
 
+	mutex_lock(&bo->madv_lock);
 	if (bo->madv != VC4_MADV_WILLNEED) {
 		DRM_DEBUG("mmaping of %s BO not allowed\n",
 			  bo->madv == VC4_MADV_DONTNEED ?
 			  "purgeable" : "purged");
+		mutex_unlock(&bo->madv_lock);
 		return -EINVAL;
 	}
+	mutex_unlock(&bo->madv_lock);
 
 	return drm_gem_cma_mmap(obj, vma);
 }
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D443344DA8;
	Sat, 30 May 2026 16:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158200; cv=none; b=jCvZVzSKG7M+d1XqLnP7XuWzWzk216HwG8DRjH1plRhr681aapYra/cO3cHJ2qzOZ907BmNRCrYe109OFQCdbyEUDlobEq77eOeOKaNz6eoI9bG8/l/evEgLteD9AiAGYxPheISR09DAauiZNfxHKwwDcV70Xa/wEnKJQ02cNZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158200; c=relaxed/simple;
	bh=uxZ36W//3Kr81h29Ee0+Xd09DCgJl2Z59cG5PSZLf38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbdHoz1VlyIdeOK7mK7Hn2xxg0aLQiRgZUTqlKPRw5XuyZuhnmz++kCjRdJ88Bwqy7ITPXRnVcbJwqoeWDryTrdNUpbII1iqiJPi7MwCz4Vewl+8iEDKZRSUHU+UTXK5D8ELbvvGhd+r9TZQYRpb/QTOQaG0MY7WvGrlXFhYHmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDdaJJC/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDdaJJC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88211F00893;
	Sat, 30 May 2026 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158197;
	bh=vxNdmS3odJxzG/c5Uok3N0ACnT5zwkjvK3yV6HZzK7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDdaJJC/Z3PiAiUYZSXoFq2AIr7FUdyExSi8nH6W/OyxsxSunYwd0/IvJLb0qC14n
	 FrQuOgxN0fCULTSnn0I1aExCnImtYmmwBQ5+GgR+2vrOnox6MkcdTd/khSuG3W8rBY
	 VRD5VfvkunZUw8NvksJymgRiI/URoxanFy/jSsx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/969] drm/vc4: Protect madv read in vc4_gem_object_mmap() with madv_lock
Date: Sat, 30 May 2026 17:52:34 +0200
Message-ID: <20260530160301.269977099@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ce0ea446bd707..9028a56dd12b8 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -738,12 +738,15 @@ static int vc4_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struct
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
 
 	return drm_gem_dma_mmap(&bo->base, vma);
 }
-- 
2.53.0




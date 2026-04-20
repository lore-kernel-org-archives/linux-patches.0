Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A721EB5CE;
	Mon, 20 Apr 2026 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700741; cv=none; b=G2MY2MqgNYcX8VtORUa6z+hmcsjpZiitQHLs1t6duiqghwSU+QDf1ErpZRK216GvUUxGAczgNdJxgUJTS4wwFCVZfYJfFwvm0V/XGl7feFgcTR06vZ8gXlRUB0NgSuei6EUe/Lqzhl2F95v9ZUCf/K+WtpxWoTrI9U3aHM2U6As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700741; c=relaxed/simple;
	bh=nzHr05GC+ZV/e6yXtgU+TsNohVCpcUZd0a/Ka68/tR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bUw2kNfgzQ/fB5ljRJElKK0VOe1id8V3gVyKJ53QXaVt40eaXO52y8tkjF3fkZJA3lPlKNa/e7AeunWPQ8hAOkShcC94g1g9lgjQozzxCtwhpyv1bdrTCEO5QF3rsKmi29PPDNmo5uu5VTwef+RXxLSwzKIJbOizsdp7t0WjMR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duSLrFqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duSLrFqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FE1C19425;
	Mon, 20 Apr 2026 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700741;
	bh=nzHr05GC+ZV/e6yXtgU+TsNohVCpcUZd0a/Ka68/tR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duSLrFqpahlmVdjzAqiYHqpCBMj+9N++cScsX146o9eSqbiATIcviFUUUjeUQ+6kK
	 oZnjvgt1R5UMQHvdmZ/brIx9UK6hKlJbAgOnuRGTFp4mV7nO4yMHmSJL1+0oZC4gQf
	 1Qr9W3PwHdllbGjvSVoMqmid32PfgaGbRiaFpEBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/198] drm/vc4: Protect madv read in vc4_gem_object_mmap() with madv_lock
Date: Mon, 20 Apr 2026 17:40:47 +0200
Message-ID: <20260420153938.060315447@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
index 4aaa587be3a5e..a1efda9c39f92 100644
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




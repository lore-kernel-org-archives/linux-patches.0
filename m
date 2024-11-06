Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED711F668B;
	Wed,  6 Nov 2024 12:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896915; cv=none; b=kwJxVu1pjhynidjByAiju1pVvHPqTJZAvti+afzaeXn59rXtbQBl67J/Eheo1JlWf5a5RXU2jIRzhg6dBLJdr/9U8FOaVidhslRPWsW2SGZdKO8hQbBNtOtK3s7CGGh49giw7af1EF2PHsUnYqiKJPNWVPzJEjHORyrhim0qGFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896915; c=relaxed/simple;
	bh=E1NCKsHxS4/6m6q++bQlHDZJ2yo1eXhJuWu7df64KWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQLoIxv7uLg8qRtAMFy9zbfNdhRDVsyx0iAeCZo6h8RLzU5kEYveu7aJmDy/TdPoQ6txL1fvX8uis6EHxf35YJ9oisbfq2oyBq1OX0OJy6jI5g4NM4VKRsaLFFmC8oAGbRM7e2AAVyxQOYjhORFKqmdkF5K9eyd2u1L3MM+6VZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqL2qifA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqL2qifA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241B2C4CECD;
	Wed,  6 Nov 2024 12:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896915;
	bh=E1NCKsHxS4/6m6q++bQlHDZJ2yo1eXhJuWu7df64KWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqL2qifARG3MCas9FjetkQvmLPtE6Yxow/RCNNWKQf+1ZlqHC7zQjjoJc53B5XSHM
	 ByIMaiiVi5nBceyKuSAFqVK9JWe5az1NcJqn3zenFQ0UJHlhHTgHaA90Y5dG8BjymV
	 mFEs5s0m6FT0BEKmlTtq4MqG8vDmF/sFy/UVn80U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
	Eric Anholt <eric@anholt.net>,
	Rob Herring <robh@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	"Wachowski, Karol" <karol.wachowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Artem Sdvizhkov <raclesdv@gmail.com>
Subject: [PATCH 5.10 108/110] drm/shmem-helper: Fix BUG_ON() on mmap(PROT_WRITE, MAP_PRIVATE)
Date: Wed,  6 Nov 2024 13:05:14 +0100
Message-ID: <20241106120306.155669246@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wachowski, Karol <karol.wachowski@intel.com>

commit 39bc27bd688066a63e56f7f64ad34fae03fbe3b8 upstream.

Lack of check for copy-on-write (COW) mapping in drm_gem_shmem_mmap
allows users to call mmap with PROT_WRITE and MAP_PRIVATE flag
causing a kernel panic due to BUG_ON in vmf_insert_pfn_prot:
BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));

Return -EINVAL early if COW mapping is detected.

This bug affects all drm drivers using default shmem helpers.
It can be reproduced by this simple example:
void *ptr = mmap(0, size, PROT_WRITE, MAP_PRIVATE, fd, mmap_offset);
ptr[0] = 0;

Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: Rob Herring <robh@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Wachowski, Karol <karol.wachowski@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20240520100514.925681-1-jacek.lawrynowicz@linux.intel.com
[ Artem: bp to fix CVE-2024-39497, in order to adapt this patch to branch 5.10
  add header file mm/internal.h]
Signed-off-by: Artem Sdvizhkov <raclesdv@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -17,6 +17,8 @@
 #include <drm/drm_prime.h>
 #include <drm/drm_print.h>
 
+#include "../../../mm/internal.h"   /* is_cow_mapping() */
+
 /**
  * DOC: overview
  *
@@ -630,6 +632,9 @@ int drm_gem_shmem_mmap(struct drm_gem_ob
 		return ret;
 	}
 
+	if (is_cow_mapping(vma->vm_flags))
+		return -EINVAL;
+
 	shmem = to_drm_gem_shmem_obj(obj);
 
 	ret = drm_gem_shmem_get_pages(shmem);



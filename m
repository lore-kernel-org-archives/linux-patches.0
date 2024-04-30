Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD6A12C487;
	Tue, 30 Apr 2024 10:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474333; cv=none; b=Lr0vjdflfXoaxf00GuYdSQZuRaGfDvFk1k/eq3vjsJ/0pzFsHy3F0dtNrDPUftqNIeVJhWW08JgGt5N9HFCMJyFQJ3c0QiVQsqw42IJ7O9xCxko0dEl84JXoersxH0Wm4fF/MdNNqBrdmY6l0gylzMvG3EWpRx9g6wFlV2yZ8bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474333; c=relaxed/simple;
	bh=5AN3uE5hrB5Z3q1tDWVKXPqET8e3T0glW5RMJRo7wdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+K3TCTMMwJCocichx34vWMYoi5lNGylG9RCyNjy4hcVo2HszT7FsIXSq0TVzcDv5d9RmfpG2cvLyDVREYuVizSgHRWLoD2DBc/50EUluYRD611oN0Pr9FHp9d6zNp+jugS7y6Yc7GfcFckS5omOOf+fGjJPUqEhu6yyxdoXP2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYig0/bV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYig0/bV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDC9C2BBFC;
	Tue, 30 Apr 2024 10:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474332;
	bh=5AN3uE5hrB5Z3q1tDWVKXPqET8e3T0glW5RMJRo7wdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYig0/bVU2VF7HxgNxBPJKxQukDIEtaBJhszPQKqdHz2My9wSA8GtdMAHD5ZG/INo
	 VZLN8QjhUKggusteSgLmVeyo/0M3v/ycpwmK3vas90SdwpWrLwrVyEwqQ56HjWLTnJ
	 JouSoWvVJnGpoix1t+4lLzXuSCZiCd/01tGrDhoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.keonig@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 6.8 126/228] drm: add drm_gem_object_is_shared_for_memory_stats() helper
Date: Tue, 30 Apr 2024 12:38:24 +0200
Message-ID: <20240430103107.442520638@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit b31f5eba32ae8cc28e7cfa5a55ec8670d8c718e2 ]

Add a helper so that drm drivers can consistently report
shared status via the fdinfo shared memory stats interface.

In addition to handle count, show buffers as shared if they
are shared via dma-buf as well (e.g., shared with v4l or some
other subsystem).

v2: switch to inline function

Link: https://lore.kernel.org/all/20231207180225.439482-1-alexander.deucher@amd.com/
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com> (v1)
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.keonig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Stable-dep-of: a6ff969fe9cb ("drm/amdgpu: fix visible VRAM handling during faults")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_gem.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 369505447acd8..2ebec3984cd44 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -553,6 +553,19 @@ unsigned long drm_gem_lru_scan(struct drm_gem_lru *lru,
 
 int drm_gem_evict(struct drm_gem_object *obj);
 
+/**
+ * drm_gem_object_is_shared_for_memory_stats - helper for shared memory stats
+ *
+ * This helper should only be used for fdinfo shared memory stats to determine
+ * if a GEM object is shared.
+ *
+ * @obj: obj in question
+ */
+static inline bool drm_gem_object_is_shared_for_memory_stats(struct drm_gem_object *obj)
+{
+	return (obj->handle_count > 1) || obj->dma_buf;
+}
+
 #ifdef CONFIG_LOCKDEP
 /**
  * drm_gem_gpuva_set_lock() - Set the lock protecting accesses to the gpuva list.
-- 
2.43.0




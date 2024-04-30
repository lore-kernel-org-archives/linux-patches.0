Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0961E50A;
	Tue, 30 Apr 2024 11:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475455; cv=none; b=Qo9BSnVxnqcyJc7aXbWTMOXFEAiiPvY12h8fNBMMhHyH8Qx7bXICmUieFhNEqnZd7f/eJTQ7P8CXwJG6vcRGgapH0keLPIuEW+ZCklmYzLjFCMZzHXjRIISt+HmzykfxKtVmNvoxuTVb3k4hpOjJixcVxZatBW/ToSNv2w2yhPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475455; c=relaxed/simple;
	bh=LkKlqpAy5c58GNlo1hbrGFwzx0XyCgHv5wyBPemNBuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MN+XAqZCKKRpXSz8FkvA4tdlRiz0WlG8HsBz9XseppK42IcPDXTV1xl5IxBAaMRn7WS/YVpzfKpfOPkP0zTmVtOTRD/xRVDXcNtWHy9Bylptt6cCx7myORoeRDYIIxH+XAquQxPPDj4OqVSyWB/Hw8tWbPgFUuAWVbjfVc05fJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ieTmiARh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ieTmiARh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD928C2BBFC;
	Tue, 30 Apr 2024 11:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475455;
	bh=LkKlqpAy5c58GNlo1hbrGFwzx0XyCgHv5wyBPemNBuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ieTmiARhEa4llZbSEdvi5VPB/0X7ikWmMwmez0t2q5EXxqjbGz8Qi3CZ/C/7FBS8n
	 9gD4m8q5AXlNLApRVJQeNXnBmJImRNb5BTWNkiZe2FJE+KsTakUn/EBi7KXjW8IUuL
	 Flw7sZBIQOKhIBzqD/LQsRVqXe1WT9puX1l3uWsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.keonig@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 6.6 100/186] drm: add drm_gem_object_is_shared_for_memory_stats() helper
Date: Tue, 30 Apr 2024 12:39:12 +0200
Message-ID: <20240430103100.937717138@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bc9f6aa2f3fec..7c2ec139c464a 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -544,6 +544,19 @@ unsigned long drm_gem_lru_scan(struct drm_gem_lru *lru,
 
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




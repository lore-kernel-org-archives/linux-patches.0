Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B32947D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFBCC433C8;
	Sun, 16 Jul 2023 20:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539416;
	bh=wHXPk/2iZFgSi1mwBD2h53f6ZfvhaI5jXSeeV7N0CNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLmE7XA3g2sFjTiTkXAw1mHLubmw0lIJnUONlNkPMBwiAfPyNBmWzye+n8cUm5GAU
	 lkC7pXaWwI9rAZ5LVYiK41af8i1K/LfSKiyKCcKadlG4v8tJxUXLwDTzxTaZJOYokH
	 Xc4QiR7mMxb7I7AGrapi0d9kDjbRAB62Rjw8VsGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=F6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH 6.4 788/800] drm/amdgpu: make sure that BOs have a backing store
Date: Sun, 16 Jul 2023 21:50:41 +0200
Message-ID: <20230716195007.452091843@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

commit ca0b954a4315ca2228001c439ae1062561c81989 upstream

It's perfectly possible that the BO is about to be destroyed and doesn't
have a backing store associated with it.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.3.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1266,8 +1266,12 @@ void amdgpu_bo_move_notify(struct ttm_bu
 void amdgpu_bo_get_memory(struct amdgpu_bo *bo,
 			  struct amdgpu_mem_stats *stats)
 {
-	unsigned int domain;
 	uint64_t size = amdgpu_bo_size(bo);
+	unsigned int domain;
+
+	/* Abort if the BO doesn't currently have a backing store */
+	if (!bo->tbo.resource)
+		return;
 
 	domain = amdgpu_mem_type_to_domain(bo->tbo.resource->mem_type);
 	switch (domain) {



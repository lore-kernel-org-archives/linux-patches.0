Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836E91F5FA;
	Thu, 11 Apr 2024 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830181; cv=none; b=qc6y5rgF1aU9V56xunBksQAfBA+0kEp9ZYFUoEYbExXDaILL51qajTtAGM5np6yKwq1ktMNGsYRh0p/DM8o98h4bPbOeeLJhjM/XHcR8B6gxshPfCGk6+l+932EO4b+Tw0CWn7/yYhgSK+XxCV/xVaRFSavvZ2AWFmsY0XEy5ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830181; c=relaxed/simple;
	bh=5HhCjqwYlPXNn20F0szPHx8xuI47ngiPDhafT1Qz5Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jFpGOyVQb+UhuvIyi0pUcwZTlpdVdHGVWjLFA5Vjk2oFqshe6b93HyWJTUTNzqFpH+QullNMZqcnluo4A/Q1742MWfTbISU/NAY/d/zOWZL0tC2npGgPbXPAG6GdYs4D2qx0iEtK/72BFGUb8UGFqsPs0KUxgap9wAceEXuH/FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tRAaWfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tRAaWfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FFEC433F1;
	Thu, 11 Apr 2024 10:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830181;
	bh=5HhCjqwYlPXNn20F0szPHx8xuI47ngiPDhafT1Qz5Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tRAaWfSJnGHzGsJoksW9ON9anTmXYMbaCF/DHy7u+pRCKTbJ9AwitmYfB2mb8yco
	 cYuK7ja9WM3I144keDI0c7X3QQFGK+9ri+jCal0Sdt5zNr6VXbGN3o1zM3cEAS3Kur
	 kC98VMYWu0E1kI3gNmiimK9Lwvisl7ZfZshzSBDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 063/143] drm/ttm: return ENOSPC from ttm_bo_mem_space v3
Date: Thu, 11 Apr 2024 11:55:31 +0200
Message-ID: <20240411095422.812631219@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 28e5126718c7b306b8c29d2ae8f48417e9303aa1 ]

Only convert it to ENOMEM in ttm_bo_validate.

This allows ttm_bo_validate to distinguish between an out of memory
situation and just out of space in a placement domain.

v2: improve commit message
v3: fix kerneldoc typos

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240112125158.2748-3-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index edf10618fe2b2..f95b0406ca995 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -770,7 +770,7 @@ static int ttm_bo_mem_force_space(struct ttm_buffer_object *bo,
  * This function may sleep while waiting for space to become available.
  * Returns:
  * -EBUSY: No space available (only if no_wait == 1).
- * -ENOMEM: Could not allocate memory for the buffer object, either due to
+ * -ENOSPC: Could not allocate space for the buffer object, either due to
  * fragmentation or concurrent allocators.
  * -ERESTARTSYS: An interruptible sleep was interrupted by a signal.
  */
@@ -830,7 +830,7 @@ int ttm_bo_mem_space(struct ttm_buffer_object *bo,
 			goto error;
 	}
 
-	ret = -ENOMEM;
+	ret = -ENOSPC;
 	if (!type_found) {
 		pr_err(TTM_PFX "No compatible memory type found\n");
 		ret = -EINVAL;
@@ -916,6 +916,9 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
 		return -EINVAL;
 
 	ret = ttm_bo_move_buffer(bo, placement, ctx);
+	/* For backward compatibility with userspace */
+	if (ret == -ENOSPC)
+		return -ENOMEM;
 	if (ret)
 		return ret;
 
-- 
2.43.0




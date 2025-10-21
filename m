Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B327FB28;
	Tue, 21 Oct 2025 20:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077638; cv=none; b=HGUYDad5Rgn9klpS+eTXxQ+9jwR8gT2a9FbNQIcv7sMX64HO/FBawCvT/il3XzLa2VMVX5azvt76lsfPv+lclRLDTr+QTEXha4k+Wi/dpYUc4KaZJ+Dqo4c0nonez4GOl0zToPOhzS90StIPe+6W079HjsJlhyA5pZi2Rpr3NQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077638; c=relaxed/simple;
	bh=j8f8olhIExITD6nCBcHUXC9b510caFhkWKIMLc7if/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vo7PU2Tz6wZzUOgGQeLdojmXJuhz4gqt4f2s9w66iUYcNHjm3r3ESPcupOfnQCd07P6rSrMylIjTBiBC2rKJE8rZiaCLPsrqGhQ1cB2QgC3ozszvv/8oE5iAwSNBqZQMinMxjZNfF12YUtC9ymL4O6JNxIUIWizY/z9AOMTq3Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KwzSb5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KwzSb5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BD6C4CEF1;
	Tue, 21 Oct 2025 20:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077637;
	bh=j8f8olhIExITD6nCBcHUXC9b510caFhkWKIMLc7if/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KwzSb5ftshBY9rSq07tUM5EnudRvyN9H3YDXcsTHewaoq7XgpiQs9o7wWBXYY/vR
	 zYqm3qIWYZYiZhGblJtsOdh2jyKc5tYjD7SErP4dhR2hARyx/PyVsODKNntc+fdUOE
	 ZJE+YljPKztOqLBPGgLi3P8PbAP2AoeRxAFiJZ0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 133/159] drm/xe/evict: drop bogus assert
Date: Tue, 21 Oct 2025 21:51:50 +0200
Message-ID: <20251021195046.346542743@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 225bc03d85427e7e3821d6f99f4f2d4a09350dda ]

This assert can trigger here with non pin_map users that select
LATE_RESTORE, since the vmap is allowed to be NULL given that
save/restore can now use the blitter instead. The check here doesn't
seem to have much value anymore given that we no longer move pinned
memory, so any existing vmap is left well alone, and doesn't need to be
recreated upon restore, so just drop the assert here.

Fixes: 86f69c26113c ("drm/xe: use backup object for pinned save/restore")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6213
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://lore.kernel.org/r/20251010152457.177884-2-matthew.auld@intel.com
(cherry picked from commit a10b4a69c7f8f596d2c5218fbe84430734fab3b2)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo_evict.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo_evict.c b/drivers/gpu/drm/xe/xe_bo_evict.c
index d5dbc51e8612d..bc5b4c5fab812 100644
--- a/drivers/gpu/drm/xe/xe_bo_evict.c
+++ b/drivers/gpu/drm/xe/xe_bo_evict.c
@@ -182,7 +182,6 @@ int xe_bo_evict_all(struct xe_device *xe)
 
 static int xe_bo_restore_and_map_ggtt(struct xe_bo *bo)
 {
-	struct xe_device *xe = xe_bo_device(bo);
 	int ret;
 
 	ret = xe_bo_restore_pinned(bo);
@@ -201,13 +200,6 @@ static int xe_bo_restore_and_map_ggtt(struct xe_bo *bo)
 		}
 	}
 
-	/*
-	 * We expect validate to trigger a move VRAM and our move code
-	 * should setup the iosys map.
-	 */
-	xe_assert(xe, !(bo->flags & XE_BO_FLAG_PINNED_LATE_RESTORE) ||
-		  !iosys_map_is_null(&bo->vmap));
-
 	return 0;
 }
 
-- 
2.51.0




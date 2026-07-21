Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C325A3B4EAC;
	Tue, 21 Jul 2026 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658282; cv=none; b=LjNODtFiubQ0omfoJwuj5WOtzEfxq6DfuvOhJteO/2CmufvzcF+D0QDd+obt+/cmxhrVFGPGB8YiP6XdIp/lRL4oK/uHE5RMEExMoGImYXzcbs1NY2MVGgcw4TeetyDYXj0ZGR3Kp65d94z7P+JuKG4OqbWkbRmSqi8AeJ5ZEaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658282; c=relaxed/simple;
	bh=8WrDRurQfQawMLHYzQisyNB+CnEomRO5RsCx0W+8iUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSpFeanUakPMH6Li9xQ6bJPTmGuwxS1U90ox2cNahzupU+bdYmlLpNNXR18pnUiSqggYF1v26BBuyz4RO3kf4dWo/z9cxdR7LJkJc2cnuL60ATXi4uHt0jrGt6cIQ5playT8+wthxz8kkGc5ozwAKkrF2FdxxVmKprbVy/vKG0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dxfuf2dz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dxfuf2dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8551F00A3A;
	Tue, 21 Jul 2026 18:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658280;
	bh=dVYLkGO2oUWHXAlJNsRqM5rVeerCew+vOn3ODqsuDao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dxfuf2dzCC7uKaAGKWQt1/r6Dl0kEYeS3rmDoptJOanxDAhFFOHRsrlNUnpKzdyn4
	 RIqJiv4yIDpeBJYZ/wG3w7otshfXGzVz+kMMXpQbgyKfdReOo0aPuiYQRKHAAxcfGM
	 70zkIjeMRDm/b9ZbFBCBFY7R2jAG8db7CsrxkjIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1067/1611] accel/amdxdna: Fix potential amdxdna_umap lifetime race
Date: Tue, 21 Jul 2026 17:19:43 +0200
Message-ID: <20260721152539.407629999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 14f172eff9c19f8043a9858845f33cd034f3a41e ]

amdxdna_umap_release() calls the blocking mmu_interval_notifier_remove()
before removing the object from abo->mem.umap_list. If
aie2_populate_range() runs concurrently, it may obtain a reference to an
amdxdna_umap that is being released, leading to a potential use-after-free.

Use kref_get_unless_zero() in aie2_populate_range() when acquiring a
reference. If the reference count has already dropped to zero, release
is in progress and the entry is skipped.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260706221228.434099-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 80de2906a26fcb..612ad6302622a4 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -794,7 +794,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	found = false;
 	down_write(&xdna->notifier_lock);
 	list_for_each_entry(mapp, &abo->mem.umap_list, node) {
-		if (mapp->invalid) {
+		if (mapp->invalid && kref_get_unless_zero(&mapp->refcnt)) {
 			found = true;
 			break;
 		}
@@ -805,7 +805,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 		up_write(&xdna->notifier_lock);
 		return 0;
 	}
-	kref_get(&mapp->refcnt);
+
 	up_write(&xdna->notifier_lock);
 
 	XDNA_DBG(xdna, "populate memory range %lx %lx",
-- 
2.53.0




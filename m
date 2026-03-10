Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B042FFDF7;
	Tue, 10 Mar 2026 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142156; cv=none; b=NdaG5wvvLUK82WolNukv3bZ9ojMPIVRRWWPr/alQN9NrZvfpqnTNl1ykcE+4b3o3XBr+D6X8Pk6VaZ07+11xyFGu7cBs6ZMaiEINdYOveKCMe0VnIgcmxXl0uQ6UeQWOXsP9VpBEQUSZXXjHcwpq++g5Jpp1al3Yw3ZX9AZG4/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142156; c=relaxed/simple;
	bh=yprFvWYeTD7Zavgg8BQigbDslxxmKEQXskHVDorM7SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIYBtnjNDsiNfooR+94f3nhxiPAuz+f7rMpXwToxYI5iBCFqpzmI6I69jEnzVGcl6TL5neY327ehpHv7V5b44Z3l+8yxupISGpZqcwInViDxvJzm26HO05p30+GixvuIrYnisC+lfOYIJLuYhFHSenCsTAONBiMPOl43dWbIRkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAdevaG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAdevaG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A64C19423;
	Tue, 10 Mar 2026 11:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142156;
	bh=yprFvWYeTD7Zavgg8BQigbDslxxmKEQXskHVDorM7SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAdevaG3bMtHxfeKrjWyfz10M4oEJz8ubbzMraM+Li6JICyNv6yGdzL3HLeh7vP8C
	 4n/FSPB2c+oIYQJlDKxFz3yNwQXKqKb97KXdCWuhd0u49A4IbOuERN+4AK6oM1QgAz
	 Pb434hdqIK8ob0tlm/BVwtp3CwyI3eEhocDGxS18/GwCQIcrWRMjGLXzslX8y9imbz
	 DP9sGja7KEYKdX5JYhvmt034S9QR19/QveDzVJUyJ6YNlqr3OgKl1je6SCLv0Apr1m
	 YlITGInvCays41KUvuA614VmvX1Mi6t4AJwaK1uN9hLphhVM9HVWAYayw1z28e6ANn
	 A7QNv/mGA6bDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuicheng Lin <shuicheng.lin@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 244/314] drm/xe/configfs: Free ctx_restore_mid_bb in release
Date: Tue, 10 Mar 2026 07:18:23 -0400
Message-ID: <190a1b017c9a72dd84784b07e2a7304a33c554d7.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit e377182f0266f46f02d01838e6bde67b9dac0d66 ]

ctx_restore_mid_bb memory is allocated in wa_bb_store(), but
xe_config_device_release() only frees ctx_restore_post_bb.

Free ctx_restore_mid_bb[0].cs as well to avoid leaking the allocation
when the configfs device is removed.

Fixes: b30d5de3d40c ("drm/xe/configfs: Add mid context restore bb")
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Nitin Gote <nitin.r.gote@intel.com>
Link: https://patch.msgid.link/20260225013448.3547687-2-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit a235e7d0098337c3f2d1e8f3610c719a589e115f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_configfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_configfs.c b/drivers/gpu/drm/xe/xe_configfs.c
index 6688b2954d20b..08f379cb5321f 100644
--- a/drivers/gpu/drm/xe/xe_configfs.c
+++ b/drivers/gpu/drm/xe/xe_configfs.c
@@ -688,6 +688,7 @@ static void xe_config_device_release(struct config_item *item)
 
 	mutex_destroy(&dev->lock);
 
+	kfree(dev->config.ctx_restore_mid_bb[0].cs);
 	kfree(dev->config.ctx_restore_post_bb[0].cs);
 	kfree(dev);
 }
-- 
2.51.0


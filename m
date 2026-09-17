Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CD23845AC;
	Thu, 17 Sep 2026 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659304; cv=none; b=b61S4jSpjING0n00z76RIzwaL1Bz1KpV64Y97MPXJ/JZViAh4zlkX20GTlpvr0bE2rfDc7466NBtiSTEOJjIkpxbDIJJVr9xpH8BcJCHUnNPfZjAV4it/6fKSBq1CK55a3EIH9caE+d9w7XCKs8VQZaL1F/mjgvzyqtfpW7Odz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659304; c=relaxed/simple;
	bh=ZXqXRcCKZ2vZPG9aGS6oYtuW1vazTEaCKcveuUFJbAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEwc2WesQ8LaN2+rkaUpKDbENrRng6R9LtXCL53xY0W6+vdv0E7NExJ38YgN2t4ROsJFxwYryCF9/Rw9bGUz2NUKRoWnKeMKyCP1UP+Y/D6qONglE4EFJYjHU05/nCvJdpQesVb87MxKdx3T6xoPa35u/UJGN/P+5UmqHGBnI2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hL58NEAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hL58NEAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C191F00893;
	Thu, 17 Sep 2026 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659297;
	bh=n3PAc3Lp3O0iXmC3DYQT0AjdN+SCXNDzpuTlH8F+/Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hL58NEAl2zDX6bNi66iZ176KWeR2GWzPq3sqRu+BwWW+ozycjFpuyAujIJ5pz0Ye2
	 ov1Hfl/DeGQzpHL0CZHH43plW+ISXCroJLHmp+664Ew0RyHluUvVGThJztTkraS+j7
	 gaTiXy0p4fVeFQf2uBK+9lrgW59q36DWSpzD9uh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 161/733] drm/xe/oa: Remove sysfs entry on idr_alloc failure in xe_oa_add_config_ioctl()
Date: Thu, 17 Sep 2026 16:07:49 +0100
Message-ID: <20260917151355.086626877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit 3663c8d1f31e65771bd73ee3259f35fd397f9933 ]

If idr_alloc() fails after create_dynamic_oa_sysfs_entry() has
succeeded, the error path frees the OA config without removing the
metrics sysfs group.

Remove the sysfs group before releasing the config, and fix up the
misleading error message copied from the sysfs creation failure path.

Fixes: cdf02fe1a94a ("drm/xe/oa/uapi: Add/remove OA config perf ops")
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Link: https://patch.msgid.link/20260831014218.28515-1-yaolu@kylinos.cn
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 2c6fbda5fdde461d6dedb82a59285182720b8fef)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 18d990c5d4ec4..e5b0f3e2f3894 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -2431,9 +2431,9 @@ int xe_oa_add_config_ioctl(struct drm_device *dev, u64 data, struct drm_file *fi
 
 	oa_config->id = idr_alloc(&oa->metrics_idr, oa_config, 1, 0, GFP_KERNEL);
 	if (oa_config->id < 0) {
-		drm_dbg(&oa->xe->drm, "Failed to create sysfs entry for OA config\n");
+		drm_dbg(&oa->xe->drm, "Failed to allocate id for OA config\n");
 		err = oa_config->id;
-		goto sysfs_err;
+		goto id_alloc_err;
 	}
 
 	id = oa_config->id;
@@ -2444,6 +2444,8 @@ int xe_oa_add_config_ioctl(struct drm_device *dev, u64 data, struct drm_file *fi
 
 	return id;
 
+id_alloc_err:
+	sysfs_remove_group(oa->metrics_kobj, &oa_config->sysfs_metric);
 sysfs_err:
 	mutex_unlock(&oa->metrics_lock);
 reg_err:
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2B24F5DE2;
	Thu, 17 Sep 2026 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665537; cv=none; b=eJa9QeTqotHxMVHGYSt3LpRUpPagO6EL8IXYdZ7eajrnnbRtlG0Q8eWcXsaIhhANXWCC9ca7zPYwRaIPTiJfBQkhBEwDkclQA+++7Xrwh1DCdXCRrtEsKERkunhw6nd3Op73b123f2ixn4ji12pdYu8+Mo5pA4qo2asUtYV6pYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665537; c=relaxed/simple;
	bh=5Aa0VTv3YE0ouDkSPeddtlRAO9xFeyuLq7ajQt+6svo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtDZW5OpnmoD1mU9IEIaU/SNiwWc8TJZ32xfVDx+A5bDe81T45BRBOwNk6KQTpgOgwwiKj2phD1cbSCfntQl5ji9RYbmf4WN9wEK7h8IY6h1fLqzwGgDfhFEWtX0kPIixnv6ta72HIZIGJuIHTiWwkkkle9ZuEUR3ZlDiYB2HVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4wANUA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4wANUA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B211F000FF;
	Thu, 17 Sep 2026 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665535;
	bh=PW1/GKrVyJCDlHuk7eGyIxeqPzPuEOpxX9lUx7dw2FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4wANUA32IsEAPW569Ejw2tL4OALdhrAZfZMZWAzYZQKg6meo6M8SYgAAIOrSGVav
	 YhdUZvayuTtaPhyCoVfOwtdi6oFteQzC+Fmoz7V2TYzlV/SdyIQ0AYqMHHua7BooEJ
	 oIwMA67s2v+c9UeChIzmXzya89GziKSKKNFBDov8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0698/1250] drm/xe/oa: Remove sysfs entry on idr_alloc failure in xe_oa_add_config_ioctl()
Date: Thu, 17 Sep 2026 16:08:13 +0100
Message-ID: <20260917151610.810601091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index ff19553e8843b..a753ac7ecc860 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -2418,9 +2418,9 @@ int xe_oa_add_config_ioctl(struct drm_device *dev, u64 data, struct drm_file *fi
 
 	oa_config->id = idr_alloc(&oa->metrics_idr, oa_config, 1, 0, GFP_KERNEL);
 	if (oa_config->id < 0) {
-		drm_dbg(&oa->xe->drm, "Failed to create sysfs entry for OA config\n");
+		drm_dbg(&oa->xe->drm, "Failed to allocate id for OA config\n");
 		err = oa_config->id;
-		goto sysfs_err;
+		goto id_alloc_err;
 	}
 
 	id = oa_config->id;
@@ -2431,6 +2431,8 @@ int xe_oa_add_config_ioctl(struct drm_device *dev, u64 data, struct drm_file *fi
 
 	return id;
 
+id_alloc_err:
+	sysfs_remove_group(oa->metrics_kobj, &oa_config->sysfs_metric);
 sysfs_err:
 	mutex_unlock(&oa->metrics_lock);
 reg_err:
-- 
2.53.0




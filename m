Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6CB400981;
	Tue, 21 Jul 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653955; cv=none; b=cojlJ0wiTY64QCj/jVjRSE+verC77A1wi/QkqNVeR1hXRGmBTWsKlWn93xq/liG7pTi3UOLrFqnnEuLX2p9HkKVcDaR1x6cXmdOItnq/B0R8ChCJgpDs7VPwajUwn3mZK2V8Eki3SVwprR/+61lWe/EMTgBAW4XvX4z6tWMgWfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653955; c=relaxed/simple;
	bh=lwMoTSDoD5moSAK1cSff8SW31lm05KPdz5vJkJ+n4us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKCq9pNUVClGVNz31FDdxd+bvFxrKoha0+n6KGdY18Is57Vf5kwsQC5VaTh0o8mUvqiHKsntQj6PIXSFiEiNbdipJa0GJAMUB+na5Wqz4xBIvDmpcXxPBhtLLx35UTC1VWh8Apwh4XTk5E5CPn/ddV+JYsIvGK+2hgu2E2Fv268=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNI1fbGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNI1fbGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C061E1F000E9;
	Tue, 21 Jul 2026 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653954;
	bh=oibTitqqLWZB23IPtl1a9dwG6Pgk5yBLXpl5CkHH+ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNI1fbGLC609sPBIWpeMgywAdc3iF0aLCu74KeJ77RE9+g8r+qZHGhnvTQtpvOmm/
	 IvOibfsVRPQqM35NgA1SqOh0RcYInTm2hfd4qHkY2M8Ppmh4L4hkc3q1H2E/NAo2Zm
	 GK7UKJ72X+xuz3DvNmFlINJ+gsUlTRaqMLOqxCso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1479/2077] drm/v3d: Reject invalid indirect BO handle in indirect CSD setup
Date: Tue, 21 Jul 2026 17:19:12 +0200
Message-ID: <20260721152627.683116457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 2f8b8593c7832fad655290cef9e99af05b1b52b3 ]

v3d_get_cpu_indirect_csd_params() looks up the indirect buffer object
from a userspace-supplied handle but never checks the result. A bogus
or stale handle makes drm_gem_object_lookup() return NULL, which is
then stored in info->indirect and only dereferenced later when the
indirect CSD job runs, turning a userspace mistake into a NULL pointer
dereference in the kernel.

Bail out with -ENOENT as soon as the lookup fails, so the bad handle is
rejected at submission time.

Fixes: 18b8413b25b7 ("drm/v3d: Create a CPU job extension for a indirect CSD job")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patch.msgid.link/20260703-v3d-cpu-job-fixes-v3-2-bc51b1f3eeb5@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_submit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_submit.c b/drivers/gpu/drm/v3d/v3d_submit.c
index 3ddd53b6f43769..f6a9bfa3548ce7 100644
--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -484,6 +484,8 @@ v3d_get_cpu_indirect_csd_params(struct drm_file *file_priv,
 	       sizeof(indirect_csd.wg_uniform_offsets));
 
 	info->indirect = drm_gem_object_lookup(file_priv, indirect_csd.indirect);
+	if (!info->indirect)
+		return -ENOENT;
 
 	return v3d_setup_csd_jobs_and_bos(file_priv, v3d, &indirect_csd.submit,
 					  &info->job, &info->clean_job,
-- 
2.53.0




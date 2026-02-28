Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F0A4BC002;
	Sat, 28 Feb 2026 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301342; cv=none; b=gF2GQ9kFG5PaF8YFj0JKpSnbUtcb7XS4JPcn0FElxINMpnN+3AjtME+VrpRgAR6JZ0efJpNGNTruagfu9cZQFdtnLNVMO2n4YyfXJw1EctcDjSpucF6cwqrzo11q48ePWBLCGEyWcx78y9J21vBHXOCEQZ6RBSge75q1q9OeF64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301342; c=relaxed/simple;
	bh=kpzNSLO0+nDpaFQyrjX+Cxy8Ilx+5nvWcG0HcKXLtJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYqpuRS0HE6LXfLZQgjclEkKz0HQFdQb/NEzyTJoudPUyaB4VNlT0deQwRPxQ7Ndq74+ij+cw/+eaeG73dQEtllTxuAzjyyGkHHwhIz+DkZ9KyggV4oR2ybuRgNvrHUf/ASNk1b0Pkp/QuLpXtHtB/3ln7WwrIatI3REe3b+Wms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e88zCJ5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e88zCJ5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56B0C19425;
	Sat, 28 Feb 2026 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301342;
	bh=kpzNSLO0+nDpaFQyrjX+Cxy8Ilx+5nvWcG0HcKXLtJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e88zCJ5uU0Y6qOW062GBykNAqkphJCD6RHmQKQlA82CAwZMkUzjhmgu2Ck7iS0Lkg
	 NcvRTRbzV5zAKsbph2BTypI+QgkaKRRsOjhM/iA9HWljSy8tm7WgpsY5sITScHw7W6
	 jEtk0ZIFcaP1jCE+5AMaUMH1A//qEqqEgPdLahm715yYC8usdyxvs0y/z/ZjBHgYu2
	 vS5UlwrYQRChMHdNwo/nKOhb31oRMPSPzC2M+7SNNfQNaqqVPECm3J3hHegow8tVyJ
	 9w9keHa1hsT2/dy5ba9ptUdgWICd200QmyrjxJTQ0laKXoHIqGKRusO4zx77wyBCNc
	 VuaFSkmf0L0AQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	stable@vger.kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 529/752] media: ccs: Fix setting initial sub-device state
Date: Sat, 28 Feb 2026 12:44:00 -0500
Message-ID: <20260228174750.1542406-529-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 31e5191aa11931b53e1242acef4f4375f00ca523 ]

Fix setting sub-device state for non-source sub-devices.

Fixes: 5755be5f15d9 ("media: v4l2-subdev: Rename .init_cfg() operation to .init_state()")
Cc: stable@vger.kernel.org # for v6.8 and later
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs/ccs-core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ccs/ccs-core.c b/drivers/media/i2c/ccs/ccs-core.c
index 01ddfa332c700..3f7162f3d1e32 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -2940,6 +2940,8 @@ static void ccs_cleanup(struct ccs_sensor *sensor)
 	ccs_free_controls(sensor);
 }
 
+static const struct v4l2_subdev_internal_ops ccs_internal_ops;
+
 static int ccs_init_subdev(struct ccs_sensor *sensor,
 			   struct ccs_subdev *ssd, const char *name,
 			   unsigned short num_pads, u32 function,
@@ -2952,8 +2954,10 @@ static int ccs_init_subdev(struct ccs_sensor *sensor,
 	if (!ssd)
 		return 0;
 
-	if (ssd != sensor->src)
+	if (ssd != sensor->src) {
 		v4l2_subdev_init(&ssd->sd, &ccs_ops);
+		ssd->sd.internal_ops = &ccs_internal_ops;
+	}
 
 	ssd->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	ssd->sd.entity.function = function;
@@ -3062,6 +3066,10 @@ static const struct media_entity_operations ccs_entity_ops = {
 	.link_validate = v4l2_subdev_link_validate,
 };
 
+static const struct v4l2_subdev_internal_ops ccs_internal_ops = {
+	.init_state = ccs_init_state,
+};
+
 static const struct v4l2_subdev_internal_ops ccs_internal_src_ops = {
 	.init_state = ccs_init_state,
 	.registered = ccs_registered,
-- 
2.51.0


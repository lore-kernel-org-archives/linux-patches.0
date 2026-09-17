Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07C34F55D3;
	Thu, 17 Sep 2026 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661157; cv=none; b=WtB0aym1LYzzSJkPQCyGyBTgkHLR6JrdRS38Ofy1SHVQkhM2Z74+3AXCRG5uQKnK6xST5/bRedTnCIJzZq0wHc+anbEe/g96ZZruhRQt+Eoe5AUwaiuoJCmQMVX3EnD/lFT/Je0omOA+U0agnR/dbzzEj8mKoeV9p12Xt+Yvk/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661157; c=relaxed/simple;
	bh=0sgLagasoa39+FbAzF3j9wJsj734c5+hEmM6lYVLmpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbWLVyel8umR3p1peUUFCQLGZDK17EhehT1+Ejsp9B2aScdn0CmBcReXzDouXyjJf0pQThBly03bfg2pV6wGQcEKqcISyg0VCc9YfjdRHmR0WqWZtzuovmMnPq1HiBfnSxYEHL54j2+Y4xdm2OXoaGzjzpowFy10+h/RYcSOd0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lknrUIhA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lknrUIhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CAB1F000FF;
	Thu, 17 Sep 2026 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661155;
	bh=lgDYxkmVMDfxqGIHAWwHKhvsyFFO26/P/M/GY4F70bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lknrUIhAQs6Og8/xovvvmxJ5P1IdrvE63EdVEfKyhA8ZneJHbEZ007nEVKKwlrueV
	 BTKS8qFS6cQ66+mRu4GM7fS/g6XO+lpiLfMFJ8maurdhw84Bvxs7WUGD02gv2Cmppw
	 F+rcyGS9ZhfVeEJVieTtMrSoH3DNmeRi7zao4o2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0101/1250] drm/amd/ras: Fix CPER ring debugfs read overflow
Date: Thu, 17 Sep 2026 15:58:16 +0100
Message-ID: <20260917151554.730976795@linuxfoundation.org>
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

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 1e40ef87ffdc291e05ccdade8b9170cc9c1c4249 ]

The legacy CPER debugfs reader can reach the payload path without a
valid pointer snapshot. The remaining user byte count is also treated as
the ring occupancy in dwords, so reads past the header can copy more than
requested.

Take the CPER lock before sampling pointers. Resample rptr/wptr for
payload reads, bound the payload copy by available dwords and the
remaining user size, and advance the file position for each dword copied.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 29 +++++++++++++++++-------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 304564ec2f59a..431cc39ea0178 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -498,8 +498,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 					size_t size, loff_t *pos)
 {
 	struct amdgpu_ring *ring = file_inode(f)->i_private;
-	uint32_t value, result, early[3];
+	u32 value, result, early[3] = { 0 };
 	uint64_t p;
+	u32 avail_dw, start_dw, read_dw;
 	loff_t i;
 	int r;
 
@@ -508,10 +509,10 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 
 	result = 0;
 
-	if (*pos < 12) {
-		if (ring->funcs->type == AMDGPU_RING_TYPE_CPER)
-			mutex_lock(&ring->adev->cper.ring_lock);
+	if (ring->funcs->type == AMDGPU_RING_TYPE_CPER)
+		mutex_lock(&ring->adev->cper.ring_lock);
 
+	if (*pos < 12) {
 		early[0] = amdgpu_ring_get_rptr(ring) & ring->buf_mask;
 		early[1] = amdgpu_ring_get_wptr(ring) & ring->buf_mask;
 		early[2] = ring->wptr & ring->buf_mask;
@@ -543,13 +544,24 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 			*pos += 4;
 		}
 	} else {
+		early[0] = amdgpu_ring_get_rptr(ring) & ring->buf_mask;
+		early[1] = amdgpu_ring_get_wptr(ring) & ring->buf_mask;
+
 		p = early[0];
 		if (early[0] <= early[1])
-			size = (early[1] - early[0]);
+			avail_dw = early[1] - early[0];
 		else
-			size = ring->ring_size - (early[0] - early[1]);
+			avail_dw = ring->buf_mask + 1 - (early[0] - early[1]);
 
-		while (size) {
+		start_dw = (*pos > 12) ? ((*pos - 12) >> 2) : 0;
+		if (start_dw >= avail_dw)
+			goto out;
+
+		p = (p + start_dw) & ring->ptr_mask;
+		avail_dw -= start_dw;
+		read_dw = min_t(u32, avail_dw, size >> 2);
+
+		while (read_dw) {
 			if (p == early[1])
 				goto out;
 
@@ -562,9 +574,10 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 
 			buf += 4;
 			result += 4;
-			size--;
+			read_dw--;
 			p++;
 			p &= ring->ptr_mask;
+			*pos += 4;
 		}
 	}
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020024;
	b=WYY7kFUF8Rx5TrcVmwkOT1DaDH3mJHZZLe+G5cgBlzWImFhkx0TXxGLdqnJudoGS5XUy
	 yEJourm29RBw/nTHwrlTOgF9aXSs4XNIKfF11eZLwPNPYNtN19y7t80XsZfXg3ja5Lh0n
	 eCHC4B+h2wrOuanHkylyJmRLssa6NV8gBcQlnNQ62txQKmlQjspOy4wwYnUZLcwbOTqNo
	 Lj0C4pXlvcB9GOt49fusrMmW1LhqXipr5W5ig6vQkHwS/HYlHESnz7DBdivM0kYUtZqNt
	 1ySPbUMpf2d4E/Nia0pGJ8HNYESJNRd5x/ebqz5iVSWJzwoKeoSoMOd7pDdutMtDlFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hCJVHLQSCyEmhB6ELHQ8yjjQHeqQrq6kt+djO3nrQg0=;
	b=28Vi8NE9POdd0z/mf2CbXqNT3KfyWhgLPqpNqWM8nTwkTPjfZO9i2YErYFoef4ooUyAx
	 81ajUI01i5aG5IQfChjyzj/SgvjIlHbDEHno5XHHJYABijNG3HwCJQKw99Pm2QNGFXs/2
	 a/allLjzLhENVPsJbZKTFch34yh2Yx/zaLodUni0rBGNjcBOpti7V8XqFpnLFj+o/Fhg1
	 aojeOlL63ZhZdHVLhlSP6IHkKr2hSIAg6DSUfyQDi55TS1k1V4YAHoeOouS4eqDmzDyyr
	 P/g55d+8u6MrfuepM6VBtuB27MJYm6Z4WWVmRZUbUf4lhAwVjc/P0Xjs2q6NH6P89Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rs4eEXD2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F13606A32A;
	Wed, 18 Nov 2026 16:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rs4eEXD2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9891F000C4;
	Wed, 18 Nov 2026 16:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020023;
	bh=hCJVHLQSCyEmhB6ELHQ8yjjQHeqQrq6kt+djO3nrQg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rs4eEXD2/Y6J61rIAAGrqfOV9mRrYGFazfJDHJVoG/+qRGEINOTj7s2+vGHgLycIN
	 93QeEl/XvmM2FYL6yuWWLrUFGfBUUi8rePli8cznt0Zr5xNLZi9scl67NDjnvrWVrR
	 h+NDZLC6ZjUjXRedPMgskETN7XK4Rw90VNg7sQXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1805/2651] accel/qaic: Protect perf stats BO state with bo->lock
Date: Wed, 18 Nov 2026 15:50:45 +0100
Message-ID: <20261118150352.247880560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit 1c50c57717c013ca63363eecb4154049cc727767 ]

qaic_perf_stats_bo_ioctl() validates each BO by checking bo->sliced and
bo->dbc before returning its perf stats. These fields are changed by the
detach paths while holding bo->lock, but the perf stats ioctl reads them
without that lock.

A concurrent detach can clear bo->dbc and mark the BO unsliced while the
perf stats ioctl is validating the BO. Take bo->lock while checking the
BO state and copying the per-BO stats into the temporary result buffer.

Fixes: 4ddf4ddfceb4 ("accel/qaic: Ensure entry belongs to DBC in qaic_perf_stats_bo_ioctl()")
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/6a115824.a0bed9bd.3c0137.9edf@mx.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_data.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index 4d55531bf1c9e..ee35e13091b30 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -1840,15 +1840,16 @@ int qaic_perf_stats_bo_ioctl(struct drm_device *dev, void *data, struct drm_file
 			goto free_ent;
 		}
 		bo = to_qaic_bo(obj);
+		ret = mutex_lock_interruptible(&bo->lock);
+		if (ret)
+			goto put_obj;
 		if (!bo->sliced) {
-			drm_gem_object_put(obj);
 			ret = -EINVAL;
-			goto free_ent;
+			goto unlock_bo;
 		}
 		if (bo->dbc->id != args->hdr.dbc_id) {
-			drm_gem_object_put(obj);
 			ret = -EINVAL;
-			goto free_ent;
+			goto unlock_bo;
 		}
 		/*
 		 * perf stats ioctl is called before wait ioctl is complete then
@@ -1864,7 +1865,12 @@ int qaic_perf_stats_bo_ioctl(struct drm_device *dev, void *data, struct drm_file
 						    bo->perf_stats.req_received_ts), 1000);
 		ent[i].queue_level_before = bo->perf_stats.queue_level_before;
 		ent[i].num_queue_element = bo->total_slice_nents;
+unlock_bo:
+		mutex_unlock(&bo->lock);
+put_obj:
 		drm_gem_object_put(obj);
+		if (ret)
+			goto free_ent;
 	}
 
 	if (copy_to_user(u64_to_user_ptr(args->data), ent, args->hdr.count * sizeof(*ent)))
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9AB18FC72;
	Tue, 10 Sep 2024 10:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962428; cv=none; b=sJBbhjjtJG5gD+bOjpUwC1CYjM3jSx8YRMgFYoNPVYr9v40cyYD25OGfRiJCLqQAf7ilZFjhe129ars2x2FnBKnaYAkVU9C3eqh828aEhsnm9U3rYQsFFbmsIZyyKG0qQwr4T9CYY6PxQ+ZoYCu09+pRAYdIN8Xm13aV979zc5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962428; c=relaxed/simple;
	bh=4MtkY8I8sa/M9c1vgPpx6t8C7wCBNnogDphprVvR4ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZfRiEVndX/Q/p5dWPeZYN3+8hrIDcKVyW8uq0WS4ig+R33f8TlvEzGTuLL3XUU11vpXDXxrbkG/uCqmImo9YI7HQkD48Vk9G1ZHVTPvwJjV6Xk90IYKS3tWAXP8ngGXum+no0P03syi56o2bG5aPxdcnbRG2tnsXOhkWX17AM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5O0AcXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5O0AcXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFB0C4CEC3;
	Tue, 10 Sep 2024 10:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962427;
	bh=4MtkY8I8sa/M9c1vgPpx6t8C7wCBNnogDphprVvR4ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5O0AcXP4DO00Z/AjHve09d9BQopElZ4XcHEhlHi+at478rWkhDrKj0QVapW30gxe
	 xg6wxgXmigB51P8q60R9LXGgf7QZ2ikLvDQ5qcH9z061RvlGVy7LGvIDBKFcsb2xOA
	 q2AQg6RZ3jmrAlyS3aDQ36Q0pkcHMxGmp5RZSIXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/121] drm/amdgpu: fix overflowed array index read warning
Date: Tue, 10 Sep 2024 11:31:20 +0200
Message-ID: <20240910092545.994088407@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit ebbc2ada5c636a6a63d8316a3408753768f5aa9f ]

Clear overflowed array index read warning by cast operation.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index e5c83e164d82..8fafda87d4ce 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -437,8 +437,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 					size_t size, loff_t *pos)
 {
 	struct amdgpu_ring *ring = file_inode(f)->i_private;
-	int r, i;
 	uint32_t value, result, early[3];
+	loff_t i;
+	int r;
 
 	if (*pos & 3 || size & 3)
 		return -EINVAL;
-- 
2.43.0




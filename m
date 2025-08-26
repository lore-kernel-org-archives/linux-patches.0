Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFAB302CA6;
	Tue, 26 Aug 2025 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216352; cv=none; b=XPc4E9U5ZUgEgGVJep16n5SZje3efXjFtorBzFd8thkqb3xAa4OuDH7VVLz1qiRLsHeoDqNWXPtsc3hhIruZKiFOAT7BNqPj+O/phULIESlXB1Uf+tr/m+Z+YpzCSmdkOJXryOBN+6ULLHpwjYEMf2WwPYuN7Vmx7QK9CQTkTHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216352; c=relaxed/simple;
	bh=wRBi6UOqPD47LsN93uQu6yXGrvaLL40ofvMMb0umr3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rboWSRFN6wiYrNXWhUHYdWJnrUOMds0WGpYcsVv3Q1BA3uo31q0GpgewGjiRlmVXot0Uzw68BTIgY+Zhts77L1wh7BdUxzVrYn7qNNv0ELQwUOrRfN7NcNQYGu47F1sksfT8XUZGoafl5U4suvr6SWFR2+xw9SbNILEsJFPm8rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S69ls6A4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S69ls6A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABB8C4CEF1;
	Tue, 26 Aug 2025 13:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216352;
	bh=wRBi6UOqPD47LsN93uQu6yXGrvaLL40ofvMMb0umr3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S69ls6A4hlNfpOThJRIYAV0I+oaQ2v3QdUcmw3kCCChIVreq9w5Ga8b31Z7Y3UzUS
	 zsqbFvDAP1UVYYaM+5ptI/RBwxcfLa5CmTs8w1r5YjSMTl2stZ5ar1DStJ69WyHOBC
	 rl/yb/e35NDFeEvdNoT8CJL8IGCpsRbzTXTVSI4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 378/644] drm/ttm: Should to return the evict error
Date: Tue, 26 Aug 2025 13:07:49 +0200
Message-ID: <20250826110955.789647801@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emily Deng <Emily.Deng@amd.com>

[ Upstream commit 4e16a9a00239db5d819197b9a00f70665951bf50 ]

For the evict fail case, the evict error should be returned.

v2: Consider ENOENT case.

v3: Abort directly when the eviction failed for some reason (except for -ENOENT)
 and not wait for the move to finish

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250603091154.3472646-1-Emily.Deng@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_resource.c b/drivers/gpu/drm/ttm/ttm_resource.c
index 2c590b4c46cb..9a8f565aa6ad 100644
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -150,6 +150,9 @@ int ttm_resource_manager_evict_all(struct ttm_device *bdev,
 	}
 	spin_unlock(&bdev->lru_lock);
 
+	if (ret && ret != -ENOENT)
+		return ret;
+
 	spin_lock(&man->move_lock);
 	fence = dma_fence_get(man->move);
 	spin_unlock(&man->move_lock);
-- 
2.39.5




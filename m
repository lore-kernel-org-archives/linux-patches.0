Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6395B81AC9;
	Mon,  8 Apr 2024 13:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582101; cv=none; b=kZWbcl9e1qAq8LW2f7gGCMRW6QL42KtaUZdoAT9YM5zyOQIeKmOjADSmrcAAvOqGwJyxGG4rNvDZvYTjopTKWixcScLWLUXqBxtsxk/loQSB1vKQ9jYWc71lETsD6ZiApq5nnihnJHLTkxHYgdPsx4I8OvkBPcfcXEFW6lwr60M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582101; c=relaxed/simple;
	bh=XVpYYfq8Xw+Gjm/0fh7UWwr6YTEP2120pKKSOHJyTE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eDhuvk6eC1ckCGO0AsN/Pipp/JYAqsTTth7TR6s+8+5YVT7LmoUGQz9Q9nKAaSvh/f6/IGNgeEN9vFEohSVAbN0uULFi+fG6s9dwTSn+QLD8Y6FOhSheElQjSXIt+mlTIvgD5MpQ+EdxpubtKvl9aSkcy1OkDPSHZTFKwgwTVuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUjvB3hC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUjvB3hC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD27C433F1;
	Mon,  8 Apr 2024 13:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582101;
	bh=XVpYYfq8Xw+Gjm/0fh7UWwr6YTEP2120pKKSOHJyTE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUjvB3hC7olX+L/B7uX3/U0i5obaTUQyCE7QXReiVdu7OakVw71quaOLd9A+3juJg
	 faW2SUvZvHxfwiqIYMQjvhM7kesMtME3g06yN48mqMpHVezDKDY/femOgYI8wEAO0n
	 IK55ui3JLPOverDCgQXwsZNGYFj2X2czAUe2R3Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/690] drm/amdgpu: amdgpu_ttm_gart_bind set gtt bound flag
Date: Mon,  8 Apr 2024 14:49:37 +0200
Message-ID: <20240408125403.546212853@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 6c6064cbe58b43533e3451ad6a8ba9736c109ac3 ]

Otherwise after the GTT bo is released, the GTT and gart space is freed
but amdgpu_ttm_backend_unbind will not clear the gart page table entry
and leave valid mapping entry pointing to the stale system page. Then
if GPU access the gart address mistakely, it will read undefined value
instead page fault, harder to debug and reproduce the real issue.

Cc: stable@vger.kernel.org
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index b06fb1fa411b4..9a1b19e3d4378 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -859,6 +859,7 @@ static int amdgpu_ttm_gart_bind(struct amdgpu_device *adev,
 		r = amdgpu_gart_bind(adev, gtt->offset, ttm->num_pages,
 				     gtt->ttm.dma_address, flags);
 	}
+	gtt->bound = true;
 
 gart_bind_fail:
 	if (r)
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9208053816;
	Wed, 21 Feb 2024 13:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521557; cv=none; b=ezoy6vPzsM9rq3cdGdqKk0IVUscXqLzFkZtsNqU5wy4BRE9JfmdDSyE3PxLLYi2Hsz8wFHATbVvX1X6noKOvqnhpxYjdj5HLg8QTT6pE9R+w/oluAF4r2gFm7bLbg/rmjKm4aLLv60fg8L0TiquZAnrjncXB7VNDQQMumWUwtKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521557; c=relaxed/simple;
	bh=9hJauWcuciE/MwP11IRDUjl9DSzON3ah4ibyHalizgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ac3bBa5TqY9vP6j2H1Pj73rs3hNvUqvjy4LwOZ2awdjsklX1UaiSnTnRgXNNJqGzF3q9XYD57y6OQoJ1tdutmfrYks/8JYpoF6aPBeEJhd9wRlNeeRdfj5u7z3jww9qR6ltJe0QlL7kdmLDJihFbkRyhzMXS8d3+ZNMCwBMqJ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPFmKoiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPFmKoiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C2FC433C7;
	Wed, 21 Feb 2024 13:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521557;
	bh=9hJauWcuciE/MwP11IRDUjl9DSzON3ah4ibyHalizgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPFmKoiQYakQIwxGNjVTYc4PTpMepmDtVXBjZgcQ4D9q05c+QLBs4lKCxZhZXcJMS
	 WwkfHdBcHEADPOFnZuYtEjj1T1Yz1uJBm5hrRvBLpTljKym76krI6VU47jA5Db/sb1
	 Jg4iH4zbTy1Pn9zlUW7U0FVNOLS7gN8QDKg/b/30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/202] drm/amdgpu: Let KFD sync with VM fences
Date: Wed, 21 Feb 2024 14:06:55 +0100
Message-ID: <20240221125935.421329811@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit ec9ba4821fa52b5efdbc4cdf0a77497990655231 ]

Change the rules for amdgpu_sync_resv to let KFD synchronize with VM
fences on page table reservations. This fixes intermittent memory
corruption after evictions when using amdgpu_vm_handle_moved to update
page tables for VM mappings managed through render nodes.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
index 2d6f5ec77a68..5eb8f93c7022 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -219,7 +219,8 @@ int amdgpu_sync_resv(struct amdgpu_device *adev,
 		 */
 		fence_owner = amdgpu_sync_get_owner(f);
 		if (fence_owner == AMDGPU_FENCE_OWNER_KFD &&
-		    owner != AMDGPU_FENCE_OWNER_UNDEFINED)
+		    owner != AMDGPU_FENCE_OWNER_UNDEFINED &&
+	    owner != AMDGPU_FENCE_OWNER_KFD)
 			continue;
 
 		if (amdgpu_sync_same_dev(adev, f)) {
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA946198822;
	Thu,  5 Sep 2024 09:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530058; cv=none; b=eZ8mv4M9oExznnqUHY2Be/5HRkdIbQJsz8OLuEE3aauMEzhraieO+pAP1RlzOHd/gfzk2lsa+K6twBxz92Gx+5MXt9KhNgwVgEbNuGeyOGviIaC1c3Mn7NpSkpcrQBtPp1wUOTJdo07iq/amrCw0jrZmvaAIFw8LZqXgDuhlnSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530058; c=relaxed/simple;
	bh=THbkKN1DzS7OCuMLSEeO0du2danEjS6e5OWwA8RbdPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DciQFNuRkjRLvS94yQ7eQdUgsYCTshwVwg/ZsQ71qcYkQsP/8TdRBH565L5LimLTZbC4QXHl7RBePNoP5IzTYLGzMDa0hrCXtF40wVPsKAHZVDno2bkNeq21SP4f18aKFF+dreF5pphLtE6iqwWJJLNdZy0OashmbdmQjZ/7MzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqTTVKZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqTTVKZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00987C4CEC4;
	Thu,  5 Sep 2024 09:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530058;
	bh=THbkKN1DzS7OCuMLSEeO0du2danEjS6e5OWwA8RbdPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqTTVKZUqZ4weNSK1ENe58PsZYmXWBho0UEOqcPTSr68pKd0vk1lE/2ZaV+PfMuHo
	 pV+uuBLakIb9GpB7CDmh1ksN2UQntWw7bpDZd39E/MxFAxAW53G1TnsjeFllhZIf6/
	 +Us/+NN2s2wGzIQv6QvT22YL+XowWCUAKbSk9cXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/132] drm/amdgpu: fix overflowed array index read warning
Date: Thu,  5 Sep 2024 11:40:29 +0200
Message-ID: <20240905093723.894946115@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dbde3b41c088..0bedffc4eb43 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -469,8 +469,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FB21494DB;
	Thu,  5 Sep 2024 10:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530561; cv=none; b=dgh/VOAcO+4W6fYvvr4yrSER/6yBGXyMKa4xXLMFmGb6pxB02nQfqcQkpT9XDS5hLK0dADnNJmF/6AW6xEitxEbjO5TfAcfIxf3Z57jMmIuaLczSe0dhmd2fzREBRPcrskejT2XE/JofoHoW2H8X/06R3dZpmlpszMvFQ/SRiJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530561; c=relaxed/simple;
	bh=PCc09MS4k40n2R3dirE6k5gCGH7dfICoyws8mVBBEVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJfQmJuvl9gF7jARmpsc7KRF5vXljlZvIgfeuGQ0TTQiY2ZB5j26ALViOB2KA+L1cfM/XKJAu+UE8W1ttH1LhWH9R57NcmNHh62k+5X1BhfUenXc5L9qe/N9TDpwwagAVO72outTrNDYeUUqGRpEfdwPtb6HLZW4ghT7g4hh/Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvCVn1rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvCVn1rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E24C4CEC3;
	Thu,  5 Sep 2024 10:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530561;
	bh=PCc09MS4k40n2R3dirE6k5gCGH7dfICoyws8mVBBEVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvCVn1rljCNpfKYnJ40U2AFoXVB68KhDHHDG6JI3A1mwAtBbU4OnZHeVM++TpuXxG
	 7UB67BJUj63IdxXpxJfDn9hKYswppqmiFn6dtIy1ERCk6hH/cNkKviFqm+wMiYYkGm
	 P1GtrhFN4ViakuSSwCaietqtfYzgZLqi7tU2Dhlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/101] drm/amdgpu: fix overflowed array index read warning
Date: Thu,  5 Sep 2024 11:41:03 +0200
Message-ID: <20240905093717.346877057@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 296b2d5976af..2001c7d27a53 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -434,8 +434,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
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




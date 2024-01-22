Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA48145327;
	Tue, 23 Jan 2024 00:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969566; cv=none; b=EXG0hEwBOL+KwvXheF8drgdzMj5i615Kz2709SE9Dd6c9q82A1nRcRxIhIHE30pj7lC1f04acFDVmf1TqEYrnFLlg7L/KeWJ4W7mMvbNVKI/K6oLBI6AOpGG8LN4RdktiWNW7TZ99o1hksb9Z05JQZtxfbIJJF/yvmgYT6zQBM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969566; c=relaxed/simple;
	bh=a3Ll8a3Sn493y/IrHgQ2sozEqRDYp0vY51Pb0sNo80I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KyLRSo8eqOC/fTrH6N9wz/trYySoS/zGdFwCGcJOI2m2ftZklr3Z0T93Qa09z/NQnicOSP61S7VbEMYmiDEXd71CfERNHLQFDiutfQ6lsZYbYfm4coBZVaeuxH1UXNUlwnh9Mc7wij71RiDcSyXjdK3Dl/sCkO3CcmYLaXHh/mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7pW4fdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7pW4fdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43D4C43399;
	Tue, 23 Jan 2024 00:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969566;
	bh=a3Ll8a3Sn493y/IrHgQ2sozEqRDYp0vY51Pb0sNo80I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7pW4fdqu5E9WdmEIKmv6Rwi5f/NZIXENQRO5YBlOazC0BTZfrvXMTpsVKwa/gAM9
	 /kxO1gJS4TvF+96QhRQqZD6XgRYat0J7QstSxRyqhNEiQJA/9vD7ZaetK7NWIJZOgp
	 EwOXYmnJSo1b2rmVH2k2Klpf6pUnkJY3kP3rp9Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 327/641] drm/amdgpu/debugfs: fix error code when smc register accessors are NULL
Date: Mon, 22 Jan 2024 15:53:51 -0800
Message-ID: <20240122235828.121339238@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit afe58346d5d3887b3e49ff623d2f2e471f232a8d ]

Should be -EOPNOTSUPP.

Fixes: 5104fdf50d32 ("drm/amdgpu: Fix a null pointer access when the smc_rreg pointer is NULL")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index 0e61ebdb3f3e..8d4a3ff65c18 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -755,7 +755,7 @@ static ssize_t amdgpu_debugfs_regs_smc_read(struct file *f, char __user *buf,
 	int r;
 
 	if (!adev->smc_rreg)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
@@ -814,7 +814,7 @@ static ssize_t amdgpu_debugfs_regs_smc_write(struct file *f, const char __user *
 	int r;
 
 	if (!adev->smc_wreg)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
-- 
2.43.0




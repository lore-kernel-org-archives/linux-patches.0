Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145ED1272D1;
	Tue, 23 Jan 2024 00:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968683; cv=none; b=jrUZ6taZOpH39Z+2NUUiu97g00sGVtKnBHTYB6D2UasC2rn1R3Sjsl5CaNJ5r5Fp8dPMWw82NWYTHiSHYP1OlzrpUzkgu/xXmEjv4QF9sPr5m4eolBbByi3pyvggm7qsyKjwgQ3eRnqCShNBjkGSnchh9x0T6QELdXEZ2ZC8PrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968683; c=relaxed/simple;
	bh=NHZ140e9fFJzlifaVYENcOqUJn3GYHo6GjfEKpm/Apg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PsVDgCUkwlNTzZZGkJaGm2q/HgjGZtpTgFTHHqbeGgJPjzOhP4knuxJEe5SSgCpkHzB/YeRONchpL+fupGgv4Wn3JUDpZbaQ2tSVJpZ3ZSjHb0JAUa2lydZWm/PJ83QOWCDmPYMO3P4jaXf0COoihchukkbN3rd8UArm2262Was=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeBRzlLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeBRzlLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E00C43390;
	Tue, 23 Jan 2024 00:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968682;
	bh=NHZ140e9fFJzlifaVYENcOqUJn3GYHo6GjfEKpm/Apg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeBRzlLf2b+9tKaWXhoJitFng5pXhoNpuDJKjoKMIZKliqEc8Sg/jzO8IkApk1+ED
	 vZxFhw33CLAMZd1DtrIrcklN3Yf2KYcFCm16CT8qmoOLDRhdSd4VZLSPCNJLyxn70b
	 raLkaRqDZgvtL91K0GkF+x8wMrind7t2ZPcf18hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/148] drm/amdgpu/debugfs: fix error code when smc register accessors are NULL
Date: Mon, 22 Jan 2024 15:57:38 -0800
Message-ID: <20240122235716.533674176@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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
index 41a9cc9e0f9d..98bd8a23e5b0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -392,7 +392,7 @@ static ssize_t amdgpu_debugfs_regs_smc_read(struct file *f, char __user *buf,
 	int r;
 
 	if (!adev->smc_rreg)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
@@ -434,7 +434,7 @@ static ssize_t amdgpu_debugfs_regs_smc_write(struct file *f, const char __user *
 	int r;
 
 	if (!adev->smc_wreg)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
-- 
2.43.0




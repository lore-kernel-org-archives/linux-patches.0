Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BC266B3C;
	Tue, 23 Jan 2024 02:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975325; cv=none; b=EOxyiEasH5NTpK0Gr+/Nikoaeqj7+wmY/coo+ZH3fihgkNOe4q9fKZS27pUmr4NQhI6n02PANH52eC7UrSf0JoipMPMox9uqJPPVEXIBwWHCka6q0xAYEKAcZFvi1K7isHpaqkh9XyUJXVjQsLY1frIz9RmBXJehNs3eU6dCSn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975325; c=relaxed/simple;
	bh=29yXy8qZdB8aNri4+sQjgsO3z4T88dicOrVfignEzwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SzrC9bC1codwgOwdejZagD/VPmFg4/CgMq6gesIFQ3TfCnAlimuER08MsuiD5Tp9HGhElYjD1aV10swUVtqqw0zgL+gC7lPzrlt7GKPThsj0c9VIxJR8+bGkeb4pY9yoyxGWxH4AXGw6e/uKk3wYN0BDRcMY5Ll/ERZdOR2JLgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUtvfPyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUtvfPyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDA7C433C7;
	Tue, 23 Jan 2024 02:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975324;
	bh=29yXy8qZdB8aNri4+sQjgsO3z4T88dicOrVfignEzwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUtvfPyGUVBP8UKB9YMrj4CwvWpk/sv7vnIkw4kEMBpp31QC/DR2XALv2aBPJupYh
	 E/ZsiTwChks/o8rHT7YJ1anZ7Toyj6y/QSgijFZG7Qdb0n1LhiUi7UXfN/0NIl/UWr
	 WxcQf/J09dOMdiANghd4kA6WI8HNPpT2jKMA34v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/583] drm/amdgpu/debugfs: fix error code when smc register accessors are NULL
Date: Mon, 22 Jan 2024 15:55:39 -0800
Message-ID: <20240122235820.821753347@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 3f2126f99923..418ff7cd662d 100644
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




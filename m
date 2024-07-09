Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDED1158A15;
	Tue,  9 Jul 2024 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523994; cv=none; b=bYDkDMt8K28i1gVK2wbwk51g1RQPGWdB23Ylv80M7TkzIvsUg1ME+OPBUysTHwhkn6NOYSdXXVUZebRAHPtKKSmprFxKLb+e6UzO7eIOz00rZ8CWM5QGAm1GrZG9KcOvo9HzSwBZjeuNfAfnk5B1QW7D5FZgAyAx+gIjDlPR68U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523994; c=relaxed/simple;
	bh=rBmtFuO65TZaxxiNhruwP7H/E2ChDpji+AxHFqXqo9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXu0zbqkDdy7DqVWsj8yYAGKE5DsHNbFMbIPmUpvYksmOgMmscITABlFxTI/cgU5PUByva9pV+g+A54Si4gH+pbVx2BnNb8CppuoV/B2p8yiN8QMogBbn/0fef2TQRAFtUcnJa0j/uNUoiJk89lAqe606W+BHJUDUdcnngleg/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fj0tuWJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fj0tuWJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FC0C3277B;
	Tue,  9 Jul 2024 11:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523994;
	bh=rBmtFuO65TZaxxiNhruwP7H/E2ChDpji+AxHFqXqo9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fj0tuWJ3ohp7JJeZxjwPjJegGL9ECoh9A7xECPgUNHXI8csnFkN2e4nC+UcpLAX08
	 EoVFI6nTy4WYJ6OYZNi05qpGINRxw58zTGeFAtmWBqfGuVbut3XibQkSMVNRj9kVEE
	 SRfsY/Ic8rfJWKO9Lfy85vgM1czjLz54orkkF+fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 038/197] drm/amdgpu: fix the warning about the expression (int)size - len
Date: Tue,  9 Jul 2024 13:08:12 +0200
Message-ID: <20240709110710.393640767@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit ea686fef5489ef7a2450a9fdbcc732b837fb46a8 ]

Converting size from size_t to int may overflow.
v2: keep reverse xmas tree order (Christian)

Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index f5d0fa207a88b..b62ae3c91a9db 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -2065,12 +2065,13 @@ static ssize_t amdgpu_reset_dump_register_list_write(struct file *f,
 	struct amdgpu_device *adev = (struct amdgpu_device *)file_inode(f)->i_private;
 	char reg_offset[11];
 	uint32_t *new = NULL, *tmp = NULL;
-	int ret, i = 0, len = 0;
+	unsigned int len = 0;
+	int ret, i = 0;
 
 	do {
 		memset(reg_offset, 0, 11);
 		if (copy_from_user(reg_offset, buf + len,
-					min(10, ((int)size-len)))) {
+					min(10, (size-len)))) {
 			ret = -EFAULT;
 			goto error_free;
 		}
-- 
2.43.0




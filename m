Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFAF189B84;
	Tue, 11 Nov 2025 01:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824645; cv=none; b=TXrC3v7pDh4yal9CYUQmpdifu765m4wv2QD4Q+xDk7MQf2Ag8r6DPzpmNf0X+oKI8ICwXzgWTc5qoxZ5UsuDTSaT5ULdm8JFTStFApyLNckhrM8jKES2GIcblfD3p58P0eNI37lqc70tkzH5gB8JOhKOOTupWgnHMZ+2LPZ0K/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824645; c=relaxed/simple;
	bh=iKAOafGtof0HpEk7qx/kg7LHPaK0n+IwF9hCOEouwTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWwrigtkBpkJkrbcz2rI8QK2Q7GoQrhPHfumi1F93uGeNS36qHSA1S2q+jdQ8vd+aewkSycQIo/JPsl5nKrRfZbYta6N+DOKU2lRVH3Byd4tLLYGU1pZ1PJps0sBCQBplnLur2I3eczaiICfCpEPWoTLO47xMLwlb9aSLCqTWkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIaDeAJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIaDeAJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B54C116B1;
	Tue, 11 Nov 2025 01:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824645;
	bh=iKAOafGtof0HpEk7qx/kg7LHPaK0n+IwF9hCOEouwTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIaDeAJiiPllJJgeX2+I9MzdgWFeyDeMu0Dy/RMSfqfSfaKP4vr0iIG2Z7ZBxJtdG
	 KGL+klQEjwcOpgTQonyj+2fLTZaeiO/+W+wKWNWuUZu3lsTWTcCuzhPtnRRGI6UlkF
	 S3xMw35DcC7wgyahRICTq5M5fxICDxbC+hD80Jk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 491/565] drm/amdkfd: Fix mmap write lock not release
Date: Tue, 11 Nov 2025 09:45:47 +0900
Message-ID: <20251111004537.979523967@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 7574f30337e19045f03126b4c51f525b84e5049e ]

If mmap write lock is taken while draining retry fault, mmap write lock
is not released because svm_range_restore_pages calls mmap_read_unlock
then returns. This causes deadlock and system hangs later because mmap
read or write lock cannot be taken.

Downgrade mmap write lock to read lock if draining retry fault fix this
bug.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 155948dc3d07a..0d950a20741d8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3036,6 +3036,8 @@ svm_range_restore_pages(struct amdgpu_device *adev, unsigned int pasid,
 	if (svms->checkpoint_ts[gpuidx] != 0) {
 		if (amdgpu_ih_ts_after_or_equal(ts,  svms->checkpoint_ts[gpuidx])) {
 			pr_debug("draining retry fault, drop fault 0x%llx\n", addr);
+			if (write_locked)
+				mmap_write_downgrade(mm);
 			r = -EAGAIN;
 			goto out_unlock_svms;
 		} else {
-- 
2.51.0




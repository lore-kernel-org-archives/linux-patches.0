Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8A424EA90;
	Tue, 11 Nov 2025 01:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825267; cv=none; b=dB+j4GM+iYY6A3H3mVYrCHsvsmMSFYcDwWyLyYMx8ehtZfMsEIto4PspJfqbKzgk0CRJMueBuW4TIN4oJnLayoQAFkylK1blXWV0ubyzK0yL2pG4rCuEUCVmeoWXu/+HPW+Yt/9n9FlnDd94ClP598JZAUHj/ZMPIDl6qXNY2bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825267; c=relaxed/simple;
	bh=T3rupkfSzcSs90BaQ0fPJ3Zugr0GARhyyvE8iGzowMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WI1wl3JCnXHP+6aLNMqmyDYFErkzeym1V9FM0fUIH7b4MFVrY/wap44W2G3czYJmRIPiIuGzMn7DHuEwWNTjS3BhBv72i7L0WYvdTMzx8/UpFTOmPyLoaCbuC0xoWGrj65TuBeia3fvna7qshUcdKY3k517Vsrrx/Lo9OcQPJUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Jte2lIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Jte2lIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B95C4CEFB;
	Tue, 11 Nov 2025 01:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825266;
	bh=T3rupkfSzcSs90BaQ0fPJ3Zugr0GARhyyvE8iGzowMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Jte2lINv984e1QKAEUP+PcRZUclHL4J+NiI9udyoxSwXlqvhhb126WWGZkltxprM
	 vTYAXjm6NG1q+X5wtHLM6sQpagQccX+e8eybMY/uWoNDHYA7U0zQ7OKZ/KIH+oe9dK
	 iER1ip7Dd6NpyKDSEfMfrHbOnhJ9qeog8QGH87/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 731/849] drm/amdkfd: Fix mmap write lock not release
Date: Tue, 11 Nov 2025 09:45:01 +0900
Message-ID: <20251111004554.108626446@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index cecdbcea0bb90..827507cfed7aa 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3046,6 +3046,8 @@ svm_range_restore_pages(struct amdgpu_device *adev, unsigned int pasid,
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




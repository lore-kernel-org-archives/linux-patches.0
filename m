Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A13DC87B;
	Wed, 30 Sep 2026 18:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794144; cv=none; b=IxSw+pjVvRQvFbEDwAr4QEzZWMsWh/9bdGxz0H+7p7rtZWiMeEMlVvmLg7gLyF+JwKlBlyNw+Lb2c0sSmI8RkXAI4jSlRq9/MmE/pSVAgQSSMviQLjBlwfY/CH7D2TBvWQNEPR1zMLmy5DIEagNdeuKMzcClNpmnlkAGDB4qHOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794144; c=relaxed/simple;
	bh=VgCmESy5FB4tz+hk8Bobjf6QN1F7PmdgY7ztq26Mm7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmpz0AKncDf2LULRQTX32bdzTM9xAggBEuavxcP5NMj3g6iuiBfNY9s3PSPsO40eosZH/oWafGKpYvQ3nrB7rMW7jUHGpygDO0K4MC4KAWK5ewxw2WkQ6Jd6b8mgDmpQvnbVRK/sADMYy1n40zoS8YiLLi36bCPT7pmce3Rwk9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVdo2oF+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVdo2oF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEBB1F000FF;
	Wed, 30 Sep 2026 18:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794142;
	bh=jig5LyOjYg8yoJKEc1s2GpM1mjfJfYdJlJd9hNrxn+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVdo2oF+fx+SUfU6a1bdIk/bp49tHk/Ee36Fp1RZN50Co33RIGP1YKyaa5ZAfUMWT
	 Z5+wPm0uyxS0Ax4w759eUibKHp8fN+MjbfR3OjjM1Q8WZMoBAQOJ2TtfVyt65ug8rU
	 afrjdzjGGZH3UNFFWKlGFNn1NSwy8DO25NATjJQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunday Clement <Sunday.Clement@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0062/1193] drm/amdkfd: Fix OOB memory exposure in get_wave_state()
Date: Wed, 30 Sep 2026 17:12:26 +0200
Message-ID: <20260930152435.653158027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunday Clement <Sunday.Clement@amd.com>

[ Upstream commit 7ef144458f48d5589e36f1b3d83e83db2e5c5ba5 ]

The get_wave_state() function for v9 trusts cp_hqd_cntl_stack_size and
cp_hqd_cntl_stack_offset values read directly from the MQD, which are
written by GPU microcode and fully attacker-controlled on the
CRIU-restore path (via AMDKFD_IOC_RESTORE_PROCESS with H3).

this leads to an unbounded copy_to_user() that can leak adjacent
GTT/kernel memory. If offset > size, integer underflow produces a ~4 GiB
read length, if size is set to 1 MiB against a 4 KiB allocation, we leak
1 MiB of adjacent kernel memory (other queues' MQDs, ring buffers, KASLR
pointers).

Fix by clamping both cp_hqd_cntl_stack_size to the actual allocated
buffer size (q->ctl_stack_size) and cp_hqd_cntl_stack_offset to the
clamped size before performing arithmetic and copy_to_user().

This ensures we never read beyond the allocated kernel BO regardless of
attacker-supplied MQD field values.

Signed-off-by: Sunday Clement <Sunday.Clement@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 1ac66c5337df4..9d643c1bd28bb 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -322,11 +322,15 @@ static int get_wave_state(struct mqd_manager *mm, void *mqd,
 {
 	struct v9_mqd *m;
 	struct kfd_context_save_area_header header;
+	u32 cntl_stack_size;
+	u32 cntl_stack_offset;
 
 	/* Control stack is located one page after MQD. */
 	void *mqd_ctl_stack = (void *)((uintptr_t)mqd + PAGE_SIZE);
 
 	m = get_mqd(mqd);
+	cntl_stack_size = min_t(u32, m->cp_hqd_cntl_stack_size,   q->ctl_stack_size);
+	cntl_stack_offset = min_t(u32, m->cp_hqd_cntl_stack_offset, cntl_stack_size);
 
 	*ctl_stack_used_size = m->cp_hqd_cntl_stack_size -
 		m->cp_hqd_cntl_stack_offset;
@@ -342,9 +346,10 @@ static int get_wave_state(struct mqd_manager *mm, void *mqd,
 	if (copy_to_user(ctl_stack, &header, sizeof(header.wave_state)))
 		return -EFAULT;
 
-	if (copy_to_user(ctl_stack + m->cp_hqd_cntl_stack_offset,
-				mqd_ctl_stack + m->cp_hqd_cntl_stack_offset,
-				*ctl_stack_used_size))
+	*ctl_stack_used_size = cntl_stack_size - cntl_stack_offset;
+
+	if (copy_to_user(ctl_stack + cntl_stack_offset, mqd_ctl_stack + cntl_stack_offset,
+					*ctl_stack_used_size))
 		return -EFAULT;
 
 	return 0;
-- 
2.53.0




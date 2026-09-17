Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F3D598BF3;
	Thu, 17 Sep 2026 16:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661255; cv=none; b=iePT84paCSZ8S0FhySn6HoQYqByn76+a6JXe7yvtUV8F/Q6mBvJaTsW1Q5jtLOYRCezVEGxTAoW3wrryu9Qash7gtcv63xCtbN37QNwHIZg1OKWrQzIf5Vmy6DUK5fxU4dQ8fXkKZUrkLl1NtYAY4Go7l5uVzhbCo8IoLYQ+owU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661255; c=relaxed/simple;
	bh=DrbUB+LbW16u35RtZwXfbVySugu/FZroecWcf2asYgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvhPH+gkoB0phiG/J7NpJjhirNKsPtT8BXLitckWz0sASSnaZ8/GI+uRz9IXYN4Qhwo8RFo5Eb+HTuhBrSAFeI14rZP5FMLjQ3GrSmUno+nWFfOsHUD0fuTw71L+5cO/MEtRcjVdg8vwCX/5V1jJr+UFJErsIPCrlOgfzBb3Gwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlZ41cT0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlZ41cT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9502D1F000FF;
	Thu, 17 Sep 2026 16:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661253;
	bh=5Odlp4KZq22g0hE8UiEhZZqIExU2Xs406Nv0L0m1uDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlZ41cT0xHFrp1XxdJ902/bZ+HGCdqLmrdfXWxuRacuQML9hNECYl7FNK3pfSBq3/
	 x/6IpskPTphwNCH/55lu8b199QPgWBFdzhpsDkkF4+u/vLx/f2GsfNqSJsbmJBkTYL
	 CJtcmaXxddXTwrV4x3+aV0wnlu1RDtFEKoF6/gGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunday Clement <Sunday.Clement@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0135/1250] drm/amdkfd: Fix OOB memory exposure in get_wave_state()
Date: Thu, 17 Sep 2026 15:58:50 +0100
Message-ID: <20260917151555.705263638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f2dee320fada4..e3a33a92b1799 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -341,11 +341,15 @@ static int get_wave_state(struct mqd_manager *mm, void *mqd,
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
@@ -361,9 +365,10 @@ static int get_wave_state(struct mqd_manager *mm, void *mqd,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7962C2357;
	Tue, 11 Nov 2025 01:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823522; cv=none; b=LNcg/pPAUHj+Gj1ZF2iRVg4Ain6NY+JLPx6i366av2Rg2WGcx8aQuScAQQ26YcM+UKI+YicQ83cD6owtstq4zxnrXGD3eQnflZWUVwqGppiCJZTb6iDIZIDmsUS2abUOgetuj1bsbV+4YN9+Ife99THpUp5rY0WqwwPAhBbsZkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823522; c=relaxed/simple;
	bh=SC/sPu1QmFoT0FqMD3F8Fh9IT/S1pIhrAcA1+5PS4Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlIO3GLXafKBPG3Q2/nyLcKg3+95WJA2ExyXpS3ow5iyKRzEv5ZRkT1zQ7O/Lx5/J1JlO7G4Um0PHQeI5lU/A0TO+HIt82RL22eA6nluleKNb1vtZxaAXNOwYiZzAB1JWlDtdo2dUz3b4yZ+drXx6T/9VpEzSqHSqK2k4tcDRdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+rek/Q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+rek/Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B138C4CEF5;
	Tue, 11 Nov 2025 01:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823522;
	bh=SC/sPu1QmFoT0FqMD3F8Fh9IT/S1pIhrAcA1+5PS4Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+rek/Q89HXA0Xws737Fh1fj+mHHyKqD5aXRrk2Q24zTdbPmgWw8hmDyL3PV3HuyH
	 Lsm9l9jsU5l6BIFVcUqKU/OkwBn3FCPISffIHtVUplh5016k3HN7GdzfDD8c9N31S2
	 k0op4YsSRhdCRuxwvuz6EySJTRy7i9jOiGXMcBeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 316/849] drm/amdkfd: Handle lack of READ permissions in SVM mapping
Date: Tue, 11 Nov 2025 09:38:06 +0900
Message-ID: <20251111004544.056840283@linuxfoundation.org>
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

From: Kent Russell <kent.russell@amd.com>

[ Upstream commit 0ed704d058cec7643a716a21888d58c7d03f2c3e ]

HMM assumes that pages have READ permissions by default. Inside
svm_range_validate_and_map, we add READ permissions then add WRITE
permissions if the VMA isn't read-only. This will conflict with regions
that only have PROT_WRITE or have PROT_NONE. When that happens,
svm_range_restore_work will continue to retry, silently, giving the
impression of a hang if pr_debug isn't enabled to show the retries..

If pages don't have READ permissions, simply unmap them and continue. If
they weren't mapped in the first place, this would be a no-op. Since x86
doesn't support write-only, and PROT_NONE doesn't allow reads or writes
anyways, this will allow the svm range validation to continue without
getting stuck in a loop forever on mappings we can't use with HMM.

Signed-off-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 3d8b20828c068..cecdbcea0bb90 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1714,6 +1714,29 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 
 			next = min(vma->vm_end, end);
 			npages = (next - addr) >> PAGE_SHIFT;
+			/* HMM requires at least READ permissions. If provided with PROT_NONE,
+			 * unmap the memory. If it's not already mapped, this is a no-op
+			 * If PROT_WRITE is provided without READ, warn first then unmap
+			 */
+			if (!(vma->vm_flags & VM_READ)) {
+				unsigned long e, s;
+
+				svm_range_lock(prange);
+				if (vma->vm_flags & VM_WRITE)
+					pr_debug("VM_WRITE without VM_READ is not supported");
+				s = max(start, prange->start);
+				e = min(end, prange->last);
+				if (e >= s)
+					r = svm_range_unmap_from_gpus(prange, s, e,
+						       KFD_SVM_UNMAP_TRIGGER_UNMAP_FROM_CPU);
+				svm_range_unlock(prange);
+				/* If unmap returns non-zero, we'll bail on the next for loop
+				 * iteration, so just leave r and continue
+				 */
+				addr = next;
+				continue;
+			}
+
 			WRITE_ONCE(p->svms.faulting_task, current);
 			r = amdgpu_hmm_range_get_pages(&prange->notifier, addr, npages,
 						       readonly, owner, NULL,
-- 
2.51.0




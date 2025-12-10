Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D358B1DD0EF;
	Wed, 10 Dec 2025 07:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351907; cv=none; b=eLVOsG3BDgtNzA1Wuv78wFAjWA3gXzTwyPYPv1j1ZpkEPwjgIT482LoNxm4KblMfzM2m+PKsOl1laGJIQHp2z+EdNglyG805DMKf9NdKomeBwCqIb0kk5aLszg4r24951QFHjK6I/Zats4SNFNqECti00KFyWalfe367WRrQSJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351907; c=relaxed/simple;
	bh=HfsRtB3lA0a7zzXHmU5vRuRTXZ7+NfjLP9LYQ1AsHAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdZPxmT7ouZYq24nYz9Z0L0Bi98s3h0NY5kmcjFCi/7SFIeIi6CiHW3PrEu0KGszSPllxqzkmp5HL+ylOuqDdup+w+F1aokonq3BdjbGHQgNnM3VNOLURwDry4JQcrvl5k8o0mm49yTyodHSPjZO04tMWyCMrNS9auXnqJlS+wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV8x2hzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV8x2hzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18646C4CEF1;
	Wed, 10 Dec 2025 07:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351907;
	bh=HfsRtB3lA0a7zzXHmU5vRuRTXZ7+NfjLP9LYQ1AsHAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV8x2hzlx7hCfahAHeBa7iIsvmWmgCdUxJMQQz72tWOfE0lQJWcJ26yNLLivLqik5
	 aTb5KVIRnNh5HiSmh3QtjdqLIfBYFhYyz+yjNS69wOUyuDnV7PZLHnXlp8rSMBXLk9
	 ghInLSszJ/jqAXqFIY8ZavtebKUUEGLeTrO40pmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 26/49] drm/amdkfd: Fix GPU mappings for APU after prefetch
Date: Wed, 10 Dec 2025 16:29:56 +0900
Message-ID: <20251210072948.814639764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit eac32ff42393efa6657efc821231b8d802c1d485 ]

Fix the following corner case:-
 Consider a 2M huge page SVM allocation, followed by prefetch call for
the first 4K page. The whole range is initially mapped with single PTE.
After the prefetch, this range gets split to first page + rest of the
pages. Currently, the first page mapping is not updated on MI300A (APU)
since page hasn't migrated. However, after range split PTE mapping it not
valid.

Fix this by forcing page table update for the whole range when prefetch
is called.  Calling prefetch on APU doesn't improve performance. If all
it deteriotes. However, functionality has to be supported.

v2: Use apu_prefer_gtt as this issue doesn't apply to APUs with carveout
VRAM

v3: Simplify by setting the flag for all ASICs as it doesn't affect dGPU

v4: Remove v2 and v3 changes. Force update_mapping when range is split
at a size that is not aligned to prange granularity

Suggested-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Philip Yang<Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 076470b9f6f8d9c7c8ca73a9f054942a686f9ba7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 0d950a20741d8..99ce4fe5eb170 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3675,6 +3675,8 @@ svm_range_set_attr(struct kfd_process *p, struct mm_struct *mm,
 		svm_range_apply_attrs(p, prange, nattr, attrs, &update_mapping);
 		/* TODO: unmap ranges from GPU that lost access */
 	}
+	update_mapping |= !p->xnack_enabled && !list_empty(&remap_list);
+
 	list_for_each_entry_safe(prange, next, &remove_list, update_list) {
 		pr_debug("unlink old 0x%p prange 0x%p [0x%lx 0x%lx]\n",
 			 prange->svms, prange, prange->start,
-- 
2.51.0




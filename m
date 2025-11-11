Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FF73491D6;
	Tue, 11 Nov 2025 01:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823793; cv=none; b=ITUUjLsAkpd0faCBZnSKBD+YJ3om0NLutAfQ5x9IF7v0o+UFc/Dbdgoyb/SHleLkk7LKLQmT61DJUnwaPOvdy+c9HLGJQVGvtwv/17mBgGDSj6ca9WdklgE725IP9GIOMcfITcisP2tgvTA4gcTgF7cuEITX/oaVFjaZBw5fjE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823793; c=relaxed/simple;
	bh=zzvbXEz2wLqOcVgyyVanX5128UJjd2NreyOiPBmE2zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaolE1Ik4fX+62nHEQBlhzgv3KoaDPcKYtD+z40FgOmyPXfuXl5Ze0NX8XZSfgA6yiAgFYlbaEqcpEJpOo3ZNKK4hZG2XxesZ6kNaHanLrHpbO4YTL7DAisPjxDfOMCuaSicCeM2ft4dJ4ajY4dzFTic8tQfeoMad1+8cRbxWqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NO7o7hy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NO7o7hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BCBC113D0;
	Tue, 11 Nov 2025 01:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823793;
	bh=zzvbXEz2wLqOcVgyyVanX5128UJjd2NreyOiPBmE2zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NO7o7hySdU/Sfk+qlecWkmMgNh/Y24NpSbhxpOczlJUGxP8VahckauYLdy0lSqQ5
	 R/Nnrbklb7M0Q24FH9LOAt71zp88drSW2UmnolNo+78rEVuPOisURSu04rvsNuqAWX
	 gGk2AfTpq/ndlVhu64JVLQ89CnswDpQMD1/50fKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 373/849] drm/amdkfd: fix vram allocation failure for a special case
Date: Tue, 11 Nov 2025 09:39:03 +0900
Message-ID: <20251111004545.449667208@linuxfoundation.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit 93aa919ca05bec544b17ee9a1bfe394ce6c94bd8 ]

When it only allocates vram without va, which is 0, and a
SVM range allocated stays in this range, the vram allocation
returns failure. It should be skipped for this case from
SVM usage check.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 79ed3be63d0dd..43115a3744694 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1070,7 +1070,12 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 	svm_range_list_lock_and_flush_work(&p->svms, current->mm);
 	mutex_lock(&p->svms.lock);
 	mmap_write_unlock(current->mm);
-	if (interval_tree_iter_first(&p->svms.objects,
+
+	/* Skip a special case that allocates VRAM without VA,
+	 * VA will be invalid of 0.
+	 */
+	if (!(!args->va_addr && (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM)) &&
+	    interval_tree_iter_first(&p->svms.objects,
 				     args->va_addr >> PAGE_SHIFT,
 				     (args->va_addr + args->size - 1) >> PAGE_SHIFT)) {
 		pr_err("Address: 0x%llx already allocated by SVM\n",
-- 
2.51.0




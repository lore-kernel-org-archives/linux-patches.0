Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCC13F660C;
	Tue, 17 Mar 2026 17:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767462; cv=none; b=Rta2ax5g6jSIOMTjuNCUiukrMhWL8Zz7GJP+Y4v23GmQQYnZoPsfqSVVugR6ftibM+AplRq9o76Leu8ZJVuuOPmojixxA2Tb3qlpVIiNJYSHZ0z5JGO0301ZqTCQXj3fvcBmoQCITpZLPSzHJFNoGmEovK4xAiTn/3nu1tfIS9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767462; c=relaxed/simple;
	bh=211szymnCx4GBFeYVxbgPN4Dm7Cbo3OQMx9NYG7ildo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozPd5iQBmw/uJRGIyE14tugiDC34ZHyeov9zVKzjrGe93NJj/d3HD9sO1etud+s9PNZmpEVMdna1/jKswC4qMCN43J+XlRWvwPoqKofg8AWQ+tJLkkVuJNxJZ2PUIOCCiA7XyUNPJd1dCwyFUQSdBMEspPQ+OD2z/zvOEplwdOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJScaWCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJScaWCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BB5C4CEF7;
	Tue, 17 Mar 2026 17:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767462;
	bh=211szymnCx4GBFeYVxbgPN4Dm7Cbo3OQMx9NYG7ildo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJScaWCYB+PZexGE+UKD2fV+r7K0YPDkjn1Hhq0Tbh0kiEK+kttzFBmobiUXsuR2F
	 OiC2Fim+RfZb8kavkv2qKnwbta6Ldz/dDoUBuXKa4F3Ycy/ba07JHIMpsMEs/QnFz1
	 9LOKGVBJRRcGdcB0OsXbXs6IQe7ka9c6H03ttqng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Sierra <alex.sierra@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/333] drm/amdkfd: Unreserve bo if queue update failed
Date: Tue, 17 Mar 2026 17:32:00 +0100
Message-ID: <20260317163002.745655919@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 2ce75a0b7e1bfddbcb9bc8aeb2e5e7fa99971acf ]

Error handling path should unreserve bo then return failed.

Fixes: 305cd109b761 ("drm/amdkfd: Validate user queue update")
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c24afed7de9ecce341825d8ab55a43a254348b33)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 7fbb5c274ccc4..7bf712032c52c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -606,6 +606,7 @@ int pqm_update_queue_properties(struct process_queue_manager *pqm,
 					 p->queue_size)) {
 			pr_debug("ring buf 0x%llx size 0x%llx not mapped on GPU\n",
 				 p->queue_address, p->queue_size);
+			amdgpu_bo_unreserve(vm->root.bo);
 			return -EFAULT;
 		}
 
-- 
2.51.0




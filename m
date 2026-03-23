Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CD132470A;
	Mon, 23 Mar 2026 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275385; cv=none; b=WZ3jPcr7EZ1N3W9OLt7WIeDTkXnsJvCpIYG8H5doja11vc+x80WE/WiMLf+ueIo1ghXm7WZqqzOFH5rThFkHDM1W+o2LPOIj7UlckSG45gh3S1UE6nNNGb7A4qpdeGNprqainW2Lrz7ATN0NpTCbkmT/XkmzBMKCe1MADd+Rzho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275385; c=relaxed/simple;
	bh=lX9wyF9yjM0nXDjuZd/35s8r87986gDE7FIt2HMSL+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0o6o2IzQ49qNA369l0Un2x8zzAD3Ipd9/wzqLxeAiaIJ7yM0F/dogOw8f1OjrL2qjWeo2XY5OxkcVAil0smwyJb1MMvdYxDDZX15APesABtyECw1CaCAZqQB4EntCa6NucKnKxQgpPi+7o84m/ucSVm9l1/v+UIpRnjoqO55KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bx0aVNpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bx0aVNpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45266C4CEF7;
	Mon, 23 Mar 2026 14:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275385;
	bh=lX9wyF9yjM0nXDjuZd/35s8r87986gDE7FIt2HMSL+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bx0aVNpDjTaK+gGiqosem23fEE56S2Oo6yZeD4kloFFUM63Xs4U6MKyl123JQw7J+
	 Yizlub1UXY4xH1Efk1nt4h8E5lxPx3aaqn8WKoRHnWvncr9EtFtX+4AQrGLOfLlp8k
	 rMAO2BxNO3zO+TPlRdnmzTDicUpH9dDAlD+Qh6NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Sierra <alex.sierra@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/460] drm/amdkfd: Unreserve bo if queue update failed
Date: Mon, 23 Mar 2026 14:41:16 +0100
Message-ID: <20260323134528.646827203@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
index 4078a81761871..e3749dae5e599 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -600,6 +600,7 @@ int pqm_update_queue_properties(struct process_queue_manager *pqm,
 					 p->queue_size)) {
 			pr_debug("ring buf 0x%llx size 0x%llx not mapped on GPU\n",
 				 p->queue_address, p->queue_size);
+			amdgpu_bo_unreserve(vm->root.bo);
 			return -EFAULT;
 		}
 
-- 
2.51.0




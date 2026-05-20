Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3F931F9BE;
	Wed, 20 May 2026 16:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295112; cv=none; b=F373uAzniZAw2qUzgunrsyw5jSmRcyEe21uop6sTmgtDQBxgDlUfNqNhkQ4exCfLBt0I1QOVcF/hWt5aHbGxjmzFKzAE1ATenYfJc4iF5AskYg0UTBC8GtnFPDdyvpAukAaA6trlMPXnpmlO0YF94O8jg/3Zmu/KjJJPVV28YbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295112; c=relaxed/simple;
	bh=PofoS5PZS590ThJujNPrmY/zDHp/BfoA4n8YOMkb9Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP7w0DWjLZa9uGoqDN3LSGW0mmccg7NkduQ0yzm2R1PH5D055GVzZvujnnAjotKLB0JWNnw/ArTN6uCdCjnBdkPPVrxtaiYIZ46YnCDsFwKi/3a784XzeFhESJWLLJ3F6ULVzFHmzYC/hLrr5CpYXqrJsXPHnZKA5S+toFu+Z/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2ZW1aaF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2ZW1aaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F0C1F000E9;
	Wed, 20 May 2026 16:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295111;
	bh=8csqHZobXrmeXje2HNux6kuOB84SUqcCu9nQ4xOmfWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2ZW1aaF2fOWLl+rboV4G85jlOIxvO/UcXZj6qEslbUJoXGEu43OgXbOJdFs8uTiC
	 N1HZopUEgO0R22std/LMf6MjSkptJpnVtRGu1w0ZIQvOuzZ38fG2sYQTxUSu3IMfC6
	 lhFhAwbEaVbhPoftYFrhpRXXSe9SzUnTNVDldrr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Sierra <alex.sierra@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0293/1146] drm/amdkfd: Update queue properties for metadata ring
Date: Wed, 20 May 2026 18:09:03 +0200
Message-ID: <20260520162154.845856494@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 189208d3d503090d95a39e85433bd608a0d84511 ]

Metadata ring and queue ring is allocated as one buffer and map
to GPU, so update queue peoperties should add the queue metadata
size and ring size as buffer size to validate queue ring buffer.

Fixes: c51bb53d5c68 ("drm/amdkfd: Add metadata ring buffer for compute")
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index f5d2847e1cbb4..3d172e35e57ce 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -590,7 +590,8 @@ int pqm_update_queue_properties(struct process_queue_manager *pqm,
 			return err;
 
 		if (kfd_queue_buffer_get(vm, (void *)p->queue_address, &p->ring_bo,
-					 p->queue_size)) {
+					 p->queue_size +
+					 pqn->q->properties.metadata_queue_size)) {
 			pr_debug("ring buf 0x%llx size 0x%llx not mapped on GPU\n",
 				 p->queue_address, p->queue_size);
 			amdgpu_bo_unreserve(vm->root.bo);
-- 
2.53.0




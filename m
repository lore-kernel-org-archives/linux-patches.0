Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766EF29CE7;
	Wed,  2 Oct 2024 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875847; cv=none; b=dHx7ak/mD+QEZix+r8dhVj/EI0JbAB40wc46MSo1GaOyi81lnoCVjWpbsuQwM993By+BoGgt6PMaO4+tw0c25Oi0BlRWYYgqMG4J2lVi9y3yUJsaz2rjeWZbVzfiQ27mvUczh1fBCf0YA5DEI4rh6aN9d6f0/WNmklEv6Hwczss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875847; c=relaxed/simple;
	bh=ukyRDo88wlhFcBSyZA/JF9wLZ30UZPDr132stwP6Wwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L40t/zmjli+aGAMOV2fxPYqIv3fDjABZCDUxRI+fJ2JddeLvXMeQVpqv2k/RnU5XCoJ9oaVtbyNea7ZaWXOMPMfXAAnus0eSpx0WrUlUayNbjaOvO4+ufghSzjBpF70/G9vU9Y4AA+Lo29EIlsnorZ1ecCeh2OTK4yKhoTq9H9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9XAyP+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9XAyP+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5FCC4CECD;
	Wed,  2 Oct 2024 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875847;
	bh=ukyRDo88wlhFcBSyZA/JF9wLZ30UZPDr132stwP6Wwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9XAyP+TTkpCtNeFIMzmm2g70svAU+Z10DJrjHe6ShMMtypsin95OsQIVlxVKtfaf
	 RINyu1/VQC9P3+Npscqri5mOs8pyRUtjcLiHkAWlAFRjhD9L1DEKX6/YKXZVZpQDN7
	 KE0zrAxbIX9V3r2yp/8M+GlLHd7/iaAsAvJyHen4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <lang.yu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 241/695] drm/amdgpu: fix invalid fence handling in amdgpu_vm_tlb_flush
Date: Wed,  2 Oct 2024 14:53:59 +0200
Message-ID: <20241002125832.071880163@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Yu <lang.yu@amd.com>

[ Upstream commit 4453808d9eab0461dea338e89372ffc4a3c50acc ]

CPU based update doesn't produce a fence, handle such cases properly.

Fixes: d8a3f0a0348d ("drm/amdgpu: implement TLB flush fence")
Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index a060c28f0877c..119eebeb16b7f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -902,10 +902,12 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_update_params *params,
 {
 	struct amdgpu_vm *vm = params->vm;
 
-	if (!fence || !*fence)
+	tlb_cb->vm = vm;
+	if (!fence || !*fence) {
+		amdgpu_vm_tlb_seq_cb(NULL, &tlb_cb->cb);
 		return;
+	}
 
-	tlb_cb->vm = vm;
 	if (!dma_fence_add_callback(*fence, &tlb_cb->cb,
 				    amdgpu_vm_tlb_seq_cb)) {
 		dma_fence_put(vm->last_tlb_flush);
-- 
2.43.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585788;
	b=5keZPHc6o3VlgAnEBuzk1CDicTncwcEpWawmUZH/mzfETzRUtWGMycdAG5YXCqYI8Zbe
	 AjUebLi7kiOGwaIEEOj4mWIHUWjDTWfTnbGlINlgR5EXJsrNxYiBjFwzUDmBEH72HswGi
	 Ed+tkpm+h4qt0dshRAmCcnZJ4GSJ3PfsneCiL3THcaPhXiFMTFmu20f8ZVRF23R1/wuNF
	 ZyUKcuBQe/xYVrgQ5lCE2rkfylIX9mqLk0p9Ef4BLpHiItD8/RfI5g9DNTU2zhGMauNYq
	 cAG9eZdealcZ3t6KX5zbJBRpUe6KrL6pxSOgDy682aG3HEN4LjytOInuBOgduO0e+6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4i3CRQ0M1DBXAGERss4Z1rp/uRxA0xqUjl9315scWpM=;
	b=jzlvENvxtaHrmCkqqyJeqZMRHUNWkE5OS7BkncaPnsEmnmW/HNn9H6zuT4TMVxLYyvyq
	 LsgVZBwite5mWsyExip/0TLfsA1X5R+mVTCKUOrDWWykABldvn3vr18JrBqVsSxDISHLB
	 qm3lw15RdwcMHIFqRtEemqu5yF9RKuGg7Dcaeq3Ee00v0ntqbD9QP4bHmDKj4B73HSSNV
	 Qe+t7fUTFDB373WV43RF3OEfqDbpWFs7d3vxJ1lbms6zRlOLe51D2hyfY91uTZBHFFW1v
	 JeXYHtg9jGFVuSm8DL5BjwNW7E4C0af1rjOgcrZDdxnPFX+mbw2gBuFengVT+csrNGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PaoaJYg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40D606D479;
	Fri, 13 Nov 2026 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PaoaJYg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989F21F000C4;
	Fri, 13 Nov 2026 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585787;
	bh=4i3CRQ0M1DBXAGERss4Z1rp/uRxA0xqUjl9315scWpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PaoaJYgLFNR8ff+vU2x5eYABjNrqytTOeQEovvQ3PGBfBlrm5lj1obE07knjLh8s
	 dXQzctf46hhu6mqab2uBZdJ7CZRKRMOUcf33yLO5RcOzVYwbKtvl8HCbBnt3tDft1l
	 P0NhBZ9puDKNmnBXWub/XXjEdo0sAHHGxPPFX5Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 377/507] drm/amdgpu: rewrite all PTEs of the BOs after a VM reset
Date: Fri, 13 Nov 2026 10:51:21 -0500
Message-ID: <20261113153809.002644507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 71388e1ed836d7645b4807cead35edf24da00bcd ]

amdgpu_vm_bo_reset_state_machine() moves all idle vm_bos to needs_update
so that their mappings are written again, e.g. after a GPU reset lost
VRAM. Since commit 5be7f6720a0f ("drm/amdgpu: Only set bo->moved when
the BO was actually moved") amdgpu_vm_bo_needs_update() no longer sets
the moved flag, so amdgpu_vm_bo_update() writes nothing for the kernel
and always valid BOs. The same applies to vm_bos already on a
needs_update list, e.g. after an AMDGPU_VM_DELAY_UPDATE mapping, where
only the new mapping gets written.

An SDMA write to an always valid BO after a VRAM-losing reset faults:

  amdgpu 0000:03:00.0: VRAM is lost due to GPU reset!
  amdgpu 0000:03:00.0: [gfxhub] page fault (src_id:0 ring:40 vmid:7 pasid:9)
  amdgpu 0000:03:00.0:   in page starting at address 0x0000000100000000 from client 10

Set the moved flag for all vm_bos on the needs_update lists after moving
the idle ones there; the root PD still goes back to idle.

Fixes: 5be7f6720a0f ("drm/amdgpu: Only set bo->moved when the BO was actually moved")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d397f95f63cc0f711c3e8f2043edc59b575345ab)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index fc3a8d38d5149..c07f1115f6543 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -269,19 +269,27 @@ static void amdgpu_vm_bo_reset_state_machine(struct amdgpu_vm *vm)
 
 	/*
 	 * Don't use list splice here, we need the special handling for the root
-	 * PD and set the moved flag appropriately.
+	 * PD. All mappings must be written again, also of the vm_bos which are
+	 * already waiting for an update of some of them, e.g. after a map with
+	 * a delayed update, so set the moved flag for everything that needs an
+	 * update.
 	 */
 	amdgpu_vm_assert_locked(vm);
 	list_for_each_entry_safe(vm_bo, tmp, &vm->kernel.idle, vm_status)
 		amdgpu_vm_bo_needs_update(vm_bo);
+	list_for_each_entry(vm_bo, &vm->kernel.needs_update, vm_status)
+		vm_bo->moved = true;
+
 	list_for_each_entry_safe(vm_bo, tmp, &vm->always_valid.idle, vm_status)
 		amdgpu_vm_bo_needs_update(vm_bo);
+	list_for_each_entry(vm_bo, &vm->always_valid.needs_update, vm_status)
+		vm_bo->moved = true;
 
 	spin_lock(&vm->individual_lock);
-	list_for_each_entry_safe(vm_bo, tmp, &vm->individual.idle, vm_status) {
-		vm_bo->moved = true;
+	list_for_each_entry_safe(vm_bo, tmp, &vm->individual.idle, vm_status)
 		list_move(&vm_bo->vm_status, &vm->individual.needs_update);
-	}
+	list_for_each_entry(vm_bo, &vm->individual.needs_update, vm_status)
+		vm_bo->moved = true;
 	spin_unlock(&vm->individual_lock);
 }
 
-- 
2.53.0




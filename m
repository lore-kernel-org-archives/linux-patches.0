Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EA94FD27C;
	Wed, 30 Sep 2026 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787612; cv=none; b=qX1RPFMvIJ9R8bRmbYcMWho0w5aMuonbNr2VaaZ8Gh7XRZJe1mTWifEZYg6U0Ov0cPSI6Q1qyMPuR0ps2FxXw6W14OMXgo/IQ5oom0UNI2aDDImcB6QWiOBZ45TeBrXmlRhp/eqht4u22X0ssQyWtydY6MPcNSdi1dQkSg7x3Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787612; c=relaxed/simple;
	bh=xWs6hNLtrXaiuVsoeL5PhgccXg/GqiMm1liZHqaTsOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTs0zr+HBC3bWhU0hn9DjyOl6t9SXKXipNzQwcoXTkuvUAZzDE1mqjrWMjROkSUWk47nn70Ppyv9QYt9xJaB5JJea13JDfojB1kYrLsrqvbCG/J8lgRdcQ92MmBKZKxw3xaNM9TeWVU95hbPIrYub6VbIsLgJtrkKn9MbhDcHho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laDKxYNo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laDKxYNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6960B1F000FF;
	Wed, 30 Sep 2026 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787611;
	bh=zRbBvovyLYQC/0GM450tBr7EV7RGJs95R8bmaAkIFmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=laDKxYNou8eOxb2wVIyHx/zEkdbbf6X5i5f/HwVzrE9XCFIyNr9UKQoT38qfCNeOE
	 fmo2yVoSQ2FXwnXfHE6wXvJW2hQRyqP2E2MZ83WrEUIu1qw3IKW8frJm/OWFUSgb1j
	 SVDVtYlxDCaCUIWf9jDKXwwkTIw0MACXhI68KsSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 289/457] drm/amdgpu: Fix last_update fence leak in amdgpu_vm_init()
Date: Wed, 30 Sep 2026 17:26:34 +0200
Message-ID: <20260930152352.271971506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit b4f7b4459b1b155e4c4977a6482b5df2cf08758c upstream.

amdgpu_vm_init() initializes vm->last_update, vm->last_unlocked and
vm->last_tlb_flush with references to the stub fence taken via
dma_fence_get_stub().  The error label at the end of the function
releases the last_unlocked and last_tlb_flush references with
dma_fence_put(), but the reference stored in vm->last_update is never
dropped, so whenever the page table root creation, the reservation of
the root BO or the PASID registration fails, the stub fence reference
leaks.

Drop the vm->last_update reference together with the other stub fence
references on the error path.

Fixes: 187916e6ed9d ("drm/amdgpu: install stub fence into potential unused fence pointers")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e7979c84fc05a176bdf855ee664871b1648404c9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2665,6 +2665,7 @@ error_free_root:
 	amdgpu_bo_unref(&root_bo);
 
 error_free_delayed:
+	dma_fence_put(vm->last_update);
 	dma_fence_put(vm->last_tlb_flush);
 	dma_fence_put(vm->last_unlocked);
 	ttm_lru_bulk_move_fini(&adev->mman.bdev, &vm->lru_bulk_move);



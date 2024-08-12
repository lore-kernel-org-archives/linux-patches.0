Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DA92C1A5;
	Mon, 12 Aug 2024 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480335; cv=none; b=IevfvoJ9g9bDW3M91aFa2g+vP33Z4ji/rcM4R8/4vI92UN0pyGJmbcOBUgNwnXpUA8Ahn7jaUiNa6HrPNJkxKEJ9Eui3dEaXetsKzBpzrzxXJVq5nm7wUYG8RVo/ojOp5/FM8r9uaalTsXCx1QJ7Akiw3RFFp/n8cz1y5TCeDJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480335; c=relaxed/simple;
	bh=SZ+3FSK9IbgDl7XeTUgwQ8wQHXJupELMSJFe8EVbyB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2ujGn8oSizP4Gntqf30ERcYVX+oQgxEG6cUoyz5EBIcvyiNfnKGuenKKlAumUJMG8jPHpfU8mlCc4EsnsYg6NzdN+LwaG5qqwARgCqN+JddPxoRNfvdy7sghQeWrFldvYwn9kdfKulpPB2MJ+Llm+HipsJK5/9ghmzU2AA2ni0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQL1/UUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQL1/UUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9B1C32782;
	Mon, 12 Aug 2024 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480335;
	bh=SZ+3FSK9IbgDl7XeTUgwQ8wQHXJupELMSJFe8EVbyB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQL1/UUr64EfQNFf+ZRr8OsXi1Fwm4QU2AwSgU2sqGeIV9bst2+aTsM5aksKCUX+J
	 ZqHFqKOmtw3CmgkH4qykdcOelhBzegvzgK1BsSIkiHol8I5No46jzofUZGU1ATOSg0
	 NH7BWuDnL659wEUezXTeUKZvdoCwvRbLeT60qc6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 167/263] drm/xe: Take ref to VM in delayed snapshot
Date: Mon, 12 Aug 2024 18:02:48 +0200
Message-ID: <20240812160152.940628056@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 642dfc9d5964b26f66fa6c28ce2861e11f9232aa ]

Kernel BO's don't take a ref to the VM, we need the VM for the
delayed snapshot, so take a ref to the VM in delayed snapshot.

v2:
 - Check for lrc_bo before taking a VM ref (CI)
 - Check lrc_bo->vm before taking / dropping a VM ref (CI)
 - Drop VM in xe_lrc_snapshot_free
v5:
 - Fix commit message wording (Johnathan)

Fixes: 47058633d9c5 ("drm/xe: Move lrc snapshot capturing to xe_lrc.c")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240801154118.2547543-2-matthew.brost@intel.com
(cherry picked from commit c3bc97d2f102ddd5a8341eeb2dbae2a3e98bb46a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_lrc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 760f38992ff07..d7bf7bc9dc145 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -1354,6 +1354,9 @@ struct xe_lrc_snapshot *xe_lrc_snapshot_capture(struct xe_lrc *lrc)
 	if (!snapshot)
 		return NULL;
 
+	if (lrc->bo && lrc->bo->vm)
+		xe_vm_get(lrc->bo->vm);
+
 	snapshot->context_desc = xe_lrc_ggtt_addr(lrc);
 	snapshot->head = xe_lrc_ring_head(lrc);
 	snapshot->tail.internal = lrc->ring.tail;
@@ -1370,12 +1373,14 @@ struct xe_lrc_snapshot *xe_lrc_snapshot_capture(struct xe_lrc *lrc)
 void xe_lrc_snapshot_capture_delayed(struct xe_lrc_snapshot *snapshot)
 {
 	struct xe_bo *bo;
+	struct xe_vm *vm;
 	struct iosys_map src;
 
 	if (!snapshot)
 		return;
 
 	bo = snapshot->lrc_bo;
+	vm = bo->vm;
 	snapshot->lrc_bo = NULL;
 
 	snapshot->lrc_snapshot = kvmalloc(snapshot->lrc_size, GFP_KERNEL);
@@ -1395,6 +1400,8 @@ void xe_lrc_snapshot_capture_delayed(struct xe_lrc_snapshot *snapshot)
 	dma_resv_unlock(bo->ttm.base.resv);
 put_bo:
 	xe_bo_put(bo);
+	if (vm)
+		xe_vm_put(vm);
 }
 
 void xe_lrc_snapshot_print(struct xe_lrc_snapshot *snapshot, struct drm_printer *p)
@@ -1440,7 +1447,13 @@ void xe_lrc_snapshot_free(struct xe_lrc_snapshot *snapshot)
 		return;
 
 	kvfree(snapshot->lrc_snapshot);
-	if (snapshot->lrc_bo)
+	if (snapshot->lrc_bo) {
+		struct xe_vm *vm;
+
+		vm = snapshot->lrc_bo->vm;
 		xe_bo_put(snapshot->lrc_bo);
+		if (vm)
+			xe_vm_put(vm);
+	}
 	kfree(snapshot);
 }
-- 
2.43.0




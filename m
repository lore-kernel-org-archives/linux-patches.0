Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D114B43F8BF;
	Thu, 30 Jul 2026 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422345; cv=none; b=ocTd6dTfhfmVGf521ElR2dUACkZAoK292ZOzaU4EjjGsS8lNUwBsWCrF0r/5PEllGihjYX/r/yfxT9e0Jxafe5MNlFYxuSqY/gxx+d4vhlUK+8MJ70tgA7omFUA+5EJ8Wlj+bPuSHOJyRFfRku9VinE6Ka5h4XJXURLiUECyJs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422345; c=relaxed/simple;
	bh=5zyJmXzjRgLAVBAN/D61No0AufAf8vCOwu8ETiBz+VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LroZJyyveGaGAtL+3JB1pw5xcFxrLApKD6qLYdOvsT6I8kmrOUHEuqgFCSFzpctmbPj4NqwJ4ybx7J+gKWHsIMejL2p9m+ji49/frJId8LsB3ZQ+0lAmvgS99sWQW3gvt70PuEkqsMKxgC/v/WS0azAMC1sQOkRzlzzyyQRUXYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7SWg0Gm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7SWg0Gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10001F000E9;
	Thu, 30 Jul 2026 14:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422344;
	bh=vYhcahZpp6GnrNFp13coiZXsBgSzkAMIDp7I5QjsS6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7SWg0GmyZuiF/f4YT8ryk1YU+EVU91LCxP7Wx+33bx3HAIHsxctvcY1ma7tZY3B+
	 m/Qj2oPDwXj4qog9QyNcaUHsT9AbqZsASq3KgMRSBhC/mYtkLrgFHlb+pPW57Ltyyg
	 GcH97fZIjor6qD9X56E/YRvUE3VHiqKb1gtdAt28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Zongyao Bai <zongyao.bai@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 7.1 404/744] drm/xe/pt: Reset current_op in xe_pt_update_ops_init()
Date: Thu, 30 Jul 2026 16:11:17 +0200
Message-ID: <20260730141452.879179208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongyao Bai <zongyao.bai@intel.com>

commit 6384271ac1ac0099198d15df79212a19ebdb929d upstream.

xe_pt_update_ops_init() fails to reset current_op to 0. On the
vm_bind path, ops_execute() calls xe_pt_update_ops_prepare() inside
the xe_validation_guard() / drm_exec_until_all_locked() loop. When
that loop retries due to lock contention or OOM eviction
(drm_exec_retry_on_contention() / xe_validation_retry_on_oom()),
xe_pt_update_ops_prepare() runs again on the same vops, and each
call to bind_op_prepare() increments current_op without resetting it.

After N retries current_op exceeds the array size allocated by
xe_vma_ops_alloc(), causing an out-of-bounds write into
SLUB-poisoned memory and a subsequent UAF crash in
xe_migrate_update_pgtables_cpu() when reading the corrupted pt_op->bind.

Also reset needs_svm_lock and needs_invalidation which are derived in
the same prepare pass and would otherwise cause wrong migrate ops
selection and redundant TLB invalidation on retry.

Fix this by resetting current_op, needs_svm_lock and needs_invalidation
in xe_pt_update_ops_init().

v2 (Matt):
   - Add details in commit message.
   - Add Fixes tag and Cc to stable@vger.kernel.org

Fixes: e8babb280b5e ("drm/xe: Convert multiple bind ops into single job")
Suggested-by: Matthew Auld <matthew.auld@intel.com>
Cc: stable@vger.kernel.org
Assisted-by: GitHub-Copilot:claude-sonnet-4.6
Signed-off-by: Zongyao Bai <zongyao.bai@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260714232433.2737533-1-zongyao.bai@intel.com
(cherry picked from commit 046045543e530605c441063535e7dca0075369a6)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -2364,8 +2364,11 @@ static void
 xe_pt_update_ops_init(struct xe_vm_pgtable_update_ops *pt_update_ops)
 {
 	init_llist_head(&pt_update_ops->deferred);
+	pt_update_ops->current_op = 0;
 	pt_update_ops->start = ~0x0ull;
 	pt_update_ops->last = 0x0ull;
+	pt_update_ops->needs_svm_lock = false;
+	pt_update_ops->needs_invalidation = false;
 	xe_page_reclaim_list_init(&pt_update_ops->prl);
 }
 



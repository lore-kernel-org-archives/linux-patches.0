Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB040327C19;
	Tue,  6 Jan 2026 18:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722545; cv=none; b=S1OsRt001oD+1SQH1MdwzQdJsuoGVl+Gsb+QmtWD+GcVE9OS0yIlca4JlFtoS6ov/+JNw/7I90d5hpehr8XPTLRJo6lymFyiifwdbLAKBUEA/hRIng5o9Ni9jKdzKdWwymYBrTEJ3SMLWizzOAtgAbMXdhEWwuD/4B1xn8klSkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722545; c=relaxed/simple;
	bh=0T59KhUC7Ac6GdBqHzgiq5gbfMF/CVVDKN5n0SanLow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PVcgaArjwb4G8omboHFC7E0emovnZLAnTz8/8B4kSDDMR1AIxVRYiOUxtCtm+0dKTxIZd30+Fb9L6i7NF7nMQHdtyoPjvNDy87xIe2z0IdqYyJ2ShyT1OKCNbVE+8uhs3VmrH7rYduh9sfKpR0qdTJzLjJYzfBqGZI0Kn/sz3iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beILhr/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beILhr/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8143C116C6;
	Tue,  6 Jan 2026 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722545;
	bh=0T59KhUC7Ac6GdBqHzgiq5gbfMF/CVVDKN5n0SanLow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beILhr/OIwWDElCZB1l0h1jXPDDWEnaCxUIG7afwvQcxV2nlgpcsiJ4nHLIE4Mqa7
	 pckr+8rGBRseqt8tmw/HZHZPxnWieTEBGveYJA4AcJ2kZ2z1KEiK2zoIk3YlcRFEOT
	 azIpKZcSopb5WWDjRP/dKxpNymUSbXT2IsP74chI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 295/312] drm/xe: Adjust long-running workload timeslices to reasonable values
Date: Tue,  6 Jan 2026 18:06:09 +0100
Message-ID: <20260106170558.527720872@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 6f0f404bd289d79a260b634c5b3f4d330b13472c upstream.

A 10ms timeslice for long-running workloads is far too long and causes
significant jitter in benchmarks when the system is shared. Adjust the
value to 5ms for preempt-fencing VMs, as the resume step there is quite
costly as memory is moved around, and set it to zero for pagefault VMs,
since switching back to pagefault mode after dma-fence mode is
relatively fast.

Also change min_run_period_ms to 'unsiged int' type rather than 's64' as
only positive values make sense.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20251212182847.1683222-2-matthew.brost@intel.com
(cherry picked from commit 33a5abd9a68394aa67f9618b20eee65ee8702ff4)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c       |    5 ++++-
 drivers/gpu/drm/xe/xe_vm_types.h |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1481,7 +1481,10 @@ struct xe_vm *xe_vm_create(struct xe_dev
 	INIT_WORK(&vm->destroy_work, vm_destroy_work_func);
 
 	INIT_LIST_HEAD(&vm->preempt.exec_queues);
-	vm->preempt.min_run_period_ms = 10;	/* FIXME: Wire up to uAPI */
+	if (flags & XE_VM_FLAG_FAULT_MODE)
+		vm->preempt.min_run_period_ms = 0;
+	else
+		vm->preempt.min_run_period_ms = 5;
 
 	for_each_tile(tile, xe, id)
 		xe_range_fence_tree_init(&vm->rftree[id]);
--- a/drivers/gpu/drm/xe/xe_vm_types.h
+++ b/drivers/gpu/drm/xe/xe_vm_types.h
@@ -268,7 +268,7 @@ struct xe_vm {
 		 * @min_run_period_ms: The minimum run period before preempting
 		 * an engine again
 		 */
-		s64 min_run_period_ms;
+		unsigned int min_run_period_ms;
 		/** @exec_queues: list of exec queues attached to this VM */
 		struct list_head exec_queues;
 		/** @num_exec_queues: number exec queues attached to this VM */



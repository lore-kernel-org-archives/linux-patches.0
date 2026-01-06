Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8BE2C326B;
	Tue,  6 Jan 2026 17:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721243; cv=none; b=l83eVrYipdZCAVTc7Rd//mgcq+89Drl2S6uvTNflhA87pC6Qgyc6hCIR09f5wyNsJ4oPsMrAIdirjHiTXbwz1gIO8MjhLUgO0UnVoinDV7JM6qwehecX1PdMsuFivIhtPJ4J81PR3fvhwK4h521vBu23yBpvlZ1KFfDTU8uFVbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721243; c=relaxed/simple;
	bh=texQ4ROJjgk2M4EcZ0VUcPBg+Uf/6q0iAokoFzpHPX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ba3223mH6BwJl8nJ+42oDG07mic8fLQa1ET+bbVolafqoK/Sx0hsDCfwbwYzBWcUVUyUbGwucn/Bedg92ZOJfWarAC2olsWzl6DTnkQZZih9++wBgrqSppITIrRY+Sts8Qpeg18LKQyMhmt4Hx0jxLrMWAuiWCVZkiVMr12C+i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GPKwwrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GPKwwrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8B5C19424;
	Tue,  6 Jan 2026 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721243;
	bh=texQ4ROJjgk2M4EcZ0VUcPBg+Uf/6q0iAokoFzpHPX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GPKwwrrgF2jW2f3AHRLroXfncvP/xQSFskWAsutQabwGqaART8K9t2GncE6LQ1hH
	 gyktEXhLLJdvXTehyg91NBfrQ8UJmWkxuzn2WIk5RMSPIT0ISiQjDlqcUyf1bvrBGn
	 /b3dZUxbXjl8bFJA3v3wpE27y27aG2yqIMDbDejY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 478/567] drm/xe: Adjust long-running workload timeslices to reasonable values
Date: Tue,  6 Jan 2026 18:04:20 +0100
Message-ID: <20260106170509.037374834@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1468,7 +1468,10 @@ struct xe_vm *xe_vm_create(struct xe_dev
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
@@ -243,7 +243,7 @@ struct xe_vm {
 		 * @min_run_period_ms: The minimum run period before preempting
 		 * an engine again
 		 */
-		s64 min_run_period_ms;
+		unsigned int min_run_period_ms;
 		/** @exec_queues: list of exec queues attached to this VM */
 		struct list_head exec_queues;
 		/** @num_exec_queues: number exec queues attached to this VM */



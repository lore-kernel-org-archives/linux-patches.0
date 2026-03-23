Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CC33B52F5;
	Mon, 23 Mar 2026 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274471; cv=none; b=DMyPY5ek7+mWhQ+9SGRgNJVI5EYU3pvpi73SSmSc7dB78tmXFdW5fT8hool/bE90DoqI1919ACs0yWtj4gaElPgIHehVbTY1Ly8Gu2WEj9TNLK15k4Aah8IdDWQPrl8tneVyoKiz7UC7SW3S3AorZJXDG9fbm9SvC+vKefp0bkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274471; c=relaxed/simple;
	bh=0sV07C4vYro8LlX+T/h0g5IBrpL+QJ236Ujzf8fMVKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2XDHwAvSsQge30Eo0mFFh/s6yCpv4a7C1TXrUPn+02iUpZzTPzfk4wOq1zVwfQSVceXngWJ55OAU6OyIfyCdwSUGYvGO93GOPPyWwQZpgMP0crdpjFC61QxRzPO2T6fNYA3skQPP2DTVYtdgBiY0Y5K12ol2GLSAfT5ATHmwxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jq0MYFqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jq0MYFqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C3EC4CEF7;
	Mon, 23 Mar 2026 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274470;
	bh=0sV07C4vYro8LlX+T/h0g5IBrpL+QJ236Ujzf8fMVKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jq0MYFqDTcvLsPMj8ATdg6//SL2UpCRKBlSxLOTJeDWsD9fFaS8M7YkjlwXR4gGQ2
	 cMz7Uplw/F1yxh8wkSlfJ1UjYASLWxJ2Q3rfErlwkGvmwd9IfTx3D0N59EZMIXiL6K
	 +k3wQYkP+wLfOYNKDf7wUsG0VDyqfJOLFjDWbxDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Bukte <rahul.bukte@sony.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 214/220] drm/i915/gt: Check set_default_submission() before deferencing
Date: Mon, 23 Mar 2026 14:46:31 +0100
Message-ID: <20260323134511.287165652@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Bukte <rahul.bukte@sony.com>

[ Upstream commit 0162ab3220bac870e43e229e6e3024d1a21c3f26 ]

When the i915 driver firmware binaries are not present, the
set_default_submission pointer is not set. This pointer is
dereferenced during suspend anyways.

Add a check to make sure it is set before dereferencing.

[   23.289926] PM: suspend entry (deep)
[   23.293558] Filesystems sync: 0.000 seconds
[   23.298010] Freezing user space processes
[   23.302771] Freezing user space processes completed (elapsed 0.000 seconds)
[   23.309766] OOM killer disabled.
[   23.313027] Freezing remaining freezable tasks
[   23.318540] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[   23.342038] serial 00:05: disabled
[   23.345719] serial 00:02: disabled
[   23.349342] serial 00:01: disabled
[   23.353782] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   23.358993] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[   23.361635] ata1.00: Entering standby power mode
[   23.368863] ata2.00: Entering standby power mode
[   23.445187] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   23.452194] #PF: supervisor instruction fetch in kernel mode
[   23.457896] #PF: error_code(0x0010) - not-present page
[   23.463065] PGD 0 P4D 0
[   23.465640] Oops: Oops: 0010 [#1] SMP NOPTI
[   23.469869] CPU: 8 UID: 0 PID: 211 Comm: kworker/u48:18 Tainted: G S      W           6.19.0-rc4-00020-gf0b9d8eb98df #10 PREEMPT(voluntary)
[   23.482512] Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
[   23.496511] Workqueue: async async_run_entry_fn
[   23.501087] RIP: 0010:0x0
[   23.503755] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[   23.510324] RSP: 0018:ffffb4a60065fca8 EFLAGS: 00010246
[   23.515592] RAX: 0000000000000000 RBX: ffff9f428290e000 RCX: 000000000000000f
[   23.522765] RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffff9f428290e000
[   23.529937] RBP: ffff9f4282907070 R08: ffff9f4281130428 R09: 00000000ffffffff
[   23.537111] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9f42829070f8
[   23.544284] R13: ffff9f4282906028 R14: ffff9f4282900000 R15: ffff9f4282906b68
[   23.551457] FS:  0000000000000000(0000) GS:ffff9f466b2cf000(0000) knlGS:0000000000000000
[   23.559588] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.565365] CR2: ffffffffffffffd6 CR3: 000000031c230001 CR4: 0000000000f70ef0
[   23.572539] PKRU: 55555554
[   23.575281] Call Trace:
[   23.577770]  <TASK>
[   23.579905]  intel_engines_reset_default_submission+0x42/0x60
[   23.585695]  __intel_gt_unset_wedged+0x191/0x200
[   23.590360]  intel_gt_unset_wedged+0x20/0x40
[   23.594675]  gt_sanitize+0x15e/0x170
[   23.598290]  i915_gem_suspend_late+0x6b/0x180
[   23.602692]  i915_drm_suspend_late+0x35/0xf0
[   23.607008]  ? __pfx_pci_pm_suspend_late+0x10/0x10
[   23.611843]  dpm_run_callback+0x78/0x1c0
[   23.615817]  device_suspend_late+0xde/0x2e0
[   23.620037]  async_suspend_late+0x18/0x30
[   23.624082]  async_run_entry_fn+0x25/0xa0
[   23.628129]  process_one_work+0x15b/0x380
[   23.632182]  worker_thread+0x2a5/0x3c0
[   23.635973]  ? __pfx_worker_thread+0x10/0x10
[   23.640279]  kthread+0xf6/0x1f0
[   23.643464]  ? __pfx_kthread+0x10/0x10
[   23.647263]  ? __pfx_kthread+0x10/0x10
[   23.651045]  ret_from_fork+0x131/0x190
[   23.654837]  ? __pfx_kthread+0x10/0x10
[   23.658634]  ret_from_fork_asm+0x1a/0x30
[   23.662597]  </TASK>
[   23.664826] Modules linked in:
[   23.667914] CR2: 0000000000000000
[   23.671271] ------------[ cut here ]------------

Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260203044839.1555147-1-suraj.kandpal@intel.com
(cherry picked from commit daa199abc3d3d1740c9e3a2c3e9216ae5b447cad)
Fixes: ff44ad51ebf8 ("drm/i915: Move engine->submit_request selection to a vfunc")
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index b721bbd233567..ce8cdd517daa1 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -1969,7 +1969,8 @@ void intel_engines_reset_default_submission(struct intel_gt *gt)
 		if (engine->sanitize)
 			engine->sanitize(engine);
 
-		engine->set_default_submission(engine);
+		if (engine->set_default_submission)
+			engine->set_default_submission(engine);
 	}
 }
 
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022E321CA0E;
	Wed, 19 Mar 2025 14:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395132; cv=none; b=sUlo1p/HsV9pGgRRUpRaAXM38yXuaJotOsA9bte8gVKURToCP0P6szbRcc4gCg/MjZELhQj83MGNUKl3lJH0K2FaDtB8kz8y25Y+ft0yV29zZPGVpgqTiTpVcvHckw2dGUsLPb3NLu+ZdmdUM7WXlSFK2DqZiM1D1Y7Af5o026M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395132; c=relaxed/simple;
	bh=BmKSliDpAy3R5sdE7mqc+EBgllVWTSO6M2nnx6k7Zlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKPxEdEhnycNpdvoLQ6Glc+XC9jhJtcuzh84+03toTkggwQbRYmpiTPPZOv9UCcXPKlV6XtWgNVTDSXGE7iBnnLsnsdKqKoTuyHOHFzohwCaQ8QsBLQroA/myU9ZwNqxR+L/X9IMEpw1N8dm8v7I2B8MK4FgToGABd8k1P1yLzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0MhpeKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0MhpeKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC503C4CEE9;
	Wed, 19 Mar 2025 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395131;
	bh=BmKSliDpAy3R5sdE7mqc+EBgllVWTSO6M2nnx6k7Zlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0MhpeKmRxaB9e1QpTQKCpwNXAJWBv5ZW50PSSPV9GgSblBK2kzdBAmALRvu1OmZ6
	 wdqExlYcT6zm9viXNxBjQgQr4CC+R3d9f+s5DgR6FRSDJxgNj/E7kRcK1wusvE7zSV
	 K0kjZWAQuHg+5Z611s7yVuaRktElOmtD4jpzm42U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 197/231] sched_ext: Validate prev_cpu in scx_bpf_select_cpu_dfl()
Date: Wed, 19 Mar 2025 07:31:30 -0700
Message-ID: <20250319143031.711352426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andrea Righi <arighi@nvidia.com>

commit 9360dfe4cbd62ff1eb8217b815964931523b75b3 upstream.

If a BPF scheduler provides an invalid CPU (outside the nr_cpu_ids
range) as prev_cpu to scx_bpf_select_cpu_dfl() it can cause a kernel
crash.

To prevent this, validate prev_cpu in scx_bpf_select_cpu_dfl() and
trigger an scx error if an invalid CPU is specified.

Fixes: f0e1a0643a59b ("sched_ext: Implement BPF extensible scheduler class")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -6052,6 +6052,9 @@ __bpf_kfunc_start_defs();
 __bpf_kfunc s32 scx_bpf_select_cpu_dfl(struct task_struct *p, s32 prev_cpu,
 				       u64 wake_flags, bool *is_idle)
 {
+	if (!ops_cpu_valid(prev_cpu, NULL))
+		goto prev_cpu;
+
 	if (!static_branch_likely(&scx_builtin_idle_enabled)) {
 		scx_ops_error("built-in idle tracking is disabled");
 		goto prev_cpu;



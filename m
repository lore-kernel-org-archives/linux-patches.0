Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C051341C69;
	Tue, 11 Nov 2025 00:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822033; cv=none; b=LMd/yY9Z6srYLxQaHS1P9iLnM6ZoNyHZzEOltG43+w/f64TKzf0Q1v4UsF0yN2/Y5sgKnSMGR0XUBcKAaavHAcF9FRHTmCNgRb++fZPxLCsqQVz52FZaYIXVabEt0Zb1/LV97FXHo1VvmFyBGtcOr+kMZB4nJ9x2AMUpGz0nMjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822033; c=relaxed/simple;
	bh=P2Z60V4yXxoZrCEpxYfYs2hWEZ7EZjY7LnlYaJF3bys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcWvdlscIReVAOzqdjyi/WjZAp0RJJcSrYQ/HKaY2fUrcp3ncKv++5v4uj9uXR2nvsGFr3hpRlhoSamON5y5DI4JGXE/8uVWzqNmhmM0WgiUbdgyTX4V/Mj10pIwBTBkKDOFex3v8rz+Uaua49uNAZbF/cID4aEGAVeqBDSZTWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+SXDLC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+SXDLC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D9BC4CEF5;
	Tue, 11 Nov 2025 00:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822033;
	bh=P2Z60V4yXxoZrCEpxYfYs2hWEZ7EZjY7LnlYaJF3bys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+SXDLC5/H2q/fDZKUgprR2x1V4QSrqOF8ivC1ZIAbTE/iS8UrvzESChSpv94Zwmh
	 HbzBKxiU2lOKDP4AMY81Wrihr9kk/RVccCB4+NCU1nMt9SlhvmDT6egGkyfNTrc+8Z
	 gsqlgwf592zXurxgKZRboh0WzsD2gl7gD7Rl97tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.17 002/849] sched_ext: Mark scx_bpf_dsq_move_set_[slice|vtime]() with KF_RCU
Date: Tue, 11 Nov 2025 09:32:52 +0900
Message-ID: <20251111004536.524657347@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 54e96258a6930909b690fd7e8889749231ba8085 upstream.

scx_bpf_dsq_move_set_slice() and scx_bpf_dsq_move_set_vtime() take a DSQ
iterator argument which has to be valid. Mark them with KF_RCU.

Fixes: 4c30f5ce4f7a ("sched_ext: Implement scx_bpf_dispatch[_vtime]_from_dsq()")
Cc: stable@vger.kernel.org # v6.12+
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5706,8 +5706,8 @@ BTF_KFUNCS_START(scx_kfunc_ids_dispatch)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_nr_slots)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_cancel)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move_to_local)
-BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_slice)
-BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_vtime)
+BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_slice, KF_RCU)
+BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_vtime, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move_vtime, KF_RCU)
 BTF_KFUNCS_END(scx_kfunc_ids_dispatch)
@@ -5832,8 +5832,8 @@ __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(scx_kfunc_ids_unlocked)
 BTF_ID_FLAGS(func, scx_bpf_create_dsq, KF_SLEEPABLE)
-BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_slice)
-BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_vtime)
+BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_slice, KF_RCU)
+BTF_ID_FLAGS(func, scx_bpf_dsq_move_set_vtime, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dsq_move_vtime, KF_RCU)
 BTF_KFUNCS_END(scx_kfunc_ids_unlocked)



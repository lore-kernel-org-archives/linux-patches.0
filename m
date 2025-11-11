Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C825224113D;
	Tue, 11 Nov 2025 00:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822573; cv=none; b=p3tpxa+Gx8pP5PqLHcCbqOpmj7FszG8IvMv32GB0291rTwYfvyNHe7IgKYIoAvNG1t7ozTgMwHRWMQTGn6svEnhx9QA7/e3GiDdZOVXT3LzC9ku+hPzjm+cLK/QFBBoZMDxEwgL2z7oTPEUHsKMfS0+cR0UAdDTAziA7pK6LvUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822573; c=relaxed/simple;
	bh=YrOPYrWLTACaHrF23owHTe+46E7WoMYdwPlQet79ZCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHOzvbB/uxxYRTBlvHOEdgUFAcoY3zJILdFhA7r8WkLn0HFRInX9HAnvWh2QoEPHK7Kv1YDBT1TMUgfbNNXiu0wsH596HSIilTZdbKia5w/XeOHTiy7JdfcLG/gz67sdEZ3DawSDnyey1QvGUQEGbmbBoHrbJ9bUsuMH2ThDd2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srovob6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srovob6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FBBC4CEF5;
	Tue, 11 Nov 2025 00:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822573;
	bh=YrOPYrWLTACaHrF23owHTe+46E7WoMYdwPlQet79ZCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srovob6NZ2AHUzEkD7rXsN3WNqbEWqWTp6i1KKduglCuVzvpEwNVuRqJLApGPdetm
	 g8ceMTCJeghR6pOpi76E5MpxdUKl1t7FFEb3+RhxTioTRf/hBwz8Giu7w08iMYl4Sz
	 uBnA4ew3vTgPupb68BHcpXnR7ivfdBPakuBL4NTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/565] sched_ext: Mark scx_bpf_dsq_move_set_[slice|vtime]() with KF_RCU
Date: Tue, 11 Nov 2025 09:38:53 +0900
Message-ID: <20251111004528.697634109@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 54e96258a6930909b690fd7e8889749231ba8085 ]

scx_bpf_dsq_move_set_slice() and scx_bpf_dsq_move_set_vtime() take a DSQ
iterator argument which has to be valid. Mark them with KF_RCU.

Fixes: 4c30f5ce4f7a ("sched_ext: Implement scx_bpf_dispatch[_vtime]_from_dsq()")
Cc: stable@vger.kernel.org # v6.12+
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ scx_bpf_dsq_move_set_* => scx_bpf_dispatch_from_dsq_set_* ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -6493,8 +6493,8 @@ BTF_KFUNCS_START(scx_kfunc_ids_dispatch)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_nr_slots)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_cancel)
 BTF_ID_FLAGS(func, scx_bpf_consume)
-BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_slice)
-BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_vtime)
+BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_slice, KF_RCU)
+BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_vtime, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_vtime_from_dsq, KF_RCU)
 BTF_KFUNCS_END(scx_kfunc_ids_dispatch)
@@ -6593,8 +6593,8 @@ __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(scx_kfunc_ids_unlocked)
 BTF_ID_FLAGS(func, scx_bpf_create_dsq, KF_SLEEPABLE)
-BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_slice)
-BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_vtime)
+BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_slice, KF_RCU)
+BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_vtime, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_vtime_from_dsq, KF_RCU)
 BTF_KFUNCS_END(scx_kfunc_ids_unlocked)



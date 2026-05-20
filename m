Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374F43FC5AE;
	Wed, 20 May 2026 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299965; cv=none; b=oJxvlmnFvdnNZ/hOTBB3i1+bIySbkCt5U0VVW3V24HycOHtovYKVjcmRFh7+rseivVGHNeVY0qLl1NJAoGvKNL9JsQX0AnLwAWRKnZpwndUtO9UdoL6JvDzf413KRRJwXb90CThvn8dzMUaf//6aRw3FqhM0dGowis2SY8MkvhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299965; c=relaxed/simple;
	bh=PWpbr9s32fIT1gPa/DSUFkejOi1LkEn+be27uMnk55s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdolSFHiILqvp1VU6R3DOtyouoUZVBXQ7gPPoyUhRKqjeYJuENsuT/yZq3SzaT/4PN5oZUtupbXsuVOmV8B4Z7nLYULwAhwY3/b5XhAYPQXaIsRZyBHOpfxl/kBzSg75xUrhn8EccOBo5PdxbAuV3yipm3XNW/a0NlU3Hf3MAjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLLAPio9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLLAPio9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BA71F000E9;
	Wed, 20 May 2026 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299963;
	bh=Okdf9mP5ea2CihL14RaEyGEZ/3jWb8Njg9oa2ZxBwLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLLAPio9QoDo0lW1ud3aNeY2hp6RFaJcwNz+VJuFfWyfLbbB/EQjNHdJkItNMo4Tm
	 LQ5w8vGl10WItOq/XT+/vrOeICp5/YOF8SFjnqm9pGMnaKpCGAY7qY5DaWNMMZtzDk
	 YeQg3n73l9q5vPnS2Xo9pop0mryEWRMINLhmgg1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 953/957] sched_ext: Guard scx_dsq_move() against NULL kit->dsq after failed iter_new
Date: Wed, 20 May 2026 18:23:56 +0200
Message-ID: <20260520162155.270345073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 4fda9f0e7c950da4fe03cedeb2ac818edf5d03e9 ]

bpf_iter_scx_dsq_new() clears kit->dsq on failure and
bpf_iter_scx_dsq_{next,destroy}() guard against that. scx_dsq_move() doesn't -
it dereferences kit->dsq immediately, so a BPF program that calls
scx_bpf_dsq_move[_vtime]() after a failed iter_new oopses the kernel.

Return false if kit->dsq is NULL.

Fixes: 4c30f5ce4f7a ("sched_ext: Implement scx_bpf_dispatch[_vtime]_from_dsq()")
Cc: stable@vger.kernel.org # v6.12+
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
[ dropped upstream `sch = src_dsq->sched` reordering since stable initializes `sch` from `scx_root` instead ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5650,6 +5650,14 @@ static bool scx_dsq_move(struct bpf_iter
 	bool in_balance;
 	unsigned long flags;
 
+	/*
+	 * The verifier considers an iterator slot initialized on any
+	 * KF_ITER_NEW return, so a BPF program may legally reach here after
+	 * bpf_iter_scx_dsq_new() failed and left @kit->dsq NULL.
+	 */
+	if (unlikely(!src_dsq))
+		return false;
+
 	if (!scx_kf_allowed_if_unlocked() &&
 	    !scx_kf_allowed(sch, SCX_KF_DISPATCH))
 		return false;



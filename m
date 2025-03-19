Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4842147EE;
	Wed, 19 Mar 2025 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395048; cv=none; b=mPRS7oGgv3EWrYNAY8sJFMzoCqGnetW8aW0oANYooFmFEkoBxskQUEVEMvi34sFFtuWHkssJ8aFiDi/j9xO1SZc1/H01j7+fPnKa+Y8sFqo5vn8uNDES5TPfAGqALWQfuMD2+cVSe7mLeyt7+FRXGykYh346LGiNUfM0QUwRXEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395048; c=relaxed/simple;
	bh=PmyI/16zpOtiZUEZAlD2Z+34lsnWWLRoJmLlEvdIr7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSSBij/7iEuoiQsBUSnEu/Ki5PFj+TxlSI0QjXggUTBwL2nMHzRy3yPcg1rabmQrXqWCKs7GXkhlt1zCLrUy7raNGdVAJSsei2XCMmXzPZFkaPwu+PpKTwPaxGPNybHh2NmEbjtE0cgsIUkR6EjiksTKbtt04PCNUihqigjRtFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QolTRzke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QolTRzke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406ADC4CEE4;
	Wed, 19 Mar 2025 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395048;
	bh=PmyI/16zpOtiZUEZAlD2Z+34lsnWWLRoJmLlEvdIr7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QolTRzkefX4Apqqg/n4S045cbMsDcTFuckTTFv9OsNK7I56kcGaeYJTO/M54YE68O
	 KvR4Jb7AKXDjtVDhg6H8QC9UULZDZcc619/2n8ds4ZWj8WhJEp6ZS1Bo72jyhgX1KR
	 KhE2FrJmC9uuubEWHd6v1dS1EgztpTyHMoCdl9sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Ihor Solodrai <ihor.solodrai@pm.me>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/231] sched_ext: selftests/dsp_local_on: Fix sporadic failures
Date: Wed, 19 Mar 2025 07:29:27 -0700
Message-ID: <20250319143028.660551467@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit e9fe182772dcb2630964724fd93e9c90b68ea0fd ]

dsp_local_on has several incorrect assumptions, one of which is that
p->nr_cpus_allowed always tracks p->cpus_ptr. This is not true when a task
is scheduled out while migration is disabled - p->cpus_ptr is temporarily
overridden to the previous CPU while p->nr_cpus_allowed remains unchanged.

This led to sporadic test faliures when dsp_local_on_dispatch() tries to put
a migration disabled task to a different CPU. Fix it by keeping the previous
CPU when migration is disabled.

There are SCX schedulers that make use of p->nr_cpus_allowed. They should
also implement explicit handling for p->migration_disabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ihor Solodrai <ihor.solodrai@pm.me>
Cc: Andrea Righi <arighi@nvidia.com>
Cc: Changwoo Min <changwoo@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/dsp_local_on.bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c b/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
index c9a2da0575a0f..eea06decb6f59 100644
--- a/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
+++ b/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
@@ -43,7 +43,7 @@ void BPF_STRUCT_OPS(dsp_local_on_dispatch, s32 cpu, struct task_struct *prev)
 	if (!p)
 		return;
 
-	if (p->nr_cpus_allowed == nr_cpus)
+	if (p->nr_cpus_allowed == nr_cpus && !p->migration_disabled)
 		target = bpf_get_prandom_u32() % nr_cpus;
 	else
 		target = scx_bpf_task_cpu(p);
-- 
2.39.5




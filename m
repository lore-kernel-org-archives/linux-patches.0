Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85A1365A19;
	Tue, 12 May 2026 18:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609589; cv=none; b=UOKA/6+ThfINEw5UPfVgb5u8KgAiOkgO9rM4tMlqsXqiqMWZvsMrZMb6viLjEBcuiN37l/qMHWe7wDsFnDgerfsn0AnklpHY5iterI9eONZJxeDkL3Zv5/nNzkuHm1T/8zn2MmmoF5bivbpWFiXihVXtQkmPweI1q/gFvCPQcwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609589; c=relaxed/simple;
	bh=aYjlpVb5eSbxqcs/EQAe0GCAHqdAJzY29siXeq5s4Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLGt9zo0XRmekNuW5EtONdveIRyEzfptr+vBZZGdfqY7mmvAgJxkNv00n4BWB0lREG9Q0Uk5jhpsY08QpdTc+6T1GNGYWa+ocBk7n2kVVOl9W66tSNxDey0/KVrDj2Y7xxmIk7PRMerAaHTeIG9Zdej7KzJDTv024v0W5yA08kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMX/9JeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMX/9JeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500D4C2BCB0;
	Tue, 12 May 2026 18:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609589;
	bh=aYjlpVb5eSbxqcs/EQAe0GCAHqdAJzY29siXeq5s4Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMX/9JeXwLxduUjU0ERossReTEH/qIsGpomFt4XPqvNoidc+YqsD+i/xqdmwBCNfg
	 Qx6l7jEkLgOApNBu3RvW1h4qUsDnZLqrn40n5rc9xSn3CpVVJSL8KJwy6D7vkQyYAj
	 ckRJAGR/32DvqgiNNdOYV+OK8rxF6fNg0Ao522rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 7.0 247/307] sched_ext: Skip tasks with stale task_rq in bypass_lb_cpu()
Date: Tue, 12 May 2026 19:40:42 +0200
Message-ID: <20260512173945.338221208@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit da2d81b4118a74e65d2335e221a38d665902a98c upstream.

bypass_lb_cpu() transfers tasks between per-CPU bypass DSQs without
migrating them - task_cpu() only updates when the donee later consumes the
task via move_remote_task_to_local_dsq(). If the LB timer fires again before
consumption and the new DSQ becomes a donor, @p is still on the previous CPU
and task_rq(@p) != donor_rq. @p can't be moved without its own rq locked.

Skip such tasks.

Fixes: 95d1df610cdc ("sched_ext: Implement load balancer for bypass mode")
Cc: stable@vger.kernel.org # v6.19+
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4008,6 +4008,15 @@ resume:
 		if (cpumask_empty(donee_mask))
 			break;
 
+		/*
+		 * If an earlier pass placed @p on @donor_dsq from a different
+		 * CPU and the donee hasn't consumed it yet, @p is still on the
+		 * previous CPU and task_rq(@p) != @donor_rq. @p can't be moved
+		 * without its rq locked. Skip.
+		 */
+		if (task_rq(p) != donor_rq)
+			continue;
+
 		donee = cpumask_any_and_distribute(donee_mask, p->cpus_ptr);
 		if (donee >= nr_cpu_ids)
 			continue;



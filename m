Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A983CAA39;
	Fri, 15 May 2026 16:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862810; cv=none; b=W74e8i7gv5dW/xjXsQs8YB5/VuSF7zEsKZhcWZ2wp8Q4Zy0ovt8oFDut8tgJwXzJh1hqhw4HI8LA/93YUH8q3pePWbxWkUFcSvJi8L5PbWDToKT/LmXBANIrAVLRwy/iVUat6Z2rfh3OWi2gSsVRqX5aLUlL0e4q85R+fx6TfVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862810; c=relaxed/simple;
	bh=Dnr1hdeQ3nC5WVgVorxw3JaZMk4fR4RHGAKG2wLU7M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckS8D5jxWGygAK7IfX01OfDC/86f5MQLIvE73E6RuEwVo+X4CEbIAvhpfaXM8DVzQ/4bGho1UFgPhh65IVRH2BWnYtlIhpCVb5uophdIgnwkF16p1MM3QVAJ9qpw2KSst8FfQ2szhLxodmdeclg11xiVlkSiUKR9wjYFnWTJ0Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syOUcZqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syOUcZqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060B3C2BCB0;
	Fri, 15 May 2026 16:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862810;
	bh=Dnr1hdeQ3nC5WVgVorxw3JaZMk4fR4RHGAKG2wLU7M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=syOUcZqyYCqZ0dS6T/n76CkDwb1qxBDshDQFM1TvoP3zJShf/OXX/LATrScZWr3R7
	 MejrXkEqx1TfJq+lAY8S4XX7UoMk2WH3K7dHwA568KnUmcf9IrifQ6PShGSGIaDHkg
	 4dtsy7etZFpahxsL4KWH6n8356/OcutPyFqld2dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 7.0 192/201] sched_ext: Skip tasks with stale task_rq in bypass_lb_cpu()
Date: Fri, 15 May 2026 17:50:10 +0200
Message-ID: <20260515154702.740335500@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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
[ arighi: replace donor_rq with rq, not present in v7.0.y ]
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4010,6 +4010,15 @@ resume:
 		if (cpumask_empty(donee_mask))
 			break;
 
+		/*
+		 * If an earlier pass placed @p on @donor_dsq from a different
+		 * CPU and the donee hasn't consumed it yet, @p is still on the
+		 * previous CPU and task_rq(@p) != @rq. @p can't be moved
+		 * without its rq locked. Skip.
+		 */
+		if (task_rq(p) != rq)
+			continue;
+
 		donee = cpumask_any_and_distribute(donee_mask, p->cpus_ptr);
 		if (donee >= nr_cpu_ids)
 			continue;



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774041;
	b=0P/Udgk8NFDX/BkBKwNggwWYY/ezwaRp1MdR9JF4a2uCsBOyD19l7MfvLpk+OUUDatPk
	 QoIL3QfZ5FkwhSUrrBKwSo2CRqcFu/0Wzb75MY6AVtpb/LLPI6GrWkXw+D3gZ6PVHLoTT
	 S9duxsjnMqlzg7cLSGQNWixDdBBZy0Og/8fWntQB5O+fafAtRmecNcFwBMXbBArpoAhaQ
	 pTDYMhy+aiCQ0UynED3GVZqGoh+1uiyue9HRmR7JNZMnTZ1wcXwUDo1vHipkSVqxaCb4N
	 b+gzVsJnoT7YVUqThd6EPRHnFaEbyiw5jSKhtq3W+qe31RJyP7GzoQyhoFDkjRwMu6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tl+0007nuF1O7Sdc66qs0OU7IaKjZjhccfrTjc05XOc=;
	b=TR+oPYVnl/vUBAADO/I3iOClL1qrHMyAKIBkcz7o3A5TzHx90/rkcR103CWRUW3YpAN8
	 FAr6nwEqbZzW+qwe5HF9Ez8WIaRS1Qp4TtMjFB/vMxchYULl9PVWRKLZ8/kN+g9cQM01d
	 h44hrqUiZn/yPw5VTdrwAXSR00ax4zxHjPCMBwSSIZA9ysQu9bU6dpUAjhgNxnquWo0vZ
	 /65/CJs8YxU/FPxN6FgyC0raGqWrBrVvTMjlLtTz0lyhpaqAFrkN4cJfz22/dJSs+2cza
	 H4gjZ+3YXQealnCesfWcLf7GtRD51apGDUztUJGD7pHYwZcnaidWNOi+b1XMaOFMolg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNzL1vbP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B75606A31A;
	Fri, 23 Oct 2026 16:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNzL1vbP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F581F01825;
	Fri, 23 Oct 2026 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774041;
	bh=Tl+0007nuF1O7Sdc66qs0OU7IaKjZjhccfrTjc05XOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNzL1vbPVoZvmW5RvzYfL0LKzrc3zVelwi9+GlBnfIAWksNDBhJI2oQvbTrgpiYDy
	 mPqGKqAefs3FMSGGLVgU6ljCxjKS44fnzfV441VkLe3ln0ZH+HRdF0vuIV8JZ2DM+0
	 c91tiRJ9Kt5eGrgbkshWBgfef2WlI+EwY9ShQxVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Huret <antoine.huret@bull.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 094/193] perf: Update cgroup time when rotating multiplexed events
Date: Fri, 23 Oct 2026 18:36:11 +0200
Message-ID: <20261023163716.428438807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Huret <antoine.huret@bull.com>

commit e4c7c401c6b9174c0c893084fdaa6a84bd2520d7 upstream.

Since commit bd2756811766 ("perf: Rewrite core context handling"),
perf_rotate_context() only updates the context time before scheduling
out the flexible events. It no longer updates the cgroup time, which
ctx_sched_out() used to do.

Cgroup events take their times from the per-cpu cgroup clock, so
between two cgroup switches the rotations see a frozen clock. The
events rotated out lose the running time they accumulated, and the next
update, usually a read, credits the whole interval to the events that
happen to be on the PMU at that moment.

As a result, the time_running of multiplexed cgroup events is wrong,
and so are their scaled counts, as long as no other cgroup runs on the
CPU, e.g. a busy job alone on its CPUs. Counting cycles over one second
of a busy loop in a cgroup gives from half to several times the max
frequency of the CPU.

Update the cgroup time before rotating the CPU context, as was done
before the rewrite.

Fixes: bd2756811766 ("perf: Rewrite core context handling")
Closes: https://lore.kernel.org/r/PR3PR07MB69223331EED5BEBE150375B7849C2@PR3PR07MB6922.eurprd07.prod.outlook.com/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Antoine Huret <antoine.huret@bull.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261015-perf-cgroup-rotation-time-v1-1-93e177dfee5d@bull.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4496,6 +4496,7 @@ static bool perf_rotate_context(struct p
 
 	if (cpu_event) {
 		update_context_time(&cpuctx->ctx);
+		update_cgrp_time_from_cpuctx(cpuctx, false);
 		__pmu_ctx_sched_out(cpu_epc, EVENT_FLEXIBLE);
 		rotate_ctx(&cpuctx->ctx, cpu_event);
 		__pmu_ctx_sched_in(cpu_epc, EVENT_FLEXIBLE);



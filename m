Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210165;
	b=u0ZoM/WwMujdL+gP6xmVQ9QSyYnnIdGrFe/b+Du5wp0j8f6PVCBV9IXNKoAOwPWS2BpQ
	 gcVGzP3J4IuMfzGR5CZ/zwKOoqb19oMCgQF7ukgdAQG84m04P8tmR3KSZAe3l3XDRpmmo
	 r5/5TnsODREZ2c2CtT8smUEVa5/SiboP/p9u/IRLsu7vHpx61WLCPnvuw6cRZaDERLgx6
	 SE4rhHG7PzafOY7/fy1gs4iCAmNC5UpnyVwXz2DDc38Rp3eXL9xA+yMI1GTcnEjpHsvqf
	 xioPGot2cW7IS85+zed8pKnomhog0HDMfYqKGLCHDSmRxlyDzkJWJH//R5Dg150yGUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=99iz1FwOYKtLcJk7CpFMg8ze42/inb8JyXEGV2N9gEo=;
	b=Uhh1ytD51bopAE12nj+u2v8U97OwN2Jf1Q2iWfSqJgtB9VhyMiTRGguqXyW17HmqWkWo
	 tq+B0Yhjz6CAutdFlclWdbWJNSqK55uKLt99BcMtcNpeoQKFZf0dmbq8eqDmv1K9gVXrS
	 Uq86msQ47aPAS7QNIft1mTVMjwJxs+LADEkAPLovBksqAs4C4aX5wry2mjyTzVHVDTJO4
	 bldB7xWExEn+VzO/bl57jAWmMDZ1EXZJpMQ28X2VOdfbgCXTgl4giGKPK56mLzO9d41Zj
	 17NM+04CoS0nxbjAFrxdO7raIgwk8PdlIAZA8105ql6HXnpDAskLGE7ZpIbT6yhWYPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhNsOBpX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F0C606A33A;
	Wed, 28 Oct 2026 17:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhNsOBpX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C0B1F031E4;
	Wed, 28 Oct 2026 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210164;
	bh=99iz1FwOYKtLcJk7CpFMg8ze42/inb8JyXEGV2N9gEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhNsOBpXr3E2W+fsGGklts829FOPs49yuL1A3YBQYFSK8vnXeXyQrAiHJsJfdwsMO
	 1Ix70Wq0WPx3MjGY0QsFHMg10wKbpJ/Tomyx3eti+651Vc9qn1SI8LhC0nwtf5jZlA
	 zf0yNKJTHJVv6mtVNdJ4yEYvtQ37uaWqVNPEu028=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Huret <antoine.huret@bull.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 053/168] perf: Update cgroup time when rotating multiplexed events
Date: Wed, 28 Oct 2026 17:59:49 +0100
Message-ID: <20261028165944.344926621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4363,6 +4363,7 @@ static bool perf_rotate_context(struct p
 
 	if (cpu_event) {
 		update_context_time(&cpuctx->ctx);
+		update_cgrp_time_from_cpuctx(cpuctx, false);
 		__pmu_ctx_sched_out(cpu_epc, EVENT_FLEXIBLE);
 		rotate_ctx(&cpuctx->ctx, cpu_event);
 		__pmu_ctx_sched_in(&cpuctx->ctx, pmu);



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207619;
	b=Wdst7ktJabR+ewHS4/aT6/tTTvNM1WG7BmjN7Grn1e8gg5f1X+5CMZgSYxhHO1keHH/8
	 s8rEh3J/cMMDI8tf7mtFfWcLsr0xHxLj+xcnJsSE1tcZ9kC3GZ+MWKOAPXWBten5oaRRN
	 T4rsFD35P/IA7yyDBWwcKBcimLlEac6G127TJEU+8sMtihmK8dHbxAsbgDmeEzxgsLq6i
	 oBu1gN6TzVRlwyu7Wq1RhDx7l1jzML7shuAFunxTXo8qNnAPAPDw/CWWJdIsC3vz8bf07
	 nQVOKLY8rU4klkAgjFTDR4XUAyMSHXl7ZYRxujUyJHfFkwUDan994Ke6IwRw/4qB4jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jqkdp757z0Rt4zbV0OaOLyDDmMwwKVGbMxTdLavxY1s=;
	b=iDpBN2uLyId5nRZcCvU2uw2ggKplPJymmC20l5ujSkKdEUvD9oqEHDfkQilSEys6lbWz
	 T/8Z1cfHH8Mr1OvXngJo70bE4nfXSy3xlCkI7FzgqPGHmT9G6Hh50tQUam6rvC+/Diw+e
	 Lx2tDZUHB7hRco54zn0ODViPhVicMo18jl0K8IarRQPAfTbzUEUxxjBb1ZhguEOZXQ4YI
	 jYJpNhImt+nRvpmJKmWJZJ8cL5UqV1JiA5CHc81WLOR320o+p4czdn+RrU3lmnanF1EO9
	 tsE61xcYobffhD5mrl5n3/RiGgRZP79fC5KubDju1AiFMi0w8McRjFdqbeicXuJKDiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8fw+KZ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648F0606A31C;
	Wed, 28 Oct 2026 17:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8fw+KZ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B425A1F01825;
	Wed, 28 Oct 2026 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207619;
	bh=Jqkdp757z0Rt4zbV0OaOLyDDmMwwKVGbMxTdLavxY1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8fw+KZ0JMO8XgJvaQlo704KzwdNQO/hURzpbsEcpDvnnNgwoWrQNoUbfQja2VASP
	 FvCDym+kOFzPDZviqksQcGuw/Eq3qxYPvQyR37ervCbofhn4Llv/RzGxok7ej4GzTp
	 nygmGmseUoMfPrSBCvosv7xSewEC6ONJHQQQ0Kso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Huret <antoine.huret@bull.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 078/247] perf: Update cgroup time when rotating multiplexed events
Date: Wed, 28 Oct 2026 17:58:01 +0100
Message-ID: <20261028165949.240402077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4451,6 +4451,7 @@ static bool perf_rotate_context(struct p
 
 	if (cpu_event) {
 		update_context_time(&cpuctx->ctx);
+		update_cgrp_time_from_cpuctx(cpuctx, false);
 		__pmu_ctx_sched_out(cpu_epc, EVENT_FLEXIBLE);
 		rotate_ctx(&cpuctx->ctx, cpu_event);
 		__pmu_ctx_sched_in(cpu_epc, EVENT_FLEXIBLE);



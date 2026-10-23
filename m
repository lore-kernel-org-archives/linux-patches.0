Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774730;
	b=G5xoxivu4w4pk8VLp/dcUaJq48hIuqmR3BXGdJPkedaJkPSd2T9A8Op0p0gl/FA8xELv
	 4FMRkO5+oR5r0qPIy78Tc0IGE3Ro+KZoPpMoXBQm7F8K+6OhTE7DNB68v+LmV4t4ze2qf
	 WNRf+zALfm0zcbEFM4jjj4b7BfNstzvC1tQw+/R9xsgvV7sPTpjgkud3AqE6IMVlr9C/l
	 W36KX53f3ebrlsuRzorxxTSmUIBXT8Hc+amqw5FDi0EuiJe/JoT2k6CBMqdamkQJHLuSA
	 TP+jwDl8kc4qgWdIhqlctqNhYUG6fQdg9oYjnbvDsj6odAioixUAa5A7vX27hohpYEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7PlDDh9Ooxrv+Kkfk2Q/+Ve7MAFoNG28CGnRC5BR7xw=;
	b=uIF09vEV7BU9rkr+QDgoRVy1T95flIRzU6ilgF2GUxKiwS/+hM84pZMvC8hJA9Vef+PM
	 owg3d9HE1f2Psv7hWAIib+8ij611pKhP4PXvuQc3AiY64/wit7gCqh9MspQKdwcaqtHf3
	 9pQKfp1rLl2XRiF1Gzn4qbTVLeNZy9wuqb0TSTbgSfQFX5VNmt08+hbakcmdfYnHIOiQh
	 n5LjrhC4chUfyioZVIia4kuUtQOonVr6KL+H9/IrkNqpc1lbhp/PnVfpDsaXrZVI9Fp6G
	 SRXo/jxPtB0Xn9SWWgL/lbdIWkdKR5y/Uagk3ZASHfg8PFddGQ1WpBgwlhDKmXHwvNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcMyd4Rl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2117606A31A;
	Fri, 23 Oct 2026 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcMyd4Rl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D9D1F01825;
	Fri, 23 Oct 2026 16:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774730;
	bh=7PlDDh9Ooxrv+Kkfk2Q/+Ve7MAFoNG28CGnRC5BR7xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcMyd4RlJHXIHt2NjX2vGKaPOc4OMujT17HKMJVQVEY+tCyXT0i7irmAj8zbFKWFZ
	 +y+JFdheBHEehda23uIzDW0OFLJhXjooJrge4C9Ziiaic+1SOEK/ZVQL2g3BbhnPld
	 4yCjC/S7CSN5whZBANaD7L24MP5/iQjMGfVpCCiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Huret <antoine.huret@bull.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.2 140/242] perf: Update cgroup time when rotating multiplexed events
Date: Fri, 23 Oct 2026 18:39:42 +0200
Message-ID: <20261023163717.090745188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4639,6 +4639,7 @@ static bool perf_rotate_context(struct p
 
 	if (cpu_event) {
 		update_context_time(&cpuctx->ctx);
+		update_cgrp_time_from_cpuctx(cpuctx, false);
 		__pmu_ctx_sched_out(cpu_epc, EVENT_FLEXIBLE);
 		rotate_ctx(&cpuctx->ctx, cpu_event);
 		__pmu_ctx_sched_in(cpu_epc, EVENT_FLEXIBLE);



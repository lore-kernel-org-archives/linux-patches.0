Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625646;
	b=GS1aRXDCegHUJJIzfE1M3UYQdWKue5/vbUN/aUlynf1cDKMnPW7CxutgDNv7TAcsjEIb
	 hroLWVCEOTrSc/mBX9sH5NWyLjA/fUd70TUwTJH6JS+1QeCKv/zK86N0US50amb2576Yg
	 xBXoQQseTRjccT+Mi/ZVnEYwtEkIDHGEEAFxhjbmLQbPbQ0k8FJh70wbdRDVMVXvzipuT
	 uYg0jUX3S/z7OEu0op0T9OwL3BdrAwcssmQ4eRwE4G90S4d05UDJM7PvedaCS0YK8zhvv
	 6AK8/JFD93JOqi6uhqY4autTbq72zMxBIc91ScN/aIJEz/KwGR77qngJ5CJazruDJMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yyZAtjeum6NBn4h/vPBEX4sy8ews3CXj6Ae8uFIAwac=;
	b=sFCDdc2UeRGNs51cNGyO5LryQD6DbHmZvy9OSNhie5y7Lh/Hsi5GK3b1VfymKg8kBR3q
	 kbG80vSDtr4Me9JyJbp5dG/OGe+j7vQgzLW9awvC+WNTc4vN9UZ/NYFwLre71HKD/TnRx
	 UIdZNLCYLIqOyJBFHRfHqz6d31EH26jfKxsR8k71oxeAp1ODH9a7eDwidd1OHY9WbAzy3
	 FToHu7FQTk+hufyjX5zZKoeP5e7TsDBjyGYmxJAOzCQXPl/wGV/Y8v6G0wUEAi93dCwba
	 I/nmd95BzMD7XMnzO2EUWY9HXN2tD4/NbRt3jCwvJJE/XApozVy2RFpd1raY6tJS04A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iycuASVx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409A5606A31E;
	Wed, 25 Nov 2026 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iycuASVx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915581F000C4;
	Wed, 25 Nov 2026 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625646;
	bh=yyZAtjeum6NBn4h/vPBEX4sy8ews3CXj6Ae8uFIAwac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iycuASVx1KVfeGlP4UZwsYyQZUMDGiLiK3b9EHa+Ya8NI4DRPQmPx3kzup2NpoJIA
	 cUvwHFPqLFqkEySBcQo4mFiquYi/5VnbfRBMo7Qsay6FEaAP/QTo+NyRZ8w8aGm6jh
	 K98mmK7gdObshFLPr+IHNELbXSHIsTN24Ra5Mj/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH 6.12 585/816] tsacct: Keep task begin times stable across suspend
Date: Wed, 25 Nov 2026 15:35:33 +0100
Message-ID: <20261125143902.719081684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

commit c49b3c20a2d0b22700e2100a527e68e829ece7f0 upstream.

bacct_add_tsk() derives ac_btime and ac_btime64 by subtracting a
CLOCK_MONOTONIC elapsed duration from CLOCK_REALTIME. MONOTONIC stops
during suspend while REALTIME continues, so querying an existing task
after resume moves its reported begin time forward by the time spent
suspended.

Calculate the begin time from the wall-clock boot timestamp and the
task's CLOCK_BOOTTIME start timestamp instead. This accounts for suspend
and adds the nanoseconds before truncating to seconds. Keep ac_etime and
ac_tgetime on CLOCK_MONOTONIC and retain the existing rebasing when the
wall clock is adjusted.

The new begin time can be negative: setting CLOCK_REALTIME is bounded
by CLOCK_MONOTONIC, which excludes suspend, rather than CLOCK_BOOTTIME.
A permitted backward clock adjustment after suspend can therefore put
the task's begin time before the epoch. Clamp ac_btime64 at zero too,
instead of wrapping in the unsigned field, and retain its positive range.

Fixes: f3cef7a99469 ("[PATCH] csa: basic accounting over taskstats")
Reported-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20130611200600.GA15168@redhat.com
Link: https://lore.kernel.org/r/alpine.DEB.2.21.1911071335320.4256@nanos.tec.linutronix.de
Link: https://patch.msgid.link/20261030054227.35453-3-dennylin0707@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/tsacct.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -24,7 +24,7 @@ void bacct_add_tsk(struct user_namespace
 	const struct cred *tcred;
 	u64 utime, stime, utimescaled, stimescaled;
 	u64 now_ns, delta;
-	time64_t btime;
+	struct timespec64 btime;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
@@ -39,9 +39,11 @@ void bacct_add_tsk(struct user_namespace
 	do_div(delta, NSEC_PER_USEC);
 	stats->ac_etime = delta;
 	/* Convert to seconds for btime (note y2106 limit) */
-	btime = ktime_get_real_seconds() - div_u64(delta, USEC_PER_SEC);
-	stats->ac_btime = clamp_t(time64_t, btime, 0, U32_MAX);
-	stats->ac_btime64 = btime;
+	getboottime64(&btime);
+	btime = timespec64_add(btime, ns_to_timespec64(tsk->start_boottime));
+	stats->ac_btime = clamp_t(time64_t, btime.tv_sec, 0, U32_MAX);
+	/* Setting the clock back after suspend can make btime negative. */
+	stats->ac_btime64 = max_t(time64_t, btime.tv_sec, 0);
 
 	if (tsk->flags & PF_EXITING)
 		stats->ac_exitcode = tsk->exit_code;



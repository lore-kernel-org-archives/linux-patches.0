Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3603C18025
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mI0PBukm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7A6C433C8;
	Mon, 23 Oct 2023 11:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061540;
	bh=4/bd8zIyusHzJSfyySzgWSnjsv+KAc3LXedFKl1y3Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mI0PBukmjFpErUhgcURRxKT0GDKm41cBvA8deiqsx74amcfJwqdd53MGJI6kLvwIN
	 C3Iw00TdYxcVjL0MguLPGuGMo8bgMDSI/t8HXIfWKs4NMO6idCbE10nVHcSsvFfecS
	 sEIfqQ8pBoJkWPmVUgYG9JJjqWRCArUdpL7EdMhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mel Gorman <mgorman@techsingularity.net>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ben Segall <bsegall@google.com>,
	Christoph Lameter <cl@linux.com>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Pekka Enberg <penberg@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Shakeel Butt <shakeelb@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 5.10 082/202] lib/Kconfig.debug: do not enable DEBUG_PREEMPT by default
Date: Mon, 23 Oct 2023 12:56:29 +0200
Message-ID: <20231023104828.939961475@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyeonggon Yoo <42.hyeyoo@gmail.com>

commit cc6003916ed46d7a67d91ee32de0f9138047d55f upstream.

In workloads where this_cpu operations are frequently performed,
enabling DEBUG_PREEMPT may result in significant increase in
runtime overhead due to frequent invocation of
__this_cpu_preempt_check() function.

This can be demonstrated through benchmarks such as hackbench where this
configuration results in a 10% reduction in performance, primarily due to
the added overhead within memcg charging path.

Therefore, do not to enable DEBUG_PREEMPT by default and make users aware
of its potential impact on performance in some workloads.

hackbench-process-sockets
		      debug_preempt	 no_debug_preempt
Amean     1       0.4743 (   0.00%)      0.4295 *   9.45%*
Amean     4       1.4191 (   0.00%)      1.2650 *  10.86%*
Amean     7       2.2677 (   0.00%)      2.0094 *  11.39%*
Amean     12      3.6821 (   0.00%)      3.2115 *  12.78%*
Amean     21      6.6752 (   0.00%)      5.7956 *  13.18%*
Amean     30      9.6646 (   0.00%)      8.5197 *  11.85%*
Amean     48     15.3363 (   0.00%)     13.5559 *  11.61%*
Amean     79     24.8603 (   0.00%)     22.0597 *  11.27%*
Amean     96     30.1240 (   0.00%)     26.8073 *  11.01%*

Link: https://lkml.kernel.org/r/20230121033942.350387-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ben Segall <bsegall@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1136,13 +1136,16 @@ config DEBUG_TIMEKEEPING
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPTION && TRACE_IRQFLAGS_SUPPORT
-	default y
 	help
 	  If you say Y here then the kernel will use a debug variant of the
 	  commonly used smp_processor_id() function and will print warnings
 	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
 	  will detect preemption count underflows.
 
+	  This option has potential to introduce high runtime overhead,
+	  depending on workload as it triggers debugging routines for each
+	  this_cpu operation. It should only be used for debugging purposes.
+
 menu "Lock Debugging (spinlocks, mutexes, etc...)"
 
 config LOCK_DEBUGGING_SUPPORT



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99D917744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2453BC433C7;
	Wed,  9 Aug 2023 11:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580622;
	bh=QlD4ZVRHPa71SG9RMGMvA3qKKliPG7mC2S7EWHyUOUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgfdLUBX8Lp5v6w9a5ZsG2g51ZHSzHgZwFMyhR+us6mN7kyxlz48kl5yNoX3kL0Ok
	 y51R+uE/clKDM+X284AvknBzSOvlIp09K52VlhlegiNipDE2lLcJRXGGWLf8QAHhHn
	 XUdvgdo40sLnIgXWUAlz5hE9CLNfSguuEfdqE4VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Cixi Geng <cixi.geng1@unisoc.com>
Subject: [PATCH 5.4 091/154] perf: Fix function pointer case
Date: Wed,  9 Aug 2023 12:42:02 +0200
Message-ID: <20230809103639.999359004@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

commit 1af6239d1d3e61d33fd2f0ba53d3d1a67cc50574 upstream.

With the advent of CFI it is no longer acceptible to cast function
pointers.

The robot complains thusly:

  kernel-events-core.c:warning:cast-from-int-(-)(struct-perf_cpu_pmu_context-)-to-remote_function_f-(aka-int-(-)(void-)-)-converts-to-incompatible-function-type

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Cixi Geng <cixi.geng1@unisoc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1134,6 +1134,11 @@ static int perf_mux_hrtimer_restart(stru
 	return 0;
 }
 
+static int perf_mux_hrtimer_restart_ipi(void *arg)
+{
+	return perf_mux_hrtimer_restart(arg);
+}
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -9997,8 +10002,7 @@ perf_event_mux_interval_ms_store(struct
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
 
-		cpu_function_call(cpu,
-			(remote_function_f)perf_mux_hrtimer_restart, cpuctx);
+		cpu_function_call(cpu, perf_mux_hrtimer_restart_ipi, cpuctx);
 	}
 	cpus_read_unlock();
 	mutex_unlock(&mux_interval_mutex);



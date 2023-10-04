Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AD71C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qa/nCHwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79ABC433C9;
	Wed,  4 Oct 2023 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444521;
	bh=2yPcKuFpPwq5SchytPF/Wz9Go03K8XHZ2f8A2Z07TEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qa/nCHwvqQmTBEmWmv1lRpZqXe6+K0XlK/7IW1IfEYpe3zjLP2LsP7DFVOwQ43Ey1
	 1O8Bp5aTHivk5cZs+CeM/54QuzeMMuutScYmdGwRQ6hOGen/+tuzPLANUWwdfhfFbg
	 Tl7o5P5y0tQ4InpDJYS75gWWEywuEHJTOfnpsdkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 6.5 272/321] sched/rt: Fix live lock between select_fallback_rq() and RT push
Date: Wed,  4 Oct 2023 19:56:57 +0200
Message-ID: <20231004175241.885389061@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Fernandes (Google) <joel@joelfernandes.org>

commit fc09027786c900368de98d03d40af058bcb01ad9 upstream.

During RCU-boost testing with the TREE03 rcutorture config, I found that
after a few hours, the machine locks up.

On tracing, I found that there is a live lock happening between 2 CPUs.
One CPU has an RT task running, while another CPU is being offlined
which also has an RT task running.  During this offlining, all threads
are migrated. The migration thread is repeatedly scheduled to migrate
actively running tasks on the CPU being offlined. This results in a live
lock because select_fallback_rq() keeps picking the CPU that an RT task
is already running on only to get pushed back to the CPU being offlined.

It is anyway pointless to pick CPUs for pushing tasks to if they are
being offlined only to get migrated away to somewhere else. This could
also add unwanted latency to this task.

Fix these issues by not selecting CPUs in RT if they are not 'active'
for scheduling, using the cpu_active_mask. Other parts in core.c already
use cpu_active_mask to prevent tasks from being put on CPUs going
offline.

With this fix I ran the tests for days and could not reproduce the
hang. Without the patch, I hit it in a few hours.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230923011409.3522762-1-joel@joelfernandes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpupri.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -101,6 +101,7 @@ static inline int __cpupri_find(struct c
 
 	if (lowest_mask) {
 		cpumask_and(lowest_mask, &p->cpus_mask, vec->mask);
+		cpumask_and(lowest_mask, lowest_mask, cpu_active_mask);
 
 		/*
 		 * We have to ensure that we have at least one bit



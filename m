Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AE57BB0C;
	Wed, 21 Feb 2024 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524041; cv=none; b=DVsUfuqX2i3Osn1VXneHHYs7KEinyvr0qi+mWcp00VOZjB9r+soiuaJOzw12Ff2Upe1dJraUhtNLg+LDdGu2LN3YByAYrvO6m7WqXf1IM4t95ppqWeM5wSzqJdz+8qbrI371TfxSlJnqTT7u0+ROi/oEpwSCsupJ1Y1VTDTTPQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524041; c=relaxed/simple;
	bh=drGzIVzvdwIiclk7pPb5v4Nikgpei+95BX1gjXDQx/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGOlY5UMOOJ8jZI0zTjwUkALP3j3knBJjthWSgvGQSaLnTXPCTPucMupVgJtFOjGKupF49XZ4a4wxup4++YlFC4Q36fEJkm5TBjyyTli0Ndhb68y8Ch7hfsA8kuPnf5VeORAxA3rOcLMEyZ58MWv/hO6aNf/Fi3Z54qVLbxrpMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrlqE7jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrlqE7jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70A1C433C7;
	Wed, 21 Feb 2024 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524041;
	bh=drGzIVzvdwIiclk7pPb5v4Nikgpei+95BX1gjXDQx/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrlqE7jzIDCy+xOH6aNvJki7eUV2kJahffjEc4AujrFER2FuIQwJJh/dyaWrc4U5q
	 HWAnmVoXsnHQgtfg0ZObSABwcMm7mIG6dyCfxGqVhPPVPdK16uo8b2lr6P+gD0W8Y7
	 77udz8UkmucRjNKGclOS/7j3QCuiiUfkThWegVW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 099/379] tick/sched: Preserve number of idle sleeps across CPU hotplug events
Date: Wed, 21 Feb 2024 14:04:38 +0100
Message-ID: <20240221125957.851305759@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Tim Chen <tim.c.chen@linux.intel.com>

commit 9a574ea9069be30b835a3da772c039993c43369b upstream.

Commit 71fee48f ("tick-sched: Fix idle and iowait sleeptime accounting vs
CPU hotplug") preserved total idle sleep time and iowait sleeptime across
CPU hotplug events.

Similar reasoning applies to the number of idle calls and idle sleeps to
get the proper average of sleep time per idle invocation.

Preserve those fields too.

Fixes: 71fee48f ("tick-sched: Fix idle and iowait sleeptime accounting vs CPU hotplug")
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240122233534.3094238-1-tim.c.chen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/tick-sched.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1440,6 +1440,7 @@ void tick_cancel_sched_timer(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t idle_sleeptime, iowait_sleeptime;
+	unsigned long idle_calls, idle_sleeps;
 
 # ifdef CONFIG_HIGH_RES_TIMERS
 	if (ts->sched_timer.base)
@@ -1448,9 +1449,13 @@ void tick_cancel_sched_timer(int cpu)
 
 	idle_sleeptime = ts->idle_sleeptime;
 	iowait_sleeptime = ts->iowait_sleeptime;
+	idle_calls = ts->idle_calls;
+	idle_sleeps = ts->idle_sleeps;
 	memset(ts, 0, sizeof(*ts));
 	ts->idle_sleeptime = idle_sleeptime;
 	ts->iowait_sleeptime = iowait_sleeptime;
+	ts->idle_calls = idle_calls;
+	ts->idle_sleeps = idle_sleeps;
 }
 #endif
 



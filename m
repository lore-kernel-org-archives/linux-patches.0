Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9451A3BB6;
	Thu, 15 Aug 2024 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732867; cv=none; b=eav9WkFFci8wcvSIgF0XG5e5v6s56Q9G56cvANcyWb2rV7GnzS6g6tW43UrwSCazoIGmcEQGBOT8zOebrh/RDFyP0GluVT6D939Lb4NI1296v6sUat8AgyBziYq1qPSlL3kePmVSmnNwskdje3+35ZHxzPD9Ied9Maz75uNPwOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732867; c=relaxed/simple;
	bh=ygTw6H3NfQwanyqGWDJ+QIl1vmmYZkjmaI3vQZRY0RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAxHT8lOh/p7xCrw0tybZcshp71Ci9kb9rnDReomw3B9h6i1NVv83aOOlyCuYbXFf0Exre/kNfCYeS+m86Y0NVgS6ALTnk7XjWf/6k+G76XkP+uiWJEeTHxVQ4llDK8/vdQulP0xpSp9WNzOmFTzEvnH2DbF39pPjZpPWxRAvS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOpYVXRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOpYVXRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF38C4AF16;
	Thu, 15 Aug 2024 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732867;
	bh=ygTw6H3NfQwanyqGWDJ+QIl1vmmYZkjmaI3vQZRY0RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOpYVXRO0JcHNdJV1Lr0dyaLynrk0c5iXp3g+5O3IwiS5BYrcfJoK1tQq6B8uDlEq
	 QPGytJozMTIO7RGV+fq8ohomjoo2fxPU5Ujy7sjz9+VKmhK5lhSySI+8oYlz3b4Ald
	 WRkKDkveORoKHFrZsFGFGm4KbKgPRxuEcLD/GArg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yu Liao <liaoyu15@huawei.com>
Subject: [PATCH 5.10 310/352] tick/broadcast: Move per CPU pointer access into the atomic section
Date: Thu, 15 Aug 2024 15:26:16 +0200
Message-ID: <20240815131931.439336797@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 6881e75237a84093d0986f56223db3724619f26e upstream.

The recent fix for making the take over of the broadcast timer more
reliable retrieves a per CPU pointer in preemptible context.

This went unnoticed as compilers hoist the access into the non-preemptible
region where the pointer is actually used. But of course it's valid that
the compiler keeps it at the place where the code puts it which rightfully
triggers:

  BUG: using smp_processor_id() in preemptible [00000000] code:
       caller is hotplug_cpu__broadcast_tick_pull+0x1c/0xc0

Move it to the actual usage site which is in a non-preemptible region.

Fixes: f7d43dd206e7 ("tick/broadcast: Make takeover of broadcast hrtimer reliable")
Reported-by: David Wang <00107082@163.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Yu Liao <liaoyu15@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/87ttg56ers.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/tick-broadcast.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -944,7 +944,6 @@ void tick_broadcast_switch_to_oneshot(vo
 #ifdef CONFIG_HOTPLUG_CPU
 void hotplug_cpu__broadcast_tick_pull(int deadcpu)
 {
-	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *bc;
 	unsigned long flags;
 
@@ -970,6 +969,8 @@ void hotplug_cpu__broadcast_tick_pull(in
 		 * device to avoid the starvation.
 		 */
 		if (tick_check_broadcast_expired()) {
+			struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
+
 			cpumask_clear_cpu(smp_processor_id(), tick_broadcast_force_mask);
 			tick_program_event(td->evtdev->next_event, 1);
 		}



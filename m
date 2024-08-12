Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9671183CA6;
	Mon, 12 Aug 2024 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478992; cv=none; b=O7vOtxoQsRWgqkpIsY+ZviRoxxRrVNtrOByKtiI9wF/fogzZltynh/oQeCIz9waiCiBNWjx+iE6WHX3rRwmL6nOMOm3u/W5zrUx9OPxYfsUzcjFTV++Q5jlN2HxW058istJVwZc8wDHF/m9lrTC6RU+5ij8c9uDIE+a893yTya0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478992; c=relaxed/simple;
	bh=Nkk6IzKyDnt7qpCRLYKtfsDNXq/euEUXLvUVXpusFZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GekOA/bwoX54/4Or3ljWL8DwoaKscHaf9wZ4GyNlM0CCSZYFcEE9TtTaHo7YOsIhBKj0ffaYZ9thQ5RS81QC0iGJl/8yqZY4YgOe5z5TQSDcZKA4gu3YAtl+42Hvo9g9Y1K7LqfCRq6xCJ4AYKsotKzCjGjVlRrAdk1Prv24Les=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuFqfuB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuFqfuB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC63C32782;
	Mon, 12 Aug 2024 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478992;
	bh=Nkk6IzKyDnt7qpCRLYKtfsDNXq/euEUXLvUVXpusFZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuFqfuB05dJXETfN1AtIEnXAKWIWUUYee8XvqjlhN7YqSTm6yezUZTMIOV70jX/hP
	 60UbsL1KnnqMUqCW2ZXETFGCG8vJ/BtFGTjpvLDqiSZ392ClBP7EpIwM6FHEX0X4cv
	 T01gFihJMrkr2l6NecC3LAhpiPiqukQSCOSRqdhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yu Liao <liaoyu15@huawei.com>
Subject: [PATCH 6.1 100/150] tick/broadcast: Move per CPU pointer access into the atomic section
Date: Mon, 12 Aug 2024 18:03:01 +0200
Message-ID: <20240812160129.020325551@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1137,7 +1137,6 @@ void tick_broadcast_switch_to_oneshot(vo
 #ifdef CONFIG_HOTPLUG_CPU
 void hotplug_cpu__broadcast_tick_pull(int deadcpu)
 {
-	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *bc;
 	unsigned long flags;
 
@@ -1163,6 +1162,8 @@ void hotplug_cpu__broadcast_tick_pull(in
 		 * device to avoid the starvation.
 		 */
 		if (tick_check_broadcast_expired()) {
+			struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
+
 			cpumask_clear_cpu(smp_processor_id(), tick_broadcast_force_mask);
 			tick_program_event(td->evtdev->next_event, 1);
 		}



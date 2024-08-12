Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E433D18454D;
	Mon, 12 Aug 2024 16:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479569; cv=none; b=dEMA8hsmVEDImOQXf4I90einytOl8a1gVMulRCu4C4nuvnzgHV80tTilzY0HsiSZxxQD6PJpnwwUTjLYRolyct7emd7BWos14QoHGmNEerT4HiuEVSlKD9Dn6PyaeaF9mvXiWMBNZ3rUivF7DG43N2wvfL7KcH0RXTADGwzdRPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479569; c=relaxed/simple;
	bh=0JWOFf7W9PNUozfDMP3WYuOZY+6ynzPowl9GcHKKkVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBXJ2PfCvEz+t2pUzwMBGQDL+njjiA3adVA3TaQHDB8ipsvsJ0JfzWXXVY1hbYLauDViRKYYlOZLXF8+dVTJkupsc8ndOorWF9KHI1M4pWcDXsNvxYCfXAYzaAoWKs1cv4T8FZpdRW3J98y9OHzhmdACf7Q8+hF82/V1ccD7TNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgFTyltu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgFTyltu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500C4C32782;
	Mon, 12 Aug 2024 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479568;
	bh=0JWOFf7W9PNUozfDMP3WYuOZY+6ynzPowl9GcHKKkVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgFTyltuE8CFmHRkGjZa0VX3TW/plxlJ5m4+yFZ4bUAhie+ymqndKpDvJdgVI5nQa
	 SvgEAjiSxiwMnM7ANvfnVWJTLppYZpb8aB2GJe1aWs2UeUCNqY3LZwPJQwEc4ZABy5
	 t2IQWOyqm9y3k4HQ8+N1gmpkT65EjMjzSR2G0xIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yu Liao <liaoyu15@huawei.com>
Subject: [PATCH 6.6 126/189] tick/broadcast: Move per CPU pointer access into the atomic section
Date: Mon, 12 Aug 2024 18:03:02 +0200
Message-ID: <20240812160136.995963125@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1141,7 +1141,6 @@ void tick_broadcast_switch_to_oneshot(vo
 #ifdef CONFIG_HOTPLUG_CPU
 void hotplug_cpu__broadcast_tick_pull(int deadcpu)
 {
-	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *bc;
 	unsigned long flags;
 
@@ -1167,6 +1166,8 @@ void hotplug_cpu__broadcast_tick_pull(in
 		 * device to avoid the starvation.
 		 */
 		if (tick_check_broadcast_expired()) {
+			struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
+
 			cpumask_clear_cpu(smp_processor_id(), tick_broadcast_force_mask);
 			tick_program_event(td->evtdev->next_event, 1);
 		}



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52423C9893;
	Fri,  9 Oct 2026 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556518; cv=none; b=rriEfgT5LmskDM/7Wz/z6Sr71vcPjJydE3EiB4mP6rbyV9ulTQ7M7EAvBUqRPo8NYB7dI5pSe1GYV2g9zT+WLLP+gNLPhU6QsgiFwDSjoERTn65poERhRaYudPVHSbB0E+jaELVRLh77si2Av57egyrD23m3r8WTb7AzpWSwITA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556518; c=relaxed/simple;
	bh=COpVtPhYbE7I+lKHiPq/gUXVW4DbBMMk6xhlhz3/Qig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWprRkKYDg+DraTAtpOCEM/N8GPd6qxBm8POEVlEn93z7PfisP+6hIfMsqT+3E7XCii+Ggma47PM3O3F4JkJ4cV8MrRExuLbSOE9EPy3FhQ4fV31TDrzY71R+vQnQpm07mic3m1MA2Y9Lsuz2PrN7kxi81gaXUq3QFP1IAU0qVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFqnFJPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFqnFJPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6641F00899;
	Fri,  9 Oct 2026 14:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556516;
	bh=63aXOIWbew1VH1RXvuaI6DpzlBFovLwjSlSk6QGTClM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFqnFJPMtrG9Z7F3WLtR85W/I/6YjEuPnKM4EhroZK8gd9oOBeMH4rK4QgMSfjpUU
	 NeHWxDZWxnGM9K4riSS5f09r4CG90GjJvXMBTLFGlI0WafOSt6XRrFtdx+TMIRAP1J
	 qqAuK2NFbZuA/15l+wSwwq536kReOo85BLR95h+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.2 194/428] hrtimer: Use the mask to clear TIF_HRTIMER_REARM from the exit work
Date: Fri,  9 Oct 2026 16:08:51 +0200
Message-ID: <20261009140950.401790518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 28fa9af353bed2bb738c46e31f9b7d0347b759d1 upstream.

hrtimer_rearm_deferred_user_irq() removes the rearm bit from the local
copy of the TIF work with:

	*tif_work &= ~TIF_HRTIMER_REARM;

TIF_HRTIMER_REARM is the bit number (12), not the mask. That clears
TIF_NOTIFY_SIGNAL (bit 2) and TIF_MEMDIE (bit 3) from the copy and
leaves bit 12 set.

So the function never returns true, and the copy handed to
exit_to_user_mode_loop() lacks TIF_NOTIFY_SIGNAL. If that was the only
work for the loop, the task returns to user space with the task work
still pending. hrtimer_interrupt() sets TIF_HRTIMER_REARM every time,
so the next tick repeats that. Task work queued with TWA_SIGNAL from a
hrtimer callback stays pending until the task does a syscall, takes an
interrupt without deferred rearm or has to reschedule.

A task which polls the io_uring completion ring in user space sees a
timeout completion after 30ms (median) instead of 70us. 2 CPU QEMU
guest, HZ=1000.

Use the mask.

Fixes: 15dd3a948855 ("hrtimer: Push reprogramming timers into the interrupt return path")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260919144027.70250-1-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hrtimer_rearm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hrtimer_rearm.h
+++ b/include/linux/hrtimer_rearm.h
@@ -40,7 +40,7 @@ hrtimer_rearm_deferred_user_irq(unsigned
 		clear_thread_flag(TIF_HRTIMER_REARM);
 		__hrtimer_rearm_deferred();
 		/* Don't go into the loop if HRTIMER_REARM was the only flag */
-		*tif_work &= ~TIF_HRTIMER_REARM;
+		*tif_work &= ~_TIF_HRTIMER_REARM;
 		return !*tif_work;
 	}
 	return false;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E760337EB4;
	Wed, 17 Sep 2025 12:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112908; cv=none; b=uU582jdFPY/P9FpGSPqmQiH5TnT2xwBs+K9ZmsIdZ6RRVJMd4JtF1/ImU3IixjsSTZj1VwAJ+ZSygk1aQLKbeYTYzIOU1mj2bbw1DWxN5m6z2sxlYZGmiwlySvvzte70O148at3a5cHCsCv/V8RHeX9Ub5eAdZBT+yub8RfjFX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112908; c=relaxed/simple;
	bh=z9jxRQHP0VxLiRMHYHhJ4fOSdNPE0ydf74rxxiNnYx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3a4n0fvay0cyEcjp5t+woO3KMLRIh16e7YnnlGSsq788Nh02tg0x4jv5gogpowEtecZS//Rp2ucvIJ8sxD0UIq5GEzd/JVLOiKI/aeOlxW+NWHEIfTyJKMdXN/az9XlE84Xdjnp557Tse/jHxviOxvVrDUGsAq6x10fL+dEqPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEYj212c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEYj212c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812AFC4CEF0;
	Wed, 17 Sep 2025 12:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112907;
	bh=z9jxRQHP0VxLiRMHYHhJ4fOSdNPE0ydf74rxxiNnYx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEYj212cvaQkYFAuAnCjIGFOclY6xUpQljxmJJijSmYa3FHA61OL2gk5KAbUfsc/b
	 FfaUb2KDRu1Er6SMKCPpCdZ+zmZg+WTnLMjRpMeWnGn4gy5db8u8qlA+d4ElekiOZ7
	 /3ppFyqSvMrpgtNbVNWAPg6uSIqtrSvkrVQFuL98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.16 113/189] hrtimers: Unconditionally update target CPU base after offline timer migration
Date: Wed, 17 Sep 2025 14:33:43 +0200
Message-ID: <20250917123354.628268748@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

commit e895f8e29119c8c966ea794af9e9100b10becb88 upstream.

When testing softirq based hrtimers on an ARM32 board, with high resolution
mode and NOHZ inactive, softirq based hrtimers fail to expire after being
moved away from an offline CPU:

CPU0				CPU1
				hrtimer_start(..., HRTIMER_MODE_SOFT);
cpu_down(CPU1)			...
				hrtimers_cpu_dying()
				  // Migrate timers to CPU0
				  smp_call_function_single(CPU0, returgger_next_event);
  retrigger_next_event()
    if (!highres && !nohz)
        return;

As retrigger_next_event() is a NOOP when both high resolution timers and
NOHZ are inactive CPU0's hrtimer_cpu_base::softirq_expires_next is not
updated and the migrated softirq timers never expire unless there is a
softirq based hrtimer queued on CPU0 later.

Fix this by removing the hrtimer_hres_active() and tick_nohz_active() check
in retrigger_next_event(), which enforces a full update of the CPU base.
As this is not a fast path the extra cost does not matter.

[ tglx: Massaged change log ]

Fixes: 5c0930ccaad5 ("hrtimers: Push pending hrtimers away from outgoing CPU earlier")
Co-developed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250805081025.54235-1-wangxiongfeng2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/hrtimer.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -787,10 +787,10 @@ static void retrigger_next_event(void *a
 	 * of the next expiring timer is enough. The return from the SMP
 	 * function call will take care of the reprogramming in case the
 	 * CPU was in a NOHZ idle sleep.
+	 *
+	 * In periodic low resolution mode, the next softirq expiration
+	 * must also be updated.
 	 */
-	if (!hrtimer_hres_active(base) && !tick_nohz_active)
-		return;
-
 	raw_spin_lock(&base->lock);
 	hrtimer_update_base(base);
 	if (hrtimer_hres_active(base))
@@ -2295,11 +2295,6 @@ int hrtimers_cpu_dying(unsigned int dyin
 				     &new_base->clock_base[i]);
 	}
 
-	/*
-	 * The migration might have changed the first expiring softirq
-	 * timer on this CPU. Update it.
-	 */
-	__hrtimer_get_next_event(new_base, HRTIMER_ACTIVE_SOFT);
 	/* Tell the other CPU to retrigger the next event */
 	smp_call_function_single(ncpu, retrigger_next_event, NULL, 0);
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CB137289E;
	Wed, 17 Sep 2025 12:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113903; cv=none; b=ChSV/JMyJ556KaQPHBeEMiSA9VFyU5zdXoITh4GZbP6/C3Cg1zL0ubb47y6gY610sYyVIg3/daVf7fGep/VXW3EbOv35/kHSr0eEqeTTkTl1ydDkpImrGnTMTCsOEjcmK/Tco/zzzwahSpYufj82By73h0WlEKc9fCizMUt417A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113903; c=relaxed/simple;
	bh=qs0zn5H2Vwza9Gbh02DmNmIlYGdl23zuBbDMiv8CcLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbS4GuEn4Or+h77M/YZkismlzlxYCRpBmThovPwRSmgNJfvHTm5SAkoCYlTEOIRjXNac0VmGZAIvNIRv4jSVmpp08ZWK1kuFb5bChm+A7tRz1vVAiGICOGCy1KsalJqOTtjVBm43DJ8e4CG6Qv93H655x5+tec7ofPgbidw+o2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OAODape; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OAODape"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BA7C4CEF0;
	Wed, 17 Sep 2025 12:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113901;
	bh=qs0zn5H2Vwza9Gbh02DmNmIlYGdl23zuBbDMiv8CcLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OAODapeJOTT0//uEZDkuZWPPEjIhCmizqvxoi2VdN9JJuHVy5Yp66HXGZ5noULgz
	 aogeexbtCy1Z/5h5n1YG79mvHTHX3AQTVN6y4Wwoc9L76ZUJh9d7gCGllUf5pdcTPl
	 jV7niaOoEqqUS9LkYIPMC1iLXRB5KqJSXfI8ezZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/101] hrtimers: Unconditionally update target CPU base after offline timer migration
Date: Wed, 17 Sep 2025 14:35:11 +0200
Message-ID: <20250917123338.964479797@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit e895f8e29119c8c966ea794af9e9100b10becb88 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 0c3ad1755cc26..ccea52adcba67 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -808,10 +808,10 @@ static void retrigger_next_event(void *arg)
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
@@ -2289,11 +2289,6 @@ int hrtimers_cpu_dying(unsigned int dying_cpu)
 				     &new_base->clock_base[i]);
 	}
 
-	/*
-	 * The migration might have changed the first expiring softirq
-	 * timer on this CPU. Update it.
-	 */
-	__hrtimer_get_next_event(new_base, HRTIMER_ACTIVE_SOFT);
 	/* Tell the other CPU to retrigger the next event */
 	smp_call_function_single(ncpu, retrigger_next_event, NULL, 0);
 
-- 
2.51.0




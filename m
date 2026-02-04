Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577863B52EE;
	Wed,  4 Feb 2026 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218105; cv=none; b=HTPdRPfXTYZsu/krHr1XiuDfKgSQ3XwYPxSScw3SS20YkSgwBmfsj7iJO/mBJujIhLhqZ4C/5IFbX+mcNA4c2CzL4w43sxvAErNkUJ6pcEJnp7gSLmY0JWtvIAjuyzS4dPNbyiO8xbvGplLhfdSppkxzQaZ+ph6hby0GBiuub/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218105; c=relaxed/simple;
	bh=OYpYS3doT/i/5iNXBylSp1gUC+/ODtNXwrPStg99FDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBNSyVaINB5z0xgCOtp9NSfI/cVKq7LBFddGrGotLxfDKEuzAZ082oLlF0iZvZd+EX6TGmsJll2+eVfYUGDLWQmYucwTCy2JXsIORkFmjtKPi7EC0WQwuO7jO4NE5x6730phG2u4WeaxfyE4MCqgCQBG5czJfZlRpN2J1I8+Am8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5P3lJFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5P3lJFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9884C4CEF7;
	Wed,  4 Feb 2026 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218105;
	bh=OYpYS3doT/i/5iNXBylSp1gUC+/ODtNXwrPStg99FDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5P3lJFx0Z91KbO4+7qgk7GJU0zfP1DgMKAMkY8wIcIlk5KRFmcAhNPLj63j70iIf
	 opYbM5lpbaS0kXbZEmmSFlRF3oytuYmM2iwhAX9uSFDcYyN1EGo4Fjhg11i8I7L+iA
	 LOMP2bxlMStanBCrXTxvR4q/y0tOtfdK+ssZk6Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Bernd Schubert <bernd@bsbernd.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 214/280] flex_proportions: make fprop_new_period() hardirq safe
Date: Wed,  4 Feb 2026 15:39:48 +0100
Message-ID: <20260204143917.311094090@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit dd9e2f5b38f1fdd49b1ab6d3a85f81c14369eacc upstream.

Bernd has reported a lockdep splat from flexible proportions code that is
essentially complaining about the following race:

<timer fires>
run_timer_softirq - we are in softirq context
  call_timer_fn
    writeout_period
      fprop_new_period
        write_seqcount_begin(&p->sequence);

        <hardirq is raised>
        ...
        blk_mq_end_request()
	  blk_update_request()
	    ext4_end_bio()
	      folio_end_writeback()
		__wb_writeout_add()
		  __fprop_add_percpu_max()
		    if (unlikely(max_frac < FPROP_FRAC_BASE)) {
		      fprop_fraction_percpu()
			seq = read_seqcount_begin(&p->sequence);
			  - sees odd sequence so loops indefinitely

Note that a deadlock like this is only possible if the bdi has configured
maximum fraction of writeout throughput which is very rare in general but
frequent for example for FUSE bdis.  To fix this problem we have to make
sure write section of the sequence counter is irqsafe.

Link: https://lkml.kernel.org/r/20260121112729.24463-2-jack@suse.cz
Fixes: a91befde3503 ("lib/flex_proportions.c: remove local_irq_ops in fprop_new_period()")
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Bernd Schubert <bernd@bsbernd.com>
Link: https://lore.kernel.org/all/9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com/
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/flex_proportions.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/flex_proportions.c b/lib/flex_proportions.c
index 84ecccddc771..012d5614efb9 100644
--- a/lib/flex_proportions.c
+++ b/lib/flex_proportions.c
@@ -64,13 +64,14 @@ void fprop_global_destroy(struct fprop_global *p)
 bool fprop_new_period(struct fprop_global *p, int periods)
 {
 	s64 events = percpu_counter_sum(&p->events);
+	unsigned long flags;
 
 	/*
 	 * Don't do anything if there are no events.
 	 */
 	if (events <= 1)
 		return false;
-	preempt_disable_nested();
+	local_irq_save(flags);
 	write_seqcount_begin(&p->sequence);
 	if (periods < 64)
 		events -= events >> periods;
@@ -78,7 +79,7 @@ bool fprop_new_period(struct fprop_global *p, int periods)
 	percpu_counter_add(&p->events, -events);
 	p->period += periods;
 	write_seqcount_end(&p->sequence);
-	preempt_enable_nested();
+	local_irq_restore(flags);
 
 	return true;
 }
-- 
2.53.0




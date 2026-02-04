Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244BB2D0292;
	Wed,  4 Feb 2026 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219154; cv=none; b=DioavmJNKy/mqcfnpiYsdPrWZJjBmnrhb9Ma2nUXSAna8zXqmXiVv01yKuP+5Nufv9HRv8nrzQv+noYb5uDxxctMNz76sk7SnyX+0EWGcCWNZbdxXfvnILqaY6LwldtijVw8YW5JwEVPVRa7vn5MJNWDt4jWI6zVXKLbdOyOrtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219154; c=relaxed/simple;
	bh=HMHkvgs6QEmAUNg6Lzl9T2RNrDp7NQlAgDenj/14Ce4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRaDI8dtS1FAfMazh+P77+ZgViqmtHH2fzyauWlC+PwKpSHQT9b4flTvLiPp0c4Qq7uQEg+KObxeQukCFFkR8ULtcCwvcRPnEqND9rB4InjppRA5zdRCUHM+eJWBeac1uqjte+8bWbYtlSKR5xQNX7Kq/vET1tQo7mi9Mcj1H94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzAdenEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzAdenEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8F7C4CEF7;
	Wed,  4 Feb 2026 15:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219154;
	bh=HMHkvgs6QEmAUNg6Lzl9T2RNrDp7NQlAgDenj/14Ce4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzAdenEMMI44UDl7FznRJGE4Z1fZmvLGlVJ4yI9QCV9Z6hfQEzM+2MYIuiT5TMXx+
	 4/a4W/P1b1sRzqijReYD5Oi7R9m3dB4OLEnvkSlXkTMg4fnVrqts8iB+eiAfGSOUix
	 imsviT49SrSBkZyeP5UgYhX1B9UUsLVW1IwKCJQ4=
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
Subject: [PATCH 6.18 083/122] flex_proportions: make fprop_new_period() hardirq safe
Date: Wed,  4 Feb 2026 15:41:05 +0100
Message-ID: <20260204143854.838266553@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 lib/flex_proportions.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/flex_proportions.c
+++ b/lib/flex_proportions.c
@@ -64,13 +64,14 @@ void fprop_global_destroy(struct fprop_g
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
@@ -78,7 +79,7 @@ bool fprop_new_period(struct fprop_globa
 	percpu_counter_add(&p->events, -events);
 	p->period += periods;
 	write_seqcount_end(&p->sequence);
-	preempt_enable_nested();
+	local_irq_restore(flags);
 
 	return true;
 }



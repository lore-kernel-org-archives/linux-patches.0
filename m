Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396802BD02A;
	Wed,  4 Feb 2026 15:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218462; cv=none; b=f0KCxY5ecH6p9NwUeckSFGDNrQsZfPAKbISWzCS+ooPv7/bLGaEGlDohHYtMcznD7yT2MkV4Gup27WWRt6G5IEK0FS1EKss6TTps87gF6LtWkPT841/KmvLnnf8lMkictEym1qUsXq1xCNPJsxj4J7n4FehVW4NYtTa/V2Y6B4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218462; c=relaxed/simple;
	bh=zAqoZLXzv5DGTCVliBNZjcNcala5wVzSUhAMiRg/doE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxjTUUMzQbP4HXhxAxnHIXM/YR6d9vgj8p2WgVlBTjyxDIxZ6X51m/XMKfXYV7/IDSd5wKQaIo4klN2Yw/aGzSfO9dvN6TuCsMRjScBabxrBaXhiv7ODFOoqYqHDoQR1DQh0Tf4Iprob+uhWzW8Khuoi2m3D7RHeE7DrKMqq7Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rq59Abb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rq59Abb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E30EC4CEF7;
	Wed,  4 Feb 2026 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218462;
	bh=zAqoZLXzv5DGTCVliBNZjcNcala5wVzSUhAMiRg/doE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rq59Abb+EKCzLukFfHvIxamSaTnzSMw8YJfbPtv8CfKfMRU0plCckhqwkmymNXTMu
	 j8D1g9fheIsqB1zp0+QUEPcDBjsPW+Gjyzd5zZSz1JvtVTnc9lmYc2e7NFeK96gEBu
	 u0DnZU/u+5NjZ7iPAzLUpzQfRog6UEVlKapHHqQQ=
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
Subject: [PATCH 6.6 36/72] flex_proportions: make fprop_new_period() hardirq safe
Date: Wed,  4 Feb 2026 15:40:39 +0100
Message-ID: <20260204143846.932664338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



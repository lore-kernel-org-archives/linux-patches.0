Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB4A19E83F;
	Tue, 10 Sep 2024 10:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964014; cv=none; b=AI3FzfmNYtA8J6fiexY8tlGw+3pC5uMgMzZp+xFnt8ZCqJBA7fb1/9wDalAkHq64dTailUp+I4av3jBeuSaewp2gQYI/NOHYgHHQyVNhjywZDFqeudLYG1IiX8GIJa6x5//W3OGrFe6tlcHjPfuC/pYN8nCcF2z/bgORHm2rTyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964014; c=relaxed/simple;
	bh=Wjk4GNcqV4MiZCkX+X8kkrro1GJxywXKMmI3rgeT0Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGuS9GIq/f5dCd+Pr2/7EZMMaan4j6f0v3JVsDUKzlBHKSWfF7/lK5l/eBha86+US6Y0DZ/huzz2rZjv2PIJQQj+y/DYySbVW2kh96z2W3C2UL5zcuzq4nfFVvr0fP17+wYCZtElBEWtrpBjb/DGYLG1MvrgPW+kLpjjpALcTeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6mxZevO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6mxZevO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FC3C4CEC6;
	Tue, 10 Sep 2024 10:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964014;
	bh=Wjk4GNcqV4MiZCkX+X8kkrro1GJxywXKMmI3rgeT0Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6mxZevOFF2aR0epjTUSDYMkSz7TaPNpriHB+6ZxwFCaHeXa9Z8+pppnlaY1xhRoB
	 wdRS6JAfVErRqd+nUAyXUnW9rfIaytpkx8/8uLjMqhlmOLGx+wXNj+AxKXIO5TOygX
	 m+lAQTZFkx9RUQ6RBY/1VsbbLULMA0nGqQDCQTbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	"Hailong.Liu" <hailong.liu@oppo.com>,
	Christoph Hellwig <hch@infradead.org>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 039/269] mm: vmalloc: ensure vmap_block is initialised before adding to queue
Date: Tue, 10 Sep 2024 11:30:26 +0200
Message-ID: <20240910092609.653978630@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

commit 3e3de7947c751509027d26b679ecd243bc9db255 upstream.

Commit 8c61291fd850 ("mm: fix incorrect vbq reference in
purge_fragmented_block") extended the 'vmap_block' structure to contain a
'cpu' field which is set at allocation time to the id of the initialising
CPU.

When a new 'vmap_block' is being instantiated by new_vmap_block(), the
partially initialised structure is added to the local 'vmap_block_queue'
xarray before the 'cpu' field has been initialised.  If another CPU is
concurrently walking the xarray (e.g.  via vm_unmap_aliases()), then it
may perform an out-of-bounds access to the remote queue thanks to an
uninitialised index.

This has been observed as UBSAN errors in Android:

 | Internal error: UBSAN: array index out of bounds: 00000000f2005512 [#1] PREEMPT SMP
 |
 | Call trace:
 |  purge_fragmented_block+0x204/0x21c
 |  _vm_unmap_aliases+0x170/0x378
 |  vm_unmap_aliases+0x1c/0x28
 |  change_memory_common+0x1dc/0x26c
 |  set_memory_ro+0x18/0x24
 |  module_enable_ro+0x98/0x238
 |  do_init_module+0x1b0/0x310

Move the initialisation of 'vb->cpu' in new_vmap_block() ahead of the
addition to the xarray.

Link: https://lkml.kernel.org/r/20240812171606.17486-1-will@kernel.org
Fixes: 8c61291fd850 ("mm: fix incorrect vbq reference in purge_fragmented_block")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Hailong.Liu <hailong.liu@oppo.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2066,6 +2066,7 @@ static void *new_vmap_block(unsigned int
 	vb->dirty_max = 0;
 	bitmap_set(vb->used_map, 0, (1UL << order));
 	INIT_LIST_HEAD(&vb->free_list);
+	vb->cpu = raw_smp_processor_id();
 
 	xa = addr_to_vb_xa(va->va_start);
 	vb_idx = addr_to_vb_idx(va->va_start);
@@ -2082,7 +2083,6 @@ static void *new_vmap_block(unsigned int
 	 * integrity together with list_for_each_rcu from read
 	 * side.
 	 */
-	vb->cpu = raw_smp_processor_id();
 	vbq = per_cpu_ptr(&vmap_block_queue, vb->cpu);
 	spin_lock(&vbq->lock);
 	list_add_tail_rcu(&vb->free_list, &vbq->free);



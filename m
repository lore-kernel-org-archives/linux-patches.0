Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BA434320F;
	Tue, 26 Aug 2025 13:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215995; cv=none; b=WUfbbAXlq+3ohhZe5DyJejAEGg8A2mOPY4CpVmirQ3JWehm8BgbWdi8H1iZOp9xQJa7pg79D3U29++oFBejWQoDei8MhQZ5pVjHh56hW95UvrnnwP3NS3K42Gz+sEcvoIG4Fg8dwSxxcYWGQ9Ex2vrKsKfkxr5XBenHJU6u8PQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215995; c=relaxed/simple;
	bh=BkP6ahwJZ6AnBHIWGan7uxgmAq6V3xFaND3N084RaZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXacJpZ92wKB/16GZRNkw60XVB6UDKZlx/yipXTRfy/V+DQ7E4UskvAs2eclCPzqXkofMNBiwWCpg+Xw4fsdMf5bzRDuFaDRT10Vtih3XuabV6FeWRdqObP9bkVwNxiV6wiUSrZa8Ei1TQo3jUSIymsHw3zgVmvC5CCoCeCfnN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjjRSVoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjjRSVoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454A9C113CF;
	Tue, 26 Aug 2025 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215995;
	bh=BkP6ahwJZ6AnBHIWGan7uxgmAq6V3xFaND3N084RaZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjjRSVoLYWHK7quClrNOllYoLK4RLb4ADNfNYOdoioud39ERvtLvcLzMeoeW5sPJg
	 BAumsVtDzN5ZusCbeCsKUbXCGxw+A7/QlUDW8f/qrYk4CQhkuBnOlIdi02kDIQO/c+
	 pxj2Buz08BAIt4xh3VkbFXZ3h5nyJy6/sSmbG7qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 5.15 245/644] perf/core: Dont leak AUX buffer refcount on allocation failure
Date: Tue, 26 Aug 2025 13:05:36 +0200
Message-ID: <20250826110952.463987809@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 5468c0fbccbb9d156522c50832244a8b722374fb upstream.

Failure of the AUX buffer allocation leaks the reference count.

Set the reference count to 1 only when the allocation succeeds.

Fixes: 45bfb2e50471 ("perf/core: Add AUX area to ring buffer for raw data streams")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6477,9 +6477,7 @@ static int perf_mmap(struct file *file,
 			goto unlock;
 		}
 
-		atomic_set(&rb->aux_mmap_count, 1);
 		user_extra = nr_pages;
-
 		goto accounting;
 	}
 
@@ -6581,8 +6579,10 @@ accounting:
 	} else {
 		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages,
 				   event->attr.aux_watermark, flags);
-		if (!ret)
+		if (!ret) {
+			atomic_set(&rb->aux_mmap_count, 1);
 			rb->aux_mmap_locked = extra;
+		}
 	}
 
 unlock:
@@ -6592,6 +6592,7 @@ unlock:
 
 		atomic_inc(&event->mmap_count);
 	} else if (rb) {
+		/* AUX allocation failed */
 		atomic_dec(&rb->mmap_count);
 	}
 aux_unlock:



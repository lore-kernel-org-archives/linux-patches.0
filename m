Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EAB239E8B;
	Tue, 26 Aug 2025 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218933; cv=none; b=i+HQncDkU6w8Q/ZsEVN87Wgmpg5cMzGAoC7JM9Nu+R/0u8I88UbvaVW9V+Lsw+b7wbtVhf6uJHoDBvgqNojCxTPpo2+kGE8L61r0EbOU/sUh/K+5EXrw4FCLrunYVWsCRqlWBZrT+KbTgGllcpatKiE3Ea7b5HyJntqaw1INqdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218933; c=relaxed/simple;
	bh=TeutQ8YMQed8xqbHiTr+YrgDnwabVXap3Q2tHkPVmI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sObZrNI/oZ2O82SYIhsJ367kNGa+c0uBVSdQoku38nZ5iexhUq4l8MwFrGD8KmXrCoPxJPIgMrm3KAG0KPeuUd0TJuXYqFpiSNIeZ0NezOEs6FaA84dFcrPn2wi8cytYoq5arTSYcJf2/r//H9o4ZaE2RgHv+Ox5m4MXJinxuyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jSgLTUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jSgLTUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AA3C4CEF1;
	Tue, 26 Aug 2025 14:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218933;
	bh=TeutQ8YMQed8xqbHiTr+YrgDnwabVXap3Q2tHkPVmI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jSgLTUYC8vP9iz2LbRHXvSANLc6lUC5tJXVcXv6Ytb67AzoQR2cfC4GAqheIhW13
	 iqPoepNDoGxfWfhzZRLs0ghPcL0W3cP3aGqdDoaXKJMAgXecA0dLKMetQ8Pr1l9/l0
	 FFeYWIABTN26TO9WI68jcRYfh5CLXFQkgVYMCbVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 5.4 148/403] perf/core: Dont leak AUX buffer refcount on allocation failure
Date: Tue, 26 Aug 2025 13:07:54 +0200
Message-ID: <20250826110910.934202666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5877,9 +5877,7 @@ static int perf_mmap(struct file *file,
 			goto unlock;
 		}
 
-		atomic_set(&rb->aux_mmap_count, 1);
 		user_extra = nr_pages;
-
 		goto accounting;
 	}
 
@@ -5986,8 +5984,10 @@ accounting:
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
@@ -5997,6 +5997,7 @@ unlock:
 
 		atomic_inc(&event->mmap_count);
 	} else if (rb) {
+		/* AUX allocation failed */
 		atomic_dec(&rb->mmap_count);
 	}
 aux_unlock:



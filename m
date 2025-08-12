Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C342D6619;
	Tue, 12 Aug 2025 19:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026834; cv=none; b=AaFwjp6uuO73OF+gG9ldQ8SU5XK+Hc9/TVGn/BHZqDpe4e9TtkkDYRUGKTtDr4c1GT1xyMn7hMw2DH14BjHjL9mNbC+TISX7j28WdI4uwz/Iu4GCwNWw8iFcgZ5okAIhm5OS7BtsiJ+pj2KJMpfwXsSY3IJdvqJtFIrNl+cfHZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026834; c=relaxed/simple;
	bh=sfcoZVDxhermPUYPZUT5ewx4nWS1D/+yr+Ac/7Xn+GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHqVv7KqaTr+Lzt2sVNJFkQrF0riWiYmERxL/5116o3bS7VAOr+QV39C8Xc8rCaggo/UPRdOhCQtH8a0FRAQmxeGG9nlMbjPBhiVnkjA7IsSGsXT2z96xgRQNkW1FoMNEeGv/0qiaSFf9dsQ1u8NL6UKvl8Hwi1dVLZAtW2+B10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxHLBXCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxHLBXCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F85C4CEF0;
	Tue, 12 Aug 2025 19:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026834;
	bh=sfcoZVDxhermPUYPZUT5ewx4nWS1D/+yr+Ac/7Xn+GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxHLBXCyQZaL0K68VI7/abE2e4EtKQmKqF43ItXGrDV2saSDtZ5xEDEWITSqF5R5v
	 44d7iEgA2YxQbJkS0UgM83w6VMBiOfQ2qNRaPGVkMo8ZbmTbTSme5Naei8gVjEUi1R
	 9N+Fj0Lz+vwwof/6rwnl2wrHcK9Ng2nq0WEPcLxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.15 437/480] perf/core: Dont leak AUX buffer refcount on allocation failure
Date: Tue, 12 Aug 2025 19:50:45 +0200
Message-ID: <20250812174415.423924373@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6988,8 +6988,6 @@ static int perf_mmap(struct file *file,
 			ret = 0;
 			goto unlock;
 		}
-
-		atomic_set(&rb->aux_mmap_count, 1);
 	}
 
 	user_lock_limit = sysctl_perf_event_mlock >> (PAGE_SHIFT - 10);
@@ -7056,8 +7054,10 @@ static int perf_mmap(struct file *file,
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
@@ -7067,6 +7067,7 @@ unlock:
 
 		atomic_inc(&event->mmap_count);
 	} else if (rb) {
+		/* AUX allocation failed */
 		atomic_dec(&rb->mmap_count);
 	}
 aux_unlock:



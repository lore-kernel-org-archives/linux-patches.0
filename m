Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584622FA0DB;
	Tue, 12 Aug 2025 18:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025125; cv=none; b=NeETn3BCvnJWS/s6+hQdw/8cg+tOMiglyHtokKyqSYSTMJwYlyjQHsJCtmksYV4jLY4rhWXpV9eJtg501g25evbjibeIuQa2cyb6UoD/EfjPiBRSDfEri7oldgAxvojl+vVdG9+xF/+cPq3uOubI4eO7kLRX5c8FZQub78/bQzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025125; c=relaxed/simple;
	bh=+3MKZVY8tQ/tvcC25djClqIECG1AY6VtwgdslGyKPxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEhBiaAxkL2t8iR6w5YMqsy4jpfqBUi9Mb69jailzOwINKPZ1mKNd4GEzHrAlKgTRwe2OYi/lNhWKbxfZ7RxYvnpZ//Jge3b7prLWZZQAKXdIDz/LJSa6/Gwqntpb5Gn7l/JTxdiqXcCmXHKJ/A6ZITJcCtQbr29VonWbJp2y8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0EBdHBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0EBdHBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC521C4CEF0;
	Tue, 12 Aug 2025 18:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025125;
	bh=+3MKZVY8tQ/tvcC25djClqIECG1AY6VtwgdslGyKPxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0EBdHBd6rbMQ8Kz8XrwBz0mqSrny2OnmtFf0YSJoYSBpsZn03bbH4R1Ly6XQmc7w
	 ekxanosCz5H/WTLnqL5j8swc9301qWNTE7YRLJvQIkDvm+hUWCOaN7aZ1T215rK/yQ
	 mw9oknxCUBiOpawgpVFo0uKCiPsh63HO8bEeEJ+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.16 577/627] perf/core: Dont leak AUX buffer refcount on allocation failure
Date: Tue, 12 Aug 2025 19:34:32 +0200
Message-ID: <20250812173453.821872940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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
@@ -7051,8 +7051,6 @@ static int perf_mmap(struct file *file,
 			ret = 0;
 			goto unlock;
 		}
-
-		atomic_set(&rb->aux_mmap_count, 1);
 	}
 
 	user_lock_limit = sysctl_perf_event_mlock >> (PAGE_SHIFT - 10);
@@ -7119,8 +7117,10 @@ static int perf_mmap(struct file *file,
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
@@ -7130,6 +7130,7 @@ unlock:
 
 		atomic_inc(&event->mmap_count);
 	} else if (rb) {
+		/* AUX allocation failed */
 		atomic_dec(&rb->mmap_count);
 	}
 aux_unlock:



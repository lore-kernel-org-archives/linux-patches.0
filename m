Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DB061FFE;
	Tue, 12 Aug 2025 18:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023127; cv=none; b=GOXLFzBTWh/q4z32at59TKTTw2h2/dtBYdGhr2Mvjy0tSdkHTUvMp1EN+CG2Yu3Ci3XTjl44lG4cA3B1a9WVyWxxJq+PKg1LGvjRIaG5Y6coc5NSpUPdEadAScD2GL9d5lZ33YDhh4RfA56+RUv8AHeQJ3xFeIr13v6Ijlwysnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023127; c=relaxed/simple;
	bh=qrGC9OvP6cVTx8Fk9mWItJtEh6BsvWcubu6Qey0r0L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xmyovd6Y3RBtWR9lxwRBcUkRP58TvxZHOzLtE+APRa72aGzuyLDbbwuq1kiBbZOH99cBbSiGeF82m4k7kW3HunEZOudcFRmnITrUxy3amfFbmyTToXp9f3uMEzPRNpDdHV+EJOkcc8CH7195uYQucVQMpDs9Q7x/HGKIUanRHAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeo8SnhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeo8SnhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C291EC4CEF0;
	Tue, 12 Aug 2025 18:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023127;
	bh=qrGC9OvP6cVTx8Fk9mWItJtEh6BsvWcubu6Qey0r0L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yeo8SnhSoFBHMeAy8atA/SeIhjGt/OqLj+D3MDRZu85fBwd9K6Hn+VJd2ay/C1kxG
	 Di6NKLwyU1LqnSUkthVJxG5SytKwAqBqFwIN9FZ/mIleCLjPBxFldRvxYsf20WW5/c
	 +U4JX8ATpmeMtbfd147vCia18lVgjrvH56znYqBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.12 324/369] perf/core: Dont leak AUX buffer refcount on allocation failure
Date: Tue, 12 Aug 2025 19:30:21 +0200
Message-ID: <20250812173028.904840412@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6713,9 +6713,7 @@ static int perf_mmap(struct file *file,
 			goto unlock;
 		}
 
-		atomic_set(&rb->aux_mmap_count, 1);
 		user_extra = nr_pages;
-
 		goto accounting;
 	}
 
@@ -6817,8 +6815,10 @@ accounting:
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
@@ -6828,6 +6828,7 @@ unlock:
 
 		atomic_inc(&event->mmap_count);
 	} else if (rb) {
+		/* AUX allocation failed */
 		atomic_dec(&rb->mmap_count);
 	}
 aux_unlock:



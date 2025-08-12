Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0C3217F35;
	Tue, 12 Aug 2025 19:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026796; cv=none; b=X3x8eT9B1ushu2gQUemCbvfuGsRD6GPFN0Gb3V5x42bjJegYHNJU1Jd+ubpgicS6TkW5841rPIfI5J5F6PqSAdiW5R3RS9V5ZU5KyofgEcZqV/bOGKM2zxaSum21or9nqSkECnwfDXn/SesEib98iU+KeaQhSulKlxNNfd2olv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026796; c=relaxed/simple;
	bh=blWaW6At7TUyCq6DMsNpoGezAJ5kAEkpMDqY59BLBkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpPD3BY+P+4I4WGRMCX56mOfiVH+UXOWK0G4pWDKjVcHQQsDR9DWN+GMMc4GCMbRqmYZ1MZ/1GyKDQjYcSlgeQUeZgEXFa+/4PKBEmKHRdoY4zcfbd7GyQe5bkyOeZP06AZccmLWasxbBJohuxNBokhy4j8L6uFgFnGoIOYgux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPeMWeg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPeMWeg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E845C4CEF0;
	Tue, 12 Aug 2025 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026796;
	bh=blWaW6At7TUyCq6DMsNpoGezAJ5kAEkpMDqY59BLBkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPeMWeg8Gc1oz8iefJ9fcZHoXadJ6oZn0D/1qSlodc+3YCUH0Wtkhd2r/tTyZwCBI
	 TGh1j9jbS/JH2pV2svWshsMha4S2QQw+NIoBnVuCAPm2ZwhE1ddPwx7o7Nvm0mz4WO
	 zgsl7E3gLGhTsQtu6rV8dfuUGtUukwRWNxiSn+qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.15 436/480] perf/core: Preserve AUX buffer allocation failure result
Date: Tue, 12 Aug 2025 19:50:44 +0200
Message-ID: <20250812174415.384114861@linuxfoundation.org>
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

commit 54473e0ef849f44e5ee43e6d6746c27030c3825b upstream.

A recent overhaul sets the return value to 0 unconditionally after the
allocations, which causes reference count leaks and corrupts the user->vm
accounting.

Preserve the AUX buffer allocation failure return value, so that the
subsequent code works correctly.

Fixes: 0983593f32c4 ("perf/core: Lift event->mmap_mutex in perf_mmap()")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7052,6 +7052,7 @@ static int perf_mmap(struct file *file,
 		perf_event_update_time(event);
 		perf_event_init_userpage(event);
 		perf_event_update_userpage(event);
+		ret = 0;
 	} else {
 		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages,
 				   event->attr.aux_watermark, flags);
@@ -7059,8 +7060,6 @@ static int perf_mmap(struct file *file,
 			rb->aux_mmap_locked = extra;
 	}
 
-	ret = 0;
-
 unlock:
 	if (!ret) {
 		atomic_long_add(user_extra, &user->locked_vm);



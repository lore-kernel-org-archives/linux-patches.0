Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B542FAC02;
	Tue, 12 Aug 2025 18:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025123; cv=none; b=fIuyg7GzDV0PoW+aD7EGjcl2kh0kJWaPsEUilgGORy0+IVL8jKBAV531gNzYXH13QEFuTi2KwNFmqSovAHKlICZeq8Ks5JUVo/s0DA6N34A9d00a63yYdqaZmT8q7r/MKavdDhoyvcFvC5tfQt9JZd2cRWWf8Q4gEucx5yFTZP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025123; c=relaxed/simple;
	bh=uOAtITfTVa98KjCiv94KaBb75e+sCodHALefgv6mWvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rneuMBZbDB/kWSLKKX0KrSLBTfRc7bR0nGitV6Baq7mh8NZ+C/Uj0tWms8pQ0o0GjsjS/QpR2TJuECOZQoFC8EYvsOUDx4iunk2i0yOL61af9LE+zqNcS/1SmS38o8/nscRkjxh2je1OAIwzZKxFR/BquFCZxOa3ewrfVSRjqic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6V9COYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6V9COYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD1CC4CEF0;
	Tue, 12 Aug 2025 18:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025121;
	bh=uOAtITfTVa98KjCiv94KaBb75e+sCodHALefgv6mWvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6V9COYFnUp4KgBgzBimztlc8lqUaT3OWhzkjmgm3b2SW05E/qw+ekJYvxk2jZZUA
	 ab7GQWdJXT4PHuzF2JXSSwHeBwGH0w9IIcVOe7WCQ4VKkkfitW4Baqa/pSVyfjh4/E
	 eIw1LVvmzXx2m7ANPlnkUpIrjdKjaTXMjYvkmefE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.16 576/627] perf/core: Preserve AUX buffer allocation failure result
Date: Tue, 12 Aug 2025 19:34:31 +0200
Message-ID: <20250812173453.784278195@linuxfoundation.org>
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
@@ -7115,6 +7115,7 @@ static int perf_mmap(struct file *file,
 		perf_event_update_time(event);
 		perf_event_init_userpage(event);
 		perf_event_update_userpage(event);
+		ret = 0;
 	} else {
 		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages,
 				   event->attr.aux_watermark, flags);
@@ -7122,8 +7123,6 @@ static int perf_mmap(struct file *file,
 			rb->aux_mmap_locked = extra;
 	}
 
-	ret = 0;
-
 unlock:
 	if (!ret) {
 		atomic_long_add(user_extra, &user->locked_vm);



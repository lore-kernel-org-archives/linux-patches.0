Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3DF188733;
	Mon, 23 Dec 2024 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970073; cv=none; b=n/Qv8uBenmZZo9RCrVS8yDuQU4OA+JldbtbmcjsSVRGnWIYLNvWLgyJa+6MPLBJPcRaZtFwJtSd2FHdyBLnYpWW6lN5bX6cMINcUZrQMkoBkSpPwD/VE8Kw/AMtTNvFYPmkfkBMgS2sCn9IYFuZyeFHaM/7c6SI8NZP8lApC79s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970073; c=relaxed/simple;
	bh=L7QeUc8NsUYw0SCM4ijaIiC6WHC4q9sLg3NHZemoyLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kn50rwfjZOC6B+Zo2UqUVI1xghf8qM55Hax+eH7r9X3ftoXTV+dd9jB7bG5c6C1Q8cBnYfrPrlyJDE9ZBn9i/ichp+kzJt93lTomspWI8qauvya5NwxhZ4PwR/Bnv/JKf7Uhl1vX22rqL+nyz9F444up0uYCh/qiOkCweMuRDXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnSQiT8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnSQiT8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D668BC4CED3;
	Mon, 23 Dec 2024 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970073;
	bh=L7QeUc8NsUYw0SCM4ijaIiC6WHC4q9sLg3NHZemoyLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnSQiT8NUqLl1kfSlD9WrlX2w+YgkiB1PAmeU60IQs8Cgt0UIig0jJ1Ment07ZhGr
	 HdbqqADnxC0zfTqvoaY0swuQjIum6m6CKCMrXHKZNUv58omNMkQGsyhBgxcs9o2Drs
	 A+Uxza0o5HlOoWv4DGaMCwzGYlVo2mQGtHfLkLZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 136/160] io_uring: Fix registered ring file refcount leak
Date: Mon, 23 Dec 2024 16:59:07 +0100
Message-ID: <20241223155414.039965419@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 12d908116f7efd34f255a482b9afc729d7a5fb78 upstream.

Currently, io_uring_unreg_ringfd() (which cleans up registered rings) is
only called on exit, but __io_uring_free (which frees the tctx in which the
registered ring pointers are stored) is also called on execve (via
begin_new_exec -> io_uring_task_cancel -> __io_uring_cancel ->
io_uring_cancel_generic -> __io_uring_free).

This means: A process going through execve while having registered rings
will leak references to the rings' `struct file`.

Fix it by zapping registered rings on execve(). This is implemented by
moving the io_uring_unreg_ringfd() from io_uring_files_cancel() into its
callee __io_uring_cancel(), which is called from io_uring_task_cancel() on
execve.

This could probably be exploited *on 32-bit kernels* by leaking 2^32
references to the same ring, because the file refcount is stored in a
pointer-sized field and get_file() doesn't have protection against
refcount overflow, just a WARN_ONCE(); but on 64-bit it should have no
impact beyond a memory leak.

Cc: stable@vger.kernel.org
Fixes: e7a6c00dc77a ("io_uring: add support for registering ring file descriptors")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20241218-uring-reg-ring-cleanup-v1-1-8f63e999045b@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring.h |    4 +---
 io_uring/io_uring.c      |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -15,10 +15,8 @@ bool io_is_uring_fops(struct file *file)
 
 static inline void io_uring_files_cancel(void)
 {
-	if (current->io_uring) {
-		io_uring_unreg_ringfd();
+	if (current->io_uring)
 		__io_uring_cancel(false);
-	}
 }
 static inline void io_uring_task_cancel(void)
 {
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3230,6 +3230,7 @@ end_wait:
 
 void __io_uring_cancel(bool cancel_all)
 {
+	io_uring_unreg_ringfd();
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 



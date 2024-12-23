Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB941B85F6;
	Mon, 23 Dec 2024 16:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970841; cv=none; b=XWr5/lssT52BANwS7rWoFQ29Q6BBjacJdKiIWJOzOrV5CwqU+s1b6cZEPmBfcNkOeV5DRLs3/VFk/VfKg60ZzQMegxYccsqWri7vteKfFkjBXuFa42U7cBKf44qAAzbepnxUeJEpXAvDkvAlhTSVQgYKBkQ2FcUpjEPVwcytIiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970841; c=relaxed/simple;
	bh=JrZjyas5v70HvsVDCoEnO36ISGT/pU4YD2mvPPhLhws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buDrTfZ41EJfL1icBEICeCH69TK65DLBn9exqjfhA0xohxrbLaFdv0lHZI2+NdzUFuFr3SYD1fn2CI6OOH5RBnWufMfAJ1L50dDFZROf0Is8S2qL3mjlRNa39QXkCqfrZfYODSGuEcuXuZn+VGd8hB8i3KWFchQwNff6dhT1mDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qThIiPHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qThIiPHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2EFC4CED3;
	Mon, 23 Dec 2024 16:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970840;
	bh=JrZjyas5v70HvsVDCoEnO36ISGT/pU4YD2mvPPhLhws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qThIiPHTyTh7meCtS0+7G4kLhvP1I6PaSsujn6o+B4LByZbY9UDaOkBaWtBcPN5v6
	 VxvrIw4UexWTmNxzYpmys/s7ipGr61WjV/HiRQFbpDn3T2xCnGYIrenFXvlp0qIVL3
	 ZWiI5F7WtYh+rQ4xJuXfg83xBPflYsNdCMKpWYFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 66/83] io_uring: Fix registered ring file refcount leak
Date: Mon, 23 Dec 2024 16:59:45 +0100
Message-ID: <20241223155356.182815286@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -50,10 +50,8 @@ bool io_is_uring_fops(struct file *file)
 
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
@@ -3085,6 +3085,7 @@ __cold void io_uring_cancel_generic(bool
 
 void __io_uring_cancel(bool cancel_all)
 {
+	io_uring_unreg_ringfd();
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 



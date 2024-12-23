Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29A91A4AAA;
	Mon, 23 Dec 2024 16:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970510; cv=none; b=NA1KcQZ+wFWjJ9GeVl4pKsZVESUc+F4+AwJq6TkefpIfGVrnyCLXUJsIE7WGQx7NgLiZt0UFiue/oRGuk0oj46E9hhreHmWoHeI93Xr3ul/Kv/8KdOaf0DCgZg/Sg2Yna5Nudsn42zDZ4xtFZdpGzs//Dkdml4Uev/zhpjLfOIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970510; c=relaxed/simple;
	bh=BPurqI2d55VlT3MYFIWPmTFt0OixaK+vlsGoXzskMiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+buP5sE4VsEsyaoFTLLkz05CoYgxGVTOed0dIwQ14rbW5mlgcBlewhUKO66iWz+p1iwPdqnfQyhFW3/xLUQKfvvVZ6u24JC5CGAoZU1ctV1VejGChbt3M8kKoT4afvPGgJDjmyfvNPLhbQgZvkqIPsZJZM7c6RFpyHo0/UBIFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjVQfZ7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjVQfZ7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3589CC4CED3;
	Mon, 23 Dec 2024 16:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970510;
	bh=BPurqI2d55VlT3MYFIWPmTFt0OixaK+vlsGoXzskMiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjVQfZ7T+A0afXv55ANOuRPkWvuoO9Z9ywzqwd/YHhoGVhuo7LLw9EiWmix59KByP
	 UwQl65uPRVfh8N9wKq6pKmjqMCRIcK/3CJ1x34lrWvnzxdzhDL12lccTFbYzlD7eZp
	 irm4SkEPcuyordjTGwO17wDQN5wUuNaqlzmlJy1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 097/116] io_uring: Fix registered ring file refcount leak
Date: Mon, 23 Dec 2024 16:59:27 +0100
Message-ID: <20241223155403.334058885@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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
@@ -65,10 +65,8 @@ static inline void io_uring_cmd_complete
 
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
@@ -3431,6 +3431,7 @@ end_wait:
 
 void __io_uring_cancel(bool cancel_all)
 {
+	io_uring_unreg_ringfd();
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 



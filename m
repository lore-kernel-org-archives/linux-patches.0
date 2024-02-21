Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BD07CF32;
	Wed, 21 Feb 2024 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524684; cv=none; b=jNZnRGvPihHp5HCIAbBqgMkxjeWYNZDTJEbFWr4mOWUtBZIvkWAXv8uZt/zBv4iAhP/uYCCqOjNNhc7iDS2Un2BBAxTq6kSdhfBJNr+U7VLh60U0aElMQ0m1uhC2Y00FHiw1LgRdDIyQfpP64CdpWyOtSv4MTn15bqe5SMIieMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524684; c=relaxed/simple;
	bh=6YMS2WwaJ4KjOzFKuj3Fpdi0SdPs7M1fiv9Eda5aU7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfuzgHQqzp4SaNSf3qHn9hnxloG0erNVPTe8ViLpX3v60uwOkxP6R44xgvpLPNEqAhggEPIe/JRxp7fPFGW8pnvGWwx5IVkfEVXAm7RKkcs8pxA71/eSeuwLSHPYzYsdVpFncefz0w7GiJDfZCArcK1EmvpwKy9oFjlH5gKIbng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHkp4f/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHkp4f/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DE0C433C7;
	Wed, 21 Feb 2024 14:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524684;
	bh=6YMS2WwaJ4KjOzFKuj3Fpdi0SdPs7M1fiv9Eda5aU7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHkp4f/lSfSKcyQoU3RPc9cjq0Z5ZgevbZA2+88VjEjN9UO5k+pLFT8XBklMNUWjf
	 AtUIdw+InI5BgZSW0ARJ9aXNTuvjo6YTp+1YtU+o17oLXKDwy18Ob4V6IJa9FninRo
	 +FZBarrCZd0jnnLQKbggo7At9jkWrMpjaiGgbSHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Martijn Coenen <maco@android.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Steven Moreland <smoreland@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.10 319/379] binder: signal epoll threads of self-work
Date: Wed, 21 Feb 2024 14:08:18 +0100
Message-ID: <20240221130004.382005339@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 97830f3c3088638ff90b20dfba2eb4d487bf14d7 upstream.

In (e)poll mode, threads often depend on I/O events to determine when
data is ready for consumption. Within binder, a thread may initiate a
command via BINDER_WRITE_READ without a read buffer and then make use
of epoll_wait() or similar to consume any responses afterwards.

It is then crucial that epoll threads are signaled via wakeup when they
queue their own work. Otherwise, they risk waiting indefinitely for an
event leaving their work unhandled. What is worse, subsequent commands
won't trigger a wakeup either as the thread has pending work.

Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Martijn Coenen <maco@android.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Steven Moreland <smoreland@google.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20240131215347.1808751-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -836,6 +836,16 @@ binder_enqueue_thread_work_ilocked(struc
 {
 	WARN_ON(!list_empty(&thread->waiting_thread_node));
 	binder_enqueue_work_ilocked(work, &thread->todo);
+
+	/* (e)poll-based threads require an explicit wakeup signal when
+	 * queuing their own work; they rely on these events to consume
+	 * messages without I/O block. Without it, threads risk waiting
+	 * indefinitely without handling the work.
+	 */
+	if (thread->looper & BINDER_LOOPER_STATE_POLL &&
+	    thread->pid == current->pid && !thread->process_todo)
+		wake_up_interruptible_sync(&thread->wait);
+
 	thread->process_todo = true;
 }
 



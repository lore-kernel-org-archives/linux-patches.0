Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A591625B662;
	Mon, 29 Dec 2025 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025488; cv=none; b=eUK2+56mOoGAD6QJoYcTN6Ft/E0UeIJKOwglqKglDbt9M6Odq+8fZg2erE7j4ABSzc5q+OnsORz2esWNyjjl++AKleHgFD1Y5uqPyp9CuinCHZcYIcuYM0d02/9YMNAxA72ZJjLzJHM4YEtcKLh4VW5Uvi6Lcek+DeQrAWvJyGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025488; c=relaxed/simple;
	bh=sG3xSJBHCLxYNe+yQ1jmP/NbHtOtHbAIfPzWBAl+T30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSr31m8D1qoM4bzXLjIJZ8JxNpvgBgas1Jd+amEfTIHT/iXLbvNE5C0Qr7ztNHmUjkNa64zT294hYV71PeLZ8l6Dti+/0+qwyxkFDiEHNSJR1k+d8jsqBpOQBZfYSkqNkQp3kKhqeVvks3XV5lub5/q7Wo1ed1gds9ZJMNrbj3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlW8wKOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlW8wKOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C98C4CEF7;
	Mon, 29 Dec 2025 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025486;
	bh=sG3xSJBHCLxYNe+yQ1jmP/NbHtOtHbAIfPzWBAl+T30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlW8wKOKsTGNobI9PKu0DbJ7qnXugJMeBqNh7F4D8/JFw9i4QAk5L1sBTKA1/oILg
	 LecDWwFG1LJWZRWSJbkU20xP6pgTV88YIk48ORpmIRvyrnOCEtCDYTSp1OevWFKbFG
	 J4Osgn03OBW3355+WB2ONr4jfAFJjFB4lxhLhuC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tip ten Brink <tip@tenbrinkmeijs.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 230/430] io_uring: fix min_wait wakeups for SQPOLL
Date: Mon, 29 Dec 2025 17:10:32 +0100
Message-ID: <20251229160732.818889985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit e15cb2200b934e507273510ba6bc747d5cde24a3 upstream.

Using min_wait, two timeouts are given:

1) The min_wait timeout, within which up to 'wait_nr' events are
   waited for.
2) The overall long timeout, which is entered if no events are generated
   in the min_wait window.

If the min_wait has expired, any event being posted must wake the task.
For SQPOLL, that isn't the case, as it won't trigger the io_has_work()
condition, as it will have already processed the task_work that happened
when an event was posted. This causes any event to trigger post the
min_wait to not always cause the waiting application to wakeup, and
instead it will wait until the overall timeout has expired. This can be
shown in a test case that has a 1 second min_wait, with a 5 second
overall wait, even if an event triggers after 1.5 seconds:

axboe@m2max-kvm /d/iouring-mre (master)> zig-out/bin/iouring
info: MIN_TIMEOUT supported: true, features: 0x3ffff
info: Testing: min_wait=1000ms, timeout=5s, wait_nr=4
info: 1 cqes in 5000.2ms

where the expected result should be:

axboe@m2max-kvm /d/iouring-mre (master)> zig-out/bin/iouring
info: MIN_TIMEOUT supported: true, features: 0x3ffff
info: Testing: min_wait=1000ms, timeout=5s, wait_nr=4
info: 1 cqes in 1500.3ms

When the min_wait timeout triggers, reset the number of completions
needed to wake the task. This should ensure that any future events will
wake the task, regardless of how many events it originally wanted to
wait for.

Reported-by: Tip ten Brink <tip@tenbrinkmeijs.com>
Cc: stable@vger.kernel.org
Fixes: 1100c4a2656d ("io_uring: add support for batch wait timeout")
Link: https://github.com/axboe/liburing/issues/1477
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2551,6 +2551,9 @@ static enum hrtimer_restart io_cqring_mi
 			goto out_wake;
 	}
 
+	/* any generated CQE posted past this time should wake us up */
+	iowq->cq_tail = iowq->cq_min_tail;
+
 	hrtimer_update_function(&iowq->t, io_cqring_timer_wakeup);
 	hrtimer_set_expires(timer, iowq->timeout);
 	return HRTIMER_RESTART;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D723DE443;
	Mon,  4 May 2026 14:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904525; cv=none; b=FRAtIVLbYX4/WrXZS4w2QvdyTSBlwyJCrAT1UiWDB0pqumn9C4/A+C2VGk7vusuCFja2zk5y8rDaDBpm5m6CDw5tV5Wiy1zdd1jxv9EA8s0jlqu5gFYswKSIYkZiEzNjLKDU5fCWC4uoz7aPBhzRDjCyII+cbj2J5/ILRe5Vnms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904525; c=relaxed/simple;
	bh=thrqqfuCkUiAw4fjcmFEiF1Y//jPkCldqfG9NGBHwEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H9Dbzc/Hmt/ui6CcgV100ph+nYnPRywShjsAZKHfMyePKQW6VGv1foTS7MW7FmZdCOYouFufPbILzjWsddSgDoiEc76Kn//pyu0ZEUiUlXViHgy9zeoKC04K7zU9ZCFBdXXXwCBD3TgtxqCtMlzueBKFpiOJmIXbyxwlS7mSiaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBl4Lsg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBl4Lsg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A28AC2BCB8;
	Mon,  4 May 2026 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904524;
	bh=thrqqfuCkUiAw4fjcmFEiF1Y//jPkCldqfG9NGBHwEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBl4Lsg2dWeNJT65NCIO3JAH/kIM8WWzJ5Tfe/rwEEV+VkTeQZxn37cAA/q/YOK8v
	 GuUUNmBJsEuvGQ5ijrE0uVEavHBxJGzxMzKvsF8t6pkXW/6nyAWOXOVNoUL74CT/VE
	 XFdbGTwtZC2y50C2vT92gZ8Oh/T6WIcYU3ICRgxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Azizcan=20Da=C5=9Ftan?= <azizcan.d@mileniumsec.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 073/215] io_uring/poll: ensure EPOLL_ONESHOT is propagated for EPOLL_URING_WAKE
Date: Mon,  4 May 2026 15:51:32 +0200
Message-ID: <20260504135132.834397550@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 1967f0b1cafdde37aa9e08e6021c14bcc484b7a5 upstream.

Commit:

aacf2f9f382c ("io_uring: fix req->apoll_events")

fixed an issue where poll->events and req->apoll_events weren't
synchronized, but then when the commit referenced in Fixes got added,
it didn't ensure the same thing.

If we mask in EPOLLONESHOT in the regular EPOLL_URING_WAKE path, then
ensure it's done for both. Including a link to the original report
below, even though it's mostly nonsense. But it includes a reproducer
that does show that IORING_CQE_F_MORE is set in the previous CQE,
while no more CQEs will be generated for this request. Just ignore
anything that pretends this is security related in any way, it's just
the typical AI nonsense.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/io-uring/CAM0zi7yQzF3eKncgHo4iVM5yFLAjsiob_ucqyWKs=hyd_GqiMg@mail.gmail.com/
Reported-by: Azizcan Daştan <azizcan.d@mileniumsec.com>
Fixes: 4464853277d0 ("io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -446,8 +446,10 @@ static int io_poll_wake(struct wait_queu
 		 * disable multishot as there is a circular dependency between
 		 * CQ posting and triggering the event.
 		 */
-		if (mask & EPOLL_URING_WAKE)
+		if (mask & EPOLL_URING_WAKE) {
 			poll->events |= EPOLLONESHOT;
+			req->apoll_events |= EPOLLONESHOT;
+		}
 
 		/* optional, saves extra locking for removal in tw handler */
 		if (mask && poll->events & EPOLLONESHOT) {



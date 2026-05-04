Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9E03A7F4C;
	Mon,  4 May 2026 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903879; cv=none; b=avwcxfzYQiUev2QCOuinHy1SK9Fxb2wPxUOSh8ak5F8AtxA35uq5xhsBl5cnVQu+Xhb302bc+Wu5T3TH75C7nWFdhVFRC0WyJkvjFdqgCMspJWTL23Vv4NcWfvS94ZUY6jg+KrXrnDwtSopN9wVKL6H3G0JIJWoXnUu5HuUpDTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903879; c=relaxed/simple;
	bh=Yc2l4jFcW2a8oueqCEQM4jmkrnzVnr/OGdPahHHCEyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=emdDgYlsGhDKhRMa/4Gl2W2unILW9wwzlzSEdyFaKW6HADqXkl7bUfX1BiguXxwBlN0497q8qmY3y9SS+gOMR5I8b1WscjS4NppeRt/JcpmvM8QiVM8pWwv4HWClVJidrgYhY8yTnolHtZBWoKwcRqf2Kp3o/vwL59sWAFC+7l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvigqtRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvigqtRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B80C2BCB8;
	Mon,  4 May 2026 14:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903879;
	bh=Yc2l4jFcW2a8oueqCEQM4jmkrnzVnr/OGdPahHHCEyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvigqtRpb18nFdlXykCfxpFv+2NHcQj8mxjvFimF8SjBSlIb2ZtKBAi+zfrBMCAsJ
	 5ni3tAzcaBVHlA1N0ixAgWUF3GuJ6bZmwlBP/iTsUXpqfdCCEY3UoCruCMEUSRSlUm
	 w24SeRrdL7vvElc7fK6xYld2NZ4rvLkRBQiSEmP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Azizcan=20Da=C5=9Ftan?= <azizcan.d@mileniumsec.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 098/275] io_uring/poll: ensure EPOLL_ONESHOT is propagated for EPOLL_URING_WAKE
Date: Mon,  4 May 2026 15:50:38 +0200
Message-ID: <20260504135146.559050091@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -412,8 +412,10 @@ static int io_poll_wake(struct wait_queu
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



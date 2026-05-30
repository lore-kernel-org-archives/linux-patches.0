Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782852FDC5E;
	Sat, 30 May 2026 18:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165899; cv=none; b=ujnA+Gnb+ZZOVwSixI6U4vm17tAhdw+q3kLmsyG4tL6IyCFkfsrB9Bcq9BUo7pAQihomiaIrcrl7ByfGFiKCYdmicJ/sTlhsO+LWBMrFS1l7PQH7kYVDIky9UlEESpMrSPRVdhfU0NrwUzil6ByHYUrOmrLvnKkf7OWcKMaooSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165899; c=relaxed/simple;
	bh=BnyjMCAAwabDy1hnGDhrLXkSSwu7S/tbSYptzXftJKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVkw7gnTymcEMbiaUL5tvGI+3AfzRpX2Pgk0BzChNvBS9Ht7Ft4nISrQJitbQSpEokVv5f9ODJRDiCP1+XrSmcYfk8y+NzGhOUdxPQufVO1rN8BkI6eo8JYavLtzjmwTxdkB0UmkviSgRzNzox5ynGTLj5cUAlXRwI5gmHBx+So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHyZzGEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHyZzGEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758C71F00893;
	Sat, 30 May 2026 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165898;
	bh=MKd1Z+WozyWvO8/NSGLTx9GuIYw0A7Gphy5TMfTFUG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHyZzGEHNT/RnQMjEV1CConx8I8tsTB+DH8plpUIILrbnz5KPTe8e21Y70rUmHp9J
	 uDvvo5YcgKem/RaVxkaeZqm3ZLvDW/HxvktdKlKT0hOAzrhlNQXy/VBZsi6vuUt541
	 xJsIMxm3cBk9bSwdELS8zRAb3K4DzrsRFUeQD5+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/589] io_uring/poll: fix EPOLL_URING_WAKE sometimes not being honored
Date: Sat, 30 May 2026 18:01:02 +0200
Message-ID: <20260530160229.644724641@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Rather than do the masking  only when we jump straight to execution,
mark it as EPOLLONESHOT regardless. This ensures it doesn't get lost.
And just kill the poll entry upfront, if marked. This is an optimization
in later kernels, but it's actually required on the older kernels to
note the EPOLL_URING_WAKE mask correctly.

Fixes: ccf06b5a981c ("io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dea1fb22c0efb..7cb4eeefd3cf4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5647,14 +5647,19 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	if (mask && !(mask & poll->events))
 		return 0;
 
+	/*
+	 * If we trigger a multishot poll off our own wakeup path,
+	 * disable multishot as there is a circular dependency between
+	 * CQ posting and triggering the event.
+	 */
+	if (mask & EPOLL_URING_WAKE)
+		poll->events |= EPOLLONESHOT;
+
 	if (io_poll_get_ownership(req)) {
-		/*
-		 * If we trigger a multishot poll off our own wakeup path,
-		 * disable multishot as there is a circular dependency between
-		 * CQ posting and triggering the event.
-		 */
-		if (mask & EPOLL_URING_WAKE)
-			poll->events |= EPOLLONESHOT;
+		if (mask && poll->events & EPOLLONESHOT) {
+			list_del_init(&poll->wait.entry);
+			smp_store_release(&poll->head, NULL);
+		}
 
 		__io_poll_execute(req, mask);
 	}
-- 
2.53.0




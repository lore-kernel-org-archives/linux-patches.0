Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE884854FF;
	Mon, 31 Aug 2026 13:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183484; cv=none; b=jiV2XGCQ/QUpZrPKinNJbWQy3IKiNnUn41vfzaovo2RokuF5ZwpueincJgCpy9GVJ9xQPQpwAGYMx1qqI3fZsVjvDuvCk/5cVgBqrqIs26umU65il+TURXMSOVKPagA0ExiGxWziOIOPa8zTnhdiF1USDGEaSKXW3aoDBEH1PnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183484; c=relaxed/simple;
	bh=kLScTsrcllmpj0crWCNO2tTZgDuFNuBC0/vs9wZy4eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkpUKdORFBeSVIR8QbnJgOAaxNYyWcSw/WQ3IfXnST0AmhbVz8OPAfqCJdsbLe4eaKZ9xADLYrp2Hj8XGxOF8lnDxasL2dm3DD3yTnF5yjbnuECMZEd0zayO7mcE5OJE6EdSmW5Y3YIcU1LXuntmR1cYhUiw9WnLq6Sn2h56W2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgN4uKIo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgN4uKIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91CB1F000E9;
	Mon, 31 Aug 2026 13:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183483;
	bh=cMiB/XVbJ2HaJ2yKntrLlVL/u8hsI/wrgPL0qT3AsKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgN4uKIoEyiIZyGJaZfk79vekF+oGCFwtblENops6/Hgq8kp73DpSY3hjalUXTti7
	 XZV/dc+ukRnDXiS2RlomhOuO0dW7tXwI3vJdjMh0cMOT3EHn1eGQo+LFEoUHsbIAE9
	 ZYQ8l3fMST2s57ajCXt+Ldd6LcEM71fXjtBdylOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d6540a3fa1626e11360d@syzkaller.appspotmail.com,
	Rochan Avlur <rochan.avlur@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.2 15/71] fuse: wait for FR_FINISHED on abort_on_kill to prevent use-after-free
Date: Mon, 31 Aug 2026 15:33:40 +0200
Message-ID: <20260831133359.778429557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rochan Avlur <rochan.avlur@gmail.com>

commit 64b0b5cacbd2fea88001464cb712c9dfc795b26e upstream.

The abort_on_kill path in request_wait_answer() calls fuse_abort_conn()
and returns without waiting for FR_FINISHED.  If fuse_dev_do_write() is
concurrently processing the same request (FR_LOCKED set), the caller
frees req->args while it is still being accessed, causing a
use-after-free.

Fix this by jumping to the existing wait_event(FR_FINISHED) instead of
returning early.  The wait will not hang because fuse_abort_conn()
ensures all requests are ended.

Reported-by: syzbot+d6540a3fa1626e11360d@syzkaller.appspotmail.com
Fixes: 204aa22a686b ("fuse: abort on fatal signal during sync init")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Rochan Avlur <rochan.avlur@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -729,7 +729,7 @@ static void request_wait_answer(struct f
 
 		if (req->args->abort_on_kill) {
 			fuse_chan_abort(fch, false);
-			return;
+			goto wait_for_finish;
 		}
 
 		if (test_bit(FR_URING, &req->flags))
@@ -740,6 +740,7 @@ static void request_wait_answer(struct f
 			return;
 	}
 
+wait_for_finish:
 	/*
 	 * Either request is already in userspace, or it was forced.
 	 * Wait it out.



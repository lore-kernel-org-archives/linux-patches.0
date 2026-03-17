Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAC73EDADD;
	Tue, 17 Mar 2026 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767060; cv=none; b=WaRMm6dp7YPmvvF83b1wo4NDj8/68WPGqrIRXXZjqXCDidKJELXSgdIuy21ZrAMVjMcBEMfyd3kviVuAApvvOY6rn3L71/aGYE489p9KfRvG3tXcAir3gXBMg80BP4qjAfoyj3ucF9s5dDsFxzQtY5BKcMRZEQGAPliUmYCpcTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767060; c=relaxed/simple;
	bh=yu+ySeld9VjmZOKUlf3QrCha5RwUYz7ooFJLIBpCG68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRMVslt3XE4GgTEE+YhPJc4NcCKarpyJU6mLVQrkdV3fugUP5hk71aW455mbey8XJ0A4AR9GeFrw84a3sqT+8gYgWDEq/OGtxD5mDE2oOh8blZXaJPOzRk48pYIiBNt41uzc+r8oBfC+Wg5zsr0vRgrYbCpnzL0W1IMZ+dhdEzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2mSlJP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2mSlJP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2747C19424;
	Tue, 17 Mar 2026 17:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767059;
	bh=yu+ySeld9VjmZOKUlf3QrCha5RwUYz7ooFJLIBpCG68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2mSlJP/JCxuc9lUg6nyfHkWzNpwAxT0t4OhFZ2xdemNfaXYOZdCC4qNV4mGesbzp
	 XTbuT1UWXr9j2ODWfH9aL5kamNXNnXHHsMgrQtFdht3AWTSkdR9cbE5aR7cipUHFsR
	 n+Eyr/bXP0+CUwhYkqZeiu2ggeFa5YZJKSO86huk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 377/378] io_uring/eventfd: use ctx->rings_rcu for flags checking
Date: Tue, 17 Mar 2026 17:35:34 +0100
Message-ID: <20260317163020.850362594@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 177c69432161f6e4bab07ccacf8a1748a6898a6b upstream.

Similarly to what commit e78f7b70e837 did for local task work additions,
use ->rings_rcu under RCU rather than dereference ->rings directly. See
that commit for more details.

Cc: stable@vger.kernel.org
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/eventfd.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -76,11 +76,15 @@ void io_eventfd_signal(struct io_ring_ct
 {
 	bool skip = false;
 	struct io_ev_fd *ev_fd;
-
-	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
-		return;
+	struct io_rings *rings;
 
 	guard(rcu)();
+
+	rings = rcu_dereference(ctx->rings_rcu);
+	if (!rings)
+		return;
+	if (READ_ONCE(rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
+		return;
 	ev_fd = rcu_dereference(ctx->io_ev_fd);
 	/*
 	 * Check again if ev_fd exists in case an io_eventfd_unregister call



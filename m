Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800D23D961;
	Mon,  1 Apr 2024 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988448; cv=none; b=S1xj1gTR4m/zjzvjkOtYFq0edh6cqd+zhQW5odbthdH0wI7UMwHlmczHOeco/2NmVLXOLbvP6DhbQqz0rAbHR0qttYU85odAjUtFQJaomZbAJqATIG/Wdt9ORRVdTSTDajDHwonfL7KrYP9CJV9KkbE5MAmWMoaavP2Huf5JuPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988448; c=relaxed/simple;
	bh=PZEiWpJli4hSFnLXEV766YvXcCZF4x5Y1lgyKD0aufg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/QC5Zs8w/XmDUQHm5cipuuboPIA3AKLgNr0uqhXy9Xnv6ZqRwNwcPhb2VXK7Aj57YWQaubzOgZ+rP/ABzLjttYJW3zO4iY+uFa05THP03UlEYsg3htZH6VpbX18wTmaP1UXYLsHAkXYgRgBElI7Qr3Q3QGUSoQeYTxcl4+6KfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPNFJb9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPNFJb9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD5BC433F1;
	Mon,  1 Apr 2024 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988448;
	bh=PZEiWpJli4hSFnLXEV766YvXcCZF4x5Y1lgyKD0aufg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPNFJb9Z/tLBnSk8bMYztWb+Y9f07KqpUasht6egaV8ln49PpywgpDGz20zaapaKg
	 jE+GXQHX3XcOvbiuJsNwtVbHQZOcIOoa4d5wGnA0Gsf/0/eZDDl1fPyZMpQrgpgot+
	 jDWjfCSU2D8RZqcKFIoX2PXPRsExA8ys4jd2y+KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 187/432] io_uring/futex: always remove futex entry for cancel all
Date: Mon,  1 Apr 2024 17:42:54 +0200
Message-ID: <20240401152558.720064482@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 30dab608c3cb99c2a05b76289fd05551703979ae ]

We know the request is either being removed, or already in the process of
being removed through task_work, so we can delete it from our futex list
upfront. This is important for remove all conditions, as we otherwise
will find it multiple times and prevent cancelation progress.

Cc: stable@vger.kernel.org
Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Fixes: 8f350194d5cf ("io_uring: add support for vectored futex waits")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/futex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 3c3575303c3d0..792a03df58dea 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -159,6 +159,7 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 	hlist_for_each_entry_safe(req, tmp, &ctx->futex_list, hash_node) {
 		if (!io_match_task_safe(req, task, cancel_all))
 			continue;
+		hlist_del_init(&req->hash_node);
 		__io_futex_cancel(ctx, req);
 		found = true;
 	}
-- 
2.43.0




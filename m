Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CB41487CD;
	Thu, 12 Dec 2024 15:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017365; cv=none; b=r5TW/ZwI5VQXRbpgEFG+HvgXTbnna4b5u+Pm7a8Guobx9Y7PO5xqzFTnLhPh0tlrgEkZ0RBzeP1IbJh3UYa4J7gKtP9DjqGCd5ydc8Bi05VpU8rImtmjc4CHgFzQ0cHDCHdD9At666vsDBqopOD6zkY8NT+PuvplYFytDiJkY44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017365; c=relaxed/simple;
	bh=kSBtl29vcEYW1rY8Chtxun/wKTXvOvpuJnAWbhcSnTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7MlVBhAlkTn//79yHxhYESEh6J1S+7D/1fk9CFF9MMSfk+5U+TM9KlrmQQBFsoQSMcfD+BXTjc7K24aDHpc2C/KqjnY+pArghkAHDhpFx8KIR9IXPbHQO4PpbHyImhoPG7LAmqd9ZkgNuedIanz5/wqdGWFuMoEuz7dltJ2fX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCOHO+rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCOHO+rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FD0C4CECE;
	Thu, 12 Dec 2024 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017364;
	bh=kSBtl29vcEYW1rY8Chtxun/wKTXvOvpuJnAWbhcSnTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCOHO+rhk+mhHx6r424jb3zFDbcm4Kwfoijqfi5x5UhXj3I6/uUmviQBk2GKDIN5X
	 RA3SCiHo6Cn9DaMbZo4RWrpE+Dmo0hEWS3rqATI8kjMRSFmbeuoa0JFHPUUW4iZ57U
	 SRtm+0XiEbNypkhTRbdB+nZ5Dz6a3melxJiTK6Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 429/466] io_uring/tctx: work around xa_store() allocation error issue
Date: Thu, 12 Dec 2024 15:59:58 +0100
Message-ID: <20241212144323.820070140@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 7eb75ce7527129d7f1fee6951566af409a37a1c4 ]

syzbot triggered the following WARN_ON:

WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51

which is the

WARN_ON_ONCE(!xa_empty(&tctx->xa));

sanity check in __io_uring_free() when a io_uring_task is going through
its final put. The syzbot test case includes injecting memory allocation
failures, and it very much looks like xa_store() can fail one of its
memory allocations and end up with ->head being non-NULL even though no
entries exist in the xarray.

Until this issue gets sorted out, work around it by attempting to
iterate entries in our xarray, and WARN_ON_ONCE() if one is found.

Reported-by: syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/673c1643.050a0220.87769.0066.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/tctx.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index c043fe93a3f23..84f6a83857204 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -47,8 +47,19 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 void __io_uring_free(struct task_struct *tsk)
 {
 	struct io_uring_task *tctx = tsk->io_uring;
+	struct io_tctx_node *node;
+	unsigned long index;
 
-	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	/*
+	 * Fault injection forcing allocation errors in the xa_store() path
+	 * can lead to xa_empty() returning false, even though no actual
+	 * node is stored in the xarray. Until that gets sorted out, attempt
+	 * an iteration here and warn if any entries are found.
+	 */
+	xa_for_each(&tctx->xa, index, node) {
+		WARN_ON_ONCE(1);
+		break;
+	}
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
-- 
2.43.0




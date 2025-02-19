Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B013E1C7B62;
	Wed, 19 Feb 2025 08:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954819; cv=none; b=ZZlvc7dkWSU8oNvxhQXkRXB6kZwrBvRDUg3FgxAX0KTqUKSPnCHGyMKdr+ALtZ+segJXR9VDCp93WeTNQhzU5GSn+UkJyHC11vkCzK8/TiEOeXjxwXYl5wPlbb9qSHAw9V9YK1InubfXyCpLu8B9NDF+ueiH1FGZlaTNoFh+rEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954819; c=relaxed/simple;
	bh=5AytZi5iIoVwvh8PKhfkxyPivmGL9S3yynDtoeZop0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOBz6otCytT2DWIPpUtAyfBtblSa1AZuLcfHh7sI5QM49W5AKjLVLfEC6GRS5WT9r3RvTA0MJIxngYHezqy8G5OHXEE10WOONIy7BAyxKU2+NM0sK3lMCJvCfDTi1z3/3oCLobt1S1qPwJQ4/etRd5lxmq700YbdILv2xW+Ab9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3B+vqZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3B+vqZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F8FC4CEE6;
	Wed, 19 Feb 2025 08:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954819;
	bh=5AytZi5iIoVwvh8PKhfkxyPivmGL9S3yynDtoeZop0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3B+vqZFL0FpF3Ec8gyvY3wybN6Vpuh2iELN7tR+ZPWOCpm++gkgH9yNsaGqQD5a4
	 uKdVlNx90yLRRMn0EZ3fZzH3BA4WRFa/KZE5mp31xUB/5bfICobScc9YnCIaamdzas
	 XAPlTiw5X7MWe9hQcVgai+d2e4LbjzAYzfbQU1Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/230] io_uring/uring_cmd: remove dead req_has_async_data() check
Date: Wed, 19 Feb 2025 09:26:03 +0100
Message-ID: <20250219082603.513531682@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 0edf1283a9d1419a2095b4fcdd95c11ac00a191c ]

Any uring_cmd always has async data allocated now, there's no reason to
check and clear a cached copy of the SQE.

Fixes: d10f19dff56e ("io_uring/uring_cmd: switch to always allocating async data")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/uring_cmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 874f9e2defd58..b2ce4b5610027 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -65,9 +65,6 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 			continue;
 
 		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
-			/* ->sqe isn't available if no async data */
-			if (!req_has_async_data(req))
-				cmd->sqe = NULL;
 			file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL |
 						   IO_URING_F_COMPLETE_DEFER);
 			ret = true;
-- 
2.39.5




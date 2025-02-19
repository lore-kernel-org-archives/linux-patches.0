Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6B81E0E0D;
	Wed, 19 Feb 2025 08:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954589; cv=none; b=D3PZOYi7DT1a/NUgadSOer0MPvS+UwCuejBYwrpUUMzl5/P+WMd8fEAfMGXXa+aGYzsAOkrCe+y4CBMTwDFSr98cQztdDRaOgTG1IoDSlzjUjxqTkyJjFmrt06xtQs5wt6M2jAA2P+WX24aq+bNzeT2xKcE2f212xj1yus8f7To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954589; c=relaxed/simple;
	bh=xq3kwD/pX35HGsRP8QOVAb29d5ccPMrhGxU/yx+zlbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNi7nzIg6lFyV4XdxvoLYgD00zfcPJ/6gxRYdCaCRWrVzk4FnpWv4UX2KnHJShKzDpnoWFj10TB8Milgq5kn7dd51MLk27w1d688XuLXMLfLEfS4j+9ln85Oz5nZFJiujJzDyUs+k2JfPaYbrnsvUkq8rzzXyyktBtyhff2IHgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aazLJzt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aazLJzt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7A5C4CEE6;
	Wed, 19 Feb 2025 08:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954589;
	bh=xq3kwD/pX35HGsRP8QOVAb29d5ccPMrhGxU/yx+zlbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aazLJzt4e/k3EQCsb/70yM6D1XNsOVcQAr8XYQuOnOz4keO3bDe3xS+IQcr+d5o2D
	 dP6SD4g4aS6xlUAr9ZpkCFYxe17OJF7w36A58rThW70iOMA28GL2Q27nDJRvacQyyC
	 LJnIyCmb5Ywckb/3opKrxoFjt8uw0EGKIjkyRZok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Li Zetao <lizetao1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 251/274] io_uring/uring_cmd: unconditionally copy SQEs at prep time
Date: Wed, 19 Feb 2025 09:28:25 +0100
Message-ID: <20250219082619.402908884@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit d6211ebbdaa541af197b50b8dd8f22642ce0b87f ]

This isn't generally necessary, but conditions have been observed where
SQE data is accessed from the original SQE after prep has been done and
outside of the initial issue. Opcode prep handlers must ensure that any
SQE related data is stable beyond the prep phase, but uring_cmd is a bit
special in how it handles the SQE which makes it susceptible to reading
stale data. If the application has reused the SQE before the original
completes, then that can lead to data corruption.

Down the line we can relax this again once uring_cmd has been sanitized
a bit, and avoid unnecessarily copying the SQE.

Fixes: 5eff57fa9f3a ("io_uring/uring_cmd: defer SQE copying until it's needed")
Reported-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/uring_cmd.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 0ec58fcd6fc9b..8c44a5198414e 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -185,15 +185,6 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-static void io_uring_cmd_cache_sqes(struct io_kiocb *req)
-{
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	struct io_uring_cmd_data *cache = req->async_data;
-
-	memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = cache->sqes;
-}
-
 static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
@@ -204,10 +195,15 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	if (unlikely(!cache))
 		return -ENOMEM;
 
-	ioucmd->sqe = sqe;
-	/* defer memcpy until we need it */
-	if (unlikely(req->flags & REQ_F_FORCE_ASYNC))
-		io_uring_cmd_cache_sqes(req);
+	/*
+	 * Unconditionally cache the SQE for now - this is only needed for
+	 * requests that go async, but prep handlers must ensure that any
+	 * sqe data is stable beyond prep. Since uring_cmd is special in
+	 * that it doesn't read in per-op data, play it safe and ensure that
+	 * any SQE data is stable beyond prep. This can later get relaxed.
+	 */
+	memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = cache->sqes;
 	return 0;
 }
 
@@ -270,16 +266,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
-	if (ret == -EAGAIN) {
-		struct io_uring_cmd_data *cache = req->async_data;
-
-		if (ioucmd->sqe != cache->sqes)
-			io_uring_cmd_cache_sqes(req);
-		return -EAGAIN;
-	} else if (ret == -EIOCBQUEUED) {
-		return -EIOCBQUEUED;
-	}
-
+	if (ret == -EAGAIN || ret == -EIOCBQUEUED)
+		return ret;
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_uring_cleanup(req, issue_flags);
-- 
2.39.5




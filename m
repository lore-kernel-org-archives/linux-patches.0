Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA691ADC84;
	Wed, 19 Feb 2025 08:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954678; cv=none; b=SyBnc5Ipi+0UCygpy5Pr2Q5tQ7frIcZfMOsJawmq1xETYMjixxwjY4GCYJJyCq9c8rg/1hVPIeTUSK/W+s5LrJzOwKubimsQ+okbgBDIT7w4IlBCCghqMlnKHNltQuH0QEG8RERuhk2qfUIgTmzytQgcPk8xo4ooM/tE2xL99U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954678; c=relaxed/simple;
	bh=3uKh5KJk71ZcaV+nZ11OWuDEpMs2mwyS+Wyjdy2ssjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2HMB0i4x1LeUfFPAT7T1VaaklBBI6jhfaEG8fXxD6vC5hXW4d0TCD3Xsm7Dvf4ARrKQiNXLC9O0jzvRXAL7yIKawPOpEVQfjqBRZMMxFumGiSFG5XVBh6+WrMq+RiRD4YMQmj5fmAOVJ/8qf5sgSoLMPLdZwb8MhSemQbVBkZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kufz3UxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kufz3UxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B69C4CED1;
	Wed, 19 Feb 2025 08:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954678;
	bh=3uKh5KJk71ZcaV+nZ11OWuDEpMs2mwyS+Wyjdy2ssjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kufz3UxGT7Ukbxuob7+l4U1Gil1+oWrdtvtaw/vSZz8sFawlXKL1ZmIAbUyKouOek
	 kIk5Ku+/SFvLGLoEh8mGhBNFm7G2A4tYKgcxBjiEV47dAHjK1Mg+TwpARre1mNNuR2
	 Ael5Obad2+INj7xn5L94nHJ2NIvYpkTyuZfWSfzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 247/274] io_uring/uring_cmd: switch sqe to async_data on EAGAIN
Date: Wed, 19 Feb 2025 09:28:21 +0100
Message-ID: <20250219082619.247289146@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit e663da62ba8672aaa66843f1af8b20e3bb1a0515 ]

5eff57fa9f3a ("io_uring/uring_cmd: defer SQE copying until it's needed")
moved the unconditional memcpy() of the uring_cmd SQE to async_data
to 2 cases when the request goes async:
- If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
- If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue

Unlike the REQ_F_FORCE_ASYNC case, in the EAGAIN case, io_uring_cmd()
copies the SQE to async_data but neglects to update the io_uring_cmd's
sqe field to point to async_data. As a result, sqe still points to the
slot in the userspace-mapped SQ. At the end of io_submit_sqes(), the
kernel advances the SQ head index, allowing userspace to reuse the slot
for a new SQE. If userspace reuses the slot before the io_uring worker
reissues the original SQE, the io_uring_cmd's SQE will be corrupted.

Introduce a helper io_uring_cmd_cache_sqes() to copy the original SQE to
the io_uring_cmd's async_data and point sqe there. Use it for both the
REQ_F_FORCE_ASYNC and EAGAIN cases. This ensures the uring_cmd doesn't
read from the SQ slot after it has been returned to userspace.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 5eff57fa9f3a ("io_uring/uring_cmd: defer SQE copying until it's needed")
Link: https://lore.kernel.org/r/20250212204546.3751645-3-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/uring_cmd.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b72154fefbee9..0ec58fcd6fc9b 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -185,6 +185,15 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
+static void io_uring_cmd_cache_sqes(struct io_kiocb *req)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	struct io_uring_cmd_data *cache = req->async_data;
+
+	memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = cache->sqes;
+}
+
 static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
@@ -195,14 +204,10 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	if (unlikely(!cache))
 		return -ENOMEM;
 
-	if (!(req->flags & REQ_F_FORCE_ASYNC)) {
-		/* defer memcpy until we need it */
-		ioucmd->sqe = sqe;
-		return 0;
-	}
-
-	memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = cache->sqes;
+	ioucmd->sqe = sqe;
+	/* defer memcpy until we need it */
+	if (unlikely(req->flags & REQ_F_FORCE_ASYNC))
+		io_uring_cmd_cache_sqes(req);
 	return 0;
 }
 
@@ -269,7 +274,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		struct io_uring_cmd_data *cache = req->async_data;
 
 		if (ioucmd->sqe != cache->sqes)
-			memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
+			io_uring_cmd_cache_sqes(req);
 		return -EAGAIN;
 	} else if (ret == -EIOCBQUEUED) {
 		return -EIOCBQUEUED;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712542BB15;
	Thu, 30 Jan 2025 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245588; cv=none; b=a2rAbtdlkmVAfAwrpEQxeVtHnI6d6gWI8HZ5dpoLUgjQ2m8YajppW5QkqjaJesasntazHX8o25/ukANN/I+kZTvvFDCvhJBek1UURZ6hozjJ18Vw/rbzJ+9ZsMPvqSEDrthEUlf5ZZhyXpsoOv34CSBhM0x8LWpFuZM27kRHhpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245588; c=relaxed/simple;
	bh=SHM8MgAd2I5MtEsxoANk4RQTf4acgNoj2DMgbBcDw/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEggTBOjB+wMKXj9bmR1fDedSvepDTvWBqJl8chEgsk242FWwCK2Cs7OuOT5E1RnrK5xqUjGLxZbGir3ahtFRHUTX8UnXjNNgEsZiaXABhNqWLCQFBJcuB0pd33Xny9wu50dgdZmE7Ci/tm1mS0JyBkpWJk85mNXBsADiUytlxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSJYVn7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSJYVn7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025ECC4CED2;
	Thu, 30 Jan 2025 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245588;
	bh=SHM8MgAd2I5MtEsxoANk4RQTf4acgNoj2DMgbBcDw/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSJYVn7Dq246XLHDs8jguV46GPUnBnGxL1RbR7P7XLk+nCAt2TRSSs9c5PYxVIvNz
	 m/WwOFV8n0Dr/E6Kv+H3k/phevzjUVCHq9gWIWrGb/x94rM2UyG3e+3czvcZNZarCQ
	 O/RTrMwBccl+++a/+gSqhVlqJEzcIWNkdJMZjdsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 18/25] io_uring/rsrc: require cloned buffers to share accounting contexts
Date: Thu, 30 Jan 2025 14:59:04 +0100
Message-ID: <20250130133457.675520105@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 19d340a2988d4f3e673cded9dde405d727d7e248 upstream.

When IORING_REGISTER_CLONE_BUFFERS is used to clone buffers from uring
instance A to uring instance B, where A and B use different MMs for
accounting, the accounting can go wrong:
If uring instance A is closed before uring instance B, the pinned memory
counters for uring instance B will be decremented, even though the pinned
memory was originally accounted through uring instance A; so the MM of
uring instance B can end up with negative locked memory.

Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/r/CAG48ez1zez4bdhmeGLEFxtbFADY4Czn3CV0u9d_TMcbvRA01bg@mail.gmail.com
Fixes: 7cc2a6eadcd7 ("io_uring: add IORING_REGISTER_COPY_BUFFERS method")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20250114-uring-check-accounting-v1-1-42e4145aa743@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -931,6 +931,13 @@ static int io_clone_buffers(struct io_ri
 	int i, ret, off, nr;
 	unsigned int nbufs;
 
+	/*
+	 * Accounting state is shared between the two rings; that only works if
+	 * both rings are accounted towards the same counters.
+	 */
+	if (ctx->user != src_ctx->user || ctx->mm_account != src_ctx->mm_account)
+		return -EINVAL;
+
 	/* if offsets are given, must have nr specified too */
 	if (!arg->nr && (arg->dst_off || arg->src_off))
 		return -EINVAL;



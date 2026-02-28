Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D787346E77
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302242; cv=none; b=PXwo2mVD/BPLLmVUPYJk8jM/5190JxPBJf9HAaZB/v7Ihi9Ck4YeSLXDy88lk6v1pVOv1ZWw14K4Q5vbmND2quFXYugyHlizKpg9yVOZkN8x6D4JP3YkV6f5ZsEvD9kbF1hLu/TdRQiSyGe9MnR5bbUbPgbj2V4riO2pzcyOo5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302242; c=relaxed/simple;
	bh=gsvBkg4/k8wIf/lOtXXhW4jc3ZJKEGlz8qO7HiOPIqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfdVk931knAApYJcBYu4vNnbjAOHHpStGNRRRlHgHW777HbLbx6+tVAat0mbJVR3tGGdzD04dOPqw2EidCQJEB+l1wvjLvY06vO4WmCPHu7AKRRrEKDcRG+H2QARAhu4rTryDwT9k8rKljyo4/MDhvdZTU00M03DI2oT0G0nOdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDwfc8gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDwfc8gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80D4C116D0;
	Sat, 28 Feb 2026 18:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302242;
	bh=gsvBkg4/k8wIf/lOtXXhW4jc3ZJKEGlz8qO7HiOPIqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDwfc8gryjZweUi1Tb1uoXC1ACx4cBEeRuxc9tWr2IAijctDadtLp4Iyw0WjQfn7k
	 pqSpQzVRcRm4/h557oT6YPyGd/byseguLWQGtrrKaC9Lg4MK+diIbgSR4Yi+Zk0H52
	 KSaJmcIm8snTxJBsh4bQ6GPSOiJwykvioERLxk4TL8pSAlne6L9oQs55aDyQSkyuD5
	 Z6Y37bCsi8/dqS5V1jG2ZLUVEVnBMd8TxfXl0C5n5umVjvcV/LlfvoxW3kTe1Kqqs9
	 ApQ3bmCFsAKsqK6RejqpJksgU7yVtxN1Hk/DvEh3r1xoamnrYQaX39R2FwWjyUcfsc
	 JESODdmwKGfwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/283] io_uring/cancel: de-unionize file and user_data in struct io_cancel_data
Date: Sat, 28 Feb 2026 13:06:36 -0500
Message-ID: <20260228180709.1583486-254-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 22dbb0987bd1e0ec3b1e4ad20756a98f99aa4a08 ]

By having them share the same space in struct io_cancel_data, it ends up
disallowing IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_USERDATA from
working. Eg you cannot match on both a file and user_data for
cancelation purposes. This obviously isn't a common use case as nobody
has reported this, but it does result in -ENOENT potentially being
returned when trying to match on both, rather than actually doing what
the API says it would.

Fixes: 4bf94615b888 ("io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index fc98622e6166e..7e6d0fca7db28 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -4,10 +4,8 @@
 
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
-	union {
-		u64 data;
-		struct file *file;
-	};
+	u64 data;
+	struct file *file;
 	u8 opcode;
 	u32 flags;
 	int seq;
-- 
2.51.0


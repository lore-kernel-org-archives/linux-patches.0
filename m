Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2752D839C;
	Wed, 25 Feb 2026 06:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002701; cv=none; b=Y+NkHqY6NNX+rEpdfS3hGCTvtm7NJxTkLeGXCf0Sv6P+8P5jCQLBLpFplBWsEHrhL3mSg3VfxwdSy2xRz6OCdpluYmleHaMQNuubeaVa9EMdpsNVrIwvc1PGvAKRyisIfI3dwgyKMgWBselZANMljPs8Q784bMR6+VbfbaKXjeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002701; c=relaxed/simple;
	bh=x7rPrJeAmQPuIFt/b5qUSSToR+iqyEoWSYHrFETECis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDxALHrNgPMx53X6HwM6NdllGJJ18fJNU5adyHNLo16LGP6LyD4gPZAO4p32uH0lC7doSf0EAS1pu4RA6aS9vkjgVAHQvuG7Dk65frBe+s+3QLMiZjEtu28Q+/DyJJ60vC4tv8xITthhckbI0LC2cdkEENQT0WKJBYYOBPJdMsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEjtqgKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEjtqgKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F1AC116D0;
	Wed, 25 Feb 2026 06:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002701;
	bh=x7rPrJeAmQPuIFt/b5qUSSToR+iqyEoWSYHrFETECis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEjtqgKPHUiOjXb3DET4vwGPcAru4pPdJdII3Fehu/Ybxdir99ZHe9ZWD9mUMF5NG
	 hIodNZd0j61zGLFTPc2b8BBIbppZUXX9xtFKXKihb8DBMcq8060/Xmw9EaK7yBazdu
	 QWbjhgv337sJ78aDcImfIH6TvPu3x6r/QPVLyBNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 499/641] io_uring/cancel: de-unionize file and user_data in struct io_cancel_data
Date: Tue, 24 Feb 2026 17:23:45 -0800
Message-ID: <20260225012400.611259052@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 43e9bb74e9d19..eaa4069e258c9 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -6,10 +6,8 @@
 
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




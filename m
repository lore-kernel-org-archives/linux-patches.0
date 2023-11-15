Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC70B37170
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYrVmUqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC17C433C8;
	Wed, 15 Nov 2023 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076354;
	bh=9jc5GGwd0Jy4Qty0j8b3dmqSxREKt2GxBzTHPMwTwA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYrVmUqneQ5fYhNwHWOh5T5pblj+LQ+RgvE1d8Dh0H6AdIeMtMhb9al+TQnA1jsdg
	 y8l1GXE+ziiNH27A6oort1ARHCtj8XdohZbZadDCJGQZIUbM6jDr/TPMkl+hKpCzqh
	 xDcc0kQCEao3y29iYMKMVBEv1EwloQ/jEchWpfvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 239/550] io_uring/kbuf: Allow the full buffer id space for provided buffers
Date: Wed, 15 Nov 2023 14:13:43 -0500
Message-ID: <20231115191617.275086598@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit f74c746e476b9dad51448b9a9421aae72b60e25f ]

nbufs tracks the number of buffers and not the last bgid. In 16-bit, we
have 2^16 valid buffers, but the check mistakenly rejects the last
bid. Let's fix it to make the interface consistent with the
documentation.

Fixes: ddf0322db79c ("io_uring: add IORING_OP_PROVIDE_BUFFERS")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/r/20231005000531.30800-3-krisman@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 427a995d26300..c4ec71801d4ad 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -19,12 +19,15 @@
 
 #define BGID_ARRAY	64
 
+/* BIDs are addressed by a 16-bit field in a CQE */
+#define MAX_BIDS_PER_BGID (1 << 16)
+
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
 	__u32				len;
 	__u32				bgid;
-	__u16				nbufs;
+	__u32				nbufs;
 	__u16				bid;
 };
 
@@ -293,7 +296,7 @@ int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
-	if (!tmp || tmp > USHRT_MAX)
+	if (!tmp || tmp > MAX_BIDS_PER_BGID)
 		return -EINVAL;
 
 	memset(p, 0, sizeof(*p));
@@ -336,7 +339,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
-	if (!tmp || tmp > USHRT_MAX)
+	if (!tmp || tmp > MAX_BIDS_PER_BGID)
 		return -E2BIG;
 	p->nbufs = tmp;
 	p->addr = READ_ONCE(sqe->addr);
@@ -356,7 +359,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	tmp = READ_ONCE(sqe->off);
 	if (tmp > USHRT_MAX)
 		return -E2BIG;
-	if (tmp + p->nbufs > USHRT_MAX)
+	if (tmp + p->nbufs > MAX_BIDS_PER_BGID)
 		return -EINVAL;
 	p->bid = tmp;
 	return 0;
-- 
2.42.0




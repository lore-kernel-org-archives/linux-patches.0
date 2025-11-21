Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFEA2750FB;
	Fri, 21 Nov 2025 13:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731113; cv=none; b=cX8nviYLywpYXONBjyLPxxpsrHdSd56eq89A1XIy8Mw4D/Tu1XPqaSOazQd1FE48lUgmqO5POhFmYOy+SXOieX2VOK002SdwxnaFKc5niAWEbxwB8QGqWOh4V/dCF/88fzgupvn0SnmfiCi3fQMz5nzzvqY7qI6nxpSAERkyww0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731113; c=relaxed/simple;
	bh=o1QH4DQwcFILUTmsjlqVqUiceyG5J4VJaPz+GFMXERo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnzMKy4eoRDMw6VvnV9r5NHM+NZoYZbrj8lViri3SGnUA61vgHQW5YY6lUOui+uF3wrXNoqHalSLWLkaHQ2G887VY3Uaahis9ml+w4w8mrY44hh0yhtrAgys8GIku+U8b9zjvp4hUO5jOxEDn1vNs1WzND+ZqvOVyPwf+cBRiaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaN8s92u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaN8s92u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755E9C4CEF1;
	Fri, 21 Nov 2025 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731112;
	bh=o1QH4DQwcFILUTmsjlqVqUiceyG5J4VJaPz+GFMXERo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaN8s92u14wPW9ZfC0xbI6gq6g8FWqlKu04r7LrVoB7uj0kUz3nuup5uFf+RltqmF
	 Tdbkg+/nM34t+p8evCoXLNQyUEQDnH1FD1O77Q7VBdKFoeiVGen8LMmC8zlBIxY1Mc
	 uYZcNqb4AucOiMNCagnttlmjBR3AzgX5ACCloB7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 095/247] io_uring/rsrc: dont use blk_rq_nr_phys_segments() as number of bvecs
Date: Fri, 21 Nov 2025 14:10:42 +0100
Message-ID: <20251121130158.001308865@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 2d0e88f3fd1dcb37072d499c36162baf5b009d41 ]

io_buffer_register_bvec() currently uses blk_rq_nr_phys_segments() as
the number of bvecs in the request. However, bvecs may be split into
multiple segments depending on the queue limits. Thus, the number of
segments may overestimate the number of bvecs. For ublk devices, the
only current users of io_buffer_register_bvec(), virt_boundary_mask,
seg_boundary_mask, max_segments, and max_segment_size can all be set
arbitrarily by the ublk server process.
Set imu->nr_bvecs based on the number of bvecs the rq_for_each_bvec()
loop actually yields. However, continue using blk_rq_nr_phys_segments()
as an upper bound on the number of bvecs when allocating imu to avoid
needing to iterate the bvecs a second time.

Link: https://lore.kernel.org/io-uring/20251111191530.1268875-1-csander@purestorage.com/
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5961f21dd65d1..b0852674730c5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -942,8 +942,8 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	struct req_iterator rq_iter;
 	struct io_mapped_ubuf *imu;
 	struct io_rsrc_node *node;
-	struct bio_vec bv, *bvec;
-	u16 nr_bvecs;
+	struct bio_vec bv;
+	unsigned int nr_bvecs = 0;
 	int ret = 0;
 
 	io_ring_submit_lock(ctx, issue_flags);
@@ -964,8 +964,11 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 		goto unlock;
 	}
 
-	nr_bvecs = blk_rq_nr_phys_segments(rq);
-	imu = io_alloc_imu(ctx, nr_bvecs);
+	/*
+	 * blk_rq_nr_phys_segments() may overestimate the number of bvecs
+	 * but avoids needing to iterate over the bvecs
+	 */
+	imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
 	if (!imu) {
 		kfree(node);
 		ret = -ENOMEM;
@@ -976,16 +979,15 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	imu->len = blk_rq_bytes(rq);
 	imu->acct_pages = 0;
 	imu->folio_shift = PAGE_SHIFT;
-	imu->nr_bvecs = nr_bvecs;
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
 	imu->priv = rq;
 	imu->is_kbuf = true;
 	imu->dir = 1 << rq_data_dir(rq);
 
-	bvec = imu->bvec;
 	rq_for_each_bvec(bv, rq, rq_iter)
-		*bvec++ = bv;
+		imu->bvec[nr_bvecs++] = bv;
+	imu->nr_bvecs = nr_bvecs;
 
 	node->buf = imu;
 	data->nodes[index] = node;
-- 
2.51.0




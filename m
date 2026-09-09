Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D02A58FD31;
	Wed,  9 Sep 2026 14:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964822; cv=none; b=ADgfATDa2+XXiEHnjDTkbI2Muj/De3OkWW2Fpqrp6vXTXPVTT2jr5c+qfcjrEdOIiSkWBM9VVziWJFflyAT6GBn9zgj7o9CTeYA4FsBHQGlHcJhXheRRxm9oDXdn00QpdVsmQBrlZecl1hX1yZl4S3KpHh37Om+MH5yr2UZf/Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964822; c=relaxed/simple;
	bh=upQq139ox4hTU/u1lKK+BJvwUZ2hNzy5SB37HgpSmzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A37ZKUAbJSYOU1Xa6E8lmYHLZZz9hVSvMRjx3/vBuj0BVXvFR57nu30k50DmKvFAt4+9LyjwTcdziEYWwCjjbTdYeoTEGh9Rpr20TpdKpbFD6BiuhU6goxV7W5FOnKKOexkQzpXnbZpCPwFXm87idQUeWOjA8kg/hJd6zwQ7Qps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpSd2kPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpSd2kPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F581F00A3D;
	Wed,  9 Sep 2026 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964821;
	bh=tqOuJsN6cqqXGOK6p1Pven/r4LU4CeRIFamA7SBxRTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpSd2kPT4yhayzV74VRiaRJJ3nOqKo9jA4FjklGD5CX7Fgl9RO/pCmG1nLiTtYelY
	 fjGlvpNxa96MDD7/+YDQ78I9rMR850GW/j8S3bBe5CjvbcF5ymmAgmJYURmQC+rJpf
	 /0ieDwqEqTfbH8HOU0spmjN+QByZ1HtI7aF3uX6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Jeff Layton <jlayton@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 518/583] fuse-uring: refactor setting up copy state for payload copying
Date: Wed,  9 Sep 2026 15:43:23 +0200
Message-ID: <20260909134255.666897446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit c0f9203732fc70de8d20697270bfe405481eac14 ]

Add a new helper function setup_fuse_copy_state() to contain the logic
for setting up the copy state for payload copying.

Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: fd10f40af314 ("fuse: copy request headers via a stack buffer for io-uring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -645,6 +645,27 @@ static int copy_header_from_ring(struct
 	return 0;
 }
 
+static int setup_fuse_copy_state(struct fuse_copy_state *cs,
+				 struct fuse_ring *ring, struct fuse_req *req,
+				 struct fuse_ring_ent *ent, int dir,
+				 struct iov_iter *iter)
+{
+	int err;
+
+	err = import_ubuf(dir, ent->payload, ring->max_payload_sz, iter);
+	if (err) {
+		pr_info_ratelimited("fuse: Import of user buffer failed\n");
+		return err;
+	}
+
+	fuse_copy_init(cs, dir == ITER_DEST, iter);
+
+	cs->is_uring = true;
+	cs->req = req;
+
+	return 0;
+}
+
 static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 				     struct fuse_req *req,
 				     struct fuse_ring_ent *ent)
@@ -660,15 +681,10 @@ static int fuse_uring_copy_from_ring(str
 	if (err)
 		return err;
 
-	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
-			  &iter);
+	err = setup_fuse_copy_state(&cs, ring, req, ent, ITER_SOURCE, &iter);
 	if (err)
 		return err;
 
-	fuse_copy_init(&cs, false, &iter);
-	cs.is_uring = true;
-	cs.req = req;
-
 	err = fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
 	fuse_copy_finish(&cs);
 	return err;
@@ -691,15 +707,9 @@ static int fuse_uring_args_to_ring(struc
 		.commit_id = req->in.h.unique,
 	};
 
-	err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
-	if (err) {
-		pr_info_ratelimited("fuse: Import of user buffer failed\n");
+	err = setup_fuse_copy_state(&cs, ring, req, ent, ITER_DEST, &iter);
+	if (err)
 		return err;
-	}
-
-	fuse_copy_init(&cs, true, &iter);
-	cs.is_uring = true;
-	cs.req = req;
 
 	if (num_args > 0) {
 		/*



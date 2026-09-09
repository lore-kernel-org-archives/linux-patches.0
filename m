Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA5B5335B3;
	Wed,  9 Sep 2026 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964758; cv=none; b=RSCYNaHU1p1WX4YV68vLlKTBYgMkdD4AWcfzwFscwm8294PVrSXpr8fY3QU0UbbKE27GLfmmAlb3Mqw23k7uz6ekNqXLNlaMdZmTLoCRmIBUS7mvzPcUzo1f4e0MXb0GbsGDwqNall+jvpgwZSk0rH/PicaEx5XPvGPl0vMsBv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964758; c=relaxed/simple;
	bh=8TAAoGeADdTluCwcvykT0YPAC65sdJtQ3nmlyyv7mwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktXuAZ3/1BIhzvMuUyxUyaKl1r6LJsMqi3WUfktHz8xtKDBn6+AAtI+eczpp3qF2PaDo7CbVvwKWPe1O+8ukVhbVtx0OtP0FNFqOUxNQaP3vUdwfdpDgRO+WTtQpVafIhtkbek6Ca/gwSbbuxszC3RTcY3C7/PUaBTjC9Ggzo7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFhfwTlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFhfwTlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D124D1F00A3D;
	Wed,  9 Sep 2026 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964757;
	bh=s28hgAm0FcX5qAsGCvfuflmk5MnGFonH/LMlVKpIZPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFhfwTlc6zpN/WCMHUp/KFNZFaUzqkGnxRvSS0r2BUYEWIuAMF8y0640LLn5LGmiV
	 XreurmBO8KjkTXoWVMcor0opUnMnK1zKEEO5YzgXnTgVWQxBJ/g6L5Y4+k+EjlxM1d
	 eTIWmXkOjq8wpTiFcDXx85iQHvwzFhnK1rEGc3WI=
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
Subject: [PATCH 6.18 516/583] fuse-uring: refactor io-uring header copying from ring
Date: Wed,  9 Sep 2026 15:43:21 +0200
Message-ID: <20260909134255.604399064@linuxfoundation.org>
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

[ Upstream commit ba7d47897fd895533c19af436ca7fc4f6b171238 ]

Move header copying from ring logic into a new copy_header_from_ring()
function. This makes the copy_from_user() logic more clear and
centralizes error handling / rate-limited logging.

Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: fd10f40af314 ("fuse: copy request headers via a stack buffer for io-uring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -593,6 +593,18 @@ static __always_inline int copy_header_t
 	return 0;
 }
 
+static __always_inline int copy_header_from_ring(void *header,
+						 const void __user *ring,
+						 size_t header_size)
+{
+	if (copy_from_user(header, ring, header_size)) {
+		pr_info_ratelimited("Copying header from ring failed.\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 				     struct fuse_req *req,
 				     struct fuse_ring_ent *ent)
@@ -603,10 +615,10 @@ static int fuse_uring_copy_from_ring(str
 	int err;
 	struct fuse_uring_ent_in_out ring_in_out;
 
-	err = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
-			     sizeof(ring_in_out));
+	err = copy_header_from_ring(&ring_in_out, &ent->headers->ring_ent_in_out,
+				    sizeof(ring_in_out));
 	if (err)
-		return -EFAULT;
+		return err;
 
 	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
 			  &iter);
@@ -842,8 +854,8 @@ static void fuse_uring_commit(struct fus
 	struct fuse_conn *fc = ring->fc;
 	ssize_t err = -EFAULT;
 
-	if (copy_from_user(&req->out.h, &ent->headers->in_out,
-			   sizeof(req->out.h)))
+	if (copy_header_from_ring(&req->out.h, &ent->headers->in_out,
+				  sizeof(req->out.h)))
 		goto out;
 
 	err = fuse_uring_out_header_has_err(&req->out.h, req, fc);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA27576EBD;
	Wed,  9 Sep 2026 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964726; cv=none; b=IbVlXDhFEJax4Ife2FXT9Gogp1TRvUivXTciq8xlBFVUGLeF4J09SzrMynPl5p1Rh1jqVkpxl3Tn4UhMdx9Lvde8n9VdYPTO3Mr1r4HKyeYTA90pfer1anuBcmBTepHAtNx+6NiQMDQHNoUkINuDEEQQKr44iu9gCoMs5sXBcMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964726; c=relaxed/simple;
	bh=7Na1pzRp9xC4ZSkGLOV9o/VceImZO+CBpptH5+XEzgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNoL/JEVVyL8jPNomEMeG8TNbUrJRhmM1JaE7g2rwWg0evda4n/1jQnvLPByoFbPg7Qf5XS8M1PHLiQdInY2aW9bbMF7DwxGXi2lb+t40q8/3uIteCJVzG04FDLOhlLpmZ2PaYsemQMQ7KPHoYc957P6Lr0iQpjtS+/9MAtIVVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFKLvhsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFKLvhsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DEA1F00A3A;
	Wed,  9 Sep 2026 14:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964725;
	bh=qzIQj59olj6NJGyM3/80eqlmPKad8Qh7rlQFDrMoPbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFKLvhsGgF8gYKcVgnqgXY1D2DqHcrX0+Bh4KMGZIE5tWvq802dczu266dh+phPDF
	 ll8/uBYRcds0dx0DF+/yAwFMa5BEqRPUV4QgTjExIUYvKG1LSVQv29wkkS5APnmtuo
	 Eu1DCXbqroRa7PIxeP79Cd6SzASq//yOZuh8pbcc=
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
Subject: [PATCH 6.18 515/583] fuse-uring: refactor io-uring header copying to ring
Date: Wed,  9 Sep 2026 15:43:20 +0200
Message-ID: <20260909134255.572377533@linuxfoundation.org>
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

[ Upstream commit 6582f8a06698403dccf8a01b7eef176b2c6dd7ff ]

Move header copying to ring logic into a new copy_header_to_ring()
function. This makes the copy_to_user() logic more clear and centralizes
error handling / rate-limited logging.

Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: fd10f40af314 ("fuse: copy request headers via a stack buffer for io-uring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -581,6 +581,18 @@ err:
 	return err;
 }
 
+static __always_inline int copy_header_to_ring(void __user *ring,
+					       const void *header,
+					       size_t header_size)
+{
+	if (copy_to_user(ring, header, header_size)) {
+		pr_info_ratelimited("Copying header to ring failed.\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 				     struct fuse_req *req,
 				     struct fuse_ring_ent *ent)
@@ -643,13 +655,11 @@ static int fuse_uring_args_to_ring(struc
 		 * Some op code have that as zero size.
 		 */
 		if (args->in_args[0].size > 0) {
-			err = copy_to_user(&ent->headers->op_in, in_args->value,
-					   in_args->size);
-			if (err) {
-				pr_info_ratelimited(
-					"Copying the header failed.\n");
-				return -EFAULT;
-			}
+			err = copy_header_to_ring(&ent->headers->op_in,
+						  in_args->value,
+						  in_args->size);
+			if (err)
+				return err;
 		}
 		in_args++;
 		num_args--;
@@ -665,9 +675,8 @@ static int fuse_uring_args_to_ring(struc
 	}
 
 	ent_in_out.payload_sz = cs.ring.copied_sz;
-	err = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
-			   sizeof(ent_in_out));
-	return err ? -EFAULT : 0;
+	return copy_header_to_ring(&ent->headers->ring_ent_in_out, &ent_in_out,
+				   sizeof(ent_in_out));
 }
 
 static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
@@ -696,14 +705,8 @@ static int fuse_uring_copy_to_ring(struc
 	}
 
 	/* copy fuse_in_header */
-	err = copy_to_user(&ent->headers->in_out, &req->in.h,
-			   sizeof(req->in.h));
-	if (err) {
-		err = -EFAULT;
-		return err;
-	}
-
-	return 0;
+	return copy_header_to_ring(&ent->headers->in_out, &req->in.h,
+				   sizeof(req->in.h));
 }
 
 static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,



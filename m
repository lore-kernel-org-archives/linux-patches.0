Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409815678FD;
	Wed,  9 Sep 2026 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964790; cv=none; b=MJ+JxP3RU+2J9ZJSxTdvwGryLM/kLv62KnbceJInWXPyAlJbYd/qXJOB8qrzizT2jSxoQWCIwpXJetz1ceWwPolkJV0auSQi/PIyRohBCZD0SbCLGKt3W262Xz92/agWS3rVK4G6YJNLV0r+x28sAC3OxnK7kD+YVlAULeWFxUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964790; c=relaxed/simple;
	bh=WKdllDwz6mfuk8flco7wbcjIcHfaewkUcLFbi7Vzrvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWj5nhxWiUPBeByL2qhsFwcv8C9CUtNPDXtXAj8cY/MGeSYXsAY6QtLqDGuw3JzLSnJdBJgF64OckcQjH1zlSq22zx+OcN8wIXjlLK48RONaJ+l8oxZF0HNz1DSBuZO4Ipwm0hrnwsR3dR+hHCV/brcV4rs6tK3yqzQwFVXTp2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IV+DcvoU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IV+DcvoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5574B1F00A3A;
	Wed,  9 Sep 2026 14:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964788;
	bh=H0UdayIwvJjcTjQZaFT2uAed9ggFwrkIPj61BpjQ5Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IV+DcvoU6mmvFwPPCetylM64qVJohAVsZxqnJ/UHbLeU9se9HlxHmXoO+z6wiNx4I
	 jqm3qfECyVSatpf1Hi0KJA84kqlXP4Vd1T6nsi33I7kjXjF8yz0apj08nW30I+Hle8
	 AmvZ2AodMvxizKqoSq3HSdD0DfhIe9wJgBjkOZj0=
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
Subject: [PATCH 6.18 517/583] fuse-uring: use enum types for header copying
Date: Wed,  9 Sep 2026 15:43:22 +0200
Message-ID: <20260909134255.636358855@linuxfoundation.org>
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

[ Upstream commit b2bbd7dcd2433e29b7e9a726aaa9571a78fa8d5f ]

Use enum types to identify which part of the header needs to be copied.
This improves the interface and will simplify both kernel-space and
user-space header addresses copying when buffer rings are added.

Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: fd10f40af314 ("fuse: copy request headers via a stack buffer for io-uring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   66 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 13 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -31,6 +31,15 @@ struct fuse_uring_pdu {
 
 static const struct fuse_iqueue_ops fuse_io_uring_ops;
 
+enum fuse_uring_header_type {
+	/* struct fuse_in_header / struct fuse_out_header */
+	FUSE_URING_HEADER_IN_OUT,
+	/* per op code header */
+	FUSE_URING_HEADER_OP,
+	/* struct fuse_uring_ent_in_out header */
+	FUSE_URING_HEADER_RING_ENT,
+};
+
 static void uring_cmd_set_ring_ent(struct io_uring_cmd *cmd,
 				   struct fuse_ring_ent *ring_ent)
 {
@@ -581,10 +590,33 @@ err:
 	return err;
 }
 
-static __always_inline int copy_header_to_ring(void __user *ring,
-					       const void *header,
-					       size_t header_size)
+static int ring_header_type_offset(enum fuse_uring_header_type type)
+{
+	switch (type) {
+	case FUSE_URING_HEADER_IN_OUT:
+		return 0;
+	case FUSE_URING_HEADER_OP:
+		return offsetof(struct fuse_uring_req_header, op_in);
+	case FUSE_URING_HEADER_RING_ENT:
+		return offsetof(struct fuse_uring_req_header, ring_ent_in_out);
+	default:
+		WARN_ONCE(1, "Invalid header type: %d\n", type);
+		return -EINVAL;
+	}
+}
+
+static int copy_header_to_ring(struct fuse_ring_ent *ent,
+			       enum fuse_uring_header_type type,
+			       const void *header, size_t header_size)
 {
+	int offset = ring_header_type_offset(type);
+	void __user *ring;
+
+	if (offset < 0)
+		return offset;
+
+	ring = (void __user *)ent->headers + offset;
+
 	if (copy_to_user(ring, header, header_size)) {
 		pr_info_ratelimited("Copying header to ring failed.\n");
 		return -EFAULT;
@@ -593,10 +625,18 @@ static __always_inline int copy_header_t
 	return 0;
 }
 
-static __always_inline int copy_header_from_ring(void *header,
-						 const void __user *ring,
-						 size_t header_size)
+static int copy_header_from_ring(struct fuse_ring_ent *ent,
+				 enum fuse_uring_header_type type, void *header,
+				 size_t header_size)
 {
+	int offset = ring_header_type_offset(type);
+	const void __user *ring;
+
+	if (offset < 0)
+		return offset;
+
+	ring = (void __user *)ent->headers + offset;
+
 	if (copy_from_user(header, ring, header_size)) {
 		pr_info_ratelimited("Copying header from ring failed.\n");
 		return -EFAULT;
@@ -615,8 +655,8 @@ static int fuse_uring_copy_from_ring(str
 	int err;
 	struct fuse_uring_ent_in_out ring_in_out;
 
-	err = copy_header_from_ring(&ring_in_out, &ent->headers->ring_ent_in_out,
-				    sizeof(ring_in_out));
+	err = copy_header_from_ring(ent, FUSE_URING_HEADER_RING_ENT,
+				    &ring_in_out, sizeof(ring_in_out));
 	if (err)
 		return err;
 
@@ -667,7 +707,7 @@ static int fuse_uring_args_to_ring(struc
 		 * Some op code have that as zero size.
 		 */
 		if (args->in_args[0].size > 0) {
-			err = copy_header_to_ring(&ent->headers->op_in,
+			err = copy_header_to_ring(ent, FUSE_URING_HEADER_OP,
 						  in_args->value,
 						  in_args->size);
 			if (err)
@@ -687,8 +727,8 @@ static int fuse_uring_args_to_ring(struc
 	}
 
 	ent_in_out.payload_sz = cs.ring.copied_sz;
-	return copy_header_to_ring(&ent->headers->ring_ent_in_out, &ent_in_out,
-				   sizeof(ent_in_out));
+	return copy_header_to_ring(ent, FUSE_URING_HEADER_RING_ENT,
+				   &ent_in_out, sizeof(ent_in_out));
 }
 
 static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
@@ -717,7 +757,7 @@ static int fuse_uring_copy_to_ring(struc
 	}
 
 	/* copy fuse_in_header */
-	return copy_header_to_ring(&ent->headers->in_out, &req->in.h,
+	return copy_header_to_ring(ent, FUSE_URING_HEADER_IN_OUT, &req->in.h,
 				   sizeof(req->in.h));
 }
 
@@ -854,7 +894,7 @@ static void fuse_uring_commit(struct fus
 	struct fuse_conn *fc = ring->fc;
 	ssize_t err = -EFAULT;
 
-	if (copy_header_from_ring(&req->out.h, &ent->headers->in_out,
+	if (copy_header_from_ring(ent, FUSE_URING_HEADER_IN_OUT, &req->out.h,
 				  sizeof(req->out.h)))
 		goto out;
 



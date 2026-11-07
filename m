Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063747;
	b=N7ubvGg5yGAHeBgqtCqf3RR3pdqyjaCr0aerM6aSfobXcIr8c+d69qECGzYcjt1lU+4X
	 HBkjNI8oPBJ6mI0nmASuOy899fWOMtjuqKmh+lC9ca2twOTazpyjoeHTqVX0bgtSeo7vo
	 LB1+bHG7cyd7ZSCIpa3nt2N2FclXbVMQ+trMqSvWPj0+VUn5xvtU8401scIo7MmRoBixk
	 gspXTNuDrqcF+zGvaR7mqLGvmWxSplTcnLtmd+ikQCgWpLt+qZ5gaIRexK/t6TUoXi7qK
	 tryL7Y0G2elFwYrcoSprwbMKlISPMxhk+Zf8Ceg0ZSJLmrIHatwbuhJtW2IAyH9o1LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VaNxsV3X3g/NmrUi42tkB07D4/D8DF4fqtV78LKHkDI=;
	b=Eh6uTfMgWRSQc07CB2CJ28tI+r+1YGFvFXa6pT7d6o6+HP09VxL0MUZ39wZsXZf/pzFs
	 nNt4PYDP9x4/Lc65Q5l3HpdmbLLH2k6ruhF+YbAqd6/Yy1j5qoMRDbCcAWJsA0nCAaDWC
	 10gsHx50G0sriI2m1uSV8VUqG//g5ExPSZ2quJp+lajm9pNCqkea33NMt69brhiXe1+kB
	 Fc5RklVkaBBR3017SOhWPn7Z+WeIOZFSbwvy6V+fpSFw6KG2OHXxYzFAieyVavXmNHw3N
	 Yo4qZ5VLi/88RZKV/aTIyzprB2FFt0xgqo2tsLN5QdPXEBMQZxDo8Watevlw1cM/LQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4PuX5MZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99190606D809;
	Sat,  7 Nov 2026 15:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4PuX5MZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488E11F008A1;
	Sat,  7 Nov 2026 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063747;
	bh=VaNxsV3X3g/NmrUi42tkB07D4/D8DF4fqtV78LKHkDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4PuX5MZvG8ExUvXAmMpKj5anwXeP2mm6dYsw4hILLJJPqmCBhRKiAxTPEBIIvGMe
	 k3ONRtNdtDRTbPqVj/0+SSQ3eA4seXQYhrQagD6aySdt6+2w/y0atRNeUsCF9IEaHl
	 PvLKKsnOyF5YJF66PYRNv9IrfZrZBGQKmMR4+n88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 841/869] fsverity: Be more careful with return value of ->get_verity_descriptor()
Date: Sat,  7 Nov 2026 08:58:43 -0500
Message-ID: <20261107134921.374171940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 8f8faec82aa902b1997ae578c46bcc84afbad811 ]

If fsverity_operations::get_verity_descriptor() returns that the verity
descriptor has 0 size, then a zero-size buffer is allocated to hold it,
and it's called again with bufsize=0.

But bufsize=0 is a special case that says to return the actual size.  If
in the meantime the filesystem has decided that the size is some
actually valid size, it will return that size, and then
validate_fsverity_descriptor() will read from ZERO_SIZE_PTR and crash.

Of course, for the filesystem to misbehave in that strange way, it
generally would require direct writes to the block device.

Regardless, fsverity_get_descriptor() might as well guard against it.
Make it do so.  Specifically, validate that the first call to
->get_verity_descriptor() returns at least the minimum descriptor size,
and validate that the second call returns the same size as the first.

Fixes: fd2d1acfcadf ("fs-verity: add the hook for file ->open()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261025203831.120095-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/verity/open.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index 2aa5eae5a5403..02e2c14ab3ffb 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -273,12 +273,6 @@ static bool validate_fsverity_descriptor(struct inode *inode,
 					 const struct fsverity_descriptor *desc,
 					 size_t desc_size)
 {
-	if (desc_size < sizeof(*desc)) {
-		fsverity_err(inode, "Unrecognized descriptor size: %zu bytes",
-			     desc_size);
-		return false;
-	}
-
 	if (desc->version != 1) {
 		fsverity_err(inode, "Unrecognized descriptor version: %u",
 			     desc->version);
@@ -317,31 +311,37 @@ static bool validate_fsverity_descriptor(struct inode *inode,
 int fsverity_get_descriptor(struct inode *inode,
 			    struct fsverity_descriptor **desc_ret)
 {
-	int res;
+	int size, res;
 	struct fsverity_descriptor *desc;
 
-	res = inode->i_sb->s_vop->get_verity_descriptor(inode, NULL, 0);
-	if (res < 0) {
-		fsverity_err(inode,
-			     "Error %d getting verity descriptor size", res);
-		return res;
+	size = inode->i_sb->s_vop->get_verity_descriptor(inode, NULL, 0);
+	if (size < 0) {
+		fsverity_err(inode, "Error %d getting verity descriptor size",
+			     size);
+		return size;
 	}
-	if (res > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
-		fsverity_err(inode, "Verity descriptor is too large (%d bytes)",
-			     res);
+	if (size < sizeof(*desc) || size > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
+		fsverity_err(inode,
+			     "Verity descriptor has invalid size (%d bytes)",
+			     size);
 		return -EMSGSIZE;
 	}
-	desc = kmalloc(res, GFP_KERNEL);
+	desc = kmalloc(size, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
-	res = inode->i_sb->s_vop->get_verity_descriptor(inode, desc, res);
+	res = inode->i_sb->s_vop->get_verity_descriptor(inode, desc, size);
 	if (res < 0) {
 		fsverity_err(inode, "Error %d reading verity descriptor", res);
 		kfree(desc);
 		return res;
 	}
-
-	if (!validate_fsverity_descriptor(inode, desc, res)) {
+	if (res != size) {
+		fsverity_err(inode, "Verity descriptor size changed (%d => %d)",
+			     size, res);
+		kfree(desc);
+		return -EINVAL;
+	}
+	if (!validate_fsverity_descriptor(inode, desc, size)) {
 		kfree(desc);
 		return -EINVAL;
 	}
-- 
2.53.0




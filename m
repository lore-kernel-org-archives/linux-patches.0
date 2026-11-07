Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062654;
	b=5PC5+Egd/LXj3P4P2hjT5xzGAgqR5qQOXYsXLIr1C3Mna6e1jvJAZo8Ryn+jm5pDTEYU
	 EyzAeuBS1V4vDtZtDHef2+RYSmi92pgLY16RB0C1Mjc7aFdE/YbR+/uFiK051qdzf6GWU
	 vEZOAlqBdizPDSEBXLAw4K4RskuMBOclfmkueycEzA44eF1SJ2DFImYmBpFz15jzk71uf
	 mAHvQAkbmn4+UyfUgKhTNwzDegU+fda6txO2o2Jy2xTaOJv+Jr3KVU/IBUsLjzhIDo8UX
	 9pH0K4w23HDQziTyOXfz0EXSVs1HrtVHudW6mRnk+JAFhAsoAt3wuYkY3L72lHdDM5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m8+vJeE0d/TZBWPOHwkDzsInguCbInucyK0/2n20oPc=;
	b=VWh9d/f6ihU7fZXj4PbNc1m+bEIvf+RNHWBaYgn8CsZKOj+FLokhTjGAGTe9Iqetprdq
	 aBt9aRVAJS+YLSeeKQ9lz7rlJBkEQ2sMKqEO6lGZfz4iXLPpikFuSxvrtN/9NmelohoyM
	 iJ5hTsfMQua1wWBIN9MKE9j3vfSbIVQcS66LnbPLHFr45vqInyGDRl52KfxrRgAfRVYLk
	 wxt8X8UMJN10jkG4icUvRD4/RojnQ4/3/Gjzbj7V7VDkI0QrA9tpnZxiy+wl8NKM6c/K8
	 jLfx4+eXRefya2T3qJ95TzqBfpCEam0Lfdmgyam09Uk3E3DBZfbdzLFPVORjUAYcEng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kOQUzw0k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCA2606A330;
	Sat,  7 Nov 2026 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kOQUzw0k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB111F0089F;
	Sat,  7 Nov 2026 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062654;
	bh=m8+vJeE0d/TZBWPOHwkDzsInguCbInucyK0/2n20oPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOQUzw0kde5h6JhL6EtTRfK2Gtmg3lsqDQuG3JdbLWMDTqbci9SQgocvNg+Z0xDBt
	 ema7artLUuEx6rfClfl7wrp5AuuwOFMwvLxY0vfzBYEqSHIF1K7Ij3auBRlpobxxLD
	 z4x2SquVUJ2jrbrP5m4Qme2ei5wc3ZPhUDiYlxHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1518/1536] fsverity: Be more careful with return value of ->get_verity_descriptor()
Date: Sat,  7 Nov 2026 08:58:54 -0500
Message-ID: <20261107135040.505956873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bd0497da5cea3..9c1b37a3b96a8 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -280,12 +280,6 @@ static bool validate_fsverity_descriptor(struct inode *inode,
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
@@ -324,31 +318,37 @@ static bool validate_fsverity_descriptor(struct inode *inode,
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




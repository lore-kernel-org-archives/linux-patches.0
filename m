Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D213D903C;
	Wed, 30 Sep 2026 18:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793940; cv=none; b=Sgm+76sRP3CBsVOhNYxMrITJ3QZXy9CJmvfK9GHet41h4ky4vbqXSGdTayWiLbJPeb6UF3+yYMCo1yMy0ikL4uRqnFwwumHY0urmG3Bix4cYq6RGwps9ZGqtbFm2CnuAxIV4ZgqOaDj5vLXBSf/rmn9h7bfKnWIOyS93/iYm67s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793940; c=relaxed/simple;
	bh=xew+Ba1u1TAIZfQrnU2kDLrrCQDnGAIECQYaqPUwZ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ns8Scli2v0L6CK7fBvTb9pr0ndQIhi+iewqnPZfuXmpU7Zvev83hxry1jLo8bkScZDJdA4eAb5qxHSmeliVflzKwHqU9NEMDZUefZujepXjj0/s5+AhznMUnA35cuga6ByedLYHGjENnqhxkULUveDqZaafPJmPics9qZ/QHg/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBubPsK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBubPsK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEF61F00899;
	Wed, 30 Sep 2026 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793938;
	bh=33QbPE2sVSLvw5PtkyQ8uRbIzT0eaPIRejHwegvmcbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBubPsK483bwrb3MbK27R1lsQmx4Mj100qs4X8//t8J06hUv9b5FQj7V9+zE7Ph+7
	 mF1mdLaAREk/rt2cO4r2U7uXVGswQCBAzUf4UDRHEooTws3SOuLIubAWx8N2hZXLHV
	 Ndh8TzltCLvS30jBj6kb5yQcFEdtv2xCn4kNpUnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0008/1193] ima: return error early if file xattr cannot be changed
Date: Wed, 30 Sep 2026 17:11:32 +0200
Message-ID: <20260930152434.493424364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

[ Upstream commit 69fc6474236d9edda6983623e4282f2bdfd8e3d8 ]

During early boot, the filesystem is read-only and any changes
to xattrs are not allowed. This fails in case of ext4 because
changing xattr starts an ext4 transaction which fails with the
following warning.

WARNING: fs/ext4/ext4_jbd2.c:75 at ext4_journal_check_start+0x63/0xa0 [ext4], CPU#1: systemd-sysroot/561
CPU: 1 UID: 0 PID: 561 Comm: systemd-sysroot Not tainted 6.19.12-1-default #1 PREEMPT(voluntary) openSUSE Tumbleweed  c2dfc3c9d9f6f1233251c5d4410574fe82a348ee
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
RIP: 0010:ext4_journal_check_start+0x63/0xa0 [ext4]
Call Trace:
  __ext4_journal_start_sb+0x3e/0x180 [ext4 6d025f3bc52c89a957b89a89d211fadf5e9434e1]
  ext4_xattr_set+0x104/0x150 [ext4 6d025f3bc52c89a957b89a89d211fadf5e9434e1]
  __vfs_setxattr+0x9a/0xd0
  __vfs_setxattr_noperm+0x76/0x1f0
  ima_appraise_measurement+0x23e/0xe40
  ima_d_path+0x5a/0xd0
  process_measurement+0xb29/0xc40
  ? copy_from_kernel_nofault+0x21/0xe0
  ? fscrypt_file_open+0xc0/0xe0
  ? ext4_file_open+0x60/0x490 [ext4 6d025f3bc52c89a957b89a89d211fadf5e9434e1]
  ? bpf_prog_31efb7c56239148b_restrict_filesystems+0xab/0x126
  ? __bpf_prog_exit+0x23/0xd0
  ? __bpf_tramp_exit+0xd/0x50
  ? bpf_trampoline_6442530367+0x9f/0xea
  ima_file_check+0x57/0x80
  security_file_post_open+0x50/0xf0
  path_openat+0x493/0x1650
  do_filp_open+0xc7/0x170

Detect the state of the file early and return the error.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_appraise.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index a5dff9c38393e..3804eaea120cd 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -90,6 +90,11 @@ static int ima_fix_xattr(struct dentry *dentry,
 	int rc, offset;
 	u8 algo = iint->ima_hash->algo;
 
+	if (IS_RDONLY(d_inode(dentry)))
+		return -EROFS;
+	if (IS_IMMUTABLE(d_inode(dentry)))
+		return -EPERM;
+
 	if (algo <= HASH_ALGO_SHA1) {
 		offset = 1;
 		iint->ima_hash->xattr.sha1.type = IMA_XATTR_DIGEST;
-- 
2.53.0




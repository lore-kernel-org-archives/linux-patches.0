Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194B359C983;
	Thu, 17 Sep 2026 16:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660919; cv=none; b=UvmrgJyLJtY0uL4Qt7matYxRUrcfh2BeuSjn6BLpsqZq4FwNssGvKT5pMri0osSrBoxRiAgLwxpxd8GgJZpei9CC56wO2ayUuJugQ/sL9WEv2c8Mz5qzWfyXgjsudtdLABvXACYC/nKokVPp7s2EqtjllJddV0OAdvSqkdphdK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660919; c=relaxed/simple;
	bh=zkwMT6JNgS03cctPhNuYNokdNP3gq/Dtuwuo3cSl72M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Udnjs/F8rhtzVvSrZx5JCBZZMJV7sVYo0fylExyQg9Vdin4IOakRIT76VMnh+YeNj83Purtb3rZp90xMcVZcSqVTai78tWDyQ9qUFiOnA5mseipMpstqsY6OsuMMLdFlJDexhYHKywe4I+QBP438BVBL4SCkTs2ywy5f7u9PMS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7TFHc/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7TFHc/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7841F00893;
	Thu, 17 Sep 2026 16:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660918;
	bh=wwMDog6dCnCPBoW1ZXDB++owAHCwPoKJZ2iOwmgUxP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7TFHc/Lo+eggNFXkefo+TWRxBVWji4d/POcna17ihvN0r1vnCqMRj3KYjKGUCpNw
	 JdX6ZkAZIW4cBaf3eAqEz3LjeZfhpCau3zQR1hBT68qAQQJkIh5S4Bbri0FfHZ0vqS
	 /xE9LmOII81mFKUI7853AwGF8NdQSO8Lxlq900hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0022/1250] ima: return error early if file xattr cannot be changed
Date: Thu, 17 Sep 2026 15:56:57 +0100
Message-ID: <20260917151552.530433909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 6a33484fcd6fe..a87ef7c05f11e 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -90,6 +90,11 @@ static int ima_fix_xattr(struct dentry *dentry, struct ima_iint_cache *iint)
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




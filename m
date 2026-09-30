Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B5A525A79;
	Wed, 30 Sep 2026 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790654; cv=none; b=t3evZem4nMW5OCD8xMU5+K2IuX2+/b/dRDbv9of4f5rt8TSYjqrIn+eQKKpQzNtaVaVVhIz9gcgpn4rhL5gnx9IlpL2U78QN4frGnrsDIKGiffLczp+TRjIlbB9sB+AfpMBsD7a/vxItdj4SxaTR39LBcKk44E94GSho/KGoqzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790654; c=relaxed/simple;
	bh=CdcMek3F9+Dsi2Galu5lzkFkfmza91dkjV5IPm5qPRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAFdyGYStuDqVOXvqGerpC6HKDh0nCBkaOB5kZXIxqO6bV1VqV49k6dVlYyqrDhHrm/+/Q9ZCKFCPL0rgvPyvv6EgXJQ2CQScg3JUTl2fI+FOi/0snrL6y10Np5e1TbwNYIF8Wdwe+3C66p1LPe333M2b7k1nJodMYrlL8l1Nl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4s//TGg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4s//TGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AA71F000FF;
	Wed, 30 Sep 2026 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790653;
	bh=OqzlOp6NBavB2S/rP+5R75Y91rKMyM9EVI+E/yFWhgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4s//TGgInNiopkLSjIMQGjHIuYEizNDNUTpicsVRwnG/p5CwnNCqg5lpwPUgGuYT
	 xfsFuVRDP2hccWns/85W6JJK1Jot3XORHURLOXBfPVmFx4aE+4qnaPJmQXfRZmyTlC
	 OXow6qXc2x3dlcnmVBx2hEqBl/sYV+qrmQR7FCq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/752] ima: return error early if file xattr cannot be changed
Date: Wed, 30 Sep 2026 17:17:53 +0200
Message-ID: <20260930152358.214638404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3cf11c81187b4..51726200e7380 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -88,6 +88,11 @@ static int ima_fix_xattr(struct dentry *dentry,
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




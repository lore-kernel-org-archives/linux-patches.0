Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FDA207E14;
	Tue,  8 Apr 2025 11:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111477; cv=none; b=hthvYjOrdQYFAMU4YgYo07reyCJzcNEdxRM6zT1BXxwdpEiAJGz/XWfQ8gUOdw0nR/W8iKVxF+BIS1JiuS3R7fhDl0x9JA7+yI62Hsb4cZlwDXgUS6YF97gewVNU0ovPpuOux71h5In69E5Vs3eV2W5AYDJauFoGjV6Z8xMxywk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111477; c=relaxed/simple;
	bh=8E1UUoEW7MIR1Kl8eQbfbgn8TiBkqD0ScUyS/sg4Bkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8KcXWE2Ii929zLISR5+Sgc4ZJx7uD8ZULVyX7JMZtJ5TTEMjvC+R8BHhg/f3SsbY1KWJNek76en01C01HPs+qy9yFdSKEzB4jD9dfyc6Fs3BpHHDc6IIvtfJYpBblBpll3rU61zJHLQcOfg959/Oiq6WOXO+dOKY0tVU8+W0t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjZI72GX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjZI72GX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46113C4CEE7;
	Tue,  8 Apr 2025 11:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111477;
	bh=8E1UUoEW7MIR1Kl8eQbfbgn8TiBkqD0ScUyS/sg4Bkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjZI72GXEPwx6aGvILM0jP1Mb/clb1ybeVR7HFItELsVlqsocQ8Ho8Aeet3OPCODV
	 z7iQTMHw/vPb55CCfFsSfojVW9fVj0rx+oosG2+8GYxnGVSH5UmItVTwXX6Owiyi1f
	 wRBwd3dm8LcwsAl0Q5Dv9D1CeWlLGHwzXV85ZOfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 445/731] fs/ntfs3: Fix proc_info_root leak when init ntfs failed
Date: Tue,  8 Apr 2025 12:45:42 +0200
Message-ID: <20250408104924.623656511@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 1d1a7e2525491f56901f5f63370a0775768044b8 ]

There's a issue as follows:
  proc_dir_entry 'fs/ntfs3' already registered
  WARNING: CPU: 3 PID: 9788 at fs/proc/generic.c:375 proc_register+0x418/0x590
  Modules linked in: ntfs3(E+)
  Call Trace:
   <TASK>
   _proc_mkdir+0x165/0x200
   init_ntfs_fs+0x36/0xf90 [ntfs3]
   do_one_initcall+0x115/0x6c0
   do_init_module+0x253/0x760
   load_module+0x55f2/0x6c80
   init_module_from_file+0xd2/0x130
   __x64_sys_finit_module+0xbf/0x130
   do_syscall_64+0x72/0x1c0

Above issue happens as missing destroy 'proc_info_root' when error
happens after create 'proc_info_root' in init_ntfs_fs().
So destroy 'proc_info_root' in error path in init_ntfs_fs().

Fixes: 7832e123490a ("fs/ntfs3: Add support /proc/fs/ntfs3/<dev>/volinfo and /proc/fs/ntfs3/<dev>/label")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 66047cf0e6e81..920a1ab47b631 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1885,7 +1885,7 @@ static int __init init_ntfs_fs(void)
 
 	err = ntfs3_init_bitmap();
 	if (err)
-		return err;
+		goto out2;
 
 	ntfs_inode_cachep = kmem_cache_create(
 		"ntfs_inode_cache", sizeof(struct ntfs_inode), 0,
@@ -1905,6 +1905,8 @@ static int __init init_ntfs_fs(void)
 	kmem_cache_destroy(ntfs_inode_cachep);
 out1:
 	ntfs3_exit_bitmap();
+out2:
+	ntfs_remove_proc_root();
 	return err;
 }
 
-- 
2.39.5




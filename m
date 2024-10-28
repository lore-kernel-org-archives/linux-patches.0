Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6912AF07;
	Mon, 28 Oct 2024 06:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098124; cv=none; b=R8ZYDcgds6MdMDp6yvXeCZDQDTPW3PNxu+cywBGFsH7OqyDGgWl76uyFeUn4r+F42FrYoQhua6ctwapomiq8DIJdi3oSlaFanYmDFnIWG25Bg/jcjcz5lPccf3ml6XrEOJhFznf8IaNLwkSBd8/m63gc7fGCyqpRBU3qutDPSis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098124; c=relaxed/simple;
	bh=b02P9aRqSr+y7KNXANF7Vs3K2DQ/7HbB4LLHlD+1fGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4oKXosw/DXt8Qq6yHnFysp6EwagRII3bVFUmeNtdOmuKJqVusH+1eQ9jq4E4GkDBb1bdLDSJ94WBCWAN7S1ftQk+LZC46oYXWpOj3dSejK4ycrSwZ2EsG0JnBIR2jfTwqoiLrGqsk1qjeIKr17RbTxG6Wt9K/jgvnvxRPSKf1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLQ4wE5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLQ4wE5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD46C4CEC3;
	Mon, 28 Oct 2024 06:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098124;
	bh=b02P9aRqSr+y7KNXANF7Vs3K2DQ/7HbB4LLHlD+1fGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLQ4wE5IfrTX86gZByq5mKFmL+1GzR8+eo1qEpN8SKB5QQPjjQjQW9PUYFRTAVIaW
	 eW/mNK8+2ck4X189QPuuQINPy5GNcbZO39QmMcteldctIVjd29Q9ZGO6SBmTHzoF9F
	 ejxdQqEKUQgGvtO8qZH/mahqXxN61OZNBrfqZtUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 086/261] smb: client: fix OOBs when building SMB2_IOCTL request
Date: Mon, 28 Oct 2024 07:23:48 +0100
Message-ID: <20241028062314.191162687@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 1ab60323c5201bef25f2a3dc0ccc404d9aca77f1 ]

When using encryption, either enforced by the server or when using
'seal' mount option, the client will squash all compound request buffers
down for encryption into a single iov in smb2_set_next_command().

SMB2_ioctl_init() allocates a small buffer (448 bytes) to hold the
SMB2_IOCTL request in the first iov, and if the user passes an input
buffer that is greater than 328 bytes, smb2_set_next_command() will
end up writing off the end of @rqst->iov[0].iov_base as shown below:

  mount.cifs //srv/share /mnt -o ...,seal
  ln -s $(perl -e "print('a')for 1..1024") /mnt/link

  BUG: KASAN: slab-out-of-bounds in
  smb2_set_next_command.cold+0x1d6/0x24c [cifs]
  Write of size 4116 at addr ffff8881148fcab8 by task ln/859

  CPU: 1 UID: 0 PID: 859 Comm: ln Not tainted 6.12.0-rc3 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  1.16.3-2.fc40 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   print_report+0x156/0x4d9
   ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   ? __virt_addr_valid+0x145/0x310
   ? __phys_addr+0x46/0x90
   ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   kasan_report+0xda/0x110
   ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   kasan_check_range+0x10f/0x1f0
   __asan_memcpy+0x3c/0x60
   smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   smb2_compound_op+0x238c/0x3840 [cifs]
   ? kasan_save_track+0x14/0x30
   ? kasan_save_free_info+0x3b/0x70
   ? vfs_symlink+0x1a1/0x2c0
   ? do_symlinkat+0x108/0x1c0
   ? __pfx_smb2_compound_op+0x10/0x10 [cifs]
   ? kmem_cache_free+0x118/0x3e0
   ? cifs_get_writable_path+0xeb/0x1a0 [cifs]
   smb2_get_reparse_inode+0x423/0x540 [cifs]
   ? __pfx_smb2_get_reparse_inode+0x10/0x10 [cifs]
   ? rcu_is_watching+0x20/0x50
   ? __kmalloc_noprof+0x37c/0x480
   ? smb2_create_reparse_symlink+0x257/0x490 [cifs]
   ? smb2_create_reparse_symlink+0x38f/0x490 [cifs]
   smb2_create_reparse_symlink+0x38f/0x490 [cifs]
   ? __pfx_smb2_create_reparse_symlink+0x10/0x10 [cifs]
   ? find_held_lock+0x8a/0xa0
   ? hlock_class+0x32/0xb0
   ? __build_path_from_dentry_optional_prefix+0x19d/0x2e0 [cifs]
   cifs_symlink+0x24f/0x960 [cifs]
   ? __pfx_make_vfsuid+0x10/0x10
   ? __pfx_cifs_symlink+0x10/0x10 [cifs]
   ? make_vfsgid+0x6b/0xc0
   ? generic_permission+0x96/0x2d0
   vfs_symlink+0x1a1/0x2c0
   do_symlinkat+0x108/0x1c0
   ? __pfx_do_symlinkat+0x10/0x10
   ? strncpy_from_user+0xaa/0x160
   __x64_sys_symlinkat+0xb9/0xf0
   do_syscall_64+0xbb/0x1d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f08d75c13bb

Reported-by: David Howells <dhowells@redhat.com>
Fixes: e77fe73c7e38 ("cifs: we can not use small padding iovs together with encryption")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 3d9e6e15dd900..194a4262d57a0 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3308,6 +3308,15 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		return rc;
 
 	if (indatalen) {
+		unsigned int len;
+
+		if (WARN_ON_ONCE(smb3_encryption_required(tcon) &&
+				 (check_add_overflow(total_len - 1,
+						     ALIGN(indatalen, 8), &len) ||
+				  len > MAX_CIFS_SMALL_BUFFER_SIZE))) {
+			cifs_small_buf_release(req);
+			return -EIO;
+		}
 		/*
 		 * indatalen is usually small at a couple of bytes max, so
 		 * just allocate through generic pool
-- 
2.43.0




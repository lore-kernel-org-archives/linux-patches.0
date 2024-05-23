Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A092C14AD36;
	Thu, 23 May 2024 13:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470743; cv=none; b=qiqAjxL6JngB9sqglt7NIgDwvsYpACA2sVYRNP53Jvs8C8WecXNA8ygfvbnSEf3nA1n0fOaFeR6DClWIrvfgK1iWhMny3ocVx2C0Lw6hswSJitgPv1c4cQlsNNNVT8wtDkUOcBjm2F8gHmn9U1vHRywkm0Ka8WrmTPHEaCVBbpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470743; c=relaxed/simple;
	bh=ygF415+6ID86gs9jh9dlFvLfjPPptfnCdPBH+HJXK/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly8h93sKV2H7IfqyGyAA+PkuOzLdNdDCqrCYYOQLvlqgR59/U8iChoIWxAIhXBRS+RAH+CYX6l3CNTPrn+jH71c54KcrqqaBbq1uMVqdlFuR5vwqrZ1s9eENzbovKIuu0sHwtaaeGINg4lmuvKPIy16T4dOSoCeQQ/qV29N6b2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGIwu/MV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGIwu/MV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277B3C4AF0A;
	Thu, 23 May 2024 13:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470743;
	bh=ygF415+6ID86gs9jh9dlFvLfjPPptfnCdPBH+HJXK/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGIwu/MV+xlvrm1Y1ttM9iki7e+0Yb7SAv+fqZBw6ZBep4LfjxcXfYIh9Z/23u664
	 gmuOm746C1380oXkWZ8i/jz/NijxCpHhGlZNnc0hWc5M1cqjw1O7lYhevEsRQVtalt
	 g2fstalX2BwMEUt/6K1X1XUVleT3Bydo3xGMgGus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/102] smb: client: fix NULL ptr deref in cifs_mark_open_handles_for_deleted_file()
Date: Thu, 23 May 2024 15:13:37 +0200
Message-ID: <20240523130345.183232062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit ec4535b2a1d709d3a1fbec26739c672f13c98a7b ]

cifs_get_fattr() may be called with a NULL inode, so check for a
non-NULL inode before calling
cifs_mark_open_handles_for_deleted_file().

This fixes the following oops:

  mount.cifs //srv/share /mnt -o ...,vers=3.1.1
  cd /mnt
  touch foo; tail -f foo &
  rm foo
  cat foo

  BUG: kernel NULL pointer dereference, address: 00000000000005c0
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 2 PID: 696 Comm: cat Not tainted 6.9.0-rc2 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  1.16.3-1.fc39 04/01/2014
  RIP: 0010:__lock_acquire+0x5d/0x1c70
  Code: 00 00 44 8b a4 24 a0 00 00 00 45 85 f6 0f 84 bb 06 00 00 8b 2d
  48 e2 95 01 45 89 c3 41 89 d2 45 89 c8 85 ed 0 0 <48> 81 3f 40 7a 76
  83 44 0f 44 d8 83 fe 01 0f 86 1b 03 00 00 31 d2
  RSP: 0018:ffffc90000b37490 EFLAGS: 00010002
  RAX: 0000000000000000 RBX: ffff888110021ec0 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000005c0
  RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
  R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000200
  FS: 00007f2a1fa08740(0000) GS:ffff888157a00000(0000)
  knlGS:0000000000000000 CS: 0010 DS: 0000 ES: 0000 CR0:
  0000000080050033
  CR2: 00000000000005c0 CR3: 000000011ac7c000 CR4: 0000000000750ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? __die+0x23/0x70
   ? page_fault_oops+0x180/0x490
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? exc_page_fault+0x70/0x230
   ? asm_exc_page_fault+0x26/0x30
   ? __lock_acquire+0x5d/0x1c70
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   lock_acquire+0xc0/0x2d0
   ? cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? kmem_cache_alloc+0x2d9/0x370
   _raw_spin_lock+0x34/0x80
   ? cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
   cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
   cifs_get_fattr+0x24c/0x940 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   cifs_get_inode_info+0x96/0x120 [cifs]
   cifs_lookup+0x16e/0x800 [cifs]
   cifs_atomic_open+0xc7/0x5d0 [cifs]
   ? lookup_open.isra.0+0x3ce/0x5f0
   ? __pfx_cifs_atomic_open+0x10/0x10 [cifs]
   lookup_open.isra.0+0x3ce/0x5f0
   path_openat+0x42b/0xc30
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   do_filp_open+0xc4/0x170
   do_sys_openat2+0xab/0xe0
   __x64_sys_openat+0x57/0xa0
   do_syscall_64+0xc1/0x1e0
   entry_SYSCALL_64_after_hwframe+0x72/0x7a

Fixes: ffceb7640cbf ("smb: client: do not defer close open handles to deleted files")
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b304215a4d668..9cdbc3ccc1d14 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1105,7 +1105,8 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 		} else {
 			cifs_open_info_to_fattr(fattr, data, sb);
 		}
-		if (!rc && fattr->cf_flags & CIFS_FATTR_DELETE_PENDING)
+		if (!rc && *inode &&
+		    (fattr->cf_flags & CIFS_FATTR_DELETE_PENDING))
 			cifs_mark_open_handles_for_deleted_file(*inode, full_path);
 		break;
 	case -EREMOTE:
-- 
2.43.0




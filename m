Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3224E129EFB;
	Mon, 18 Dec 2023 13:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4+HFTOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC041C433C8;
	Mon, 18 Dec 2023 13:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907953;
	bh=DFqmw3OzKp0TOZmJjfcViSYFnn0vpgcruYP3EzEzFCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4+HFTOVxC+r/EgZB4rEEhB8b22myzipfx4UUb9kS/lKOZZVriB3yTiJz/vWawmPv
	 5tPpZgpm5DBDQ3zm4el07ZiP392bZRks30HA4Nq5az0//Hf8iAvq6ghCYoOvRijV3i
	 5AJ7JiEELxEJYrLk4puI5Lecs7lao2jb9gUBkl04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 094/106] smb: client: fix OOB in smb2_query_reparse_point()
Date: Mon, 18 Dec 2023 14:51:48 +0100
Message-ID: <20231218135059.084151345@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 3a42709fa909e22b0be4bb1e2795aa04ada732a3 upstream.

Validate @ioctl_rsp->OutputOffset and @ioctl_rsp->OutputCount so that
their sum does not wrap to a number that is smaller than @reparse_buf
and we end up with a wild pointer as follows:

  BUG: unable to handle page fault for address: ffff88809c5cd45f
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 4a01067 P4D 4a01067 PUD 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 2 PID: 1260 Comm: mount.cifs Not tainted 6.7.0-rc4 #2
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
  RIP: 0010:smb2_query_reparse_point+0x3e0/0x4c0 [cifs]
  Code: ff ff e8 f3 51 fe ff 41 89 c6 58 5a 45 85 f6 0f 85 14 fe ff ff
  49 8b 57 48 8b 42 60 44 8b 42 64 42 8d 0c 00 49 39 4f 50 72 40 <8b>
  04 02 48 8b 9d f0 fe ff ff 49 8b 57 50 89 03 48 8b 9d e8 fe ff
  RSP: 0018:ffffc90000347a90 EFLAGS: 00010212
  RAX: 000000008000001f RBX: ffff88800ae11000 RCX: 00000000000000ec
  RDX: ffff88801c5cd440 RSI: 0000000000000000 RDI: ffffffff82004aa4
  RBP: ffffc90000347bb0 R08: 00000000800000cd R09: 0000000000000001
  R10: 0000000000000000 R11: 0000000000000024 R12: ffff8880114d4100
  R13: ffff8880114d4198 R14: 0000000000000000 R15: ffff8880114d4000
  FS: 00007f02c07babc0(0000) GS:ffff88806ba00000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff88809c5cd45f CR3: 0000000011750000 CR4: 0000000000750ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? __die+0x23/0x70
   ? page_fault_oops+0x181/0x480
   ? search_module_extables+0x19/0x60
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? exc_page_fault+0x1b6/0x1c0
   ? asm_exc_page_fault+0x26/0x30
   ? _raw_spin_unlock_irqrestore+0x44/0x60
   ? smb2_query_reparse_point+0x3e0/0x4c0 [cifs]
   cifs_get_fattr+0x16e/0xa50 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? lock_acquire+0xbf/0x2b0
   cifs_root_iget+0x163/0x5f0 [cifs]
   cifs_smb3_do_mount+0x5bd/0x780 [cifs]
   smb3_get_tree+0xd9/0x290 [cifs]
   vfs_get_tree+0x2c/0x100
   ? capable+0x37/0x70
   path_mount+0x2d7/0xb80
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? _raw_spin_unlock_irqrestore+0x44/0x60
   __x64_sys_mount+0x11a/0x150
   do_syscall_64+0x47/0xf0
   entry_SYSCALL_64_after_hwframe+0x6f/0x77
  RIP: 0033:0x7f02c08d5b1e

Fixes: 2e4564b31b64 ("smb3: add support for stat of WSL reparse points for special file types")
Cc: stable@vger.kernel.org
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3122,7 +3122,7 @@ smb2_query_reparse_tag(const unsigned in
 	struct kvec close_iov[1];
 	struct smb2_ioctl_rsp *ioctl_rsp;
 	struct reparse_data_buffer *reparse_buf;
-	u32 plen;
+	u32 off, count, len;
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
 
@@ -3202,16 +3202,22 @@ smb2_query_reparse_tag(const unsigned in
 	 */
 	if (rc == 0) {
 		/* See MS-FSCC 2.3.23 */
+		off = le32_to_cpu(ioctl_rsp->OutputOffset);
+		count = le32_to_cpu(ioctl_rsp->OutputCount);
+		if (check_add_overflow(off, count, &len) ||
+		    len > rsp_iov[1].iov_len) {
+			cifs_tcon_dbg(VFS, "%s: invalid ioctl: off=%d count=%d\n",
+				      __func__, off, count);
+			rc = -EIO;
+			goto query_rp_exit;
+		}
 
-		reparse_buf = (struct reparse_data_buffer *)
-			((char *)ioctl_rsp +
-			 le32_to_cpu(ioctl_rsp->OutputOffset));
-		plen = le32_to_cpu(ioctl_rsp->OutputCount);
-
-		if (plen + le32_to_cpu(ioctl_rsp->OutputOffset) >
-		    rsp_iov[1].iov_len) {
-			cifs_tcon_dbg(FYI, "srv returned invalid ioctl len: %d\n",
-				 plen);
+		reparse_buf = (void *)((u8 *)ioctl_rsp + off);
+		len = sizeof(*reparse_buf);
+		if (count < len ||
+		    count < le16_to_cpu(reparse_buf->ReparseDataLength) + len) {
+			cifs_tcon_dbg(VFS, "%s: invalid ioctl: off=%d count=%d\n",
+				      __func__, off, count);
 			rc = -EIO;
 			goto query_rp_exit;
 		}



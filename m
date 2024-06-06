Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E6119644F;
	Thu,  6 Jun 2024 14:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683152; cv=none; b=Gpnfj1iJV86pJL7HHhH3LOjvMhOojsLj6KVOrURbpSjPX8ma1ZUbbSK9Cgi6kvBZwmhp/FwrnrDfGOXkiuVCdUwmEBgQtefO/GTueKSNUlONNgxBpdUr6Miy02gy9AVvGiiRcu2Ml9aLUgHEi2Tv3IRCX3CTegCEEwYLhhUc2zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683152; c=relaxed/simple;
	bh=US71tsG2Bc6Ta82eM+iwF/lKiQqLfJwjSHW7TFNc7ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Alda9dmFi/IkPg4ARTNOIx7MsRRw+/8PJxV6vZ9Yfr+Vj6zPvYLL9gFv+TGzgIF8rFBibzjDuvR0jWhhz/n4uKeql4wgYfAcwtD4srmHYA/TwYern47mW05Qpo1OE4994u1Lb1DMh7BOc5izqhaS6yzD8c3sBuys9/5VW82zbRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CezJbnAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CezJbnAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D32C2BD10;
	Thu,  6 Jun 2024 14:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683152;
	bh=US71tsG2Bc6Ta82eM+iwF/lKiQqLfJwjSHW7TFNc7ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CezJbnAvBGvTpHmSv4Cv7fpjVE4WkkqD6mTXvTaNaphAab4aGOUJl+slNroXXgrL1
	 3hLoHZ+j7oW8l2ESGUqkAZ6w7R3eHc/XLjPewoYrYZAtuf0PuEJHvo6mj6Is2I3WAO
	 RjtFMBNR626i9PfovJhYbM74AcXAuWrEMdFIWbOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Kubisiak <brian@kubisiak.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/744] ecryptfs: Fix buffer size for tag 66 packet
Date: Thu,  6 Jun 2024 15:56:09 +0200
Message-ID: <20240606131735.509357636@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Brian Kubisiak <brian@kubisiak.com>

[ Upstream commit 85a6a1aff08ec9f5b929d345d066e2830e8818e5 ]

The 'TAG 66 Packet Format' description is missing the cipher code and
checksum fields that are packed into the message packet. As a result,
the buffer allocated for the packet is 3 bytes too small and
write_tag_66_packet() will write up to 3 bytes past the end of the
buffer.

Fix this by increasing the size of the allocation so the whole packet
will always fit in the buffer.

This fixes the below kasan slab-out-of-bounds bug:

  BUG: KASAN: slab-out-of-bounds in ecryptfs_generate_key_packet_set+0x7d6/0xde0
  Write of size 1 at addr ffff88800afbb2a5 by task touch/181

  CPU: 0 PID: 181 Comm: touch Not tainted 6.6.13-gnu #1 4c9534092be820851bb687b82d1f92a426598dc6
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2/GNU Guix 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4c/0x70
   print_report+0xc5/0x610
   ? ecryptfs_generate_key_packet_set+0x7d6/0xde0
   ? kasan_complete_mode_report_info+0x44/0x210
   ? ecryptfs_generate_key_packet_set+0x7d6/0xde0
   kasan_report+0xc2/0x110
   ? ecryptfs_generate_key_packet_set+0x7d6/0xde0
   __asan_store1+0x62/0x80
   ecryptfs_generate_key_packet_set+0x7d6/0xde0
   ? __pfx_ecryptfs_generate_key_packet_set+0x10/0x10
   ? __alloc_pages+0x2e2/0x540
   ? __pfx_ovl_open+0x10/0x10 [overlay 30837f11141636a8e1793533a02e6e2e885dad1d]
   ? dentry_open+0x8f/0xd0
   ecryptfs_write_metadata+0x30a/0x550
   ? __pfx_ecryptfs_write_metadata+0x10/0x10
   ? ecryptfs_get_lower_file+0x6b/0x190
   ecryptfs_initialize_file+0x77/0x150
   ecryptfs_create+0x1c2/0x2f0
   path_openat+0x17cf/0x1ba0
   ? __pfx_path_openat+0x10/0x10
   do_filp_open+0x15e/0x290
   ? __pfx_do_filp_open+0x10/0x10
   ? __kasan_check_write+0x18/0x30
   ? _raw_spin_lock+0x86/0xf0
   ? __pfx__raw_spin_lock+0x10/0x10
   ? __kasan_check_write+0x18/0x30
   ? alloc_fd+0xf4/0x330
   do_sys_openat2+0x122/0x160
   ? __pfx_do_sys_openat2+0x10/0x10
   __x64_sys_openat+0xef/0x170
   ? __pfx___x64_sys_openat+0x10/0x10
   do_syscall_64+0x60/0xd0
   entry_SYSCALL_64_after_hwframe+0x6e/0xd8
  RIP: 0033:0x7f00a703fd67
  Code: 25 00 00 41 00 3d 00 00 41 00 74 37 64 8b 04 25 18 00 00 00 85 c0 75 5b 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 85 00 00 00 48 83 c4 68 5d 41 5c c3 0f 1f
  RSP: 002b:00007ffc088e30b0 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
  RAX: ffffffffffffffda RBX: 00007ffc088e3368 RCX: 00007f00a703fd67
  RDX: 0000000000000941 RSI: 00007ffc088e48d7 RDI: 00000000ffffff9c
  RBP: 00007ffc088e48d7 R08: 0000000000000001 R09: 0000000000000000
  R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
  R13: 0000000000000000 R14: 00007ffc088e48d7 R15: 00007f00a7180040
   </TASK>

  Allocated by task 181:
   kasan_save_stack+0x2f/0x60
   kasan_set_track+0x29/0x40
   kasan_save_alloc_info+0x25/0x40
   __kasan_kmalloc+0xc5/0xd0
   __kmalloc+0x66/0x160
   ecryptfs_generate_key_packet_set+0x6d2/0xde0
   ecryptfs_write_metadata+0x30a/0x550
   ecryptfs_initialize_file+0x77/0x150
   ecryptfs_create+0x1c2/0x2f0
   path_openat+0x17cf/0x1ba0
   do_filp_open+0x15e/0x290
   do_sys_openat2+0x122/0x160
   __x64_sys_openat+0xef/0x170
   do_syscall_64+0x60/0xd0
   entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Fixes: dddfa461fc89 ("[PATCH] eCryptfs: Public key; packet management")
Signed-off-by: Brian Kubisiak <brian@kubisiak.com>
Link: https://lore.kernel.org/r/5j2q56p6qkhezva6b2yuqfrsurmvrrqtxxzrnp3wqu7xrz22i7@hoecdztoplbl
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ecryptfs/keystore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 3fe41964c0d8d..7f9f68c00ef63 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -300,9 +300,11 @@ write_tag_66_packet(char *signature, u8 cipher_code,
 	 *         | Key Identifier Size      | 1 or 2 bytes |
 	 *         | Key Identifier           | arbitrary    |
 	 *         | File Encryption Key Size | 1 or 2 bytes |
+	 *         | Cipher Code              | 1 byte       |
 	 *         | File Encryption Key      | arbitrary    |
+	 *         | Checksum                 | 2 bytes      |
 	 */
-	data_len = (5 + ECRYPTFS_SIG_SIZE_HEX + crypt_stat->key_size);
+	data_len = (8 + ECRYPTFS_SIG_SIZE_HEX + crypt_stat->key_size);
 	*packet = kmalloc(data_len, GFP_KERNEL);
 	message = *packet;
 	if (!message) {
-- 
2.43.0




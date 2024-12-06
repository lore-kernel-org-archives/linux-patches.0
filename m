Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E7C152160;
	Fri,  6 Dec 2024 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498201; cv=none; b=H0QLU9OwM1TiKDhyDObbKI5alhPRiRDmQUppC+VBzKy+NjX6T++7OSRZCWrMsIB35dhIYfhNCf8CPogjabEu8vxXFvfMzKh2cnBVf2S6ISHgc1RwH7UlIdUpPvOjUa6BvHeoWhI/JDdgNvt0Eeqsv8cOrpsy9D/bOiIEh/tK91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498201; c=relaxed/simple;
	bh=okK+qi3hLN0SS7b+FNFy7Muv5pv0q9E4jP0m3lKabGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TldwZjuaOQCy9Tw9dzoAn0SOKMpKieADXFsPockqIEYUs4QVGGft6QXQxy+o8f6AQ3blvsaLtzC6ZZajoI65CI3c0otUruCkc06iqpwY0aPw594ZvlDj8TyN75PdkyOZeDcH9hxfPwpP6MrLTqeX8MvfOpLVAvYTw2XTFEeP8cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zS0dN1kK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zS0dN1kK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A65C4CED1;
	Fri,  6 Dec 2024 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498200;
	bh=okK+qi3hLN0SS7b+FNFy7Muv5pv0q9E4jP0m3lKabGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zS0dN1kKwFV3XEuhif+XQw67SFne7XFXlwopWO2G823gBkn88iL2U3xyy3PYoZcVN
	 XW6+t8K9d2hQ0y8m8Qh3li7e1RWVOmFczwABYDbzmHag21O9hr5XlQ1pjOFTiWQe/h
	 K3mhds6z7k0LYSLyqd7p3IUrsSZlWshuxdPVUJ6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	Jianhong Yin <jiyin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 513/676] smb: client: fix NULL ptr deref in crypto_aead_setkey()
Date: Fri,  6 Dec 2024 15:35:32 +0100
Message-ID: <20241206143713.392806968@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

commit 4bdec0d1f658f7c98749bd2c5a486e6cfa8565d2 upstream.

Neither SMB3.0 or SMB3.02 supports encryption negotiate context, so
when SMB2_GLOBAL_CAP_ENCRYPTION flag is set in the negotiate response,
the client uses AES-128-CCM as the default cipher.  See MS-SMB2
3.3.5.4.

Commit b0abcd65ec54 ("smb: client: fix UAF in async decryption") added
a @server->cipher_type check to conditionally call
smb3_crypto_aead_allocate(), but that check would always be false as
@server->cipher_type is unset for SMB3.02.

Fix the following KASAN splat by setting @server->cipher_type for
SMB3.02 as well.

mount.cifs //srv/share /mnt -o vers=3.02,seal,...

BUG: KASAN: null-ptr-deref in crypto_aead_setkey+0x2c/0x130
Read of size 8 at addr 0000000000000020 by task mount.cifs/1095
CPU: 1 UID: 0 PID: 1095 Comm: mount.cifs Not tainted 6.12.0 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-3.fc41
04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x5d/0x80
 ? crypto_aead_setkey+0x2c/0x130
 kasan_report+0xda/0x110
 ? crypto_aead_setkey+0x2c/0x130
 crypto_aead_setkey+0x2c/0x130
 crypt_message+0x258/0xec0 [cifs]
 ? __asan_memset+0x23/0x50
 ? __pfx_crypt_message+0x10/0x10 [cifs]
 ? mark_lock+0xb0/0x6a0
 ? hlock_class+0x32/0xb0
 ? mark_lock+0xb0/0x6a0
 smb3_init_transform_rq+0x352/0x3f0 [cifs]
 ? lock_acquire.part.0+0xf4/0x2a0
 smb_send_rqst+0x144/0x230 [cifs]
 ? __pfx_smb_send_rqst+0x10/0x10 [cifs]
 ? hlock_class+0x32/0xb0
 ? smb2_setup_request+0x225/0x3a0 [cifs]
 ? __pfx_cifs_compound_last_callback+0x10/0x10 [cifs]
 compound_send_recv+0x59b/0x1140 [cifs]
 ? __pfx_compound_send_recv+0x10/0x10 [cifs]
 ? __create_object+0x5e/0x90
 ? hlock_class+0x32/0xb0
 ? do_raw_spin_unlock+0x9a/0xf0
 cifs_send_recv+0x23/0x30 [cifs]
 SMB2_tcon+0x3ec/0xb30 [cifs]
 ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
 ? lock_acquire.part.0+0xf4/0x2a0
 ? __pfx_lock_release+0x10/0x10
 ? do_raw_spin_trylock+0xc6/0x120
 ? lock_acquire+0x3f/0x90
 ? _get_xid+0x16/0xd0 [cifs]
 ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
 ? cifs_get_smb_ses+0xcdd/0x10a0 [cifs]
 cifs_get_smb_ses+0xcdd/0x10a0 [cifs]
 ? __pfx_cifs_get_smb_ses+0x10/0x10 [cifs]
 ? cifs_get_tcp_session+0xaa0/0xca0 [cifs]
 cifs_mount_get_session+0x8a/0x210 [cifs]
 dfs_mount_share+0x1b0/0x11d0 [cifs]
 ? __pfx___lock_acquire+0x10/0x10
 ? __pfx_dfs_mount_share+0x10/0x10 [cifs]
 ? lock_acquire.part.0+0xf4/0x2a0
 ? find_held_lock+0x8a/0xa0
 ? hlock_class+0x32/0xb0
 ? lock_release+0x203/0x5d0
 cifs_mount+0xb3/0x3d0 [cifs]
 ? do_raw_spin_trylock+0xc6/0x120
 ? __pfx_cifs_mount+0x10/0x10 [cifs]
 ? lock_acquire+0x3f/0x90
 ? find_nls+0x16/0xa0
 ? smb3_update_mnt_flags+0x372/0x3b0 [cifs]
 cifs_smb3_do_mount+0x1e2/0xc80 [cifs]
 ? __pfx_vfs_parse_fs_string+0x10/0x10
 ? __pfx_cifs_smb3_do_mount+0x10/0x10 [cifs]
 smb3_get_tree+0x1bf/0x330 [cifs]
 vfs_get_tree+0x4a/0x160
 path_mount+0x3c1/0xfb0
 ? kasan_quarantine_put+0xc7/0x1d0
 ? __pfx_path_mount+0x10/0x10
 ? kmem_cache_free+0x118/0x3e0
 ? user_path_at+0x74/0xa0
 __x64_sys_mount+0x1a6/0x1e0
 ? __pfx___x64_sys_mount+0x10/0x10
 ? mark_held_locks+0x1a/0x90
 do_syscall_64+0xbb/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Cc: Tom Talpey <tom@talpey.com>
Reported-by: Jianhong Yin <jiyin@redhat.com>
Cc: stable@vger.kernel.org # v6.12
Fixes: b0abcd65ec54 ("smb: client: fix UAF in async decryption")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1228,7 +1228,9 @@ SMB2_negotiate(const unsigned int xid,
 	 * SMB3.0 supports only 1 cipher and doesn't have a encryption neg context
 	 * Set the cipher type manually.
 	 */
-	if (server->dialect == SMB30_PROT_ID && (server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
+	if ((server->dialect == SMB30_PROT_ID ||
+	     server->dialect == SMB302_PROT_ID) &&
+	    (server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
 		server->cipher_type = SMB2_ENCRYPTION_AES128_CCM;
 
 	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,



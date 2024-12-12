Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20D8214227;
	Thu, 12 Dec 2024 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023737; cv=none; b=Hd2reQFr4iLzDXSBNwaepdSHCbs60BE6PxnXXjUBIpSUgDmyuHqhaFHS2zduKExH/cpm2Vux1hekqvypMgp68/Z0ReoBBl3sE1S01qIq8HnuNp46KV40NFgzxWf/Ew8Z+JWwxxSByK2N2z/oqQVR4Adx+F5xGugR0gtlktzwCM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023737; c=relaxed/simple;
	bh=WlZOlNk6AIsbkT9HwQMTy++L99rQJK+NRgCSGjGK608=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+YozueLXPb6EsO0Mz9nC2kN2JPgp2SBec37db71jEzXrj9ptLD1a30L/nsToAjBmD6zvH+uLFakbBt6CL5AgQHaCjGLlg7WaHLId5dr1I4EqlBT5pRMM7kVk6H/Cat27/X1VnXKMirgZsCdsmGGas9TXkQCOGIo0H4BtUEu4Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tga3MZ4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tga3MZ4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431F2C4CECE;
	Thu, 12 Dec 2024 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023737;
	bh=WlZOlNk6AIsbkT9HwQMTy++L99rQJK+NRgCSGjGK608=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tga3MZ4SMltRPbRyBeOKxpV7r9+TcJTjjc2GIFc4IHP64bGiC6GWdnNJGEXuya2yn
	 pSfhMYosGOUXBQ8KkAXhcBshd2HUgaeDy+oPogkIyas/xT+jIqksXwN9wst0IkScv+
	 sBqfolw3coK4lkuA7D1R5jgf65VOMbhzmKneWKIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/459] hfsplus: dont query the device logical block size multiple times
Date: Thu, 12 Dec 2024 15:56:44 +0100
Message-ID: <20241212144256.127326890@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 1c82587cb57687de3f18ab4b98a8850c789bedcf ]

Devices block sizes may change. One of these cases is a loop device by
using ioctl LOOP_SET_BLOCK_SIZE.

While this may cause other issues like IO being rejected, in the case of
hfsplus, it will allocate a block by using that size and potentially write
out-of-bounds when hfsplus_read_wrapper calls hfsplus_submit_bio and the
latter function reads a different io_size.

Using a new min_io_size initally set to sb_min_blocksize works for the
purposes of the original fix, since it will be set to the max between
HFSPLUS_SECTOR_SIZE and the first seen logical block size. We still use the
max between HFSPLUS_SECTOR_SIZE and min_io_size in case the latter is not
initialized.

Tested by mounting an hfsplus filesystem with loop block sizes 512, 1024
and 4096.

The produced KASAN report before the fix looks like this:

[  419.944641] ==================================================================
[  419.945655] BUG: KASAN: slab-use-after-free in hfsplus_read_wrapper+0x659/0xa0a
[  419.946703] Read of size 2 at addr ffff88800721fc00 by task repro/10678
[  419.947612]
[  419.947846] CPU: 0 UID: 0 PID: 10678 Comm: repro Not tainted 6.12.0-rc5-00008-gdf56e0f2f3ca #84
[  419.949007] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
[  419.950035] Call Trace:
[  419.950384]  <TASK>
[  419.950676]  dump_stack_lvl+0x57/0x78
[  419.951212]  ? hfsplus_read_wrapper+0x659/0xa0a
[  419.951830]  print_report+0x14c/0x49e
[  419.952361]  ? __virt_addr_valid+0x267/0x278
[  419.952979]  ? kmem_cache_debug_flags+0xc/0x1d
[  419.953561]  ? hfsplus_read_wrapper+0x659/0xa0a
[  419.954231]  kasan_report+0x89/0xb0
[  419.954748]  ? hfsplus_read_wrapper+0x659/0xa0a
[  419.955367]  hfsplus_read_wrapper+0x659/0xa0a
[  419.955948]  ? __pfx_hfsplus_read_wrapper+0x10/0x10
[  419.956618]  ? do_raw_spin_unlock+0x59/0x1a9
[  419.957214]  ? _raw_spin_unlock+0x1a/0x2e
[  419.957772]  hfsplus_fill_super+0x348/0x1590
[  419.958355]  ? hlock_class+0x4c/0x109
[  419.958867]  ? __pfx_hfsplus_fill_super+0x10/0x10
[  419.959499]  ? __pfx_string+0x10/0x10
[  419.960006]  ? lock_acquire+0x3e2/0x454
[  419.960532]  ? bdev_name.constprop.0+0xce/0x243
[  419.961129]  ? __pfx_bdev_name.constprop.0+0x10/0x10
[  419.961799]  ? pointer+0x3f0/0x62f
[  419.962277]  ? __pfx_pointer+0x10/0x10
[  419.962761]  ? vsnprintf+0x6c4/0xfba
[  419.963178]  ? __pfx_vsnprintf+0x10/0x10
[  419.963621]  ? setup_bdev_super+0x376/0x3b3
[  419.964029]  ? snprintf+0x9d/0xd2
[  419.964344]  ? __pfx_snprintf+0x10/0x10
[  419.964675]  ? lock_acquired+0x45c/0x5e9
[  419.965016]  ? set_blocksize+0x139/0x1c1
[  419.965381]  ? sb_set_blocksize+0x6d/0xae
[  419.965742]  ? __pfx_hfsplus_fill_super+0x10/0x10
[  419.966179]  mount_bdev+0x12f/0x1bf
[  419.966512]  ? __pfx_mount_bdev+0x10/0x10
[  419.966886]  ? vfs_parse_fs_string+0xce/0x111
[  419.967293]  ? __pfx_vfs_parse_fs_string+0x10/0x10
[  419.967702]  ? __pfx_hfsplus_mount+0x10/0x10
[  419.968073]  legacy_get_tree+0x104/0x178
[  419.968414]  vfs_get_tree+0x86/0x296
[  419.968751]  path_mount+0xba3/0xd0b
[  419.969157]  ? __pfx_path_mount+0x10/0x10
[  419.969594]  ? kmem_cache_free+0x1e2/0x260
[  419.970311]  do_mount+0x99/0xe0
[  419.970630]  ? __pfx_do_mount+0x10/0x10
[  419.971008]  __do_sys_mount+0x199/0x1c9
[  419.971397]  do_syscall_64+0xd0/0x135
[  419.971761]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  419.972233] RIP: 0033:0x7c3cb812972e
[  419.972564] Code: 48 8b 0d f5 46 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c2 46 0d 00 f7 d8 64 89 01 48
[  419.974371] RSP: 002b:00007ffe30632548 EFLAGS: 00000286 ORIG_RAX: 00000000000000a5
[  419.975048] RAX: ffffffffffffffda RBX: 00007ffe306328d8 RCX: 00007c3cb812972e
[  419.975701] RDX: 0000000020000000 RSI: 0000000020000c80 RDI: 00007ffe306325d0
[  419.976363] RBP: 00007ffe30632720 R08: 00007ffe30632610 R09: 0000000000000000
[  419.977034] R10: 0000000000200008 R11: 0000000000000286 R12: 0000000000000000
[  419.977713] R13: 00007ffe306328e8 R14: 00005a0eb298bc68 R15: 00007c3cb8356000
[  419.978375]  </TASK>
[  419.978589]

Fixes: 6596528e391a ("hfsplus: ensure bio requests are not smaller than the hardware sectors")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://lore.kernel.org/r/20241107114109.839253-1-cascardo@igalia.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/hfsplus_fs.h | 3 ++-
 fs/hfsplus/wrapper.c    | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index bfbe88e804eb0..c37a2f3d88af0 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -156,6 +156,7 @@ struct hfsplus_sb_info {
 
 	/* Runtime variables */
 	u32 blockoffset;
+	u32 min_io_size;
 	sector_t part_start;
 	sector_t sect_count;
 	int fs_shift;
@@ -306,7 +307,7 @@ struct hfsplus_readdir_data {
  */
 static inline unsigned short hfsplus_min_io_size(struct super_block *sb)
 {
-	return max_t(unsigned short, bdev_logical_block_size(sb->s_bdev),
+	return max_t(unsigned short, HFSPLUS_SB(sb)->min_io_size,
 		     HFSPLUS_SECTOR_SIZE);
 }
 
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 0350dc7821bf9..59ba0a30f5392 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -173,6 +173,8 @@ int hfsplus_read_wrapper(struct super_block *sb)
 	if (!blocksize)
 		goto out;
 
+	sbi->min_io_size = blocksize;
+
 	if (hfsplus_get_last_session(sb, &part_start, &part_size))
 		goto out;
 
-- 
2.43.0




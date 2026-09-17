Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1745251B179;
	Thu, 17 Sep 2026 17:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664860; cv=none; b=p9nju+yl4ZofaHj0vo0+yZ+CDMI1DFUTtJF9gM0xHKbQbqd9ASXAU8wgQhc8IG1Sc4wHS7AJ5ORDZkYNWG5S/HcYe3PPcMlNusjLX3pnHmGTqYT3NBCs9YDDOsEXZBQfgv9UGarrwF7BSDlC4EQSfVaZtVVzn6jK7fjShtJqKtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664860; c=relaxed/simple;
	bh=g4LI/5YL/IZdWVY31hhUXr8vWKPupDT556yxqLtTWF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGlXiW8lqb3+Se6v+Pe5MXewe+fPzqLTx2imuMKd4BrrKiVRoYsumBBdjPkYYM3DuLkipMa/jCA8wm5X3+5iofCEYEMiq28I/79Y2NAL+ZZ9t4EkIUw49HN7mgMmrpKn+Vwz0wcxgjG7ZlRqHUAJq1AHeCn3QUQt8XoYV9b9yr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=noJzlKy2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="noJzlKy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332BC1F000FF;
	Thu, 17 Sep 2026 17:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664858;
	bh=JbHvU2jxZrqfn3UDO6CBivOg46cmTCsu4d4vuipEYOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=noJzlKy2mtVsAcoJThy9N2PRhxRZb71SX4Q47uE2eVFPqEtW+8bfxsc8kWu1QLh8x
	 7H3/DNkXKtBa6yYg3UpbPnbZmK084pPvlPXH+NKqKCsuw1FQOO8QpmkHrliSchU4lp
	 mlJsYDdPwIlTRCRaut5Wl43FlJRzUculObGGEoYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0475/1250] btrfs: tree-checker: validate INODE_REFs namelen
Date: Thu, 17 Sep 2026 16:04:30 +0100
Message-ID: <20260917151604.845241560@linuxfoundation.org>
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
Content-Transfer-Encoding: quoted-printable

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 3dc22abc21f5892406c09202fa2627196cc96967 ]

[BUG]
A crafted btrfs image can trigger the following crash:

  BUG: unable to handle page fault for address: ffffd1dc42884000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  CPU: 9 UID: 0 PID: 1034 Comm: poc Not tainted 7.1.0-rc4-custom+ #383 PREE=
MPT(full)  46af0a92938a63be7132e0dfd71e62327c51d5c2
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/20=
22
  RIP: 0010:memcpy+0xc/0x10
  Call Trace:
   <TASK>
   read_extent_buffer+0xe4/0x100 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1f=
92a8f]
   btrfs_get_name+0x15e/0x1e0 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1f92a=
8f]
   reconnect_path+0x165/0x390
   exportfs_decode_fh_raw+0x337/0x400
   ? drop_caches_sysctl_handler+0xb0/0xb0
   </TASK>
  ---[ end trace 0000000000000000 ]---
  RIP: 0010:memcpy+0xc/0x10
  Kernel panic - not syncing: Fatal exception

[CAUSE]
TThe crafted image has the following corrupted INODE_REF item:

         item 9 key (258 INODE_REF 257) itemoff 11544 itemsize 4106
         	index 2 namelen 4096 name: d\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000

The itemsize matches the namelen, but the namelen is 4096, way larger
than normal name length limit (BTRFS_NAME_LEN, 255).

Meanwhile the memory of the @name is only 255 byte sized, this will cause
out-of-boundary access, and cause the above crash.

[FIX]
Add extra namelen verification for INODE_REF, just like what we have
done in ROOT_REF checks.

Now the crafted image can be rejected gracefully:

 BTRFS critical (device dm-2): corrupt leaf: root=3D5 block=3D30572544 slot=
=3D14 ino=3D259, invalid inode ref name length, has 4096 expect [1, 255]
 BTRFS error (device dm-2): read time tree block corruption detected on log=
ical 30572544 mirror 2

Reported-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/linux-btrfs/aik0hEV6ehKx6Ldv@Air.local/
Acked-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
[ Rebase, add a Link: tag, add an simple cause analyze ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 97be0c1ed22f7..79f297d9ebc4a 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1813,6 +1813,12 @@ static int check_inode_ref(struct extent_buffer *lea=
f,
=20
 		iref =3D (struct btrfs_inode_ref *)ptr;
 		namelen =3D btrfs_inode_ref_name_len(leaf, iref);
+		if (unlikely(namelen =3D=3D 0 || namelen > BTRFS_NAME_LEN)) {
+			inode_ref_err(leaf, slot,
+				"invalid inode ref name length, has %u expect [1, %u]",
+				namelen, BTRFS_NAME_LEN);
+			return -EUCLEAN;
+		}
 		if (unlikely(ptr + sizeof(*iref) + namelen > end)) {
 			inode_ref_err(leaf, slot,
 				"inode ref overflow, ptr %lu end %lu namelen %u",
--=20
2.53.0




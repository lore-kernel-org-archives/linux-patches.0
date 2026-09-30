Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3F13A9852;
	Wed, 30 Sep 2026 18:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794616; cv=none; b=TjuS6al7C3Y639UX8J3il5jQaWueiTDWSdEx6e5c+tNLLMH6Im81PoKJBe5qeamsNqD68FANgBYuftKgON0+mR2RYzc0oQG6MQ0a5Lf363IDbnP0i6bPhI3/fLDP06s/ddvt9RTo/fEfRmapeMR1gUnZy7zXQ3pLDfAE+QtQVXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794616; c=relaxed/simple;
	bh=bmAqXSiBXl5dX2soGfpAE/Qfq3+ua3aPNfuMEIN0NkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSZZ95HsjLQie1Sd8w/dnUtMoU67LXV4/M1U+legEKGEFSgUhgW3rC9pWR74m4+yYEpV+v1C8q7ayOM92aSwLBpWd1BqB9vqVCRW9RUjirK8CIPj8JFpBWB2kFvwnBXr6c+lc5gXdQ9/NkHNHeC5jTXcQ6mIFPGMuuzKABTbcWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAv4e026; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAv4e026"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268861F000FF;
	Wed, 30 Sep 2026 18:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794614;
	bh=iPCYfFD2bI2UPQHDqW5AENMBIMg8HIZv/uQLWgDgRX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAv4e026JQcF0aW32HmuKPUB2mcBasfTXEEq9ODQURm8aF/vDv0j0Rp++LvIUtjdY
	 mw/ILAjtwlXXprkeCCNF5P4qTDeoOqed7emf0dPJ5BQlhIP5GqXGpsJ98db8OOOzET
	 RhA5ARJpMbAMqsOOlK0W+ezn/5ncdmXcAl5nEDyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0271/1193] btrfs: tree-checker: validate INODE_REFs namelen
Date: Wed, 30 Sep 2026 17:15:55 +0200
Message-ID: <20260930152440.187821944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 89380c41ca6cb..f9b9fb0b21d5a 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1774,6 +1774,12 @@ static int check_inode_ref(struct extent_buffer *lea=
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




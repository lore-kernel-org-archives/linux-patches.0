Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063726;
	b=tObBnsM03ZpZv8CDt+bDzMowCTL7UfiUijasQgs9m+AOOPt+B4Y2zwSU+Mm706Z1Z4Hk
	 6/nj6pFyZguk6yLTG42I+j9pGXqa1oYb6Y9A7iFQrXUEAwdjwqk6GHdGiOyvPiSVVXslk
	 QWV+nq7ZZ/E3bqyxj7xOUSbJmacjrorBXr68ebhqlM4rxbMC76ROTMjm58nHoqMEuwkNo
	 VvBx75LQnk2TTvVUhyWOZ7XtzwRcGgq61MRK2NMJikJuKx9Mz8zRat+ZGpGdnf9bWLVuc
	 qOpi5wm2+xTZfFmMoKder/1WGSzGhXuIQFstxCV7/4yR4KWCemLcDvZWE/TMjGopuTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IhHs27BGfMPbq5Uk7DA0ZMep+ZtunWfQebWDsxNDI68=;
	b=YtI1nZCepIwTL8kWuvTibuBbmyClk4YheSZfG+c9l2lfork2dilIsf6UrZc8ZCKz9v9J
	 5F5fpZPWBVrsmwnc8v/ZNIHX8jOeoIxvrqPmh54rQqyWx5lZ4zapLNaliFX2BAnn+naFE
	 OndbN1Kz8WL+J7cZMN6ukh5gKllCK8hk3SVCckzvcl2NcMGOBOi0na0aXZL21c6heB5fH
	 BfhxYD5sQVg1AmdqVsK2zeIVzg0jELQajVSeBoBsUURhT43Y5HHiHrrCA7QBVsdyozTr0
	 rZH6IlCQwdAAM8vUt+3dx7us8LKZZhsCYs9M8x23VkDpgzUdO+7gXQDC4JZsldBBKhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBwlE0rV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20025606D83F;
	Sat,  7 Nov 2026 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBwlE0rV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8701F008A1;
	Sat,  7 Nov 2026 15:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063726;
	bh=IhHs27BGfMPbq5Uk7DA0ZMep+ZtunWfQebWDsxNDI68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBwlE0rV0iQMazes69Y/41iCma0q7kwdF+arhWmsSIQvYjv5DuGCqbbj7D9ApKHR5
	 mDYBP6BfRoY8/4x329ZWKQuTzuOeTke11oi1YbA4TAkSN7XNUwsaLf746fmMEFysHE
	 VQUqbIv5QsCC750fD5IfxkEwn+jcRVjjpOSznmL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyeontae Lee <wonju345@naver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 824/869] fs/ntfs3: bound DeleteAttribute asize against rec->used in do_action
Date: Sat,  7 Nov 2026 08:58:26 -0500
Message-ID: <20261107134920.906269103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyeontae Lee <wonju345@naver.com>

[ Upstream commit 408216b66afd9ddadaba2dce56fd4af6793e95a2 ]

In do_action()'s DeleteAttribute case (fslog.c:3316), attr is
Add2Ptr(rec, roff) with roff taken from the on-disk lrh->record_off, and
asize = le32_to_cpu(attr->size) is read straight out of the MFT record:

	asize = le32_to_cpu(attr->size);
	used  = le32_to_cpu(rec->used);

	if (!check_if_attr(rec, lrh))
		goto dirty_vol;
	...
	memmove(attr, Add2Ptr(attr, asize), used - asize - roff);

check_if_attr() (fslog.c:2869) walks the attribute chain from
rec->attr_off and returns o == ro.  Its loop breaks on ATTR_END, so ro may
legitimately equal the offset of the ATTR_END marker; that is exactly how
CreateAttribute appends to a record.  But check_file_record()'s walk
(fslog.c:2831) also stops at ATTR_END, so check_attr() never inspects the
bytes there.  When roff is the ATTR_END offset, those never-validated bytes
are what gets read as attr->size, and used - asize - roff underflows.

The read itself is also unbounded: roff is a u16 and attr->size is
dereferenced at fslog.c:3317, before check_if_attr() has constrained roff
at all, so it can be up to ~64K past a record_size-sized object.

Commit 0ca0485e4b2e ("fs/ntfs3: validate rec->used in journal-replay file
record check") added at fslog.c:2844

	if (used < PtrOffset(rec, attr) + sizeof(attr->type))
		return false;

and its changelog names this very memmove.  It bounds rec->used against the
ATTR_END offset; it does not bound asize.  With record_size 0x400,
attr_off 0x38, a valid three-attribute chain ending in ATTR_END at 0x158
and used 0x160, a record whose four bytes at 0x15c read 0x100 gives

	used - asize - roff = 0x160 - 0x100 - 0x158 = 0xffffff08

i.e. a ~4 GiB memmove whose source and destination both run off the end of
rec, a kmalloc(sbi->record_size) object (record.c:105).

The equivalent non-replay path already refuses this.  mi_remove_attr()
performs the same removal and starts with (record.c:548):

	if (aoff + asize > used)
		return false;

Apply the same bound, spelled as a subtraction to match the neighbouring
cases, and move the attr->size read after check_if_attr() so that the
header is known to lie inside the record before it is dereferenced.
Requiring roff + SIZEOF_RESIDENT <= used rejects the ATTR_END offset
without rejecting any real attribute: for an attribute the walk validated,
roff + asize <= off(ATTR_END) <= used - 4, and any attribute a
DeleteAttribute record can legitimately name carries a full resident
header, so roff + SIZEOF_RESIDENT <= roff + asize <= used - 4.
check_attr() itself imposes no lower bound on asize, so a crafted
sub-header asize can still pass the first test; the second test then
bounds it and the memmove stays inside the record.

Reproduced by mounting a crafted image on v7.2-rc5, which already contains
0ca0485e4b2e, under KASAN.  The image is an ordinary mkfs.ntfs volume with
four bytes of one MFT record changed and a crafted $LogFile:

  BUG: KASAN: slab-out-of-bounds in do_action.isra.0+0x3211/0x83c0
  Read of size 4294967048 at addr ffff888002423258 by task mount/66

  CPU: 1 UID: 0 PID: 66 Comm: mount Not tainted 7.2.0-rc5 #3
  Call Trace:
   kasan_report+0xce/0x100
   kasan_check_range+0x105/0x1b0
   __asan_memmove+0x23/0x60
   do_action.isra.0+0x3211/0x83c0
   log_replay+0x920a/0xd300
   ntfs_loadlog_and_replay+0x3ef/0x510
   ntfs_fill_super+0x1d23/0x4550
   get_tree_bdev_flags+0x2ef/0x550
   vfs_get_tree+0x82/0x2f0
   fc_mount+0x10/0x1b0
   path_mount+0x517/0x1df0
   __x64_sys_mount+0x20b/0x270
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Allocated by task 66:
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_noprof+0x1b4/0x460
   mi_init+0x81/0x110
   mi_get+0x6a/0x220
   do_action.isra.0+0x1dbf/0x83c0
   log_replay+0x920a/0xd300
   ntfs_loadlog_and_replay+0x3ef/0x510
   ntfs_fill_super+0x1d23/0x4550

  The buggy address belongs to the object at ffff888002423000
   which belongs to the cache kmalloc-1k of size 1024
  The buggy address is located 600 bytes inside of
   allocated 1024-byte region [ffff888002423000, ffff888002423400)

KASAN reports the source side because __asan_memmove()
(mm/kasan/shadow.c:94) validates src before dest and returns without
copying.  Both ends are out of bounds, and on a kernel built without
KASAN the copy is performed.

rec->used is also left at used - asize by fslog.c:3323 before the memmove,
so the record stays inconsistent even when the copy is suppressed; the same
mount goes on to report "ino=1a, mi_enum_attr" and marks the volume dirty.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Hyeontae Lee <wonju345@naver.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index f9b6275643f2c..e2668c57066b4 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3340,10 +3340,21 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 		break;
 
 	case DeleteAttribute:
-		asize = le32_to_cpu(attr->size);
 		used = le32_to_cpu(rec->used);
 
-		if (!check_if_attr(rec, lrh))
+		/*
+		 * check_if_attr() accepts a record_off that points at the
+		 * ATTR_END marker, which is how CreateAttribute appends.  The
+		 * bytes there are not an attribute and check_attr() never
+		 * validated them, so refuse an offset that cannot hold a
+		 * resident header before reading attr->size, and then bound it
+		 * as mi_remove_attr() does.
+		 */
+		if (!check_if_attr(rec, lrh) || roff + SIZEOF_RESIDENT > used)
+			goto dirty_vol;
+
+		asize = le32_to_cpu(attr->size);
+		if (asize > used - roff)
 			goto dirty_vol;
 
 		rec->used = cpu_to_le32(used - asize);
-- 
2.53.0




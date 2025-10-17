Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AEB33711F;
	Fri, 17 Oct 2025 15:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713997; cv=none; b=OZ37IDvUnC+JLPMppcqUVW78LqeZnjMyK9sIJ0lohuMzcUsyMVemk5BfrHUL2T+Uf+r5WhIm+hyKNQCrGOkEyjzCKuyJzwoHgYRALueDk1vHOzTgjoVxVK1eXzSmXqctywwaLQmPjDoOuXJMGirtWh9n1JsGrNeHgoISoggM+vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713997; c=relaxed/simple;
	bh=S0/mrCcecHSVtgx/B21FhupETVprvoyYIr008x/dILQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7/rJ/3y4/hSFm94necH2CfTg7F+4efhxB01Sz7RT8i6I0cxMJ3fwA97kvbslKP3ZYuAOcp5BkpY2pUHtt5EfNi2qDziVx77sShaJY2JH4R2B5JaBRMChjV9cnLiw+UImiAuSLC2Ika7KTa/qMNX1zbsjIQzhTcpJuC9JeNH2xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDN+YMFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDN+YMFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FD2C4CEE7;
	Fri, 17 Oct 2025 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713996;
	bh=S0/mrCcecHSVtgx/B21FhupETVprvoyYIr008x/dILQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDN+YMFdDNQcbi9Xml5mSXH3r90Bt1xOi9dTU1hexZSq/BBWgaEvI4oWymh8LZ0tq
	 ZwmHA4twoivvgpmye8kwx4dvxXwy5IcAW8xJYjZFJnOEKYDWBv7BSXpPDKOyW2i55I
	 jUzMEMmjYfZz82emYeSjxf3C5giXKNhWGTn+LOcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 150/201] ext4: correctly handle queries for metadata mappings
Date: Fri, 17 Oct 2025 16:53:31 +0200
Message-ID: <20251017145140.243791984@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit 46c22a8bb4cb03211da1100d7ee4a2005bf77c70 upstream.

Currently, our handling of metadata is _ambiguous_ in some scenarios,
that is, we end up returning unknown if the range only covers the
mapping partially.

For example, in the following case:

$ xfs_io -c fsmap -d

  0: 254:16 [0..7]: static fs metadata 8
  1: 254:16 [8..15]: special 102:1 8
  2: 254:16 [16..5127]: special 102:2 5112
  3: 254:16 [5128..5255]: special 102:3 128
  4: 254:16 [5256..5383]: special 102:4 128
  5: 254:16 [5384..70919]: inodes 65536
  6: 254:16 [70920..70967]: unknown 48
  ...

$ xfs_io -c fsmap -d 24 33

  0: 254:16 [24..39]: unknown 16  <--- incomplete reporting

$ xfs_io -c fsmap -d 24 33  (With patch)

    0: 254:16 [16..5127]: special 102:2 5112

This is because earlier in ext4_getfsmap_meta_helper, we end up ignoring
any extent that starts before our queried range, but overlaps it. While
the man page [1] is a bit ambiguous on this, this fix makes the output
make more sense since we are anyways returning an "unknown" extent. This
is also consistent to how XFS does it:

$ xfs_io -c fsmap -d

  ...
  6: 254:16 [104..127]: free space 24
  7: 254:16 [128..191]: inodes 64
  ...

$ xfs_io -c fsmap -d 137 150

  0: 254:16 [128..191]: inodes 64   <-- full extent returned

 [1] https://man7.org/linux/man-pages/man2/ioctl_getfsmap.2.html

Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Message-ID: <023f37e35ee280cd9baac0296cbadcbe10995cab.1757058211.git.ojaswin@linux.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fsmap.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -74,7 +74,8 @@ static int ext4_getfsmap_dev_compare(con
 static bool ext4_getfsmap_rec_before_low_key(struct ext4_getfsmap_info *info,
 					     struct ext4_fsmap *rec)
 {
-	return rec->fmr_physical < info->gfi_low.fmr_physical;
+	return rec->fmr_physical + rec->fmr_length <=
+	       info->gfi_low.fmr_physical;
 }
 
 /*
@@ -200,15 +201,18 @@ static int ext4_getfsmap_meta_helper(str
 			  ext4_group_first_block_no(sb, agno));
 	fs_end = fs_start + EXT4_C2B(sbi, len);
 
-	/* Return relevant extents from the meta_list */
+	/*
+	 * Return relevant extents from the meta_list. We emit all extents that
+	 * partially/fully overlap with the query range
+	 */
 	list_for_each_entry_safe(p, tmp, &info->gfi_meta_list, fmr_list) {
-		if (p->fmr_physical < info->gfi_next_fsblk) {
+		if (p->fmr_physical + p->fmr_length <= info->gfi_next_fsblk) {
 			list_del(&p->fmr_list);
 			kfree(p);
 			continue;
 		}
-		if (p->fmr_physical <= fs_start ||
-		    p->fmr_physical + p->fmr_length <= fs_end) {
+		if (p->fmr_physical <= fs_end &&
+		    p->fmr_physical + p->fmr_length > fs_start) {
 			/* Emit the retained free extent record if present */
 			if (info->gfi_lastfree.fmr_owner) {
 				error = ext4_getfsmap_helper(sb, info,



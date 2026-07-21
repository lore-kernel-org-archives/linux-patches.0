Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880C4471267;
	Tue, 21 Jul 2026 18:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657077; cv=none; b=Sxmv+xcWdQQP7KtHY/H1zVLyG1wKLV0I7qrJnrC1lWFFl3Mdx52qIWKTKH7Aib71o4XDBTcwtYPClMURGeTeuZ1ypMIsmCIvPJkMSlAG+Dvc3XKMej+QTSGomidizm9rxzVNYNzUEc46eFM00W0gKi+QZRFFIL+FR1ba9R9FhDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657077; c=relaxed/simple;
	bh=wYdwt0MszEfxFsG0lSe7Osecct0VcATzYI2giq+tuLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3w+BaZLIl83g5EfwD4SAm3JgKO5omilCuZdNH6QbE1uie+NLFJcCStg2LXcPUPOY/kA3160uAA4zuDzZ8W2amb8gDvxgs5n74zSBnaZFOOi8v9iPaQCyyh+NXagfOnqyQdjZAeDheng1cDNykWL32016E6P3henUVzWy262Ha8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAhVqsjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAhVqsjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5521F000E9;
	Tue, 21 Jul 2026 18:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657076;
	bh=FbI5PrpelQcPHuB4HCedMNhtKa1aF7/Qp3p+KWNWz24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAhVqsjUwL0LC4IZwUO4VvwX5KYgzCODSvIfqc6PtQm/b6eB2ZKu5mbELCanOrXcb
	 65iOXLfS9zORgFzVTL8QgTgqsd5EHZamq6KdV/ScA8VkJmu1hlCw9K0ayMTQQk8nnM
	 fvUCAjd4Ovsw72Sn97qo7sSI99GvooHoJbIYjUqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyeong Lee <lee@jaeyeong.cc>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0628/1611] fs/ntfs3: add bounds check to run_get_highest_vcn()
Date: Tue, 21 Jul 2026 17:12:24 +0200
Message-ID: <20260721152529.513302941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit bb11485a87fbb2254b62cfed630b699d50e57da8 ]

run_get_highest_vcn() parses a packed NTFS mapping-pairs buffer without
any length bound, relying solely on a 0x00 terminator to stop.  A
crafted $LogFile UpdateMappingPairs record whose embedded attribute
contains mapping-pairs runs without a terminator causes the function to
read past the slab allocation, triggering a KASAN slab-out-of-bounds
read on mount.

The sibling function run_unpack() received an analogous bounds-check in
commit b62567bca474 ("ntfs3: add buffer boundary checks to run_unpack()"),
but run_get_highest_vcn() was missed.

Take a run_buf_size parameter and reject any run header whose payload
would extend past the buffer end, mirroring the pattern used by
run_unpack().  The caller in fslog.c passes the remaining attribute
bytes after the mapping-pairs offset.

KASAN report (on mainline v7.1 merge window HEAD):

  BUG: KASAN: slab-out-of-bounds in run_get_highest_vcn+0x3c0/0x410
  Read of size 1 at addr ffff88800e2d5400 by task mount/72
  Call Trace:
   run_get_highest_vcn+0x3c0/0x410
   do_action.isra.0+0x3ba8/0x7b50
   log_replay+0x9ddd/0x10200
   ntfs_loadlog_and_replay+0x4ad/0x610
   ntfs_fill_super+0x214a/0x4540

Fixes: b62567bca474 ("ntfs3: add buffer boundary checks to run_unpack()")
Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c   | 5 ++++-
 fs/ntfs3/ntfs_fs.h | 3 ++-
 fs/ntfs3/run.c     | 9 +++++++--
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 5d9a2e1159af98..5aa3ac25aaeb73 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3362,7 +3362,10 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 		memmove(Add2Ptr(attr, aoff), data, dlen);
 
 		if (run_get_highest_vcn(le64_to_cpu(attr->nres.svcn),
-					attr_run(attr), &t64)) {
+					attr_run(attr),
+				        le32_to_cpu(attr->size) - 
+				                le16_to_cpu(attr->nres.run_off),	
+					&t64)) {
 			goto dirty_vol;
 		}
 
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 7fb08bff025491..7e3d51b8d2ddfa 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -821,7 +821,8 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
 #else
 #define run_unpack_ex run_unpack
 #endif
-int run_get_highest_vcn(CLST vcn, const u8 *run_buf, u64 *highest_vcn);
+int run_get_highest_vcn(CLST vcn, const u8 *run_buf, size_t run_buf_size, 
+		       u64 *highest_vcn);
 int run_clone(const struct runs_tree *run, struct runs_tree *new_run);
 
 /* Globals from super.c */
diff --git a/fs/ntfs3/run.c b/fs/ntfs3/run.c
index de9081be462e59..66baaada02e9a2 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1160,18 +1160,23 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
  * Return the highest vcn from a mapping pairs array
  * it used while replaying log file.
  */
-int run_get_highest_vcn(CLST vcn, const u8 *run_buf, u64 *highest_vcn)
+int run_get_highest_vcn(CLST vcn, const u8 *run_buf, size_t run_buf_size, 
+		       u64 *highest_vcn)
 {
+	const u8 *run_last = run_buf + run_buf_size;
 	u64 vcn64 = vcn;
 	u8 size_size;
 
-	while ((size_size = *run_buf & 0xF)) {
+	while (run_buf < run_last && (size_size = *run_buf & 0xF)) {
 		u8 offset_size = *run_buf++ >> 4;
 		u64 len;
 
 		if (size_size > 8 || offset_size > 8)
 			return -EINVAL;
 
+		if (run_buf + size_size + offset_size > run_last) 
+			return -EINVAL;
+
 		len = run_unpack_s64(run_buf, size_size, 0);
 		if (!len)
 			return -EINVAL;
-- 
2.53.0




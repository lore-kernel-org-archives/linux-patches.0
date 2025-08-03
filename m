Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654711D5CC6;
	Sun,  3 Aug 2025 21:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256010; cv=none; b=XR9dK622DflJWtXZ4v5B/lQ1q3HfPWacBuewJoSmF0d7H8s6nR4v4E/hfPXuuzWqg1zsidu55oiqkFQOcRMYafPbrXDddkuKn4ByRR72aJpPzKo9zsdENm5jUyNWiP8fR0HG924/lomto6XVoe8KYxPAfFpOMhkyiwuFIrychKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256010; c=relaxed/simple;
	bh=/UrUI4XQ2djlXt2UaUC471gfyjZ3vwAugIGJCFv5QrE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YhVU0fdNa4blCSU8673lR6gLA+rASc55eLr5CRdhlJHnnIheSuGZhO+glxX1sJjNL8G0w0BTJMbrQpKI+h28ATptmMprRXIIp/U1rOQZz8z6We3hIQ+XAGizanUKtMqpdoS2aCoaGeiDWtptpxdobWhB1TEMwZAn32KwmwiYHFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pSeXOqU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pSeXOqU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98C6C4CEF0;
	Sun,  3 Aug 2025 21:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256010;
	bh=/UrUI4XQ2djlXt2UaUC471gfyjZ3vwAugIGJCFv5QrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSeXOqU7DWhGoPEoR49e6h2NJaRL8mLJZuXN51sHiRhiqWONcdtIWT5JDW9Ai18gc
	 J5zcofonudYz+UzmmifEHzzViykWT18bRNePSBXgrC20VdT4BrS6sjUe+FXwrd6zDY
	 4rzas0jts1NVMtn5//hXuAa5bkje6jbyLsRvxPWzJt14uM83EysZcZaT7/LoptMbC8
	 6bTnbaz0D7b+sUHN22KhIZFdpnPgQCMCoE+rahhyD6UK/lhem/WN46reCHnZ94ETXS
	 d+bGYE87G1GQz4blEbkhbw6G7tdgk4DMCS2uuLdRk+xwRQD4ZYG4POgQ7m3fUMRUsb
	 Ti+vtMX9plsYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrew Price <anprice@redhat.com>,
	syzbot+4708579bb230a0582a57@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.12 13/31] gfs2: Validate i_depth for exhash directories
Date: Sun,  3 Aug 2025 17:19:16 -0400
Message-Id: <20250803211935.3547048-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211935.3547048-1-sashal@kernel.org>
References: <20250803211935.3547048-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: Andrew Price <anprice@redhat.com>

[ Upstream commit 557c024ca7250bb65ae60f16c02074106c2f197b ]

A fuzzer test introduced corruption that ends up with a depth of 0 in
dir_e_read(), causing an undefined shift by 32 at:

  index = hash >> (32 - dip->i_depth);

As calculated in an open-coded way in dir_make_exhash(), the minimum
depth for an exhash directory is ilog2(sdp->sd_hash_ptrs) and 0 is
invalid as sdp->sd_hash_ptrs is fixed as sdp->bsize / 16 at mount time.

So we can avoid the undefined behaviour by checking for depth values
lower than the minimum in gfs2_dinode_in(). Values greater than the
maximum are already being checked for there.

Also switch the calculation in dir_make_exhash() to use ilog2() to
clarify how the depth is calculated.

Tested with the syzkaller repro.c and xfstests '-g quick'.

Reported-by: syzbot+4708579bb230a0582a57@syzkaller.appspotmail.com
Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a Critical Security Bug**: The commit fixes an undefined
   behavior caused by an invalid shift operation (`index = hash >> (32 -
   dip->i_depth)`) when `i_depth` is 0. This results in a shift by 32,
   which is undefined behavior in C and can lead to unpredictable
   results or crashes.

2. **Reported by Syzbot**: The bug was discovered by syzbot (Google's
   kernel fuzzer), indicating it's a real issue that can be triggered,
   not just theoretical. The commit message includes `Reported-by:
   syzbot+4708579bb230a0582a57@syzkaller.appspotmail.com`.

3. **Small and Contained Fix**: The changes are minimal and focused:
   - In `fs/gfs2/dir.c`: Simply replaces an open-coded calculation with
     `ilog2()` for clarity
   - In `fs/gfs2/glops.c`: Adds a validation check for `i_depth` to
     ensure it's not less than the minimum valid value

4. **Clear Boundary Checking**: The fix adds proper validation in
   `gfs2_dinode_in()`:
  ```c
  if ((ip->i_diskflags & GFS2_DIF_EXHASH) &&
  depth < ilog2(sdp->sd_hash_ptrs)) {
  gfs2_consist_inode(ip);
  return -EIO;
  }
  ```
  This ensures exhash directories have a valid minimum depth based on
  the hash pointer count.

5. **No Feature Changes**: The commit doesn't introduce new features or
   change the filesystem behavior - it only adds validation to prevent
   corruption from causing undefined behavior.


7. **Tested**: The commit message indicates it was tested with both the
   syzkaller reproducer and xfstests, providing confidence in the fix.

The fix prevents filesystem corruption from causing undefined behavior
that could lead to crashes or security issues, making it an excellent
candidate for stable backporting according to stable tree rules.

 fs/gfs2/dir.c   | 6 ++----
 fs/gfs2/glops.c | 6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index dbf1aede744c..509e2f0d97e7 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -60,6 +60,7 @@
 #include <linux/crc32.h>
 #include <linux/vmalloc.h>
 #include <linux/bio.h>
+#include <linux/log2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -912,7 +913,6 @@ static int dir_make_exhash(struct inode *inode)
 	struct qstr args;
 	struct buffer_head *bh, *dibh;
 	struct gfs2_leaf *leaf;
-	int y;
 	u32 x;
 	__be64 *lp;
 	u64 bn;
@@ -979,9 +979,7 @@ static int dir_make_exhash(struct inode *inode)
 	i_size_write(inode, sdp->sd_sb.sb_bsize / 2);
 	gfs2_add_inode_blocks(&dip->i_inode, 1);
 	dip->i_diskflags |= GFS2_DIF_EXHASH;
-
-	for (x = sdp->sd_hash_ptrs, y = -1; x; x >>= 1, y++) ;
-	dip->i_depth = y;
+	dip->i_depth = ilog2(sdp->sd_hash_ptrs);
 
 	gfs2_dinode_out(dip, dibh->b_data);
 
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 4b6b23c638e2..1ed42f0e6ec7 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -11,6 +11,7 @@
 #include <linux/bio.h>
 #include <linux/posix_acl.h>
 #include <linux/security.h>
+#include <linux/log2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -450,6 +451,11 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
+	if ((ip->i_diskflags & GFS2_DIF_EXHASH) &&
+	    depth < ilog2(sdp->sd_hash_ptrs)) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-- 
2.39.5


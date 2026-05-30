Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2CC282F23;
	Sat, 30 May 2026 18:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165581; cv=none; b=J3C9PxQXpNratc14QCksQ5ha8nEZMIczVPgeynnEiChNy5+pql0RhSzKlvXD1zYeKZOTbCjCoqYnh/gU+ioYTQyOkozFH9deX0+zy2Rs/2QUAR6wSShqWRenew2cNUOKISrQmyeitKaqLlEFBNiWhYwCB9VqVJEZpdX1qkGKQdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165581; c=relaxed/simple;
	bh=fohw1PUt1pAmkmzlAZjPJhOvSPF6m1R5YpX2WGEaoi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlvjzfryyLNaRJohyLn0FnmtDzQTw6RT2KmAP1Y+sjVT8xiVF9/rv0AFuomrBwp9NYwn6rkiwLbg+Yha4JA0t4P0NSvp4knB81/UfGp0U7qDl3DJwQSpCIAOOGtgyGWrQVzwHubfzTuoltd1o2vbUk6B+/QQ9IhtDj3BzUw8iR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NuB7wywL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NuB7wywL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF28A1F00893;
	Sat, 30 May 2026 18:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165580;
	bh=NiTSBE9QZlqqIp2KvTc3Z2Y432xMemesLFZrpevMuVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NuB7wywLZSmyby6EOfg7VzDzEDSwIDu5EZ4OymkLyDm9JMnzGgOeLF3EFtzPUUA0I
	 FhUXw6TZe2rWppykM5cXMdm2Bukr81NccsWZm96uGV9p/AyXZjbNdQL/ANONRcxThT
	 CX2kYO6kpZatENvN5HiDyb+yGo1CwaWZriGWt3V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4708579bb230a0582a57@syzkaller.appspotmail.com,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Ruohan Lan <ruohanlan@aliyun.com>
Subject: [PATCH 5.10 120/589] gfs2: Validate i_depth for exhash directories
Date: Sat, 30 May 2026 18:00:01 +0200
Message-ID: <20260530160227.917537634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
[ To maintain consistency in error handling in gfs2_dinode_in(),
use "goto corrupt" in v5.10. ]
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/dir.c   |    6 ++----
 fs/gfs2/glops.c |    4 ++++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -60,6 +60,7 @@
 #include <linux/crc32.h>
 #include <linux/vmalloc.h>
 #include <linux/bio.h>
+#include <linux/log2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -910,7 +911,6 @@ static int dir_make_exhash(struct inode
 	struct qstr args;
 	struct buffer_head *bh, *dibh;
 	struct gfs2_leaf *leaf;
-	int y;
 	u32 x;
 	__be64 *lp;
 	u64 bn;
@@ -977,9 +977,7 @@ static int dir_make_exhash(struct inode
 	i_size_write(inode, sdp->sd_sb.sb_bsize / 2);
 	gfs2_add_inode_blocks(&dip->i_inode, 1);
 	dip->i_diskflags |= GFS2_DIF_EXHASH;
-
-	for (x = sdp->sd_hash_ptrs, y = -1; x; x >>= 1, y++) ;
-	dip->i_depth = y;
+	dip->i_depth = ilog2(sdp->sd_hash_ptrs);
 
 	gfs2_dinode_out(dip, dibh->b_data);
 
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -11,6 +11,7 @@
 #include <linux/bio.h>
 #include <linux/posix_acl.h>
 #include <linux/security.h>
+#include <linux/log2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -452,6 +453,9 @@ static int gfs2_dinode_in(struct gfs2_in
 	depth = be16_to_cpu(str->di_depth);
 	if (unlikely(depth > GFS2_DIR_MAX_DEPTH))
 		goto corrupt;
+	if ((ip->i_diskflags & GFS2_DIF_EXHASH) &&
+	    depth < ilog2(sdp->sd_hash_ptrs))
+		goto corrupt;
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 



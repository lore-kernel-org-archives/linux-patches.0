Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D929318BC1D;
	Fri, 27 Sep 2024 12:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440347; cv=none; b=dqgOVZs4iw27Jva5GhDdj7AqLuUGbWkwJYoyMaKH3d8ViJMR8znpro1nq1CRxJ1Q2h3/MulMW5GNJKwTmLYw7PpNztI5J+Bh0jl66oRV5MZ/GOhBjkZP73VBPAkUucxMDuHC9K76O4sHuY6XyqOB+5uobaL05+79zoc8qgzsg8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440347; c=relaxed/simple;
	bh=kZ7TJf2bXbwPeeyNB5bwLd4nLtkm+jFGZYUkrYOqQfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N62idy5sBmyIXB+jvfirG/Tv1bPAKqf1QrAWYYrfscxqyUaKG803k2RdkcJ4JXTO+n8NKtSSDpHrurvEICg3AndgpxbvIQq1RN2vDChsbmV9yeGvyn33fBCZgZpvz7EOj/zleKYuZMaAGgAJlhUyFvZVGivFT8iQpLyVAgxonf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CUtPZEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CUtPZEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A0DC4CEC6;
	Fri, 27 Sep 2024 12:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440347;
	bh=kZ7TJf2bXbwPeeyNB5bwLd4nLtkm+jFGZYUkrYOqQfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CUtPZEW0mptCCK5NiUgnh8xxsBP/naPe2wJw03bk5QJqZuDXdwyyqF3WZ4OaUkF7
	 BnBVMDOIkrQVFIIu0xUTkGC9/grkZWefmGYX8JtRKdNX/xDAK+2U92mBXEFvpd18ss
	 ZtrUiQFYOEc9xuOMXHtd38t+ZyWfMQpnXMY8XnvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 50/73] xfs: fix negative array access in xfs_getbmap
Date: Fri, 27 Sep 2024 14:24:01 +0200
Message-ID: <20240927121721.928983165@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 1bba82fe1afac69c85c1f5ea137c8e73de3c8032 ]

In commit 8ee81ed581ff, Ye Bin complained about an ASSERT in the bmapx
code that trips if we encounter a delalloc extent after flushing the
pagecache to disk.  The ioctl code does not hold MMAPLOCK so it's
entirely possible that a racing write page fault can create a delalloc
extent after the file has been flushed.  The proposed solution was to
replace the assertion with an early return that avoids filling out the
bmap recordset with a delalloc entry if the caller didn't ask for it.

At the time, I recall thinking that the forward logic sounded ok, but
felt hesitant because I suspected that changing this code would cause
something /else/ to burst loose due to some other subtlety.

syzbot of course found that subtlety.  If all the extent mappings found
after the flush are delalloc mappings, we'll reach the end of the data
fork without ever incrementing bmv->bmv_entries.  This is new, since
before we'd have emitted the delalloc mappings even though the caller
didn't ask for them.  Once we reach the end, we'll try to set
BMV_OF_LAST on the -1st entry (because bmv_entries is zero) and go
corrupt something else in memory.  Yay.

I really dislike all these stupid patches that fiddle around with debug
code and break things that otherwise worked well enough.  Nobody was
complaining that calling XFS_IOC_BMAPX without BMV_IF_DELALLOC would
return BMV_OF_DELALLOC records, and now we've gone from "weird behavior
that nobody cared about" to "bad behavior that must be addressed
immediately".

Maybe I'll just ignore anything from Huawei from now on for my own sake.

Reported-by: syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-xfs/20230412024907.GP360889@frogsfrogsfrogs/
Fixes: 8ee81ed581ff ("xfs: fix BUG_ON in xfs_getbmap()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_util.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -558,7 +558,9 @@ xfs_getbmap(
 		if (!xfs_iext_next_extent(ifp, &icur, &got)) {
 			xfs_fileoff_t	end = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
 
-			out[bmv->bmv_entries - 1].bmv_oflags |= BMV_OF_LAST;
+			if (bmv->bmv_entries > 0)
+				out[bmv->bmv_entries - 1].bmv_oflags |=
+								BMV_OF_LAST;
 
 			if (whichfork != XFS_ATTR_FORK && bno < end &&
 			    !xfs_getbmap_full(bmv)) {



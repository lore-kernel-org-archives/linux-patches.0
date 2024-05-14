Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F011E495;
	Tue, 14 May 2024 11:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684883; cv=none; b=Vxp2sWQOpIS4Ind7PrcUCmZ/mA7USIb+qOfF7kvSW78GZHZhS/F5lGggzjefSlS2RL7bpz3y3YXctiBia3hN+6mOtYV9NOlzvHSdhyDTxST0/P+8N0RaP2HCdKfcXcZ2QfOREYGF2YCxgsn1Lx4CsrcsPz/boR+Rksvkd9TX6H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684883; c=relaxed/simple;
	bh=bVpf/bpO/CP2zs/m1ZfUXvozMN/+6apCv/ZieOAlcH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFqCLdCozc4dpUu3bZvl02k+EFh5mYO+ZLB9KkfX33Q8jmgeYZ6Qds/TN/8TQyNgRrMm+Ks6AwdA1CR2vEQOoO3KopVTmfWtTeMEzZAFh8M6/UmBmVXreIDJZZJbdwN3TfH6LObrAQ3GEMf+fNPX03AkdD/iIJZSsb48Xxazs+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THZ+P5qK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THZ+P5qK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE83C2BD10;
	Tue, 14 May 2024 11:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684882;
	bh=bVpf/bpO/CP2zs/m1ZfUXvozMN/+6apCv/ZieOAlcH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THZ+P5qKGj/taIzUa/jzbIJL3Gvk2J3NLPsfzo9LW4ra0W+bdTHeuHIW7URt38pu7
	 kUbc8qc/CehXUCCijToPey8jLD4BSRX/cQeL9JoWus7xFU8sqFYBF2tfdfrjJ+nHiY
	 Z361qEgGNjJu2SmZOBQ6RmW+wt0IzS/VbgshWFpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/301] gfs2: Fix invalid metadata access in punch_hole
Date: Tue, 14 May 2024 12:16:14 +0200
Message-ID: <20240514101036.139567280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Andrew Price <anprice@redhat.com>

[ Upstream commit c95346ac918c5badf51b9a7ac58a26d3bd5bb224 ]

In punch_hole(), when the offset lies in the final block for a given
height, there is no hole to punch, but the maximum size check fails to
detect that.  Consequently, punch_hole() will try to punch a hole beyond
the end of the metadata and fail.  Fix the maximum size check.

Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index ef7017fb69512..2b578615607e4 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1715,7 +1715,8 @@ static int punch_hole(struct gfs2_inode *ip, u64 offset, u64 length)
 	struct buffer_head *dibh, *bh;
 	struct gfs2_holder rd_gh;
 	unsigned int bsize_shift = sdp->sd_sb.sb_bsize_shift;
-	u64 lblock = (offset + (1 << bsize_shift) - 1) >> bsize_shift;
+	unsigned int bsize = 1 << bsize_shift;
+	u64 lblock = (offset + bsize - 1) >> bsize_shift;
 	__u16 start_list[GFS2_MAX_META_HEIGHT];
 	__u16 __end_list[GFS2_MAX_META_HEIGHT], *end_list = NULL;
 	unsigned int start_aligned, end_aligned;
@@ -1726,7 +1727,7 @@ static int punch_hole(struct gfs2_inode *ip, u64 offset, u64 length)
 	u64 prev_bnr = 0;
 	__be64 *start, *end;
 
-	if (offset >= maxsize) {
+	if (offset + bsize - 1 >= maxsize) {
 		/*
 		 * The starting point lies beyond the allocated metadata;
 		 * there are no blocks to deallocate.
-- 
2.43.0




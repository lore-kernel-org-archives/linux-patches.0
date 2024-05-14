Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05C075808;
	Tue, 14 May 2024 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687102; cv=none; b=da3w6AGE/fltXV8/5qUH/AcFO9xyvH8TtvZv+5gbHS5bxtAegahIhSq4hwVWYJ4uYKa5oGZjbeluu5gEi/JAJT07S6Vy9pYG/MuWnryiA2jon9g/SJ/GGUXybkaXPWFLVJqStHq7Run6eYY4HzOb+wCpPndWMb/eBG+oiczdNv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687102; c=relaxed/simple;
	bh=zSCGQOnqsloD0AI1Kdo1pfYsMmbgUc+FOkYyXrCGYSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAPD8AZ7VNDCq/Zsr7AaAAMJZK8rty+8/q9QsOmWAGxWtxf1brLgRpN3qoKV1xtGNZQNWnbqBt2BHBeY1L+B6H3zBgldQjebe8m+uYZobsUf1HwJTBLuuitTcfHVpe/Iisw0g1EwzWwRhBh4BLF+M+UOiXE9LYVDMo7gvrvuG48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8I1Wnon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8I1Wnon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489FCC2BD10;
	Tue, 14 May 2024 11:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687102;
	bh=zSCGQOnqsloD0AI1Kdo1pfYsMmbgUc+FOkYyXrCGYSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8I1WnonLpov+XAxti8tkH2/JoshH0yl8NMfFUQ2qq1fhVfEyWX89/JbTJ8oUhT34
	 aTrhzB0XHwbbc0br2UHt3ePyR7dN/NifWwUr1p/vYggVZsfRKdNBSzNNb/RX34Czd8
	 RhpvFIlM6bz0sTdtVGKCgLU9lBbpDqz9YMJsD4ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/84] gfs2: Fix invalid metadata access in punch_hole
Date: Tue, 14 May 2024 12:19:45 +0200
Message-ID: <20240514100952.977879038@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 63e925aa12a75..1dc0f0bca3ab3 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1760,7 +1760,8 @@ static int punch_hole(struct gfs2_inode *ip, u64 offset, u64 length)
 	struct buffer_head *dibh, *bh;
 	struct gfs2_holder rd_gh;
 	unsigned int bsize_shift = sdp->sd_sb.sb_bsize_shift;
-	u64 lblock = (offset + (1 << bsize_shift) - 1) >> bsize_shift;
+	unsigned int bsize = 1 << bsize_shift;
+	u64 lblock = (offset + bsize - 1) >> bsize_shift;
 	__u16 start_list[GFS2_MAX_META_HEIGHT];
 	__u16 __end_list[GFS2_MAX_META_HEIGHT], *end_list = NULL;
 	unsigned int start_aligned, end_aligned;
@@ -1771,7 +1772,7 @@ static int punch_hole(struct gfs2_inode *ip, u64 offset, u64 length)
 	u64 prev_bnr = 0;
 	__be64 *start, *end;
 
-	if (offset >= maxsize) {
+	if (offset + bsize - 1 >= maxsize) {
 		/*
 		 * The starting point lies beyond the allocated meta-data;
 		 * there are no blocks do deallocate.
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E85A357A4A;
	Tue, 17 Mar 2026 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766783; cv=none; b=I0uiQ1WwJKQYTUug6QXyU+lr617AY9HmmrSQhB1bifnJIa66ZyxNSPii+XDzc10/0ohTSZ3hHh8mdRLx6jinWtaJ8OExStvLwtxfS+rogmIjhsx58WZo6Mbsq5wVtcw2KetZD+n/6pqtAlPeKwpMgWzmyTbE5pdntm6EulLZ4dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766783; c=relaxed/simple;
	bh=kpVvomIlLaS9tQl93XxYsP1DeR2Ee43brCw6FpvmwBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5bOAB3YHkuBzQAQ3gscdfj5VXOM40qz2ghzRujl7rGAh6sB9pIV5BtV1+eDy+Ho5/PkiC/4NiCNkgBneYKGosDmasGqLsDJ44+0mJv6jl4dctINHaw9G/Gk2bi7QZPr0+4nY1EiHEgSls0zRf2DkqNTDmmNsqfjJn7AOHXykVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHG/lYmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHG/lYmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC44C4CEF7;
	Tue, 17 Mar 2026 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766782;
	bh=kpVvomIlLaS9tQl93XxYsP1DeR2Ee43brCw6FpvmwBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHG/lYmYIzQn8oqZZ2GOUXDmLk6lcUa8pmLiIYNq8AJfY3F2QunYs4XmcEH+4Mr6i
	 7I46jFsRL4wP5K+0twiGeyEurgRDoSUKXmTaIv+NqFXEjh6/H7vTOlMJBjoWhn6Be3
	 7gp+AzmBoQZYtXaExEB0Hq4hwC6ozTBz9HS+O4is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.19 321/378] xfs: fix undersized l_iclog_roundoff values
Date: Tue, 17 Mar 2026 17:34:38 +0100
Message-ID: <20260317163018.800140669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 52a8a1ba883defbfe3200baa22cf4cd21985d51a upstream.

If the superblock doesn't list a log stripe unit, we set the incore log
roundoff value to 512.  This leads to corrupt logs and unmountable
filesystems in generic/617 on a disk with 4k physical sectors...

XFS (sda1): Mounting V5 Filesystem ff3121ca-26e6-4b77-b742-aaff9a449e1c
XFS (sda1): Torn write (CRC failure) detected at log block 0x318e. Truncating head block from 0x3197.
XFS (sda1): failed to locate log tail
XFS (sda1): log mount/recovery failed: error -74
XFS (sda1): log mount failed
XFS (sda1): Mounting V5 Filesystem ff3121ca-26e6-4b77-b742-aaff9a449e1c
XFS (sda1): Ending clean mount

...on the current xfsprogs for-next which has a broken mkfs.  xfs_info
shows this...

meta-data=/dev/sda1              isize=512    agcount=4, agsize=644992 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=4096   blocks=2579968, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=4096  sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=268435456 extents
         =                       zoned=0      start=0 reserved=0

...observe that the log section has sectsz=4096 sunit=0, which means
that the roundoff factor is 512, not 4096 as you'd expect.  We should
fix mkfs not to generate broken filesystems, but anyone can fuzz the
ondisk superblock so we should be more cautious.  I think the inadequate
logic predates commit a6a65fef5ef8d0, but that's clearly going to
require a different backport.

Cc: stable@vger.kernel.org # v5.14
Fixes: a6a65fef5ef8d0 ("xfs: log stripe roundoff is a property of the log")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1399,6 +1399,8 @@ xlog_alloc_log(
 
 	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
 		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
+	else if (mp->m_sb.sb_logsectsize > 0)
+		log->l_iclog_roundoff = mp->m_sb.sb_logsectsize;
 	else
 		log->l_iclog_roundoff = BBSIZE;
 



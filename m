Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CF61A6828;
	Mon, 23 Mar 2026 14:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275704; cv=none; b=NdpgZEe0KX4EtvskWwWUS5RXnTxc06r10m3N7Y3JDDjs0vW6oWAaolj8+pTpd2DxxyAc+9dU+eQ4CNBcmjopxmKnLgOOqZEb27YWoCYVABaRM4vsB5QSlO+k1nUeOcdljJb6yO3BYgGZ5ZiD+l8iZEs7YBDNG/5iUJ2vNcjGckI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275704; c=relaxed/simple;
	bh=VzSD0nrSgKS9meqLlpVHOnOWniTWtpi2HYbUk+S8Wag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nskoB6laD9ahZ/yM3w/EazCgMrfc34gnaW+1YKHOhC4ZNUCjYihXK7Ly0JzW8WVeeEY0PplBi1hD1RXAATu4gPJHBFSYE0M1HVzkpnPQCoYLQt2pPb7D9rb5Hcn79CYSEq6xG1LKdlq/qs8xRn1d74kvEHS0FgDUjMXTchxbed0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2oUHeAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2oUHeAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5271AC4CEF7;
	Mon, 23 Mar 2026 14:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275703;
	bh=VzSD0nrSgKS9meqLlpVHOnOWniTWtpi2HYbUk+S8Wag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2oUHeAqCh64bHtVwdR8ausOLNLvMX1NLQd4Ju4HMXjnEGYxyFcAvfWjEcfq1F+Xc
	 Ts7gi5n9wroSqGlRrMxOjAhzyEHYz8g/9V9LIVtdUZHYmmxDs3o6kZvEgILFpgEn/R
	 s+k7cQRQ3Nw5EJgWcC83etWbSj5c7fDytzRXwuSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 188/460] xfs: fix undersized l_iclog_roundoff values
Date: Mon, 23 Mar 2026 14:43:04 +0100
Message-ID: <20260323134531.171055884@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1396,6 +1396,8 @@ xlog_alloc_log(
 
 	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
 		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
+	else if (mp->m_sb.sb_logsectsize > 0)
+		log->l_iclog_roundoff = mp->m_sb.sb_logsectsize;
 	else
 		log->l_iclog_roundoff = BBSIZE;
 



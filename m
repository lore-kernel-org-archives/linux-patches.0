Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD3624DCF6;
	Mon, 13 Apr 2026 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097535; cv=none; b=ik1PuH0v/7Z7d+lLjZuSfMQvJ0rMVk/D8w1uX2dJFl1UH9G5h/RAiYEjzdQMre0e92Sp0559t8fQ39P6MQYCjdqSzzar6tsI6YYLnAX+z0oKJUylTbQeWJPWeVhyTJVukxuU+SNqJ2uORP2zfxwUHkckENxBd+h1TNG1VptRpy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097535; c=relaxed/simple;
	bh=oy5C0PGg2q9KbohQbJgan7OnWAVtvdL5vECJoAE/GXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzBVNqsixgyow+FKMGTqyzHXVFDI0Gw5Vc4S+2QThM+kzXM5bxeiMSGZfiyIAapIuEmcaHqWaaPSWjRJbD6ESQA1RXQ1u8gjr0OpJD4PPNN/shDFCurWEcmYPnpH+NAwR1gigXP1Z9rt3wAmUozatczytojunfaAGAp9zBcv+w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eJsm3M4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eJsm3M4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3839CC2BCAF;
	Mon, 13 Apr 2026 16:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097535;
	bh=oy5C0PGg2q9KbohQbJgan7OnWAVtvdL5vECJoAE/GXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eJsm3M4cVvVB7wyVMyJIHyPY3pjXvrheRDRV9gvEyciTtlU/9sKpSe706wr5/4z/
	 Vg7QXFhYjiyUw1P3S0+C6xNY9JC/ZxFzh3Po+cYhGDaA2mQlHvvOCd58aKv+qWvyLT
	 1ScAzk+cQh+rvUjPOazMm0uZutV+zLrn7HeXlIQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 175/570] xfs: fix undersized l_iclog_roundoff values
Date: Mon, 13 Apr 2026 17:55:06 +0200
Message-ID: <20260413155837.010805329@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1503,6 +1503,8 @@ xlog_alloc_log(
 
 	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
 		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
+	else if (mp->m_sb.sb_logsectsize > 0)
+		log->l_iclog_roundoff = mp->m_sb.sb_logsectsize;
 	else
 		log->l_iclog_roundoff = BBSIZE;
 



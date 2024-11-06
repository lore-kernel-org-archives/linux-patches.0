Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383FE1FB8B1;
	Wed,  6 Nov 2024 12:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897670; cv=none; b=XvsaFvZuTq699xidQuZUwMESzKMQHUlmBPU+CTGO3c3aua1DBQlmu1k4l+PzBf1hsNSOZDFgwEm4znSVTE4dVZGsT5nOokm3VhRnQffPHxuHms6zYF1srZg288YgyyWAQvbMA7UXR7i0vEOSAmxof4KrPmiF8FDFw4wT+WRYwGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897670; c=relaxed/simple;
	bh=ncbGO4h92UUkd2BMrrJzJVcJ4lBFbkk3nXlfvy6fMW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFp2b/dxshMj4nuiSFa0+cijIIyrfp6pW7+6d5yjDB6uvXz4UIhaL+ra6MM1YaLPEPYUKTHvthOzLttdlXBQGd1ZHc2HA6XXmS8oNQ4kSwRxp0KVyimZ1QBgusBtmr/OPFyjf+57Odwj39nuRLpzDgJZs7vEuzEKAjJlpUCHW4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYCqEVGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYCqEVGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14BDC4CECD;
	Wed,  6 Nov 2024 12:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897670;
	bh=ncbGO4h92UUkd2BMrrJzJVcJ4lBFbkk3nXlfvy6fMW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYCqEVGwFlTJidr/hALagouO7M4itkUnLL/BTD4jRXigZc4SL1Vzax/NGWOZVPpPp
	 1YyXyptp/1np5ABssedOPqhPDqR6pdnFCAfD9oWoFglxntxGDC2ImYyLkikV93AVI/
	 zM6K9NVKkIlC6rpXVUNeT3qMFQtPqsWi2qOWkjEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/151] xfs: fix finding a last resort AG in xfs_filestream_pick_ag
Date: Wed,  6 Nov 2024 13:05:19 +0100
Message-ID: <20241106120312.465329693@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit dc60992ce76fbc2f71c2674f435ff6bde2108028 ]

When the main loop in xfs_filestream_pick_ag fails to find a suitable
AG it tries to just pick the online AG.  But the loop for that uses
args->pag as loop iterator while the later code expects pag to be
set.  Fix this by reusing the max_pag case for this last resort, and
also add a check for impossible case of no AG just to make sure that
the uninitialized pag doesn't even escape in theory.

Reported-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Fixes: f8f1ed1ab3baba ("xfs: return a referenced perag from filestreams allocator")
Cc: <stable@vger.kernel.org> # v6.3
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_filestream.c | 23 ++++++++++++-----------
 fs/xfs/xfs_trace.h      | 15 +++++----------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 2fc98d3137086..f62b023f274e9 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -64,7 +64,7 @@ xfs_filestream_pick_ag(
 	struct xfs_perag	*pag;
 	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
-	xfs_extlen_t		free = 0, minfree, maxfree = 0;
+	xfs_extlen_t		minfree, maxfree = 0;
 	xfs_agnumber_t		agno;
 	bool			first_pass = true;
 	int			err;
@@ -107,7 +107,6 @@ xfs_filestream_pick_ag(
 			     !(flags & XFS_PICK_USERDATA) ||
 			     (flags & XFS_PICK_LOWSPACE))) {
 				/* Break out, retaining the reference on the AG. */
-				free = pag->pagf_freeblks;
 				break;
 			}
 		}
@@ -150,23 +149,25 @@ xfs_filestream_pick_ag(
 		 * grab.
 		 */
 		if (!max_pag) {
-			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
+			for_each_perag_wrap(args->mp, 0, start_agno, pag) {
+				max_pag = pag;
 				break;
-			atomic_inc(&args->pag->pagf_fstrms);
-			*longest = 0;
-		} else {
-			pag = max_pag;
-			free = maxfree;
-			atomic_inc(&pag->pagf_fstrms);
+			}
+
+			/* Bail if there are no AGs at all to select from. */
+			if (!max_pag)
+				return -ENOSPC;
 		}
+
+		pag = max_pag;
+		atomic_inc(&pag->pagf_fstrms);
 	} else if (max_pag) {
 		xfs_perag_rele(max_pag);
 	}
 
-	trace_xfs_filestream_pick(pag, pino, free);
+	trace_xfs_filestream_pick(pag, pino);
 	args->pag = pag;
 	return 0;
-
 }
 
 static struct xfs_inode *
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3926cf7f2a6ed..d562028281f5c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -672,8 +672,8 @@ DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
 
 TRACE_EVENT(xfs_filestream_pick,
-	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino, xfs_extlen_t free),
-	TP_ARGS(pag, ino, free),
+	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino),
+	TP_ARGS(pag, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -684,14 +684,9 @@ TRACE_EVENT(xfs_filestream_pick,
 	TP_fast_assign(
 		__entry->dev = pag->pag_mount->m_super->s_dev;
 		__entry->ino = ino;
-		if (pag) {
-			__entry->agno = pag->pag_agno;
-			__entry->streams = atomic_read(&pag->pagf_fstrms);
-		} else {
-			__entry->agno = NULLAGNUMBER;
-			__entry->streams = 0;
-		}
-		__entry->free = free;
+		__entry->agno = pag->pag_agno;
+		__entry->streams = atomic_read(&pag->pagf_fstrms);
+		__entry->free = pag->pagf_freeblks;
 	),
 	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d free %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-- 
2.43.0




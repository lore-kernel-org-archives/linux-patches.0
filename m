Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025604;
	b=4ICDgHUnVSMouuPL54ekShjftlMndlmRP41VnAnSe4RI1W1Y0/AihBxW4m3SBvo+ha+R
	 f6WWsz5ftye06rv6E9WcEhqIw+GrX1FEPt1Pi5lyX0xJcyonynmxTzKCTjkFQ59YB+cn3
	 d7sWyO1aQ0mDMJU8STc8g1TzRRrftmmdv6qmtCKx2t6C7i1hishS1Qnty6QxUEz9X7ueS
	 /mB1aj01Jj4af4LrDcvnXZbw4UMdQEb5UtZTI24lXc+NFswy2Ru05IeTZT9Vzikis+aCS
	 B6CyCzsd9W1oRspKCQrpj5+j3XgofrPX/1utZrpZypnxXjuth+RfzWjHL1Zn+AWR7oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hs8dDxfLZ/hwtZsAKAwxpHHibvz0mDCRocEI7/ctWg8=;
	b=2ouL0N9Wupsy8V8rjKtc1qXXPQcGEABfTpKOwoHlkim4v0qFqG6i9IXqLI80lnV3dwJg
	 FNVPnBQS6UQcVki6kGf0uaf6pZ2IGnuRtVd/sgLB1NRQiwloXIIsSnNThfmpxHvU/otcD
	 J/RSKHMe7fWtWvdCV/wzcEt3BR7Z9LKRgaBr8cknQoMoZ7NGP0JSHCWi+3z02nzE6s+Hw
	 JadzmQd8vBNBpbRytFBwwkJLI/MJWCI0PbQ5DnJVPahEuF+IN8gXskhdNC31SLJABGOCq
	 5UT1k+0PyPNzEmUMs0K9Fa6DtVCM1oARZIrJx6b3kU3nD+TQAPmaFkiQnQhryOYhYRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tH69AMNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDAC606A320;
	Wed, 18 Nov 2026 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tH69AMNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22A01F000C4;
	Wed, 18 Nov 2026 18:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025604;
	bh=hs8dDxfLZ/hwtZsAKAwxpHHibvz0mDCRocEI7/ctWg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tH69AMNdsYXr3pb6HGdrBEwSZTgD2nNIkup1KAaVECKWcDgJy7BjtfBd0uR6o2qVF
	 7vvItc4RtIOAJ3M95cTcX5T9ir6lquVR2YHpZJ4YkEwutYwks8y4MAnn4TawYUmjMW
	 +mGgsTQSed9sjXQ9JOM12aj15Oh+LC5qqrgIKf5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1137/2151] pNFS/flexfiles: dont read through MDS when previous layout forbid it
Date: Wed, 18 Nov 2026 15:47:52 +0100
Message-ID: <20261118150203.635308504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 2f007ba074ad77e70d941e16956d1937dc3080c6 ]

ff_layout_pg_init_read() falls back to the MDS whenever
pnfs_update_layout() returns no segment and no error: a bulk
CB_LAYOUTRECALL (FSID, DEVICEID or ALL), LAYOUTGETs blocked behind a
layout being returned, or a LAYOUTGET refused with
NFS4ERR_LAYOUTUNAVAILABLE or NFS4ERR_TOOSMALL, which set the per-iomode
fail bit for PNFS_LAYOUTGET_RETRY_TIMEOUT.  That is the read-side twin
of the write path fixed by commit 1d62e659c0bf ("NFSv4/flexfiles:
honor FF_FLAGS_NO_IO_THRU_MDS in pg_get_mirror_count_write"), and it
is reached in exactly the situation that matters most: the file had a
valid layout, the layout had to go back, and the next one has not
arrived yet.

The write side could answer -EAGAIN because writeback owns the retry and
redirties the page.  A read has no such owner, so -EAGAIN here would
surface as an I/O error to the application.  Wait for a layout instead,
on the same terms the function already uses when the layout lookup
itself returns -EAGAIN: sleep a second and retry, bounded by
pg_maxretrans, which ff_layout_pg_init_read() sets only for soft and
softerr mounts.  A hard mount therefore waits, which is what a hard
mount is for, and matches what the FF_FLAGS_NO_IO_THRU_MDS check on the
data server selection a few lines above already does.  That includes
waiting out NFS4ERR_LAYOUTUNAVAILABLE: a file that was given a layout
with this flag must not be read off the MDS, whatever the server says
afterwards.

The test asks the inode (NFS_INO_NO_IO_THRU_MDS) rather than the layout
hdr, because in this path there is no segment, and the hdr that carried
the flag may already have been destroyed.  Where a segment is in hand -
the data server selection above, ff_layout_read_pagelist() - the
existing per-segment ff_layout_no_fallback_to_mds() test stays, since it
is the more precise question.

Fixes: 260074cd8413 ("pNFS/flexfiles: Add support for FF_FLAGS_NO_IO_THRU_MDS")
Assisted-by: Claude:claude-opus-5[1m]
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 38 ++++++++++++++++++--------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index b5e1f506b4c75..577a741b54355 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1080,19 +1080,33 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 	if (pgio->pg_error < 0) {
 		if (pgio->pg_error != -EAGAIN)
 			return;
-		/* Retry getting layout segment if lower layer returned -EAGAIN */
-		if (pgio->pg_maxretrans && req->wb_nio++ > pgio->pg_maxretrans) {
-			if (NFS_SERVER(pgio->pg_inode)->flags & NFS_MOUNT_SOFTERR)
-				pgio->pg_error = -ETIMEDOUT;
-			else
-				pgio->pg_error = -EIO;
-			return;
-		}
-		pgio->pg_error = 0;
-		/* Sleep for 1 second before retrying */
-		ssleep(1);
-		goto retry;
+		goto retry_nolseg;
+	}
+	/*
+	 * No segment, and no error to report either: pnfs_update_layout()
+	 * simply has nothing to give (NFS_LAYOUT_BULK_RECALL, a failed
+	 * pnfs_layout_io_test, blocked LAYOUTGETs, a layout being
+	 * returned).  If the server forbids reading this file through the
+	 * MDS there is no fallback to take, so wait for a layout on the
+	 * same terms as the -EAGAIN above.  The layout hdr that carried
+	 * FF_FLAGS_NO_IO_THRU_MDS may itself be gone by now, which is why
+	 * this asks the inode and not the hdr.
+	 */
+	if (!nfs_no_io_thru_mds(pgio->pg_inode))
+		goto out_mds;
+retry_nolseg:
+	/* Retry getting layout segment if lower layer returned -EAGAIN */
+	if (pgio->pg_maxretrans && req->wb_nio++ > pgio->pg_maxretrans) {
+		if (NFS_SERVER(pgio->pg_inode)->flags & NFS_MOUNT_SOFTERR)
+			pgio->pg_error = -ETIMEDOUT;
+		else
+			pgio->pg_error = -EIO;
+		return;
 	}
+	pgio->pg_error = 0;
+	/* Sleep for 1 second before retrying */
+	ssleep(1);
+	goto retry;
 out_mds:
 	trace_pnfs_mds_fallback_pg_init_read(pgio->pg_inode,
 			0, NFS4_MAX_UINT64, IOMODE_READ,
-- 
2.53.0




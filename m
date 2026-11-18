Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018882;
	b=orSt8G+xm2HHVXaljTSxyxAhH59F4iMGj8AnXQ2L81nF3ldLbhZVAAc2sLsHjv9apNJ/
	 LYULwo5HAq7JKqR36iPLvBicFr70A33ybs5EDfalT290glQykBUhZnQC3Nz1m6L9LSGD5
	 tOkNdO7RxfmSAE4y5KJmomiZUJ7Z1q6AEU83l1bXsE4gPKlzbXhVO3xVP7yv8IdHoKooT
	 wUbMhq/S4xGdwbuBxjolnc3WFborDHh5wdue+6tGbO/F4aSJocboebl/jOHZbVODWTk1K
	 bu4Q0v3Tia3unlvHP4hLu/FQeMQyoOYKHN0eNoOa5lEJ8Bjg9L0vQu+grdzckq4oDMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=akKfdENW+nopSKOzFze8NUCAACuTWH6fce9EUVTunRo=;
	b=Mh7mbI3gjAEE8MIycrP2hJ9hlkimZGbjx6ppAwbLKnh7y+zwqFWoD2iXOTrI6/HcOaPJ
	 Ky8Zx2GClYIxXnRAAc4XkIEcoqJoMzO6MiCz6aJ1mxsm2OjCNJU7zjsLjz8XO8KBZ10a1
	 MbdNh8K54GqXlQRoaAQzU3/yWEmlxAPu/JC9vuqGwOnFz4JNZF0DNeHoNfRjeXnl6qvI2
	 GND8u/LAEs3bp/AB4o6dNb65dJdbWsbjPtg6tWzsXekJgzY6py9CMGZICVndUYh7I/dzi
	 Mp7Gdg2bdLOEE7lGJDESJbRJOMmJKtNkiZRQc5g4XyVzxlUTh4U4J6tx8aR0Qgcvdig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V4jc1V8/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E07606A325;
	Wed, 18 Nov 2026 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V4jc1V8/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0431F000C4;
	Wed, 18 Nov 2026 16:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018882;
	bh=akKfdENW+nopSKOzFze8NUCAACuTWH6fce9EUVTunRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4jc1V8/EFhzmAoY2tTpYUHFTDE3bP11RpdhiBSFQEHppCgt1OCiuC5fICI+akK9N
	 07csKXJGu1Thw7Q/EGLEZahRgbp98BeKzASI22J5s+FUi6otuIUqj467A/ucQqdOXq
	 FnzxVrGto69xC4WjWf/G3JNq2ZqdUsP6Tq5CNqKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1357/2651] pNFS/flexfiles: dont read through MDS when previous layout forbid it
Date: Wed, 18 Nov 2026 15:43:17 +0100
Message-ID: <20261118150336.879034438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bbe2ceec55bdb..62cb2390213c8 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1078,19 +1078,33 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
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




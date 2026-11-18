Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040910;
	b=V2g2uGioJNsMRvf2BU6gH+priapALwmMZot7HAMClBv85X0w35jP8UMUjeju1/ISDimG
	 qZzBzvIe117/Qr0v5IqCA+7ih4wMZ8zDXvrV3IzeqaRHhDK5m/CfRHHnHYJ3HrEfBBnFj
	 knBpdltarm8eP13Y7HhJ6xqfcZte+SaWLOjznle66wWLEEjQN5kTM6crsiY+OB1r335au
	 hfVMZ8cFpSZY7lt83IWsx3tZz3Owb8X6l8SejxTXxfEnai4jwBhFV2MrifnFXcdUdNHS2
	 mYgt9sSFbjOknnMFjtr5WP6oqol66BKDLvS0gVuLl7e+sYxE4IE3yGLExMW8xe9N+qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VN//lM4HOzScoG31w33Jaz8nZQjlGilkiFk7Pu9O6f0=;
	b=b+996ASk2CDdglJF6J4N2NZaL2oVFVAw723tzXO/7C8YhVchyzY4XQ/6kJ5sv1ciKVBw
	 XcI/MMG33j20Cxx+46++UeTWQdbuHsjWI0pGKz03XC3Z2YKv60uSpVv0A5zGC5dUa+ckK
	 0AbX/xIvLJJZgWoItQCDSNvX2S7OsSbbJb5k5ToMLEEn6kAFMfRHi8H4JA16NHa+i2onO
	 uLlBDrkTvGUEEaefL/F+1Pn+3CBPNVgzBcyH3PX41uFbgyUwoFNcxRtkyZQ42jxXC1sLQ
	 +zjJZ4jjP4x1EyD4UgjZt5b8t7eJZCZ7X826kS8pQLLdM65UzLJnK5Dsv7nWJsu3+jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjyxlLXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5159606A320;
	Wed, 18 Nov 2026 22:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjyxlLXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F77F1F000C4;
	Wed, 18 Nov 2026 22:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040910;
	bh=VN//lM4HOzScoG31w33Jaz8nZQjlGilkiFk7Pu9O6f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjyxlLXYBA4UheRCysgL/i2BKyAcefMdbnu0o87ewaULUzfmo6DNYoFgTj1L0LBym
	 8tY7tqW7gyraIVOjADivVIW3P17CSKuzmi0WFcxv1hrg0//tZSXpl6ztJloveYtsYN
	 2M/1kQRldAZfbxthCR8DhrxdhI0rKxtlshkeTWNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2623/3318] pNFS/flexfiles: dont reset to MDS for v4 error when previous layout forbid it
Date: Wed, 18 Nov 2026 15:54:05 +0100
Message-ID: <20261118150439.795998808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit ec906cf7bee60f3bbc8500bac14e65813e38ac93 ]

ff_layout_async_handle_error_v4() ends in -NFS4ERR_RESET_TO_MDS, which
makes ff_layout_read_release() / ff_layout_write_release() call
ff_layout_reset_read() or ff_layout_reset_write(hdr, false), and those
call pnfs_read_done_resend_to_mds() / pnfs_write_done_resend_to_mds().
Those build a page I/O descriptor with force_mds set, so the flexfiles
->pg_init() never runs and no layout is consulted anywhere on the way:
the READ or WRITE goes to the metadata server unconditionally.  For a
layout carrying FF_FLAGS_NO_IO_THRU_MDS that is exactly what the server
forbade.

The fall-through into reset: is already safe, because
ff_layout_avoid_mds_available_ds() returns true for a segment with the
flag and so answers -NFS4ERR_RESET_TO_PNFS first.  What is not safe is
the goto: the invalid-layout errors (NFS4ERR_PNFS_NO_LAYOUT, STALE,
BADHANDLE, ISDIR, FHEXPIRED, WRONG_TYPE) call pnfs_destroy_layout() and
jump straight to reset:, over that check.  That is the case where the
file had a perfectly good layout, something forced it to be given back,
and the client answers by writing to the MDS behind the server's back.

Test at reset: itself, so it covers the goto and any future one, and ask
the inode (NFS_INO_NO_IO_THRU_MDS): the callers that jump here have just
destroyed the layout hdr, so the hdr-level flag is no longer reachable,
while the inode-level one is set for the life of the in-core inode.

-NFS4ERR_RESET_TO_PNFS is the right answer rather than an error.  It is
what the fall-through already returns for the same flag, and the
resends it drives - ff_layout_resend_pnfs_read() and
ff_layout_reset_write(hdr, true) - re-enter the pgio path with force_mds
clear, so a fresh LAYOUTGET is taken, which is precisely what a
destroyed layout needs.  A LAYOUTGET that fails fatally makes
pnfs_update_layout() return an error, which ->pg_init() reports; a
non-fatal refusal (NFS4ERR_LAYOUTUNAVAILABLE, NFS4ERR_TOOSMALL) returns
no segment instead, and the client keeps retrying through pNFS rather
than falling back.

ff_layout_async_handle_error_v3() needs no such change: it returns only
-NFS4ERR_RESET_TO_PNFS or -EAGAIN.

Fixes: 260074cd8413 ("pNFS/flexfiles: Add support for FF_FLAGS_NO_IO_THRU_MDS")
Assisted-by: Claude:claude-opus-5[1m]
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index ffbb7d4df19de..f5cd447e9b13b 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1223,6 +1223,23 @@ static int ff_layout_async_handle_error_v4(struct rpc_task *task,
 	if (ff_layout_avoid_mds_available_ds(lseg))
 		return -NFS4ERR_RESET_TO_PNFS;
 reset:
+	/*
+	 * FF_FLAGS_NO_IO_THRU_MDS: never resend through the MDS.  The
+	 * caller would do so with force_mds set (ff_layout_reset_read(),
+	 * ff_layout_reset_write(hdr, false) -> pnfs_*_done_resend_to_mds()),
+	 * which builds a descriptor out of the plain MDS page ops and so
+	 * consults no layout at all -- this is the last point at which the
+	 * policy can still be applied.  Retry through pNFS instead, which
+	 * takes a fresh LAYOUTGET; that is also the right answer for the
+	 * invalid-layout cases that jump here, since they have just called
+	 * pnfs_destroy_layout().  Having done so they can no longer ask the
+	 * layout hdr about the flag, hence the inode.
+	 */
+	if (nfs_no_io_thru_mds(inode)) {
+		dprintk("%s Retry through pNFS, no MDS fallback. Error %d\n",
+			__func__, task->tk_status);
+		return -NFS4ERR_RESET_TO_PNFS;
+	}
 	dprintk("%s Retry through MDS. Error %d\n", __func__,
 		task->tk_status);
 	return -NFS4ERR_RESET_TO_MDS;
-- 
2.53.0




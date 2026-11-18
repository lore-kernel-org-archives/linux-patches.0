Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025607;
	b=ykT4pf9WkMG7zvfaGNA//Plk9zE28j9qKUhYkp7P1vqc8ovIuhLXgj6mUn7jblViHwY1
	 usQf7aZTDy3oQGZXOi86xgy5lBKTy4wns6WZKOUSksGPof0e9B4ndrw/JxpMc2n3yaD7H
	 pnzX9mkgrH+YaNxxDiRlsq1iYC5qiZQ6A2v3KEuS7c58s4CVtdBMxZkkW65xpZNehikXl
	 nNRpLcHV08ShxXc+GKiHAAHVOYpdb6zx3xC5aSXUXrLeSfjt+xc5Szxan/SJD6KeulqS9
	 F0VKPb8xdFU8Vo8haUPJ/NHi4/gkhpqk69iMf2BG9Qc99Fvru4FALtb/GVF8z5APDVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AHaA86wug6FC5y+AQG9NPDDQkZPrS+hHncTaAsYJz7w=;
	b=aJfjyBPZSkRd5qhr2LchBsUXzR7DtqvQs6BWKHym6z9e1C2JnrtuoTrs2uW8akpnRDIn
	 6/mXoMaP0ym/oM3mL2O6/KQ0qG/NVRQ1IFA7dEsJGxYdXFed8qRcQG89swPmoYmRkK3qL
	 Uu8H2kQSMy3aXILcGzwCHOwcKyLEJiG5D3TkIeITViO+QdHtRtlgtl/zapemrlFUseFQL
	 b0Byuz0Y26zzh7hYfiJ4kmktx91beSSrftZHulorc6Au7ap7TnwH57fsnWapyzVJtIkJT
	 qX0SauxwSApFUZKh8XUFzG+it+2dURUwvohG1rGgSGyAvNrdoD19zkJwTFV3Npg7iIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ltw7mQRc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712C5606A320;
	Wed, 18 Nov 2026 18:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ltw7mQRc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22B41F000C4;
	Wed, 18 Nov 2026 18:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025607;
	bh=AHaA86wug6FC5y+AQG9NPDDQkZPrS+hHncTaAsYJz7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ltw7mQRcTgsOTOE0Zem+XNS3iKVvcvD/01RNOFwOwOHx2B3galMi2OQz3CMLD0sol
	 AzsirSLLA2IhzU3+qxb9qeFSnk5Kw/cTD0svz5WyqElz/aCQBe5StLcziL48/Vq18h
	 83JdnI3nuMw5QFagEos+BoFfPvxHShrSjL58Q5QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1138/2151] pNFS/flexfiles: dont reset to MDS for v4 error when previous layout forbid it
Date: Wed, 18 Nov 2026 15:47:53 +0100
Message-ID: <20261118150203.667637713@linuxfoundation.org>
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
index 577a741b54355..91671dd34e550 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1423,6 +1423,23 @@ static int ff_layout_async_handle_error_v4(struct rpc_task *task,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D4D3770B;
	Tue, 21 Jul 2026 20:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666370; cv=none; b=hxHhVmKeP3BvlQIUD7//icvS1f8NkUJhBai+6LhRKEhMvMuZgKOFea185jnE7M47GNYR+5okF9Y7kK+Ac5HnH4nX+vDMnCnE/xwOERJT27ApibmSrrB4IeE1w0CrbjqPZ9H79ilp74MQW9WS6Rgz+4uUeYDZYmMT9d/Gxb940Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666370; c=relaxed/simple;
	bh=AAB4pnrvO4tVXH8U05FZJHslJefb9r5FaXFxKd9x8DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GaNSR1LqgUhF7Uqla/Jx2xvchlxlutIo+9ScCe5wMtiM7I6HDIslcNpW7+VxV88jl9cn/Pl4u7cg0taQHdKDrrO+VsGxtuwRmw6zBorqa4IEbJK1tNwV/B3BvuC7moSk/H8GxW4XOYqH3dV0sd43aV82EJxUZ2Lmzm/lrjI0NKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKgkYLeD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKgkYLeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90071F000E9;
	Tue, 21 Jul 2026 20:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666369;
	bh=FPVz+uhmoMT4jADtmqldlgbrfHcpLKF0M31hyybROj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKgkYLeDd9rsjPmqRuQIT4nCHQGKvG2JwG9pg54zFs2vXm3o7p+7kI5cRDgW5dz/H
	 w0dIJcEd3A5S+5ci5rQhsg68tPn36pvsPDKwOfMevNt3wGBUr9JuRP6ruwLblSjf1V
	 JxNUKYpDGEPFq1kV4D0MRBZl80lWIm1tIITaGKHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0658/1266] NFSv4/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS on fatal DS connect errors
Date: Tue, 21 Jul 2026 17:18:15 +0200
Message-ID: <20260721152456.583293597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 7a375cafc14ed151508f908ea5681caf0a9cc1d6 ]

Commit f06bedfa62d5 ("pNFS/flexfiles: don't attempt pnfs on fatal DS
errors") teaches ff_layout_{read,write}_pagelist() to return
PNFS_NOT_ATTEMPTED when nfs4_ff_layout_prepare_ds() fails with a
nfs_error_is_fatal() errno (e.g. -ETIMEDOUT from a SOFTCONN connect
deadline, -ENOMEM, -ERESTARTSYS), so that the client gives up instead
of spinning.  pnfs_do_{read,write}() then dispatches the I/O through
pnfs_{read,write}_through_mds() → nfs_pageio_reset_{read,write}_mds().

That fallback is unconditional and silently violates FF_FLAGS_NO_IO_THRU_MDS:
when the layout segment carries the flag (typically single-mirror
appliance layouts where MDS I/O is explicitly forbidden), the
out_failed: path's \`&& !ds_fatal_error\` clause overrides the flag's
short-circuit through ff_layout_avoid_mds_available_ds() and routes
the I/O to the MDS file handle anyway.

This is reachable in practice during a data-server restart: SOFTCONN
exhaustion produces -ETIMEDOUT, which is fatal per nfs_error_is_fatal(),
which triggers PNFS_NOT_ATTEMPTED, which silently goes to MDS.

Preserve the upstream "don't spin on fatal errors" intent for layouts
that permit MDS fallback.  For layouts with FF_FLAGS_NO_IO_THRU_MDS
set, mark the layout for return and request PNFS_TRY_AGAIN instead;
if the server cannot supply a usable layout the failure now surfaces
cleanly via pnfs_update_layout(), rather than via silent MDS I/O that
contradicts the flag.

Fixes: f06bedfa62d5 ("pNFS/flexfiles: don't attempt pnfs on fatal DS errors")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 98536d2dad5e1f..9500cefe4884e7 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1902,6 +1902,14 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
 out_failed:
 	if (ff_layout_avoid_mds_available_ds(lseg) && !ds_fatal_error)
 		return PNFS_TRY_AGAIN;
+	if (ff_layout_no_fallback_to_mds(lseg)) {
+		/*
+		 * FF_FLAGS_NO_IO_THRU_MDS: force fresh LAYOUTGET,
+		 * never fall through to MDS I/O.
+		 */
+		pnfs_error_mark_layout_for_return(hdr->inode, lseg);
+		return PNFS_TRY_AGAIN;
+	}
 	trace_pnfs_mds_fallback_read_pagelist(hdr->inode,
 			hdr->args.offset, hdr->args.count,
 			IOMODE_READ, NFS_I(hdr->inode)->layout, lseg);
@@ -1973,6 +1981,14 @@ ff_layout_write_pagelist(struct nfs_pgio_header *hdr, int sync)
 out_failed:
 	if (ff_layout_avoid_mds_available_ds(lseg) && !ds_fatal_error)
 		return PNFS_TRY_AGAIN;
+	if (ff_layout_no_fallback_to_mds(lseg)) {
+		/*
+		 * FF_FLAGS_NO_IO_THRU_MDS: force fresh LAYOUTGET,
+		 * never fall through to MDS I/O.
+		 */
+		pnfs_error_mark_layout_for_return(hdr->inode, lseg);
+		return PNFS_TRY_AGAIN;
+	}
 	trace_pnfs_mds_fallback_write_pagelist(hdr->inode,
 			hdr->args.offset, hdr->args.count,
 			IOMODE_RW, NFS_I(hdr->inode)->layout, lseg);
-- 
2.53.0




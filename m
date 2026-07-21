Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E961435532;
	Tue, 21 Jul 2026 22:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671868; cv=none; b=rmpfKs6+ieRxcVyTydR0T3kizZrgqXoPChINW2emXP0gQ8MzZrlSLPjYbdcLz6laEjPsRkq6kgeLjM6vMcSOE3fzXfcNixKxHvR9pHBEqgaQ7Riq9mo18Cp7M9yizwzSk6lDJrtN8QVD+TS7X4Yiqx3+0wqAbPDqDdxtJ/W+pBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671868; c=relaxed/simple;
	bh=YJAuwHcxzx6xHcT32cGX9xTIGKzvtEg/LoojDe8p3aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H0iUFiR3FboA8gjQyOTt/swnI+PLQ/KJN+AFC5wmhH5zNjQ5rRLYaV7Es0vILxS09d9g+Yj2HVHj9DvYl2AVANMGgp4fo1hfK3+0Qi5OvopQqtfrubVLIpgjb5R2F1qt75xnaaRvBFVQCQptyPxTQR/7ImzKJ+QE9ZWZha9ARuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8aGJCdN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8aGJCdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D521B1F000E9;
	Tue, 21 Jul 2026 22:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671867;
	bh=ZEJRNbk5dWy6W6M9UKshRxR8MbsNL1cLEt/hZ42QAGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8aGJCdN94gLm6vRwFVX8fqqB6Kt88Ifff0F/5rEUizgSRNAwa9WcMorvxndKyqbP
	 iqYI0FIpfxYI/zhBe9bjiOnbTPoXOuFDK0iNiRUkqKezDDe6Ki3l4aO2Aq5yq/4tpj
	 EMEV8U4JZo3abnvHR107Pt/paGDUnrEiw3/RsCbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 402/843] NFSv4/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS on fatal DS connect errors
Date: Tue, 21 Jul 2026 17:20:37 +0200
Message-ID: <20260721152415.080842930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8fb5e05c4b266c..0e055b378a87d3 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1889,6 +1889,14 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
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
@@ -1960,6 +1968,14 @@ ff_layout_write_pagelist(struct nfs_pgio_header *hdr, int sync)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318BF33B970;
	Thu,  2 Jul 2026 16:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009742; cv=none; b=h1S9UstBk/3TCuE/nRDCUG/w77YieHlmX1pJuayfPbl1DXRUgjhYXwUZ5orbTEFAHKysapIPzLpOAR2c2O7tFRr20/dSWI4d4EInUh/n5NW2ExvtslKqkIePDCgmTp0Na9BOZGufMAIvZN7+619IozWimUT5HMP1x8v7YQXR/cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009742; c=relaxed/simple;
	bh=lkq0EUnLDDtHFC8HBZjJc1wo2guWTRrf2lfiPZ7PFuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip+E6VCHBczhVpD6vue8ONxFlc5810Mo5b8WleyC/JScrC5KBPhjmuoj9FZHR83t+EPM+StpMBGNeWUJlb8QIclSdpdufmaxwogM19Qf7cdLAptk3R2S4pTb1g8lyXhCXh81cnD5zVNb4wsOT8GX7m0pftT9XDYhRyeVrqddhzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2q4OO/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2q4OO/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1C31F00A3A;
	Thu,  2 Jul 2026 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009738;
	bh=229DDulCM3yw9zOKG3abB0RQq+LpMOe7+qYp/baVJ9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2q4OO/5jEKE/EQRUinOUcYezpmWrXAbXuF+xhcU5KQAwB0wY1UDxEPDsZmxJ8h0S
	 d1NhpehBFTGw7hgOEH7WsrVq9W7yZ3YQtXJrBpm7LlQHEJaPWd6ioO+ppwGhvmjYH1
	 tNYTu/j4WkIVm0KQY9l8N6MDDcEZI1TOT48uAgsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 5.15 69/95] pNFS: Fix use-after-free in pnfs_update_layout()
Date: Thu,  2 Jul 2026 18:20:12 +0200
Message-ID: <20260702155110.666284003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 13e198a90ca4050f4bee8a3f23680389a6563ccc upstream.

When hitting the NFS_LAYOUT_RETURN branch in pnfs_update_layout(),
the code calls pnfs_prepare_to_retry_layoutget(lo). If it succeeds,
pnfs_put_layout_hdr(lo) is called before trace_pnfs_update_layout(),
which still references 'lo'. This results in a use-after-free when the
tracepoint accesses lo's fields.

Fix this by moving the tracepoint call before pnfs_put_layout_hdr(lo).

Fixes: 2c8d5fc37fe2 ("pNFS: Stricter ordering of layoutget and layoutreturn")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2067,11 +2067,11 @@ lookup_again:
 		dprintk("%s wait for layoutreturn\n", __func__);
 		lseg = ERR_PTR(pnfs_prepare_to_retry_layoutget(lo));
 		if (!IS_ERR(lseg)) {
-			pnfs_put_layout_hdr(lo);
 			dprintk("%s retrying\n", __func__);
 			trace_pnfs_update_layout(ino, pos, count, iomode, lo,
 						 lseg,
 						 PNFS_UPDATE_LAYOUT_RETRY);
+			pnfs_put_layout_hdr(lo);
 			goto lookup_again;
 		}
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,



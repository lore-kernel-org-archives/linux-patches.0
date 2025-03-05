Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A187824FBE8;
	Wed,  5 Mar 2025 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197960; cv=none; b=Ne+3jVemgcs2Or4R/ZUiQekOhZ/pX0hLAZuzHMwCS8Lgq0sobXbkPx1z/VHhMY2YHPHFhMX3OgdvyXNHAx4bURyNMziJgsH4HHMr/EO4Fx/PS639glbsoNb/uvsTlopViFHIM8d+Rn74gVwPovRw/z3Og5xkt40ypJhsUi7H1eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197960; c=relaxed/simple;
	bh=3kiYAiM+99D3x4BXHj37okYH3p4uNjuRwWgXJ+cT8K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chmh6QXsUOnTwWYi4fFGSWMen5iCJIbbiZWkrdT4pX4v/jV76f+FgIi4gSD7/grq7IsPOeF83bC3qCuCfkXBZ/FkpkJ5wwdhLCqmvgxdGmooRKBQY1sgqwC5VNf3Muz43Ws5TDGuh8kplkoM8I3N29KH510AhrqeYwBUzpSAqBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tp4Lc0Bl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp4Lc0Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28553C4CED1;
	Wed,  5 Mar 2025 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197960;
	bh=3kiYAiM+99D3x4BXHj37okYH3p4uNjuRwWgXJ+cT8K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tp4Lc0BlpO1ythsbwb/B3KY/IiSezKBFXRCHEgGjmrhYt+cvd/89YUx0t+2VqfDDH
	 3T/51juDmDkFVEkT3KMGsvXgROf/V8PJ6+ebCAVGKrAa+0fMY2HBNFfH348yINsjtz
	 eFMqlMjJRnuuaWLgawhFYWd1lZbJb3bn65xVTANA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/150] NFS: Adjust delegated timestamps for O_DIRECT reads and writes
Date: Wed,  5 Mar 2025 18:47:26 +0100
Message-ID: <20250305174504.499295236@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 88025c67fe3c025a0123bc7af50535b97f7af89a ]

Adjust the timestamps if O_DIRECT is being combined with attribute
delegations.

Fixes: e12912d94137 ("NFSv4: Add support for delegated atime and mtime attributes")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 2784586f93fc0..c1f1b826888c9 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -56,6 +56,7 @@
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
 
+#include "delegation.h"
 #include "internal.h"
 #include "iostat.h"
 #include "pnfs.h"
@@ -286,6 +287,8 @@ static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
 	nfs_direct_count_bytes(dreq, hdr);
 	spin_unlock(&dreq->lock);
 
+	nfs_update_delegated_atime(dreq->inode);
+
 	while (!list_empty(&hdr->pages)) {
 		struct nfs_page *req = nfs_list_entry(hdr->pages.next);
 		struct page *page = req->wb_page;
@@ -770,6 +773,7 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 
 	spin_lock(&inode->i_lock);
 	nfs_direct_file_adjust_size_locked(inode, dreq->io_start, dreq->count);
+	nfs_update_delegated_mtime_locked(dreq->inode);
 	spin_unlock(&inode->i_lock);
 
 	while (!list_empty(&hdr->pages)) {
-- 
2.39.5




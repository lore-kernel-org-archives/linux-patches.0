Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E71E78F3A;
	Wed,  5 Mar 2025 18:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198396; cv=none; b=SUkDdw3r4uddTmQmRaLfe57iPQOmpRaP4Co6DCHrmdATh0/H6VOXsBUipZhtGA5K5X6A134uzIaJB9BDp5RLdiRTUzQOMJ4ofgK/UjV10LTQUEyPZJ6WRmTY7FFnWSKMCrQOgsCRMvVPnODU0yIusrkwIO98ph+RMbg+btzb04U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198396; c=relaxed/simple;
	bh=ZCc1k3ExwTqCPBIBp48kUUTK7cIFiOoP9pqjj8bcLng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVgKi88UsYJNwUnbqAdhgg/TxA2wap7fOTmdTxBEdLWDySshlEL39UZ0Vz1Trlo9qOBzajmFl7viii+sCUsMuJWg0ItHP2rqpdkavRoFuv7Gzu0qHzTPsaRhon96swogSHs+5VfH6jrX3iVm1vHChkuRU+V7gMjwF8310+xOogk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFj1lh4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFj1lh4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DDBC4CED1;
	Wed,  5 Mar 2025 18:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198396;
	bh=ZCc1k3ExwTqCPBIBp48kUUTK7cIFiOoP9pqjj8bcLng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFj1lh4DXkSbwiInonlX08BWlhqcimr4HSk139uWSXtO3GNna1wZcJQK07FGNXbT4
	 V+OOk+BbTk+keuXBxgzy/cT2FfezER9pShWJxzv2Ds6LYsff9slkd+6sDnicRI4KP5
	 k1sD1Ao0qfmNX6EPlxRJ06Y8GNBN+8mM3rbolNB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 014/157] NFS: Adjust delegated timestamps for O_DIRECT reads and writes
Date: Wed,  5 Mar 2025 18:47:30 +0100
Message-ID: <20250305174505.858492108@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8f2aa2bf45659..6a6e758841336 100644
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
@@ -778,6 +781,7 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 
 	spin_lock(&inode->i_lock);
 	nfs_direct_file_adjust_size_locked(inode, dreq->io_start, dreq->count);
+	nfs_update_delegated_mtime_locked(dreq->inode);
 	spin_unlock(&inode->i_lock);
 
 	while (!list_empty(&hdr->pages)) {
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430B118BBAE;
	Wed, 17 Sep 2025 12:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112645; cv=none; b=dGpLo1LsQX+S1qSxx1KsAdNoCrMz0kQ4DZ6tNUSfeGkUs9BE+w5GugOk4vMEj8tJv8F7BIoZ4i7pljyeweKDfpj8pmzTYu6m8dGmZnfDdoSVigPs+e5FaCo98YyJOIsNEEqESlCdhQVzPMdc7t7Y/PeslBTm5US2llxiHauLOWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112645; c=relaxed/simple;
	bh=ehjN6p5PeCDZVqM2QqU8f5n8259KaFq0sYdhhVwdnvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amSiijJNBFCDGbYMc3xQq4p1mnPKwaD5djJEMaVwA3K84kBl2wvbwoJtQrjz8mZrmH/M8T5OU1oQWn/YoE3SOvQEhGoW1TZp5MNy+RS9naROYy4W1Ztku+OwACRYV61VB3H4IX2a1WQ457NuiCzD6J0d58SSwiWXf4GBESA2K8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiuMAn7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiuMAn7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AD7C4CEF0;
	Wed, 17 Sep 2025 12:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112645;
	bh=ehjN6p5PeCDZVqM2QqU8f5n8259KaFq0sYdhhVwdnvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiuMAn7Dh2UxTCLNKeB5OevclVG0fhTjpxgqACP7C7X/j/Gmw18ruz1Ipew0wDI7x
	 AETH9KlcMNJ0foqO641Q5R1ja5Rvc0XifzpoTlhteEYpAFDwS2YgQIrSWeG/fQYACZ
	 PGliOR+UJ5s87pV/cia/4WvbZOztAF/5lBEeJWNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 033/189] NFS: nfs_invalidate_folio() must observe the offset and size arguments
Date: Wed, 17 Sep 2025 14:32:23 +0200
Message-ID: <20250917123352.663574087@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b7b8574225e9d2b5f1fb5483886ab797892f43b5 ]

If we're truncating part of the folio, then we need to write out the
data on the part that is not covered by the cancellation.

Fixes: d47992f86b30 ("mm: change invalidatepage prototype to accept length")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c  | 7 ++++---
 fs/nfs/write.c | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 033feeab8c346..a16a619fb8c33 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -437,10 +437,11 @@ static void nfs_invalidate_folio(struct folio *folio, size_t offset,
 	dfprintk(PAGECACHE, "NFS: invalidate_folio(%lu, %zu, %zu)\n",
 		 folio->index, offset, length);
 
-	if (offset != 0 || length < folio_size(folio))
-		return;
 	/* Cancel any unstarted writes on this page */
-	nfs_wb_folio_cancel(inode, folio);
+	if (offset != 0 || length < folio_size(folio))
+		nfs_wb_folio(inode, folio);
+	else
+		nfs_wb_folio_cancel(inode, folio);
 	folio_wait_private_2(folio); /* [DEPRECATED] */
 	trace_nfs_invalidate_folio(inode, folio_pos(folio) + offset, length);
 }
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index ff29335ed8599..08fd1c0d45ec2 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2045,6 +2045,7 @@ int nfs_wb_folio_cancel(struct inode *inode, struct folio *folio)
 		 * release it */
 		nfs_inode_remove_request(req);
 		nfs_unlock_and_release_request(req);
+		folio_cancel_dirty(folio);
 	}
 
 	return ret;
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA3836CDF4;
	Wed, 17 Sep 2025 12:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113423; cv=none; b=EEuC26GSPBnXwpnQbvrNbBI5NYbuPOdvO4joLPMltB2G2UH8i+fG6i2Uvba69lHALWI++RC0CF4KbfRHnw2onjIaYpgVY+r9/pILi+UtgkY49/uveN488xXvdipJpBPIK7pnpnCxsdFiXDV4cEKPVZif8pMF52bZhjB4icU/JK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113423; c=relaxed/simple;
	bh=yLwo7q/j+AOPa9QzPiv0KsJWB+mpAIQi0ZqJ2wqJzwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/KvWF9tlIaXkhz3S1V63LoHa3zXR/jCgxkyfWIIMrKZ5ysdfYnFrGnmcGtG6cQuBVO/0gUdI87nLtvOOltfzg+CjdpY4W96AmydLLqqazWdvgMnhrDLb4bk7yEXve8gMF6/mPpdhDumLcuWSpNgu/Q0W4qJxBNfb1A4lQA/Zcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiyBnEcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiyBnEcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C510EC4CEF7;
	Wed, 17 Sep 2025 12:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113423;
	bh=yLwo7q/j+AOPa9QzPiv0KsJWB+mpAIQi0ZqJ2wqJzwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiyBnEcZD/iN4klZUR9ladgB7Z0ohAwDUNf4npdgzidkl4zlKe6VPE9Fp0VtjjcZs
	 NoQAdxLChXcQ9rFXXGGj//CCCQPyYGLf50kwIos7AyZ3YTKs7FYRG8QB45934ZQAfj
	 bnDzBES7Ob/phzXy6TV0t4vPvCCETWdkiL8DTVZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/140] NFS: nfs_invalidate_folio() must observe the offset and size arguments
Date: Wed, 17 Sep 2025 14:33:29 +0200
Message-ID: <20250917123345.215346870@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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
index 2b6b3542405c3..fd86546fafd3f 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2058,6 +2058,7 @@ int nfs_wb_folio_cancel(struct inode *inode, struct folio *folio)
 		 * release it */
 		nfs_inode_remove_request(req);
 		nfs_unlock_and_release_request(req);
+		folio_cancel_dirty(folio);
 	}
 
 	return ret;
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA94151988;
	Wed,  5 Feb 2025 14:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765874; cv=none; b=erAYhW/6X6U1UPSfqEEWCVr7wCkttq8/eX7C+Ru81/XkcOn/KU900+HHWclNKWTmwiuGDG8+YSbLWy2+eIV+phoPlYDnMvkDa1yRK+mPeng+jTZXVhS45qfcjdewFQdO5AfLN50CbrgxalpFr/fWCifDWR9gf7GXpJHiAePL4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765874; c=relaxed/simple;
	bh=irFrj/TBCrDwZuC0UsKoyIj/UE9H5Kuy36w8ZuMFDBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Baet0UEn/5QiRJjb3XqAnK0oWFNNktO6goU4ge4w9L3P6/X1cqvi8/iWQc+VYz0xeqYkxm9iYL6CrOZIAkzc+tp4LKK03EsDF9XkU7jI15JRemipSDS3JNGjeEQ6d+G0ZauhqdBtywk2qQPpPona+IH4CuK+eFFD2Yw+HYZupmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idTp+juQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idTp+juQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8C2C4CED1;
	Wed,  5 Feb 2025 14:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765874;
	bh=irFrj/TBCrDwZuC0UsKoyIj/UE9H5Kuy36w8ZuMFDBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idTp+juQjsVXnkEy+wS6+sWOF44Gck85t2cTcAK1gb850PRFhm4eXS/wHLUHUFM5G
	 UqiWQKlezeMNdAG/ydd5kav1F2PqzSwPOMx6ACO1bUNsDopIiW+3PYI+RMiPw71iED
	 6fqhidwcWCSMNdnlmMSFzMI/3zvim3DAZWNDwOts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/393] nilfs2: protect access to buffers with no active references
Date: Wed,  5 Feb 2025 14:43:47 +0100
Message-ID: <20250205134432.093739170@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 367a9bffabe08c04f6d725032cce3d891b2b9e1a ]

nilfs_lookup_dirty_data_buffers(), which iterates through the buffers
attached to dirty data folios/pages, accesses the attached buffers without
locking the folios/pages.

For data cache, nilfs_clear_folio_dirty() may be called asynchronously
when the file system degenerates to read only, so
nilfs_lookup_dirty_data_buffers() still has the potential to cause use
after free issues when buffers lose the protection of their dirty state
midway due to this asynchronous clearing and are unintentionally freed by
try_to_free_buffers().

Eliminate this race issue by adjusting the lock section in this function.

Link: https://lkml.kernel.org/r/20250107200202.6432-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 57b535921a73b..d4a98ac72b8ea 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -734,7 +734,6 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 		if (!head)
 			head = folio_create_empty_buffers(folio,
 					i_blocksize(inode), 0);
-		folio_unlock(folio);
 
 		bh = head;
 		do {
@@ -744,11 +743,14 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 			list_add_tail(&bh->b_assoc_buffers, listp);
 			ndirties++;
 			if (unlikely(ndirties >= nlimit)) {
+				folio_unlock(folio);
 				folio_batch_release(&fbatch);
 				cond_resched();
 				return ndirties;
 			}
 		} while (bh = bh->b_this_page, bh != head);
+
+		folio_unlock(folio);
 	}
 	folio_batch_release(&fbatch);
 	cond_resched();
-- 
2.39.5




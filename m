Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AFF3770B;
	Tue, 21 Jul 2026 20:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666383; cv=none; b=CMogFD5W6pAWqcNtF7EbdXIjTT2pkJtK6fm3Lg3SVaEJnVXM74vmUj+5dqHUQYjfKxP9tvzPkmviWtntwkRoe9cS1t+3eC3fc5yMRzYIr8LLTVQ+UWYtoD2LGqpYny4Sr+nQDeGkME0t75XRGo6L5QSk8qYNVL0vyW9OsPXlMhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666383; c=relaxed/simple;
	bh=q+PQeayuMCPLfEREJ350ni88OiCpodOQ4GR4c/8fPxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ykm25Qu04C/0Ud7+adRovXkYQ/kNz9l0SEaYR89CCCz5RPOX2dc0faDVxg2LuoOiBCZfdBYNHxMTJwHit675aaEF3el68Bt0sr/Noj74W7+guVDGLjNWDz/IQ/hRj0mqbVXbJyl1lVX5UNXY2hH1S1wsbJMZeLQaagccf6KtKmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6NTMtY+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6NTMtY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B541F000E9;
	Tue, 21 Jul 2026 20:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666382;
	bh=iBYbM9S9VnurEl5AvHV6cXpu+2i5o27SAmrSFcxT8Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6NTMtY+dhHHhGozifv2xMgBf8H6ml+yBaQWscjzDMzZRKkQWS2PqcQfOLaQudKaK
	 mmpGxlMfQbqXtznDtHQyp//z4756mCF3JWPud5i0KnGgnh/gVA/B/TukWXZ4hmogbd
	 8h9Im63TSg3SVbTLCFKna7/5P/WBHTX8WRCm4oAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carol L Soto <csoto@nvidia.com>,
	Jamie Nguyen <jamien@nvidia.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0662/1266] fs/ntfs3: resize log->one_page_buf when adopting on-disk page size
Date: Tue, 21 Jul 2026 17:18:19 +0200
Message-ID: <20260721152456.673385012@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Nguyen <jamien@nvidia.com>

[ Upstream commit 5a35454179fe1041d9cd286f5d320ce0d448c12a ]

log_replay() allocates log->one_page_buf using the page size that was
chosen from the host PAGE_SIZE:

	log->one_page_buf = kmalloc(log->page_size, GFP_NOFS);

Later, when a restart area is found, the log page size recorded on disk
is adopted:

	t32 = le32_to_cpu(log->rst_info.r_page->sys_page_size);
	if (log->page_size != t32) {
		log->l_size = log->orig_file_size;
		log->page_size = norm_file_page(t32, &log->l_size,
						t32 == DefaultLogPageSize);
	}

If the on-disk page size is larger than the size used for the initial
allocation, log->page_size grows but one_page_buf is left at its
original, smaller size. A subsequent unaligned read_log_page() then
reads log->page_size bytes into the undersized scratch buffer:

	page_buf = page_off ? log->one_page_buf : *buffer;
	err = ntfs_read_run_nb_ra(ni->mi.sbi, &ni->file.run, page_vbo, page_buf,
				  log->page_size, NULL, &log->read_ahead);

overflowing the allocation. This is reachable when mounting a dirty
NTFS volume whose log was formatted with a page size larger than the
buffer initially allocated on the mounting host (for example a 64K-log
volume mounted on a host that allocated a 4K scratch buffer).

Grow one_page_buf when the adopted on-disk page size exceeds the size
used for the initial allocation. On krealloc() failure the original
buffer is left intact and freed by the existing error path.

Fixes: b46acd6a6a627 ("fs/ntfs3: Add NTFS journal")
Reported-by: Carol L Soto <csoto@nvidia.com>
Signed-off-by: Jamie Nguyen <jamien@nvidia.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 9175f53cb938cc..06fd72b4bb4e21 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3938,9 +3938,28 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 	 */
 	t32 = le32_to_cpu(log->rst_info.r_page->sys_page_size);
 	if (log->page_size != t32) {
+		u32 old_page_size = log->page_size;
+
 		log->l_size = log->orig_file_size;
 		log->page_size = norm_file_page(t32, &log->l_size,
 						t32 == DefaultLogPageSize);
+
+		/*
+		 * If the adopted on-disk page size is larger than the size used
+		 * to allocate one_page_buf above, grow the scratch buffer so a
+		 * later read_log_page() cannot overflow it.
+		 */
+		if (log->page_size > old_page_size) {
+			void *buf;
+
+			buf = krealloc(log->one_page_buf, log->page_size,
+				       GFP_NOFS);
+			if (!buf) {
+				err = -ENOMEM;
+				goto out;
+			}
+			log->one_page_buf = buf;
+		}
 	}
 
 	if (log->page_size != t32 ||
-- 
2.53.0




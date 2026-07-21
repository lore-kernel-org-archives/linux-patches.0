Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BC247124C;
	Tue, 21 Jul 2026 18:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657214; cv=none; b=AeVkEOCek99iAj12x4AhTXPlmOAyFgxpMSVJiMkF3eTx5d0Cu5fHrm3AFo7/dYLVkrqjwkEWLqZUPXOehdUOFEpw4Cwfh6Hk2TmwW8mRt9qPo99c5qdSpeO5p6wzO6P8ljkw/TdYfj3G9wV/M6rry8dzx6apSNojr0GuXVD5DCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657214; c=relaxed/simple;
	bh=sq+p2/IQmU/+X+Wbmw3HS/4tqMCDqtM3MFAkLz0UJUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us1KcqXFHWAXVSQ+wuSiIuDWEiJ+cZeqPglTsjs6SIf0q815oQICdguv1somOaobx5ERxhodWIy1FybiKoo5PgHNCq6GzIshu/2jdbbED7NWmOoJ5kXbgfxi6BeQvMsWQCqWpANYoEGmEERbmth0vj/S3SAvECP7Kd7cDPyDmZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgTbW22E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgTbW22E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1231F000E9;
	Tue, 21 Jul 2026 18:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657213;
	bh=U5YZOXBUauZ2nK3MUEImI+W9wbgZr+5p4oZwJo/ujTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgTbW22EqGRnadN8e63qfWozaBr1x+pzX+qZt9BplwCZ7ec9119NWZupcROy57ajL
	 qktTE15sSZs1rV1KTJfa0YQ+roiFIADxKLev7k81pP8HYqhF6I8hzf+j9VPDUw/hNu
	 ATeUZrw5acVQd9wxgekPLJf9z8fdWVCZ5QDMln8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carol L Soto <csoto@nvidia.com>,
	Jamie Nguyen <jamien@nvidia.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0679/1611] fs/ntfs3: resize log->one_page_buf when adopting on-disk page size
Date: Tue, 21 Jul 2026 17:13:15 +0200
Message-ID: <20260721152530.654875440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 124198539b9506..8395ca003af037 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3936,9 +3936,28 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1488E433BCE;
	Tue, 21 Jul 2026 19:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662577; cv=none; b=GYixKrVSDM+OiMVkPamPDCAjFegwjaky1KPh5hJMvPJTXHlh6c55V2P0H/enr+SnCM17p0nhBhrnjNm3pLODmZrvgyLtpbR4p7p67L3fDp99Gwgmm4V1oJfzEwLolhrB0oiugBsoIhxnVPceIibX7d/K00tryQm5QICdfqLOOgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662577; c=relaxed/simple;
	bh=GuQ5NW4Cjms42NMvsSfNHrnOqCCh+KJNUPCEJ8iHXxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHlh36ItQ49mQTmTty6w62l+e0mNwkxnnjc5iN5hkntAv/lk2X8KGZMCUVkC1xO1BDTVjv4L9BloQiokB2jIp0TRk+TRyh7mnUB2gvUEv3wW1fnW99BDLSG9wqY0bQIf8giqLb4HC/ZFjcC8rKy8QZDLFj6/rOh/iD9CIKQh6xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qz3cefnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qz3cefnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4521F00A3A;
	Tue, 21 Jul 2026 19:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662576;
	bh=r5F9jQGol6jFEBg9x5ekAzOdU8hBIjDXtK2g78H1Kjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qz3cefnv6s5J93QaxLvlok3xQq6+GyLigBSv55LTLsU9xp1AUKFo5kVBJjl1kCfm/
	 ETTS83CU55WQa2kRuWX+bjQxrLs+EJHL3/n1AK1PcKkJ2olgmAunNbFLPwh3Vq0Cv8
	 Q8kQG2NwkHsW6kLvBwtVNrMByAGAR/QVZ3zvgKnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carol L Soto <csoto@nvidia.com>,
	Jamie Nguyen <jamien@nvidia.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0496/1276] fs/ntfs3: resize log->one_page_buf when adopting on-disk page size
Date: Tue, 21 Jul 2026 17:15:39 +0200
Message-ID: <20260721152457.203410637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d581f69bd52361..954f4d35dc1da4 100644
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




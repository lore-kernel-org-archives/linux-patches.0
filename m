Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A79576EB5;
	Wed,  9 Sep 2026 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962990; cv=none; b=LqLMzrkR8aa5CA5j+ds2EW+4MGD3sEpwsXSczWh5eB8wN3UPixxFuTEke5atUP65bZ9USG0AyuffZxUomK/UKotMM52OJ1AiZQpayNmBwunUP3BUGkjRi/ATqrf0SgiCs0M1Gh7WsGaSSax3AsvnxDlquBkUNF5MnWwd59dv6/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962990; c=relaxed/simple;
	bh=LDRenztAMPBGTYYeliOhuYw+DuHImA1oRZdDfIY2rhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVyC0Z3DqMbgjPEp9VAx5NFJqSOkNza+PBwaJE6WnJachKrXNpVSAFOK8gab0GKuENKG0nZ9+UyYh46nq2cST/v2N7k5kbA5Vp6CGoKrS1U15zfGvZMdmUfa5pwhXw80lAZzKDosp7pEnNp2oSwjWlx1CEalPIYr4TNAhT9gohY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIVsB7GT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIVsB7GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771171F00A3D;
	Wed,  9 Sep 2026 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962989;
	bh=eXgpkQZPEoEi+uHkFWzKBole6n9fst2XVypnmSwJ9DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIVsB7GTfg5qSGnHnpLaLAhctKehNKsKNfyuYFT/zMHZghEXYoQnke5rO44AJVREk
	 OWPkqMnvWseHVKY1oLX3MnQbslNQWC1lZ4QJeLhLlIeAlpLerTWsx9pRU9PR97HrG9
	 GNTIn+xoS70OThLN2M0YdLFfNEVZstL10kc0kdfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 459/556] f2fs: fix folio_nr_pages() race after put in large folio invalidate
Date: Wed,  9 Sep 2026 15:42:19 +0200
Message-ID: <20260909134246.715505803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

commit 0dab71381f1b4d12dc2056f8bd5aaa9d93ce9082 upstream.

Our v6.18 based Android system is continuely suffering livelock and bad
page stat as shown in[1] which related to broken xarray slot status. By
investigating big folio operations within f2fs, we find below races and
fix it by get the nr_pages before drop the refcount and folio_lock.

f2fs_get_read_data_folio() calls f2fs_folio_put() before
folio_nr_pages() when invalidating a large folio from the page cache.
That unlocks the folio and drops the caller reference, leaving a window
where a concurrent truncate or folio split can shrink the compound folio
or free it before the invalidate range is computed. An undersized range
then leaves split sub-folios in mapping->i_pages, which can later
interact badly with truncate and reclaim (stale xarray entries and bad
page state when folio->mapping no longer matches the mapping being
truncated).

[1]
PID: 2594     TASK: ffffff8169b81580  CPU: 7    COMMAND: "Thread-3"
 #0 [ffffffc08ef2b8a0] xas_load at ffffffe52d1f42a4
 #1 [ffffffc08ef2b900] find_get_entries at ffffffe52c185798
 #2 [ffffffc08ef2bb60] truncate_inode_pages_range at ffffffe52c19e83c
 #3 [ffffffc08ef2bbc0] truncate_inode_pages_final at ffffffe52c19ec2c
 #4 [ffffffc08ef2bc20] f2fs_evict_inode at ffffffe52c4c8400
 #5 [ffffffc08ef2bcc0] evict at ffffffe52c2de9f4
 #6 [ffffffc08ef2bd00] iput at ffffffe52c2db1b4
 #7 [ffffffc08ef2bd30] dentry_unlink_inode at ffffffe52c2d7204
 #8 [ffffffc08ef2bd50] __dentry_kill at ffffffe52c2d3dcc
 #9 [ffffffc08ef2bd80] dput at ffffffe52c2d3c3c
 #10 [ffffffc08ef2bda0] __fput at ffffffe52c2b0a7c
 #11 [ffffffc08ef2bde0] ____fput at ffffffe52c2b1034
 #12 [ffffffc08ef2bdf0] task_work_run at ffffffe52beea200
 #13 [ffffffc08ef2be20] exit_to_user_mode_loop at ffffffe52bfbc17c
 #14 [ffffffc08ef2be80] el0_svc at ffffffe52d1f8e54
 #15 [ffffffc08ef2beb0] el0t_64_sync_handler at ffffffe52d1f8d10

Cc: stable@kernel.org
Fixes: 05e65c14ea59 ("f2fs: support large folio for immutable non-compressed case")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 62ea74e65db8..042ed8ad9cc3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1323,10 +1323,11 @@ struct folio *f2fs_get_read_data_folio(struct inode *inode, pgoff_t index,
 
 	if (folio_test_large(folio)) {
 		pgoff_t folio_index = mapping_align_index(mapping, index);
+		unsigned long nr_pages = folio_nr_pages(folio);
 
 		f2fs_folio_put(folio, true);
 		invalidate_inode_pages2_range(mapping, folio_index,
-				folio_index + folio_nr_pages(folio) - 1);
+				folio_index + nr_pages - 1);
 		f2fs_schedule_timeout(DEFAULT_SCHEDULE_TIMEOUT);
 		goto retry;
 	}
-- 
2.55.0




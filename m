Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077F046EF88;
	Tue, 21 Jul 2026 19:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662466; cv=none; b=YHorpMQP0m9pXJRFO96hYzb5iA/ek98k4EUqBCMo5UUXMn6XQGxiTqK5cAeaB69WtaSPqT+tbUS9Boh91eNq9En/0i0YeZN1U3uBB8sKQW6t1ux62GsHy01k6V3jIr886JoDVGC49IL5IVa0p+jgyAq7DZK5iilZQHc5dhvnwLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662466; c=relaxed/simple;
	bh=WzyjxIiNhbFaJw4HhBCeFWgoex2XAxY9shqRshnPeko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1jYxgvFY1iPO/1mNy9+25ZmmFVW6xcu5THMNBnrqC92wR5LBlIXTOqedC5LDAqdaEbpoEHXT5KvHCiJTuVVoF7P85/KU6EkU0ofKyHUogNLgXHPa42USgdrcGc9D3fn5C4pSKCGx4YZRSE7gq4fE7UJxqgK0z5GeUo24K8+TUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ba+qzNNA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ba+qzNNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA8B1F000E9;
	Tue, 21 Jul 2026 19:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662464;
	bh=pSUdngQTaz/FWcval8loqOzY9AVUhsgRc1S2L5tQEq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ba+qzNNAO9hYzqMrU6nRYO6zO5saA2269ujl3Zd+qtI7bWNvDWamaCvXT0/cdLhQl
	 jeULfa9tUxn8pJBLZ4GYBZooCrFUAtVH4csjAV8NYS0WPPH+3JF6PdhwL/DV2PhvFv
	 XFpOhhmNhldhxVHj4Ue4q/bS3zNMa5xYP3Snc4fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew R. Ochs" <mochs@nvidia.com>,
	Jamie Nguyen <jamien@nvidia.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0453/1276] fs/ntfs3: fix mount failure on 64K page-size kernels
Date: Tue, 21 Jul 2026 17:14:56 +0200
Message-ID: <20260721152456.241308258@linuxfoundation.org>
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

[ Upstream commit b7a9125cac8645245d2473c6c0a50e338280ad23 ]

On 64K page-size kernels, mounting NTFS volumes smaller than ~650 MB
fails with EINVAL. The issue is in log_replay(): the initial log page
size probe uses PAGE_SIZE (65536) instead of DefaultLogPageSize (4096)
when PAGE_SIZE exceeds DefaultLogPageSize * 2.

This makes norm_file_page() require the $LogFile to be at least
50 * 65536 = 3.2 MB, but mkfs.ntfs creates a $LogFile of only ~1.5 MB
for a typical 300 MB volume. norm_file_page() returns 0 and the mount
is rejected with EINVAL.

On 4K kernels the #if guard evaluates to true, so use_default=true is
passed and DefaultLogPageSize (4096) is used, requiring only ~200 KB.
This path works fine.

Fix this by always passing use_default=true, which forces the initial
probe to use DefaultLogPageSize regardless of the kernel's PAGE_SIZE.
This is safe because, after reading the on-disk restart area, log_replay()
already re-adjusts log->page_size to match the volume's actual
sys_page_size.

Also fix read_log_page() to pass log->page_size instead of PAGE_SIZE to
ntfs_fix_post_read(), matching the actual buffer size.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Tested-by: Matthew R. Ochs <mochs@nvidia.com>
Signed-off-by: Jamie Nguyen <jamien@nvidia.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 5d733239aa0b74..d581f69bd52361 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1170,7 +1170,7 @@ static int read_log_page(struct ntfs_log *log, u32 vbo,
 		goto out;
 
 	if (page_buf->rhdr.sign != NTFS_FFFF_SIGNATURE)
-		ntfs_fix_post_read(&page_buf->rhdr, PAGE_SIZE, false);
+		ntfs_fix_post_read(&page_buf->rhdr, log->page_size, false);
 
 	if (page_buf != *buffer)
 		memcpy(*buffer, Add2Ptr(page_buf, page_off), bytes);
@@ -3800,11 +3800,7 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 	log->l_size = log->orig_file_size = ni->vfs_inode.i_size;
 
 	/* Get the size of page. NOTE: To replay we can use default page. */
-#if PAGE_SIZE >= DefaultLogPageSize && PAGE_SIZE <= DefaultLogPageSize * 2
 	log->page_size = norm_file_page(PAGE_SIZE, &log->l_size, true);
-#else
-	log->page_size = norm_file_page(PAGE_SIZE, &log->l_size, false);
-#endif
 	if (!log->page_size) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7EB38B133;
	Tue, 21 Jul 2026 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657080; cv=none; b=g6Hh10+GpkqxPoyUNkpQ2J6a7yFOvQImW3xGpUydqwlORuUW5r1GBNnD5rebCwh3rk1oRkmp+CmtPRqk5tO+CrRr24J99UV4pve4uMRcXbkPj3Wf+qsNDaaoCsb+uG/yyv+o0veBB0AcYeEng9dqls0v/HfQl+nrlefY4VREFog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657080; c=relaxed/simple;
	bh=5G6LDc4mmveZg0X6NQ0v/9cQICyOWJnodGPzJrCWkbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmpgfGgzALADEB/PtNrWOMQ49u67unJJzUPgv1brLCXGSiHl9vzOctVqbaxk7+HUeHDOPCDDEeOeck5otaz9tDUfzpqVjGy4SzYqCjAF8KRLKrufVjiJYUlvuLnqYrrfcNv7p1sDFGCrUS6g3QlV5X4RXip6gema7sOzm+zS0Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMvUedd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMvUedd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944091F000E9;
	Tue, 21 Jul 2026 18:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657079;
	bh=vWQgqEIPXSN559KZoMVp5tSO285d0A8aDV7t4u+yoyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMvUedd8GgO88S+M3I/UzxFMsE6Iv7rtIp8qNRRWpIb3S3vjhd/O4o2QEDBgJt7Dw
	 u5G/D5jlR38sn/p3WY2fXq76BHagZkyUoQasu5UZcYrl3JOh4ckiyVs2yn5ZhTcrNP
	 cUHUdbbqZi4JTs1WVEjTw7Wlfb676eWjknlDVZIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew R. Ochs" <mochs@nvidia.com>,
	Jamie Nguyen <jamien@nvidia.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0629/1611] fs/ntfs3: fix mount failure on 64K page-size kernels
Date: Tue, 21 Jul 2026 17:12:25 +0200
Message-ID: <20260721152529.535665524@linuxfoundation.org>
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
index 5aa3ac25aaeb73..124198539b9506 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1170,7 +1170,7 @@ static int read_log_page(struct ntfs_log *log, u32 vbo,
 		goto out;
 
 	if (page_buf->rhdr.sign != NTFS_FFFF_SIGNATURE)
-		ntfs_fix_post_read(&page_buf->rhdr, PAGE_SIZE, false);
+		ntfs_fix_post_read(&page_buf->rhdr, log->page_size, false);
 
 	if (page_buf != *buffer)
 		memcpy(*buffer, Add2Ptr(page_buf, page_off), bytes);
@@ -3798,11 +3798,7 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
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




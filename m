Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEF046D2CE;
	Tue, 21 Jul 2026 19:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660402; cv=none; b=dIp8r6YnCeM9aDthWuQhZjxtP7n+K+MVkRHEMxP2LdcE6GQeq0RY6gqZcrwCPePHBS31ZMcJ1KRcSm7DoeKaCBDNO1/zi9TeRpWQx9E/Yr5VEXA05Iuh5ZCFcbdtlBfvt+G+F9d3hIivJh0HDQn9KIijLqXQm0qE6mLuf35InsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660402; c=relaxed/simple;
	bh=ldr4p4Yte4lBtOaxgXDfwkxnumkkNXofIYqAyyZhf8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNAKY8XGp0+zaaNXcbvWPxmQZzybBA1LQZOhlvDe9a9/2fHS9CkNomBy8qAohYCfTaYuZE8LjnD2+WYgO81HPT2YaN+ONKNqkibyXDZliEyIEzpYrR/Uq6thqCoDmXVW8HG3m9ouCAsMfwd+lMvl6Z0hNmLJg6uE6tgMqlDiDRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIKKe9tH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIKKe9tH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516BB1F000E9;
	Tue, 21 Jul 2026 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660401;
	bh=5WrkcJvHEVD4eIO23Zg3zVPy6BWMKbFCFymG+3v58MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIKKe9tHY2LMVr4qzdqar868gsIPehoNyRgkyqG8aOaYKeiNnFbFoQNIltuowPoJg
	 6ZwVIjM+l5I8CNorG/I2IbBYINJzdEwT7qIlcG15NEMTxUkUZqa5LQVJp2bv3Lg3jD
	 h2EVKtQaFz+iyes9O2Z4Yd+dlHmE0dVhGIfyeP+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew R. Ochs" <mochs@nvidia.com>,
	Jamie Nguyen <jamien@nvidia.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0922/2077] fs/ntfs3: fix mount failure on 64K page-size kernels
Date: Tue, 21 Jul 2026 17:09:55 +0200
Message-ID: <20260721152614.560875139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0504e5e8a5087a..3c320e7a4c12fb 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1172,7 +1172,7 @@ static int read_log_page(struct ntfs_log *log, u32 vbo,
 		goto out;
 
 	if (page_buf->rhdr.sign != NTFS_FFFF_SIGNATURE)
-		ntfs_fix_post_read(&page_buf->rhdr, PAGE_SIZE, false);
+		ntfs_fix_post_read(&page_buf->rhdr, log->page_size, false);
 
 	if (page_buf != *buffer)
 		memcpy(*buffer, Add2Ptr(page_buf, page_off), bytes);
@@ -3799,11 +3799,7 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A512F617C;
	Sat, 12 Sep 2026 09:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204605; cv=none; b=Qu4/8RJ9Xi3pQ5H4Nx04A5iJWAAi6SC0RWZsotv3WnNCGCXgX+72hOVxbby75OeqJEwzUcQIIZ9UQ6vYF2j67zvGLcKJjorTlY6x9qjE1VDwT5EQ6n/8DMKW/ep9ZUtq4jXq7iFsye/tMmlVUTH1KzYFDnX2EPzAnitZrl+FZ/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204605; c=relaxed/simple;
	bh=FaMFOXmx7xajpuMkHjCWcPetgO0dgSnZUzazEvrtYWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1NYUpeaZ+bVKkzRq/aO82srXzjxFhPJE3YBqULX1atF0i4a/rV+/zTvGJ9uQtM3OqYxHLgyPtzZSTwxwGCD2WeJCmZ+zxAGA+X3/GCJXibI6xre4fz1MqEHGI6NfIrh9aO0AWiqo7He+edAJWsCUaT4BeHRwv6iCYyVebM9MW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jauPg2B9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jauPg2B9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F281F000FF;
	Sat, 12 Sep 2026 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204604;
	bh=elyANrKis+N5rfNe/aTYchVr6FsNYDcC+UUQmS3fD+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jauPg2B9uu8DTSf2En4pMCZpFA2E2M0gMtmEmLhW7dKMfUnjd0YFEvogdq6J23zhA
	 5sfvpt4nARlO+agvImQJCAIT3r+Gpt4gcMDX76t9I6OkQAV7/ghglGU6NluYWOJmGb
	 l3+6IsCWuUpYjh/0/1P9hRp3IVS+tGRXEuSTXPgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1604/1815] ntfs: Inline zero_partial_compressed_page()
Date: Sat, 12 Sep 2026 08:55:54 +0200
Message-ID: <20260912065726.646021980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit f98d80d51777e2c8a26efec9b86541b3b5a154ae ]

zero_partial_compressed_page() has one caller and the next commit
will make changes to it that make it inelegant to split across two
functions.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/compress.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 76bd806b41edd..c904858dff3d2 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -96,26 +96,6 @@ void free_compression_buffers(void)
 	mutex_unlock(&ntfs_cb_lock);
 }
 
-/*
- * zero_partial_compressed_page - zero out of bounds compressed page region
- * @page: page to zero
- * @initialized_size: initialized size of the attribute
- */
-static void zero_partial_compressed_page(struct page *page,
-		const s64 initialized_size)
-{
-	u8 *kp = page_address(page);
-	unsigned int kp_ofs;
-
-	ntfs_debug("Zeroing page region outside initialized size.");
-	if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
-		clear_page(kp);
-		return;
-	}
-	kp_ofs = initialized_size & ~PAGE_MASK;
-	memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
-}
-
 /*
  * handle_bounds_compressed_page - test for&handle out of bounds compressed page
  * @page: page to check and handle
@@ -126,8 +106,18 @@ static inline void handle_bounds_compressed_page(struct page *page,
 		const loff_t i_size, const s64 initialized_size)
 {
 	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
-			(initialized_size < i_size))
-		zero_partial_compressed_page(page, initialized_size);
+			(initialized_size < i_size)) {
+		u8 *kp = page_address(page);
+		unsigned int kp_ofs;
+
+		ntfs_debug("Zeroing page region outside initialized size.");
+		if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
+			clear_page(kp);
+			return;
+		}
+		kp_ofs = initialized_size & ~PAGE_MASK;
+		memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
+	}
 }
 
 /*
-- 
2.53.0




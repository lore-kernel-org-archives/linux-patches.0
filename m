Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3947868A;
	Wed, 21 Feb 2024 13:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522659; cv=none; b=rXB8IPYDr5GX3QJQy3VgHvb1yF8fPUGGCPea0fwT05wMXa3uEmpY5b8D64xrUuxX4Q4EpC6yBdXemWlOLaoaogfa+dTyma3ko5aFTKafCGd0cJ9Dh3eBKFW2oriHVt5wQw9BTA9u5cnPOl6xuCbevH7N5SGD3z+vx4T2qUwU9Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522659; c=relaxed/simple;
	bh=aab/wuMvcItxJ/UvlOVyOm1jNXxkAQqwbrv6J9jiTEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIw8ZATRSAz/uN0e8ozT1zb97SpLw19J1Zv2YCkrY5yVvGX5hFSbYOWz0cqqmfQaiAb70zf/Sdzc0r3LpagzBqnJfb1it1IgxMxA/orjc/CZc0G+clNdOekrbhKf0df2uJ13E3a6qtC78Aa3Ncc2U93Ff0lhuhD2Ve1geuQ62Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKzxr2Dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKzxr2Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CBEC433F1;
	Wed, 21 Feb 2024 13:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522658;
	bh=aab/wuMvcItxJ/UvlOVyOm1jNXxkAQqwbrv6J9jiTEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKzxr2DtPl8BNRyLO+TkyNtB8A8heijakw0J/HxCiakskCvG8RdPIw4jOjtS8f+5X
	 p+Gqu9INHksmTop03uUmcnFAm+pT2F2mi+0+vYZrHynU+F60AP0eMgWwc4nFFubQo2
	 wjnGcCro2WxvYjm+XAHByg48zOxIM9QT3vjvDQPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 224/476] f2fs: fix to tag gcing flag on page during block migration
Date: Wed, 21 Feb 2024 14:04:35 +0100
Message-ID: <20240221130016.170992560@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 4961acdd65c956e97c1a000c82d91a8c1cdbe44b ]

It needs to add missing gcing flag on page during block migration,
in order to garantee migrated data be persisted during checkpoint,
otherwise out-of-order persistency between data and node may cause
data corruption after SPOR.

Similar issue was fixed by commit 2d1fe8a86bf5 ("f2fs: fix to tag
gcing flag on page during file defragment").

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 4 +++-
 fs/f2fs/file.c     | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 3982b4a7618c..7b4479d5b531 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1037,8 +1037,10 @@ static void set_cluster_dirty(struct compress_ctx *cc)
 	int i;
 
 	for (i = 0; i < cc->cluster_size; i++)
-		if (cc->rpages[i])
+		if (cc->rpages[i]) {
 			set_page_dirty(cc->rpages[i]);
+			set_page_private_gcing(cc->rpages[i]);
+		}
 }
 
 static int prepare_compress_overwrite(struct compress_ctx *cc,
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d220c4523982..489854d841e7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1278,6 +1278,7 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 			}
 			f2fs_copy_page(psrc, pdst);
 			set_page_dirty(pdst);
+			set_page_private_gcing(pdst);
 			f2fs_put_page(pdst, 1);
 			f2fs_put_page(psrc, 1);
 
@@ -3981,6 +3982,7 @@ static int redirty_blocks(struct inode *inode, pgoff_t page_idx, int len)
 			break;
 		}
 		set_page_dirty(page);
+		set_page_private_gcing(page);
 		f2fs_put_page(page, 1);
 		f2fs_put_page(page, 0);
 	}
-- 
2.43.0




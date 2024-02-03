Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B01C125C4;
	Sat,  3 Feb 2024 04:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933424; cv=none; b=nIQDIx0+juW9hMV11PomqIsWs8RHP53zdz78DsyaCs5AFP5adshj5YhSMTUYeFNWSyogB4W48PK6QGOcSI5hvm5P7wTPwb91xpGCrBtgl6tagWcfXX6Txzqvpj/BuYLIASgkXAFZauCOnwYOgvGw6QC9yAYCk7d/a8voKCXeezs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933424; c=relaxed/simple;
	bh=3ohXCnvwdV/faQx3Rk69C7jWNt76Ng0MOqw9lNWTJcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI/XRLlSNmFo4Jub/p2AbPHnHg9mm+n3sj89TQeSLnxKwjyi/uv/pSZZ2d3ai6wONFbVHIozkBTwXRFwvGvuvFqvMtGZ+CNOpC0wcQsVtWVze4GNCS/Ow3sUipSLDBH5rnGbhNtrSoKU4ynKbrURjgqZd/HQf+PCCJuxezt2G5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuDA5MOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuDA5MOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13342C43390;
	Sat,  3 Feb 2024 04:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933424;
	bh=3ohXCnvwdV/faQx3Rk69C7jWNt76Ng0MOqw9lNWTJcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuDA5MOatiTFB1E5NIdPtUdm1AaLKWe6E9M7gbIF4Dyhr3MT/0YniNsqAxyY+wkoc
	 mqXgSNIeo4VrruNisHPxmZzJ/QRXkdQ9XtW+Zg0kLYpWWiVOgOnanImEweYAlch5lW
	 6S+zWiH0p6tWpdTB9t+nggZeDtdd9QTaMl3Mkb14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/219] f2fs: fix to tag gcing flag on page during block migration
Date: Fri,  2 Feb 2024 20:04:59 -0800
Message-ID: <20240203035335.207060170@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4cb58e8d699e..3d9f6495a4db 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1026,8 +1026,10 @@ static void set_cluster_dirty(struct compress_ctx *cc)
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
index fd22854dbeae..46e4960a9dcf 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1326,6 +1326,7 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 			}
 			memcpy_page(pdst, 0, psrc, 0, PAGE_SIZE);
 			set_page_dirty(pdst);
+			set_page_private_gcing(pdst);
 			f2fs_put_page(pdst, 1);
 			f2fs_put_page(psrc, 1);
 
@@ -4037,6 +4038,7 @@ static int redirty_blocks(struct inode *inode, pgoff_t page_idx, int len)
 		f2fs_bug_on(F2FS_I_SB(inode), !page);
 
 		set_page_dirty(page);
+		set_page_private_gcing(page);
 		f2fs_put_page(page, 1);
 		f2fs_put_page(page, 0);
 	}
-- 
2.43.0




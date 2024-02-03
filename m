Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02F350A73;
	Sat,  3 Feb 2024 04:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933883; cv=none; b=mFqfgVEe8xonsKnbwT4jnrbmucZF/8zGVNmiAqo5duCZgxuJZDoKhK7ivovOfugl1B9hGCJXUfr6mn52gISmkbqn426n2YP91SEvIiYrcFDDyTN9oEXlJuaYv8AJjvQ2ZoZTJ4RvA8lbRQwgDknBRzRCSz0uib/kkQ6M5wk/Hdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933883; c=relaxed/simple;
	bh=WaMOY/kdvFG2Us3rwEU41F5NsFl+Wu/gnrXJJ6AnQJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpGdGZgQx9JQ+5N6MJv4McJ+OPybgrzDAzxJ6o+ebyJgPxGrF/KUYuohPqSH6PpX2tGFEqkVKZ/9z61l/PnDrh7CDnRcI0WfPq6tGI21qiCNz9l0IhTBTHPnti97ClLdKxLIstdyoKIh45McnmADBdkiMQAycyh9VYCOtgrvkIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9QEq7y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9QEq7y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62788C433B1;
	Sat,  3 Feb 2024 04:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933883;
	bh=WaMOY/kdvFG2Us3rwEU41F5NsFl+Wu/gnrXJJ6AnQJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9QEq7y01segPb0wV4+ey8iwlNaGM0WvkjdmnLHErHQ1poqbE/EWc36jpSjlWFkiB
	 WtzQRQFwrSaNGzK3pc9QfC9WuVIXK92k5a7keq9T24LTIlH+ZTuJA0CLS4eVUkwjnb
	 TDaF0OOSyI4PIJU0hVBPsAcvuSeUzBUIT1u3lLbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 197/353] f2fs: fix to tag gcing flag on page during block migration
Date: Fri,  2 Feb 2024 20:05:15 -0800
Message-ID: <20240203035409.920797432@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 36e5dab6baae..62119f3f7206 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1036,8 +1036,10 @@ static void set_cluster_dirty(struct compress_ctx *cc)
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
index 8912511980ae..a05781e708d6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1317,6 +1317,7 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 			}
 			memcpy_page(pdst, 0, psrc, 0, PAGE_SIZE);
 			set_page_dirty(pdst);
+			set_page_private_gcing(pdst);
 			f2fs_put_page(pdst, 1);
 			f2fs_put_page(psrc, 1);
 
@@ -4059,6 +4060,7 @@ static int redirty_blocks(struct inode *inode, pgoff_t page_idx, int len)
 		f2fs_bug_on(F2FS_I_SB(inode), !page);
 
 		set_page_dirty(page);
+		set_page_private_gcing(page);
 		f2fs_put_page(page, 1);
 		f2fs_put_page(page, 0);
 	}
-- 
2.43.0




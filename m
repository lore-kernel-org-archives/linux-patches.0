Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1328A34DCD7;
	Tue, 16 Dec 2025 11:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886119; cv=none; b=MBqZM+h8eTuOpeYi/NWDjXYW5/QF9JGwMFJc67fL3+XWPkQNVXf/YVDWJWUek2s9gPzuN3H3q7UfkW+MSMH3QSqq+VE0wdHItcXhTRlS3+XV8b2Yqfg26fC3VLbIGRe1tYr40t5E7lbAmAm0YUERFLI69I7wLUcJHOu7s5hm13I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886119; c=relaxed/simple;
	bh=OuvUZQTS/bMlIwFhm89sbC6GJvd2lRG3C92522WFzGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9EmQD1io5r2JJaojHVaaY5GK6GwVrmBEYIDP3KU8XsXLXYP2B0nsAn2g97RDgYfyZ7ST1eyPYhGqSXMS/J+u61piAb4cHJwJ3JE23TPvaDK1JTRUI4EHjHYxhYEK7GDU0v/w14SZ+HjqWNLnxPtjE6e7wMLKw1SHzajAiypYcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPrCxZ+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPrCxZ+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777A5C4CEF1;
	Tue, 16 Dec 2025 11:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886119;
	bh=OuvUZQTS/bMlIwFhm89sbC6GJvd2lRG3C92522WFzGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPrCxZ+0XJinSdhXNW/w+6f9QaZskyVGI4R62mcOHilRI3mCqv5bLJITF47oJ68tv
	 doBKCzlVCqZQJ79t9D54EQJVHcVgZJub3IIUuMaGe+0QBY6pVq7NuaIhV6plbsvz6h
	 UKncB5Q4bDanFIiPzH8JIDlL8QrKcR7IZPLdE6Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 316/507] erofs: limit the level of fs stacking for file-backed mounts
Date: Tue, 16 Dec 2025 12:12:37 +0100
Message-ID: <20251216111356.915709973@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit d53cd891f0e4311889349fff3a784dc552f814b9 ]

Otherwise, it could cause potential kernel stack overflow (e.g., EROFS
mounting itself).

Reviewed-by: Sheng Yong <shengyong1@xiaomi.com>
Fixes: fb176750266a ("erofs: add file-backed mount support")
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index edac533a389cb..32336e7c1d9b6 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -632,6 +632,22 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	sbi->blkszbits = PAGE_SHIFT;
 	if (!sb->s_bdev) {
+		/*
+		 * (File-backed mounts) EROFS claims it's safe to nest other
+		 * fs contexts (including its own) due to self-controlled RO
+		 * accesses/contexts and no side-effect changes that need to
+		 * context save & restore so it can reuse the current thread
+		 * context.  However, it still needs to bump `s_stack_depth` to
+		 * avoid kernel stack overflow from nested filesystems.
+		 */
+		if (erofs_is_fileio_mode(sbi)) {
+			sb->s_stack_depth =
+				file_inode(sbi->dif0.file)->i_sb->s_stack_depth + 1;
+			if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
+				erofs_err(sb, "maximum fs stacking depth exceeded");
+				return -ENOTBLK;
+			}
+		}
 		sb->s_blocksize = PAGE_SIZE;
 		sb->s_blocksize_bits = PAGE_SHIFT;
 
-- 
2.51.0




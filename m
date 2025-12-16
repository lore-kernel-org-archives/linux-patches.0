Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146CA33A6F4;
	Tue, 16 Dec 2025 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884606; cv=none; b=pWCyzQMu6hlabbfgsGvJaDbb65gR+RK788d591u5clM2T+pFQNJwc7s7nIaxkeqd6GIL8fqpvYJ2p7gAoO9ORfteA992rD6qnVC3v8WRw+ZKvihCMS0tXi3liIbsEvW2xe8Am+sFnhPu0+y/ruQZ1pFaVdqkzO/BLtZPQP0gK6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884606; c=relaxed/simple;
	bh=3AEi0I6YbQDhJlpkkNVn0R4G5tcVffMXSXrqGbB8X+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0jGlyhNBbDS5CdZWxbuBC9VbFO81qSrgIRKd3RwErN/VURKGwwy9Yj9pJWtM8QWJcs/hSed72b6ladcvnoPWAnPT7BJNm9bKBAeOU+VnnDX30lFECGa3q0b4uxFDNpphkeLma/1ljh6yxlbUkLd1rS0eXBYvQKfodvX4qVY4AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Et30PmnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Et30PmnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A3FC4CEF1;
	Tue, 16 Dec 2025 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884606;
	bh=3AEi0I6YbQDhJlpkkNVn0R4G5tcVffMXSXrqGbB8X+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et30PmnS6gnMvCr9hJReXI9bVSl+gsfkQPvZuYaSVtB26S7/SodZnEBlnIjVl7P+g
	 5Vjs2g5m4klHLUs+eU494+enT1YedF03qV7+bldvf+YuCBc9dpxCGwsMA4u6rXTgC1
	 A46lCtKLpqPR0Ti7ZEWeQe+naHH0IDpuEGYKLOqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/354] erofs: limit the level of fs stacking for file-backed mounts
Date: Tue, 16 Dec 2025 12:12:59 +0100
Message-ID: <20251216111328.601337869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 5fcdab6145176..027fd567a4d9f 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -636,6 +636,22 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 
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




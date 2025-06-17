Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1195A221F1F;
	Tue, 17 Jun 2025 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174483; cv=none; b=JlzGx8Zqy5kaqyYqRWq0qyx6h57tdiJmMwodz+m+svWscT4z3TCX/gbkrfNMgG/qCWcVlcRf5+mjP257Ky0/adHCyvQN3MsCfXFz8VzEZsPltEfzuOy0C5sxoQ8pxNc+HJ2atkohdrakSV4KeqANHwx2doxk6HAP/ulxcZp84i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174483; c=relaxed/simple;
	bh=bseIyof6VDQnxj3I99fjG+dvGhUfjDydBhnZCLYgFCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwNKDaBiI51mmIBYasTXF9BTcS5xbINSqSuBP9ixBwiJ1g3FmaXipSW1k8w75j9RO7UrqIbyEKkf4Kj0iyd3gxRsxm7Uz8GrEGUAni7OoshXJDXxqe0/Ae865zsq4U1YGXg35vol9dX2ykDAJVNpzNCWEF8TRUCThqUc9QuHtTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvSe24wO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvSe24wO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE6DC4CEE3;
	Tue, 17 Jun 2025 15:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174482;
	bh=bseIyof6VDQnxj3I99fjG+dvGhUfjDydBhnZCLYgFCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvSe24wO+vhA26cC23NoIGJ+K0Gx/c5aYPJTO4Unw6Sq9dTSYqbaP4X6nYYFGipqZ
	 1cYY1Zs8NcJq3oRINvkxJykh0FOio7MKqXHfkRxS2OORj6DomzNWk4IuO/8OOrQ29T
	 Y8OaWqmy30UkEPKfTuLI4lvBFW5ntAkkc1cEcReo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/512] erofs: avoid using multiple devices with different type
Date: Tue, 17 Jun 2025 17:19:51 +0200
Message-ID: <20250617152420.568515832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sheng Yong <shengyong1@xiaomi.com>

[ Upstream commit 9748f2f54f66743ac77275c34886a9f890e18409 ]

For multiple devices, both primary and extra devices should be the
same type. `erofs_init_device` has already guaranteed that if the
primary is a file-backed device, extra devices should also be
regular files.

However, if the primary is a block device while the extra device
is a file-backed device, `erofs_init_device` will get an ENOTBLK,
which is not treated as an error in `erofs_fc_get_tree`, and that
leads to an UAF:

  erofs_fc_get_tree
    get_tree_bdev_flags(erofs_fc_fill_super)
      erofs_read_superblock
        erofs_init_device  // sbi->dif0 is not inited yet,
                           // return -ENOTBLK
      deactivate_locked_super
        free(sbi)
    if (err is -ENOTBLK)
      sbi->dif0.file = filp_open()  // sbi UAF

So if -ENOTBLK is hitted in `erofs_init_device`, it means the
primary device must be a block device, and the extra device
is not a block device. The error can be converted to -EINVAL.

Fixes: fb176750266a ("erofs: add file-backed mount support")
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://lore.kernel.org/r/20250515014837.3315886-1-shengyong1@xiaomi.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 1143e1913f25b..5fcdab6145176 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -188,8 +188,11 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 				filp_open(dif->path, O_RDONLY | O_LARGEFILE, 0) :
 				bdev_file_open_by_path(dif->path,
 						BLK_OPEN_READ, sb->s_type, NULL);
-		if (IS_ERR(file))
+		if (IS_ERR(file)) {
+			if (file == ERR_PTR(-ENOTBLK))
+				return -EINVAL;
 			return PTR_ERR(file);
+		}
 
 		if (!erofs_is_fileio_mode(sbi)) {
 			dif->dax_dev = fs_dax_get_by_bdev(file_bdev(file),
-- 
2.39.5




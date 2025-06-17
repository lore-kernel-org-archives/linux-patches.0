Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B27A1E8332;
	Tue, 17 Jun 2025 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174972; cv=none; b=Xet1Gd80Z91HrIdoS2twI7/anP/Wr+K4lDlZlAXSPy5GKpUob3tN1Ry0r0HAUxRp1AZKZt74K+leq96iuLezo2nTokj+LdqNQZxMU1WEeuLlJmpxrvbSMPcm9TNf8B3FMVL4lvQtBcJ9gN74djpEC9SK9+Uf+YlSUPlBwJt6UCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174972; c=relaxed/simple;
	bh=icmQF3+HRMQOnJcYzmSl2cZEwXN+xKUBzOIptDpE8QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnuV7P2in1233ilo2aoQIeMU40Aldd8OKb5ymYSC6iJELZaoUSvrkKcdoseh6g1VBlQeyp28tqIbar5nn1YyTBVvzH3xTZumeYNcX9WA5F1LwSQEPIVbuFAFOVhak2IumOy1EICr9jF10CsO8TwryhG4D2rqeUsNzaklG+/ulBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ph/DH9rc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ph/DH9rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2AAC4CEE3;
	Tue, 17 Jun 2025 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174972;
	bh=icmQF3+HRMQOnJcYzmSl2cZEwXN+xKUBzOIptDpE8QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ph/DH9rcPGuk3oMMnHYTdlIaf+W9n4TMoBb4XLXxXpdXiA+H3csoBX0jr+ZjM43d5
	 iJaws2t0be+L9ZXWQUaLGvaODBMgg3DBy2Wy0yEehRPohpkYmtqymwR6LWy97Kz4KS
	 JGlQzXxF2ydRtsjadXlCevJleaYViJSrFG93aVFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 038/780] erofs: avoid using multiple devices with different type
Date: Tue, 17 Jun 2025 17:15:46 +0200
Message-ID: <20250617152453.050677172@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index bcb99c3c2594b..6e57b9cc6ed2e 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -165,8 +165,11 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
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




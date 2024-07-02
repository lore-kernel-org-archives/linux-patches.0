Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147CA15218A;
	Tue,  2 Jul 2024 17:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941173; cv=none; b=rvF7PrvGVqHzvf8QPBQ0Di88gkChF8hOFhh/WL+yPQpuDAzG2FSnS32ZfV0+I2sGTGy30iTgklG65Y2dhJeIdGMFUjjYR/8m9v2b22j/kpLLziGXKwbg5xndM7BYoqNw5PweoQkkHvi1cHsfseS6wUBPxVR1q9ZxlKW0WCtVMhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941173; c=relaxed/simple;
	bh=WEqxZInY+TSTquqY+RmEcolal41cdZKsbweYHvMlzu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enS3ZqHA4VJuhoAOskxsRZwC1Fd5Pz/uwP6KmUbKUMuw+ASL8ZQt+lnxzWJG0rFFXHEVFr50KbOHZPBRu3xm+tCP3ORJHP4oRinHrHKibE2JAQZbG5J3C8sVN2zm/EsoFvu+WwNovBR7stkJEuohGntKq93U5EuHgvvY9u9iJpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McSrC4sD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McSrC4sD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB99C4AF07;
	Tue,  2 Jul 2024 17:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941173;
	bh=WEqxZInY+TSTquqY+RmEcolal41cdZKsbweYHvMlzu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McSrC4sDT2oGSS/8Pk0ILYAVBOEcPPfhuh9Qr5FyoMQigZR2vOl0fHc/e+kP+Kf6G
	 GxqyWezP0u/dW4eU1JIVS5rTF4lWIaiiztIvPU2qPWmOd37T8N01rs/4ANfA/cGRan
	 7eLc7Mp6l0bC0mOOV2O2PptqVzLyTGzrPxIVZbE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqun Leng <yqleng@linux.alibaba.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>
Subject: [PATCH 6.6 150/163] erofs: fix NULL dereference of dif->bdev_handle in fscache mode
Date: Tue,  2 Jul 2024 19:04:24 +0200
Message-ID: <20240702170238.740497033@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingbo Xu <jefflexu@linux.alibaba.com>

commit 8bd90b6ae7856dd5000b75691d905b39b9ea5d6b upstream.

Avoid NULL dereference of dif->bdev_handle, as dif->bdev_handle is NULL
in fscache mode.

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 RIP: 0010:erofs_map_dev+0xbd/0x1c0
 Call Trace:
  <TASK>
  erofs_fscache_data_read_slice+0xa7/0x340
  erofs_fscache_data_read+0x11/0x30
  erofs_fscache_readahead+0xd9/0x100
  read_pages+0x47/0x1f0
  page_cache_ra_order+0x1e5/0x270
  filemap_get_pages+0xf2/0x5f0
  filemap_read+0xb8/0x2e0
  vfs_read+0x18d/0x2b0
  ksys_read+0x53/0xd0
  do_syscall_64+0x42/0xf0
  entry_SYSCALL_64_after_hwframe+0x6e/0x76

Reported-by: Yiqun Leng <yqleng@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7245
Fixes: 49845720080d ("erofs: Convert to use bdev_open_by_path()")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20231114070704.23398-1-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/data.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -222,7 +222,7 @@ int erofs_map_dev(struct super_block *sb
 			up_read(&devs->rwsem);
 			return 0;
 		}
-		map->m_bdev = dif->bdev_handle->bdev;
+		map->m_bdev = dif->bdev_handle ? dif->bdev_handle->bdev : NULL;
 		map->m_daxdev = dif->dax_dev;
 		map->m_dax_part_off = dif->dax_part_off;
 		map->m_fscache = dif->fscache;
@@ -240,7 +240,8 @@ int erofs_map_dev(struct super_block *sb
 			if (map->m_pa >= startoff &&
 			    map->m_pa < startoff + length) {
 				map->m_pa -= startoff;
-				map->m_bdev = dif->bdev_handle->bdev;
+				map->m_bdev = dif->bdev_handle ?
+					      dif->bdev_handle->bdev : NULL;
 				map->m_daxdev = dif->dax_dev;
 				map->m_dax_part_off = dif->dax_part_off;
 				map->m_fscache = dif->fscache;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C4B364B7;
	Fri, 24 Nov 2023 19:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9TCq80D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2540C433C8;
	Fri, 24 Nov 2023 19:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853369;
	bh=P88lq7XInpYnpYKW0sXYoQQO/pJ2N+XjBzAV9cO+LQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9TCq80DocoB7UCQ4v1yg4s2xOzGWj+bcVpAIrTTPIVVz24bmF6ukCufAjYMS07Nx
	 YSZsJgBkD5NNhTp8xZRcf9piGRlNl5eb170xEmBEtRB5xUty8bcK507Ml2cVxJihQI
	 CaRNd1jI+1wUW6CnPnfgak+fFlyjP8FI22DCSs3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/297] xfs: fix memory leak in xfs_errortag_init
Date: Fri, 24 Nov 2023 17:53:15 +0000
Message-ID: <20231124172005.626443132@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit cf4f4c12dea7a977a143c8fe5af1740b7f9876f8 ]

When `xfs_sysfs_init` returns failed, `mp->m_errortag` needs to free.
Otherwise kmemleak would report memory leak after mounting xfs image:

unreferenced object 0xffff888101364900 (size 192):
  comm "mount", pid 13099, jiffies 4294915218 (age 335.207s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f08ad25c>] __kmalloc+0x41/0x1b0
    [<00000000dca9aeb6>] kmem_alloc+0xfd/0x430
    [<0000000040361882>] xfs_errortag_init+0x20/0x110
    [<00000000b384a0f6>] xfs_mountfs+0x6ea/0x1a30
    [<000000003774395d>] xfs_fs_fill_super+0xe10/0x1a80
    [<000000009cf07b6c>] get_tree_bdev+0x3e7/0x700
    [<00000000046b5426>] vfs_get_tree+0x8e/0x2e0
    [<00000000952ec082>] path_mount+0xf8c/0x1990
    [<00000000beb1f838>] do_mount+0xee/0x110
    [<000000000e9c41bb>] __x64_sys_mount+0x14b/0x1f0
    [<00000000f7bb938e>] do_syscall_64+0x3b/0x90
    [<000000003fcd67a9>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: c68401011522 ("xfs: expose errortag knobs via sysfs")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_error.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 81c445e9489bd..b0ccec92e015d 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -224,13 +224,18 @@ int
 xfs_errortag_init(
 	struct xfs_mount	*mp)
 {
+	int ret;
+
 	mp->m_errortag = kmem_zalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
 			KM_MAYFAIL);
 	if (!mp->m_errortag)
 		return -ENOMEM;
 
-	return xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
-			       &mp->m_kobj, "errortag");
+	ret = xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
+				&mp->m_kobj, "errortag");
+	if (ret)
+		kmem_free(mp->m_errortag);
+	return ret;
 }
 
 void
-- 
2.42.0




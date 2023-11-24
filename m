Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496D833CCA;
	Fri, 24 Nov 2023 19:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpMOwo8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6A9C433C7;
	Fri, 24 Nov 2023 19:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853397;
	bh=WRafsSZRAO20hCbzR/dY5tiBIfw3FmMRYKLblL/xdsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpMOwo8rXBnLYidF7jQ17xxgColjiaaQ/WLNR3ipIzgCFpkOR4AcWbrzlZQB/ORE/
	 ODHjYUBAjwSDaTyZpQ5ca9I6bf8FDEql7jFC4eDTLWLmVUHGyNvNeT6j2PUpl7ivbe
	 VgJQmXT45W8gZWC+wrg7fx40kwb0HTCst3aq/SpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/297] xfs: Fix unreferenced object reported by kmemleak in xfs_sysfs_init()
Date: Fri, 24 Nov 2023 17:53:16 +0000
Message-ID: <20231124172005.653909720@linuxfoundation.org>
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

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit d08af40340cad0e025d643c3982781a8f99d5032 ]

kmemleak reported a sequence of memory leaks, and one of them indicated we
failed to free a pointer:
  comm "mount", pid 19610, jiffies 4297086464 (age 60.635s)
    hex dump (first 8 bytes):
      73 64 61 00 81 88 ff ff                          sda.....
    backtrace:
      [<00000000d77f3e04>] kstrdup_const+0x46/0x70
      [<00000000e51fa804>] kobject_set_name_vargs+0x2f/0xb0
      [<00000000247cd595>] kobject_init_and_add+0xb0/0x120
      [<00000000f9139aaf>] xfs_mountfs+0x367/0xfc0
      [<00000000250d3caf>] xfs_fs_fill_super+0xa16/0xdc0
      [<000000008d873d38>] get_tree_bdev+0x256/0x390
      [<000000004881f3fa>] vfs_get_tree+0x41/0xf0
      [<000000008291ab52>] path_mount+0x9b3/0xdd0
      [<0000000022ba8f2d>] __x64_sys_mount+0x190/0x1d0

As mentioned in kobject_init_and_add() comment, if this function
returns an error, kobject_put() must be called to properly clean up
the memory associated with the object. Apparently, xfs_sysfs_init()
does not follow such a requirement. When kobject_init_and_add()
returns an error, the space of kobj->kobject.name alloced by
kstrdup_const() is unfree, which will cause the above stack.

Fix it by adding kobject_put() when kobject_init_and_add returns an
error.

Fixes: a31b1d3d89e4 ("xfs: add xfs_mount sysfs kobject")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_sysfs.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 43585850f1546..513095e353a5b 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -33,10 +33,15 @@ xfs_sysfs_init(
 	const char		*name)
 {
 	struct kobject		*parent;
+	int err;
 
 	parent = parent_kobj ? &parent_kobj->kobject : NULL;
 	init_completion(&kobj->complete);
-	return kobject_init_and_add(&kobj->kobject, ktype, parent, "%s", name);
+	err = kobject_init_and_add(&kobj->kobject, ktype, parent, "%s", name);
+	if (err)
+		kobject_put(&kobj->kobject);
+
+	return err;
 }
 
 static inline void
-- 
2.42.0




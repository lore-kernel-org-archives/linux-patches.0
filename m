Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C52C168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C41C433EF;
	Mon,  8 May 2023 09:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539543;
	bh=8ezcZl5m/cEkzzWdEWK78JGEzBcRyHLWDItMhISB3kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zf3Tqt8yNjLWkjSeiOmxA5mE96DX1oEX7D62RuzL5mlV4e3NCWGrz/virD7lg5DMF
	 B8qPJ8E+dbXFAgyVRJzC5NL9HU5ABqX8pb8Y6LRgmQxgO+ebtqTG1kXD94HDULB7BD
	 2zomRULBTQ3BEGZ3SBZlXpFCRmmA6aVA69vRWxdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.1 055/611] fs: fix sysctls.c built
Date: Mon,  8 May 2023 11:38:17 +0200
Message-Id: <20230508094423.717770236@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit e3184de9d46c2eebdb776face2e2662c6733331d upstream.

'obj-$(CONFIG_SYSCTL) += sysctls.o' must be moved after "obj-y :=",
or it won't be built as it is overwrited.

Note that there is nothing that is going to break by linking
sysctl.o later, we were just being way to cautious and patches
have been updated to reflect these considerations and sent for
stable as well with the whole "base" stuff needing to be linked
prior to child sysctl tables that use that directory. All of
the kernel sysctl APIs always share the same directory, and races
against using it should end up re-using the same single created
directory.

And so something we can do eventually is do away with all the base stuff.
For now it's fine, it's not creating an issue. It is just a bit pedantic
and careful.

Fixes: ab171b952c6e ("fs: move namespace sysctls and declare fs base directory")
Cc: stable@vger.kernel.org # v5.17
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
[mcgrof: enhanced commit log for stable criteria and clarify base stuff ]
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/Makefile
+++ b/fs/Makefile
@@ -6,7 +6,6 @@
 # Rewritten to use lists instead of if-statements.
 # 
 
-obj-$(CONFIG_SYSCTL)		+= sysctls.o
 
 obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
@@ -49,7 +48,7 @@ obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
 obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_COREDUMP)		+= coredump.o
-obj-$(CONFIG_SYSCTL)		+= drop_caches.o
+obj-$(CONFIG_SYSCTL)		+= drop_caches.o sysctls.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
 obj-y				+= iomap/



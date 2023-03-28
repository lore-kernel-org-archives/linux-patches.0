Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6870F8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E7BC4339E;
	Tue, 28 Mar 2023 14:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015369;
	bh=zfPODjKtu3HdiMjTnIcccTGnyDmY7ImOHYYbBZV6DX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzexpjaICx8UZKIo/y2dWiue9jLmQC0qHWH+AXWTw8Lby4jyNWXMx/z8gDcaRmzEI
	 RMtF8VCvm2GjSKOuUmfJkNOggHZnXr0LjLlx/KwKhT47ETNPGcxXUQB4yoaj/uc+Wt
	 eNDsE+fuP8sZOOHjbKl3sL3F0Zop/yVMXaHbmJ3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Wysochanski <dwysocha@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/224] NFS: Fix /proc/PID/io read_bytes for buffered reads
Date: Tue, 28 Mar 2023 16:40:20 +0200
Message-Id: <20230328142618.294176884@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit 9c88ea00fef03031ce6554531e89be82f6a42835 ]

Prior to commit 8786fde8421c ("Convert NFS from readpages to
readahead"), nfs_readpages() used the old mm interface read_cache_pages()
which called task_io_account_read() for each NFS page read.  After
this commit, nfs_readpages() is converted to nfs_readahead(), which
now uses the new mm interface readahead_page().  The new interface
requires callers to call task_io_account_read() themselves.
In addition, to nfs_readahead() task_io_account_read() should also
be called from nfs_read_folio().

Fixes: 8786fde8421c ("Convert NFS from readpages to readahead")
Link: https://lore.kernel.org/linux-nfs/CAPt2mGNEYUk5u8V4abe=5MM5msZqmvzCVrtCP4Qw1n=gCHCnww@mail.gmail.com/
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/read.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 8ae2c8d1219d8..cd970ce62786b 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -15,6 +15,7 @@
 #include <linux/stat.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/pagemap.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs_fs.h>
@@ -338,6 +339,7 @@ int nfs_read_folio(struct file *file, struct folio *folio)
 
 	trace_nfs_aop_readpage(inode, page);
 	nfs_inc_stats(inode, NFSIOS_VFSREADPAGE);
+	task_io_account_read(folio_size(folio));
 
 	/*
 	 * Try to flush any pending writes to the file..
@@ -400,6 +402,7 @@ void nfs_readahead(struct readahead_control *ractl)
 
 	trace_nfs_aop_readahead(inode, readahead_pos(ractl), nr_pages);
 	nfs_inc_stats(inode, NFSIOS_VFSREADPAGES);
+	task_io_account_read(readahead_length(ractl));
 
 	ret = -ESTALE;
 	if (NFS_STALE(inode))
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26263009F1;
	Tue, 11 Nov 2025 01:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823830; cv=none; b=VXmQ+zTSuW2ZGcm5qpgz/z1371ptI5XIMCkWq1eJIQqExZieo/vGqOnKZMNsqr6z6/PEiTQbchtaurqirOkgqsKedXZ585nRXXxB9fo0QybpP9lFjnG4Z68V4nXDlgfBuoHw35XfLrsD7bY4Qe1JfoMBe1Ui8Yq2OHHFZnzx2kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823830; c=relaxed/simple;
	bh=CS4rX3wcZGOFx1ufKSEKCwo81pjup1mMFCau+aKlgqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mrv9IJwKYSMfOvysTJQiEf2uzln/S/4VWwgvKO3OtEBRAIxBokVDpSaOByjggiCWFIQSFFMvTR+a8i9pHLlF1L05QNGMhRIGLfzjUIU9D/FvDVRESVcUZahQg1UjVgM18TQUu58ueSPWYCMdjySQNW6ZNVegggA9+hli0B3LzWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfDL5uE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfDL5uE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35806C4CEFB;
	Tue, 11 Nov 2025 01:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823830;
	bh=CS4rX3wcZGOFx1ufKSEKCwo81pjup1mMFCau+aKlgqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfDL5uE2FqtKQpCGXdDE7oSL5Wlrigjv0BmQvCCQuOEn3f2I2mmcKTypAeL/W1raN
	 9VwvwTgBlvwGqivaqBUEyRBX07f8PTL+Efgs1mdkEHI1/iXpkc93d+eFaE70qRCzpN
	 k501JgwD4JQxkjnrmrh1UmQ9k1YXNRwsxPH3/8yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Li RongQing <lirongqing@baidu.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 367/849] virtio_fs: fix the hash table using in virtio_fs_enqueue_req()
Date: Tue, 11 Nov 2025 09:38:57 +0900
Message-ID: <20251111004545.295468523@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 7dbe6442487743ad492d9143f1f404c1f4a05e0e ]

The original commit be2ff42c5d6e ("fuse: Use hash table to link
processing request") converted fuse_pqueue->processing to a hash table,
but virtio_fs_enqueue_req() was not updated to use it correctly.
So use fuse_pqueue->processing as a hash table, this make the code
more coherent

Co-developed-by: Fushuai Wang <wangfushuai@baidu.com>
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c       | 1 +
 fs/fuse/virtio_fs.c | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index dbf53c7bc8535..612d4da6d7d91 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -322,6 +322,7 @@ unsigned int fuse_req_hash(u64 unique)
 {
 	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
 }
+EXPORT_SYMBOL_GPL(fuse_req_hash);
 
 /*
  * A new request is available, wake fiq->waitq
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 76c8fd0bfc75d..1751cd6e3d42b 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -20,6 +20,7 @@
 #include <linux/cleanup.h>
 #include <linux/uio.h>
 #include "fuse_i.h"
+#include "fuse_dev_i.h"
 
 /* Used to help calculate the FUSE connection's max_pages limit for a request's
  * size. Parts of the struct fuse_req are sliced into scattergather lists in
@@ -1384,7 +1385,7 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 	unsigned int out_sgs = 0;
 	unsigned int in_sgs = 0;
 	unsigned int total_sgs;
-	unsigned int i;
+	unsigned int i, hash;
 	int ret;
 	bool notify;
 	struct fuse_pqueue *fpq;
@@ -1444,8 +1445,9 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 
 	/* Request successfully sent. */
 	fpq = &fsvq->fud->pq;
+	hash = fuse_req_hash(req->in.h.unique);
 	spin_lock(&fpq->lock);
-	list_add_tail(&req->list, fpq->processing);
+	list_add_tail(&req->list, &fpq->processing[hash]);
 	spin_unlock(&fpq->lock);
 	set_bit(FR_SENT, &req->flags);
 	/* matches barrier in request_wait_answer() */
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49B8450903;
	Tue, 16 Jun 2026 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625671; cv=none; b=bfNMzYsY4XFk1eJMOBSE8nfoxMWhXUlAkeT5nZVl6tyLI0Nx3bIerWCNC6X4XaESv7sD8LcXX+Kt+35ioclVPrTXQoE2gcSyMZnKNWzPliqAzNyh1KNXAb/ljXtXAVdEva4DHM1vTmEm1g/ytEvS3xeH4JiRrmQk49ZJhVNSrrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625671; c=relaxed/simple;
	bh=FbjcDn89c+whkO9SZxwgPCWn00eFBiqrld9nuygacZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTTcEA+UPRH9rnc/KjAA09C5AkLlIV8A4SbmwGmcRy/DlB1NmmFbOaV+5jfDO7MJQrbO9GUyTJXw2vM2n2UwGicG0f5E9NAtldZ6fRs4oD4uKdvovV4uh4V6zMCAum4DmZQwndgFmCDXaXzw7RD0GQ2nHf6xsKnFcO0JEhKrfGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMsXJnZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMsXJnZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF841F000E9;
	Tue, 16 Jun 2026 16:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625670;
	bh=OCIilYG5pyMhp5DF3uGU4ZWPssHWV08GHxulIHuw2Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMsXJnZm3vfeTbFRVaUXnLmLMsUB8gMQ3zobsDk9NbY6t3S3HOS0bAcukcfVMMM2z
	 wMORYhbdZPlLTOoPuJa+SQA6MaDy2kYMEXYKSkTfHLryzxdtthdwEvlDTRi0vIg5Hz
	 zM8xePhdqCL1qdvix+kaWFUK8KEljXWGoWKuTunY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 186/325] RDMA/core: Validate the passed in fops for ib_get_ucaps()
Date: Tue, 16 Jun 2026 20:29:42 +0530
Message-ID: <20260616145107.162325575@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 4a1b1ac2744694a2ecd66a84bdb1445f4ef24bee upstream.

Sashiko pointed out it is not safe to rely only on the devt because
char/block alias so if the user finds a block device with the same dev_t
it can masquerade as a ucap cdev fd.

Test the f_ops to only accept authentic cdevs.

Link: https://patch.msgid.link/r/0-v1-fd9482545e37+1e25-ib_ucaps_fd_ops_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: 61e51682816d ("RDMA/uverbs: Introduce UCAP (User CAPabilities) API")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/ucaps.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/ucaps.c b/drivers/infiniband/core/ucaps.c
index 948093260dbd..5155ff0e538e 100644
--- a/drivers/infiniband/core/ucaps.c
+++ b/drivers/infiniband/core/ucaps.c
@@ -82,14 +82,12 @@ static int get_ucap_from_devt(dev_t devt, u64 *idx_mask)
 
 static int get_devt_from_fd(unsigned int fd, dev_t *ret_dev)
 {
-	struct file *file;
+	CLASS(fd, f)(fd);
 
-	file = fget(fd);
-	if (!file)
+	if (fd_empty(f) || fd_file(f)->f_op != &ucaps_cdev_fops)
 		return -EBADF;
 
-	*ret_dev = file_inode(file)->i_rdev;
-	fput(file);
+	*ret_dev = file_inode(fd_file(f))->i_rdev;
 	return 0;
 }
 
-- 
2.54.0




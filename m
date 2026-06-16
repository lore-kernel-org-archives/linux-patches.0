Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CBD3A257E;
	Tue, 16 Jun 2026 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623813; cv=none; b=Se0KwwKvh9i+6fo1sLl2LusKNWQqOPIn07sCaHleIovAzEnoxio/dvO2EECo1S++o1EKe+7MgzEsuUv4fppUP//XmtcoN3tqWxVaE3TX12cKSxWU7imhP96AY+obXBo9HMkdTxCoWrLwDONlRdxmbUzADqX7fuw7NX7IFvRmlX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623813; c=relaxed/simple;
	bh=XX+0FLbl/WaDT132FNtQreHCpJHseZPnN+OZKpdWOlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrgxpHiCAkEyR3+A14vymeVvVd5WMTETMdIbmYqo54i88bDYDQ001n6Id8ZQ+0vvkG+ODD2IwUS8Ti1Paiin/stw75llZsm/NuYGo+arefaPMKiwy+kfdtgptd53l28A/kAOkTFe4R2qKBV8sD/K/M19K//IhtX5aPNlRnl3cBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWMC1zHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWMC1zHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C131F000E9;
	Tue, 16 Jun 2026 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623812;
	bh=xJITHwvOx0HgOLEkzPQIgGgeCTpAgm3Xbwa3g+zexPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FWMC1zHDjCJ9pZwH4wBnnz+zbmz3kj33k3j2eByImhsh1tNBJkArPYX+vzn8B1XOM
	 H/UqmdunvrnLcjg/0H2ExjZDkcTmZqoa/aCUsSJgtOAQBUZmo5wHilZRhrwotVs7EY
	 QmWA2FzNP+wAIgJpkz+SbP+rKqNuehcactrwZRnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 221/378] RDMA/core: Validate the passed in fops for ib_get_ucaps()
Date: Tue, 16 Jun 2026 20:27:32 +0530
Message-ID: <20260616145121.945134562@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/infiniband/core/ucaps.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/core/ucaps.c
+++ b/drivers/infiniband/core/ucaps.c
@@ -82,14 +82,12 @@ static int get_ucap_from_devt(dev_t devt
 
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
 



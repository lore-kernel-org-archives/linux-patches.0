Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D5E3A16AA;
	Sat, 12 Sep 2026 19:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240340; cv=none; b=awA1IqTr4ri7bsPiUyVsjro6QNFrFzBWknZ4R+iDNyV/IAYYgNTflnP7nPARofktD6mzd90CzdBQqgDL/Ib2YC31iqDirDZdxfWa9KhqDYZKOrPrhp2sy6kjGJ77i+21C81nIMT1wv8vJxRBgDGorLTnkwIC08/Lx68/VuPIj8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240340; c=relaxed/simple;
	bh=BU8JbVHktovhZLoEnI92kxosMHmSEHeWYZhNbR6HUu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M670QJL6rM/PiBXsIs+fCv1sc5HOQTfydzmO+ykkm97dFSMRHjfvKrluHQdDK3hChF/PexuqtRLEfQW+o3KX6RGuwSGkXwY/DMooiZ1vH8vwhgHC+vvy1w1X52Aq4/ljYAxSKNxCpr5ZAO1mbBgglImT1tZCztpBdeR97aOSYuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jP3ku+hO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jP3ku+hO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF6D1F000FF;
	Sat, 12 Sep 2026 19:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240339;
	bh=fQV3dj+2tD9PtD4jclvuvU4zMjteO4Y5otJ165ywX/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jP3ku+hOHgYyKvhhWS3It4T3e/giH2eSJTrj85PD2fV0eg0cEiMHvRUADOaeDnhuI
	 6Iv2KRVN5f7VacrCM7OziR67yPdrPtYG0ijOfrTRsuKAC584Qviewypd62X5R6Sf4B
	 Awiox/wax4cGMmm9D9zayyG7ktIeR/3OfJV/ppvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 847/935] cuse: wait for pending RCU callbacks on module exit
Date: Sat, 12 Sep 2026 09:04:37 +0200
Message-ID: <20260912065546.255566127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit 4deb3edead0c0e172cc7349e8855d741d3c5e162 ]

Since commit 053fc4f755ad ("fuse: fix UAF in rcu pathwalks"),
fuse_conn_put() frees the fuse_conn through call_rcu() rather than
synchronously.  For cuse, fc->release is cuse_fc_release(), which
lives in the cuse module.  If the module is removed before the RCU
grace period ends, the callback jumps into freed module memory:

      userspace / module unload      |        RCU softirq
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 close(/dev/cuse)                    |
  cuse_channel_release()             |
   fuse_dev_release()                |
    fuse_conn_put(fch->conn)         |
     call_rcu(delayed_release) ------+---> callback queued
                                     |
 rmmod cuse                          |
  cuse_exit()                        |
   cuse_channel_destroy()            |
   ...                               |
   return                            |
                                     |
 <module text freed>                 |
                                     |  rcu_do_batch()
                                     |   delayed_release()
                                     |    fc->release()
                                     |     -> cuse_fc_release()
                                     |        ^^^ freed text!

The freed module text is unmapped by vfree(), so the jump into the
stale callback triggers a page-fault Oops.  If the virtual address
is subsequently reused, the callback could execute unrelated code
(undefined behaviour).

Fix this by calling rcu_barrier() in cuse_exit() so that any pending
fuse_conn release callback completes before the module is removed.

Fixes: 053fc4f755ad ("fuse: fix UAF in rcu pathwalks")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/cuse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index d10d58c730dd2..698a69eced17b 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -646,6 +646,11 @@ static void __exit cuse_exit(void)
 {
 	misc_deregister(&cuse_miscdev);
 	class_destroy(cuse_class);
+	/*
+	 * Wait for pending call_rcu() callbacks that call back into
+	 * this module via fc->release (cuse_fc_release).
+	 */
+	rcu_barrier();
 }
 
 module_init(cuse_init);
-- 
2.53.0




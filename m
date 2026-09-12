Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F36CA6F;
	Sat, 12 Sep 2026 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225948; cv=none; b=p68f8tMD5srX7jYkvRgcMu5HtD7vfUCkCleLwB2VKk5v0RK4+dM6cqUDciEAFu94omH7gdfnC4S2p1wL+GoTZYogo6E7KuMBSgIC7d18C80GPMmzfNcjB6JX97/12+qFKKjdcrUZ8vP4fRSfn/pHVzArGfdXk86QQukmFhAmKrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225948; c=relaxed/simple;
	bh=NYVxDLKZbPCU0XLng9UR9Zi5/Twcf6129Zd/vXNiQaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFYXZzSj2fzlnO1Tf9Zq6jspySZfb0iiP/eOF2CyFewMszQKeskKLjtrjgOz8Gdx9KhaWHAk+SXMbGPj6ovJxuZSa5QItugcOfGjVX/oqMPZrTS4gNsqZLUoPV4cExt6JgOPwb2RTN0EXekXUK//Hwve2SYYBxQjtfkyH9RLFco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4AYK6Zv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4AYK6Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546FF1F000FF;
	Sat, 12 Sep 2026 15:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225947;
	bh=grdDlmGRwE4cn4zVpsifq548dYDBGdmqBqiO1X5LmaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4AYK6ZvTvBqbpebrCMLpO8f0H5wXOHdcdtqaFc8Us7mG0pKLP+btmio0vUTaK4HI
	 4r7f2auFeeGOCY2xbMkSiTCUUSwcRCkvq4QU5ITUO8V0nVDaIbu+J/ijlndkC6tSv4
	 RPAmxOmlxa6fYDIrEXbJgVDyRQBDUWG2juGBqHy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1275/1424] cuse: wait for pending RCU callbacks on module exit
Date: Sat, 12 Sep 2026 09:01:47 +0200
Message-ID: <20260912065635.830351121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e4d809e2d68d3..5fb9fc6b51736 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -643,6 +643,11 @@ static void __exit cuse_exit(void)
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




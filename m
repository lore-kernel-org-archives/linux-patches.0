Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C3B47277D;
	Sat, 12 Sep 2026 13:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218908; cv=none; b=X2FUVPwGEfG1wS/M5GWJ8dAUOn1AYGxzjFl3IqfgyNteu8Sva3/FnfGg41bVYZKu42savhfvb5ieusXMH1B17HIYULrYAatpE+DxlqmaboyjkCQRDZSwyw3Fiep/IOGN2j4cjV022mGSQIMX44e34Sin175uuCwlYK/VFuzxytA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218908; c=relaxed/simple;
	bh=wMMNfxukcWhkv06Xn3QPj7/eqEbtCWO8DlcX78lehh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9rQfTNV3wPDiJwHdFr40RDkpKGRvpuueA7MQwdZSLgVi4P3HZrqiq+bby+m/BXGuHN5cgsbG+CA4yVLNawMkr5HldTGBpCH6lalaUueDklKEAxHeUAxtaciDFLW/f7Ws26bn4219CBtt977B/IECzSjKkt+2IEMzCAi4y/hF78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSB2rUnL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSB2rUnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EA71F00893;
	Sat, 12 Sep 2026 13:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218906;
	bh=U0LmpTt6KUHoK8671rjALsoX+KVZ32bYgJcA7nmWOXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSB2rUnLEjZz6x9xAMARdltLeIIQUwgGZw0wlT0WlxjviEVLlIHE5KPyvZpFqtcVl
	 TGhVnkYS5vE5ztIcwZmkr6c8dPXin9jYADIxfsrR4BwRbkFfegWbpn2oSE9noeqaBr
	 3iAPpukAVFOe6mbSTpaQY05gTgmuJqGJ/vApdyFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1205/1376] cuse: wait for pending RCU callbacks on module exit
Date: Sat, 12 Sep 2026 09:00:31 +0200
Message-ID: <20260912065634.405880088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 22e82dae6c6bb..47c8e17cc0286 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -647,6 +647,11 @@ static void __exit cuse_exit(void)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAED3AFD15;
	Sat, 12 Sep 2026 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204280; cv=none; b=Wo0z1OAcsSE6xTXZuve/SpsDa4CZ0FeYdW1F883QVivxea25PpaPy/yCEQEE80piEJHOu21JQgP/T5NofpIiUrsLuaxPyI/Tivywe8jvkruWxceq/Y/wGKM5yF7L0jmjABn6zxxxLlZibUHm8e+CYIk/kqqGTGG4ljd8V8obYtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204280; c=relaxed/simple;
	bh=XT1jfICxPKPva5loo3ArfGeNBE8jHtF8LtPFA3beSuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6v5PMA2UhQNRHTM8nPQG6Q9M4jfZ0Gqh4AV+ybvCupgbRXb2LnmvPQCipVKv/P+Vypp8ax5hrLhYKpPBdT+DW/DsnJvQuYY3j/Z8JIL3OelSja59hvATr/2xy2lkAhQ8l4M8KElSHHws3WdRL9w4qNzn0SsWz9nUhM+NaqXcKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHhZKETR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHhZKETR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4A21F000FF;
	Sat, 12 Sep 2026 09:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204279;
	bh=WV/FL2/c0xxITSFFnOY8+1bnHAo+DLvlTEA4QElbzuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHhZKETRVENpl3CsDX0w1cs7e/2LEMkvQeZj59zLT/rPBkvw0X4aneJaCJ8+TI/dF
	 S5iN5+6Yv7nQaDOxZBFUsT9zWO7uA9sl/jsvNknEv2/qL4Klr8pJJSTztNy+sFyIrA
	 1q/r466Oh7xcZt6mR8hIg1IG8OePgMoWPn3Y+uxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1580/1815] cuse: wait for pending RCU callbacks on module exit
Date: Sat, 12 Sep 2026 08:55:30 +0200
Message-ID: <20260912065726.081054361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3c15b5ba16d71..1c71783ca5a51 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -653,6 +653,11 @@ static void __exit cuse_exit(void)
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




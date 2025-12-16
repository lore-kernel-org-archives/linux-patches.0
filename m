Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82033341069;
	Tue, 16 Dec 2025 11:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884207; cv=none; b=NZQtYoyhZ+VMsWjw7c5CjUvSljqkTqexe6+bKB9n25B/R34ypd9OD0kLoEkQJMNpMVOycHO8ILTtzp0v+FfT4YxgIOtY06XV1i7cDT3i3uplbAOBym0I7c62IH0VPZsHnNn82wF3PvjH/LK0qGZ0VTbafmVZ5LMECO30p1cRkn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884207; c=relaxed/simple;
	bh=PmM3iqOXKN4teNDl7NhzOs8MX5zKLl9W0fxZJchmRBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEslG2hD+48en/zeszNkuCFztySF1oFaTgT9zMqUkNTw6gIxojovSGAqWWf5Wq5L8Oy/6msr/uT+ukB7SndpVLK/15+nWvynMF58PXWLl2/+dIg+8oRk3ig/WWMBVApjYN4VjK8+SUhwZfwMpASq5K5Y5s3qKPsEKG7mLaHppoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpxwWgSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpxwWgSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FECEC4CEF1;
	Tue, 16 Dec 2025 11:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884207;
	bh=PmM3iqOXKN4teNDl7NhzOs8MX5zKLl9W0fxZJchmRBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpxwWgSWrI03vCe6yY7gITgCak9KlW5HfTFMvCXDcWAmYYDKY1DJLJDXpzsi6k+8G
	 l1107GsaImOW8z6UcKmt8ZXZ6qSmgV+9RNP+ui7BWcizj01GvAs2NrtFI2QMh9TBPi
	 6IvY7WC0+OKAqKIrTGDshLd3WVTEsms8NMJKuiqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Wang Liang <wangliang74@huawei.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/354] locktorture: Fix memory leak in param_set_cpumask()
Date: Tue, 16 Dec 2025 12:11:31 +0100
Message-ID: <20251216111325.415644464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit e52b43883d084a9af263c573f2a1bd1ca5088389 ]

With CONFIG_CPUMASK_OFFSTACK=y, the 'bind_writers' buffer is allocated via
alloc_cpumask_var() in param_set_cpumask(). But it is not freed, when
setting the module parameter multiple times by sysfs interface or removing
module.

Below kmemleak trace is seen for this issue:

unreferenced object 0xffff888100aabff8 (size 8):
  comm "bash", pid 323, jiffies 4295059233
  hex dump (first 8 bytes):
    07 00 00 00 00 00 00 00                          ........
  backtrace (crc ac50919):
    __kmalloc_node_noprof+0x2e5/0x420
    alloc_cpumask_var_node+0x1f/0x30
    param_set_cpumask+0x26/0xb0 [locktorture]
    param_attr_store+0x93/0x100
    module_attr_store+0x1b/0x30
    kernfs_fop_write_iter+0x114/0x1b0
    vfs_write+0x300/0x410
    ksys_write+0x60/0xd0
    do_syscall_64+0xa4/0x260
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

This issue can be reproduced by:
  insmod locktorture.ko bind_writers=1
  rmmod locktorture

or:
  insmod locktorture.ko bind_writers=1
  echo 2 > /sys/module/locktorture/parameters/bind_writers

Considering that setting the module parameter 'bind_writers' or
'bind_readers' by sysfs interface has no real effect, set the parameter
permissions to 0444. To fix the memory leak when removing module, free
'bind_writers' and 'bind_readers' memory in lock_torture_cleanup().

Fixes: 73e341242483 ("locktorture: Add readers_bind and writers_bind module parameters")
Suggested-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/locktorture.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index de95ec07e4771..4a7fa0b74d52d 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -103,8 +103,8 @@ static const struct kernel_param_ops lt_bind_ops = {
 	.get = param_get_cpumask,
 };
 
-module_param_cb(bind_readers, &lt_bind_ops, &bind_readers, 0644);
-module_param_cb(bind_writers, &lt_bind_ops, &bind_writers, 0644);
+module_param_cb(bind_readers, &lt_bind_ops, &bind_readers, 0444);
+module_param_cb(bind_writers, &lt_bind_ops, &bind_writers, 0444);
 
 long torture_sched_setaffinity(pid_t pid, const struct cpumask *in_mask);
 
@@ -1157,6 +1157,10 @@ static void lock_torture_cleanup(void)
 			cxt.cur_ops->exit();
 		cxt.init_called = false;
 	}
+
+	free_cpumask_var(bind_readers);
+	free_cpumask_var(bind_writers);
+
 	torture_cleanup_end();
 }
 
-- 
2.51.0




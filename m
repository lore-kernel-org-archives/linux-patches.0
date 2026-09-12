Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E12D352003;
	Sat, 12 Sep 2026 09:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203797; cv=none; b=qAO0462obQ0QCNU45XVwyPXcoPC0OhGat5Yf0kzLILEn71/M8I+3GT3b157fKmXHvRX0dnIAu/n4gbOMDpYFOHoV0BgE0kwRWKIwSVTTwxY8nLrtzBsSHnXvAPVDDuVxlboUqAhsUBqKvKqi05MT2WN3srYUJ7B+SIx8WTSFyl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203797; c=relaxed/simple;
	bh=9yvBMLxOPZp+KzFEy1eGNh0R8Ih2gQB2WdS4wyonwj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CayuUna2hkOWzb6XzmE3vzupPtyBw6UXe2jIgzi3ErTHG3RW5JyaFr7mQAZEFCvB6c0uZKUybxG8hKZVQnnF/y4tvhmHwbEyqCFRIkf2rKN0Mm2JLkLcQIpOX2UAuBWHferjrBnuZ7bu7xm0XyuPes4j2r+KMIxPdPsRywmArm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2XUfZSM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2XUfZSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22421F000FF;
	Sat, 12 Sep 2026 09:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203796;
	bh=pzjWPlq4vdHQ0+Pq3EsNldfBI3owER0a6X42GG3VBqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2XUfZSMD9nph9CbEXM/dgcbBQkNMmwk7a5b+8DsdoceUHKQ3468iwlj+HsE62YKP
	 zg87QoBVLRLQ1QrM9Xc9IOj7OYWsvPgNUXxLFjaCrP1ZJlQJHosfugq6kyz3a6xYye
	 46O8vYkItQ8tchOWty1Frk041JNed+n6gHg5kq2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Zizhi Wo <wozizhi@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1481/1815] null_blk: use DEFINE_MUTEX for the file-scope mutex
Date: Sat, 12 Sep 2026 08:53:51 +0200
Message-ID: <20260912065723.774858300@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 017dac7670909eaea3eb36e6b3b5a8be9ce0a14d ]

In null_init(), mutex_init(&lock) currently happens after
configfs_register_subsystem(), which exposes the nullb subsystem to
userspace. A racing mkdir() into /sys/kernel/config/nullb/ can reach
null_find_dev_by_name() -> mutex_lock(&lock) before the mutex is
initialized, trigger warning:

[  123.137788] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[  123.137796] WARNING: kernel/locking/mutex.c:159 at mutex_lock+0x171/0x1c0, CPU#13: mkdir/1301
[  123.140090] Modules linked in: null_blk(+) nft_fib_inet nft_fib_ipv4
......
[  123.154926] Call Trace:
[  123.155172]  <TASK>
[  123.155419]  ? __pfx_mutex_lock+0x10/0x10
[  123.156181]  ? __pfx__raw_spin_lock+0x10/0x10
[  123.156571]  nullb_group_make_group+0x20/0x100 [null_blk]
[  123.157011]  configfs_mkdir+0x47b/0xc70
[  123.157337]  ? __pfx_configfs_mkdir+0x10/0x10
[  123.157719]  ? may_create_dentry+0x242/0x2e0
[  123.158061]  vfs_mkdir+0x2a9/0x6c0
[  123.158352]  filename_mkdirat+0x3dc/0x500
[  123.158710]  ? __pfx_filename_mkdirat+0x10/0x10
[  123.159070]  ? strncpy_from_user+0x3a/0x1d0
[  123.159413]  __x64_sys_mkdir+0x6b/0x90
[  123.159760]  do_syscall_64+0xea/0x600

Replace the runtime mutex_init(&lock) with a static DEFINE_MUTEX(lock)
declaration to fix this issue.

Fixes: 49c3b9266a71 ("block: null_blk: Improve device creation with configfs")
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260725022509.714271-2-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index f8c0fd57e041a..eba204b277854 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -66,7 +66,7 @@ struct nullb_page {
 #define NULLB_PAGE_FREE (MAP_SZ - 2)
 
 static LIST_HEAD(nullb_list);
-static struct mutex lock;
+static DEFINE_MUTEX(lock);
 static int null_major;
 static DEFINE_IDA(nullb_indexes);
 static struct blk_mq_tag_set tag_set;
@@ -2166,8 +2166,6 @@ static int __init null_init(void)
 	if (ret)
 		return ret;
 
-	mutex_init(&lock);
-
 	null_major = register_blkdev(0, "nullb");
 	if (null_major < 0) {
 		ret = null_major;
-- 
2.53.0




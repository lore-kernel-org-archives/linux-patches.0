Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1626415099C;
	Tue, 23 Jul 2024 13:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721742840; cv=none; b=iaiXiS88E4eF2o5hmN0Z9SKNoyt2s/RJhzabQis7ENJ9X6l4UQNfTqGL8+akjO0voldSLVSvrKJpnR98m6MWpnrtGdWkQ9LDdFm5yFeJzy4mgDs01ubnD6gEW2fPNhfgUbLTinzwqwApter7oCjEPtUWsuwC9Fou3LYPhe5iGoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721742840; c=relaxed/simple;
	bh=w2WOkqaIUx/iLwetBt6PIEtFhl0dFxPJy5xWULP5ZiQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=F6JrKpKc9YmsGCCj4WPMgb87l2JSG9nV5Syw98GBnok32rtk5+6dV0A7ntnW2Az657wmrLoRlAJd45T2+q1vE1LREltxmGYEQLA+aII+UhZrswWxlzY+KR3c6GOvzwyNW2Dmx9xrXXnGHjXCYgslOUskeOIELV8I6JCN0R8CD04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPrITiDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPrITiDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA09C4AF09;
	Tue, 23 Jul 2024 13:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721742839;
	bh=w2WOkqaIUx/iLwetBt6PIEtFhl0dFxPJy5xWULP5ZiQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=JPrITiDJVsnV01nOm0AZCazCRjHSOGtqwskqmy2zBhMmoAjzQEsnlYaJX06bImEFY
	 IZbuMv/FrIgF4sFzJu3ZzEaXsjtBaKYq3lqP6e460A5Y3Xwbw7jGyE7s6b3vXlNdx/
	 CCXZnSIveTqzCfzrGEemjypItVPC/1a4prhLK4XA=
Subject: Patch "cachefiles: fix slab-use-after-free in fscache_withdraw_volume()" has been added to the 6.9-stable tree
To: brauner@kernel.org,gregkh@linuxfoundation.org,hsiangkao@linux.alibaba.com,libaokun1@huawei.com,libaokun@huaweicloud.com,patches@lists.linux.dev,sashal@kernel.org,yangerkun@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 23 Jul 2024 15:53:46 +0200
In-Reply-To: <20240719132812.1542957-2-libaokun@huaweicloud.com>
Message-ID: <2024072346-creature-applied-491d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    cachefiles: fix slab-use-after-free in fscache_withdraw_volume()

to the 6.9-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     cachefiles-fix-slab-use-after-free-in-fscache_withdraw_volume.patch
and it can be found in the queue-6.9 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-60608-greg=kroah.com@vger.kernel.org Fri Jul 19 15:31:17 2024
From: libaokun@huaweicloud.com
Date: Fri, 19 Jul 2024 21:28:11 +0800
Subject: cachefiles: fix slab-use-after-free in fscache_withdraw_volume()
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, patches@lists.linux.dev, hsiangkao@linux.alibaba.com, yangerkun@huawei.com, libaokun1@huawei.com, Christian Brauner <brauner@kernel.org>
Message-ID: <20240719132812.1542957-2-libaokun@huaweicloud.com>

From: libaokun@huaweicloud.com

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 522018a0de6b6fcce60c04f86dfc5f0e4b6a1b36 ]

We got the following issue in our fault injection stress test:

==================================================================
BUG: KASAN: slab-use-after-free in fscache_withdraw_volume+0x2e1/0x370
Read of size 4 at addr ffff88810680be08 by task ondemand-04-dae/5798

CPU: 0 PID: 5798 Comm: ondemand-04-dae Not tainted 6.8.0-dirty #565
Call Trace:
 kasan_check_range+0xf6/0x1b0
 fscache_withdraw_volume+0x2e1/0x370
 cachefiles_withdraw_volume+0x31/0x50
 cachefiles_withdraw_cache+0x3ad/0x900
 cachefiles_put_unbind_pincount+0x1f6/0x250
 cachefiles_daemon_release+0x13b/0x290
 __fput+0x204/0xa00
 task_work_run+0x139/0x230

Allocated by task 5820:
 __kmalloc+0x1df/0x4b0
 fscache_alloc_volume+0x70/0x600
 __fscache_acquire_volume+0x1c/0x610
 erofs_fscache_register_volume+0x96/0x1a0
 erofs_fscache_register_fs+0x49a/0x690
 erofs_fc_fill_super+0x6c0/0xcc0
 vfs_get_super+0xa9/0x140
 vfs_get_tree+0x8e/0x300
 do_new_mount+0x28c/0x580
 [...]

Freed by task 5820:
 kfree+0xf1/0x2c0
 fscache_put_volume.part.0+0x5cb/0x9e0
 erofs_fscache_unregister_fs+0x157/0x1b0
 erofs_kill_sb+0xd9/0x1c0
 deactivate_locked_super+0xa3/0x100
 vfs_get_super+0x105/0x140
 vfs_get_tree+0x8e/0x300
 do_new_mount+0x28c/0x580
 [...]
==================================================================

Following is the process that triggers the issue:

        mount failed         |         daemon exit
------------------------------------------------------------
 deactivate_locked_super        cachefiles_daemon_release
  erofs_kill_sb
   erofs_fscache_unregister_fs
    fscache_relinquish_volume
     __fscache_relinquish_volume
      fscache_put_volume(fscache_volume, fscache_volume_put_relinquish)
       zero = __refcount_dec_and_test(&fscache_volume->ref, &ref);
                                 cachefiles_put_unbind_pincount
                                  cachefiles_daemon_unbind
                                   cachefiles_withdraw_cache
                                    cachefiles_withdraw_volumes
                                     list_del_init(&volume->cache_link)
       fscache_free_volume(fscache_volume)
        cache->ops->free_volume
         cachefiles_free_volume
          list_del_init(&cachefiles_volume->cache_link);
        kfree(fscache_volume)
                                     cachefiles_withdraw_volume
                                      fscache_withdraw_volume
                                       fscache_volume->n_accesses
                                       // fscache_volume UAF !!!

The fscache_volume in cache->volumes must not have been freed yet, but its
reference count may be 0. So use the new fscache_try_get_volume() helper
function try to get its reference count.

If the reference count of fscache_volume is 0, fscache_put_volume() is
freeing it, so wait for it to be removed from cache->volumes.

If its reference count is not 0, call cachefiles_withdraw_volume() with
reference count protection to avoid the above issue.

Fixes: fe2140e2f57f ("cachefiles: Implement volume support")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-3-libaokun@huaweicloud.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cachefiles/cache.c          |   10 ++++++++++
 include/trace/events/fscache.h |    4 ++++
 2 files changed, 14 insertions(+)

--- a/fs/cachefiles/cache.c
+++ b/fs/cachefiles/cache.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/statfs.h>
 #include <linux/namei.h>
+#include <trace/events/fscache.h>
 #include "internal.h"
 
 /*
@@ -319,12 +320,20 @@ static void cachefiles_withdraw_volumes(
 	_enter("");
 
 	for (;;) {
+		struct fscache_volume *vcookie = NULL;
 		struct cachefiles_volume *volume = NULL;
 
 		spin_lock(&cache->object_list_lock);
 		if (!list_empty(&cache->volumes)) {
 			volume = list_first_entry(&cache->volumes,
 						  struct cachefiles_volume, cache_link);
+			vcookie = fscache_try_get_volume(volume->vcookie,
+							 fscache_volume_get_withdraw);
+			if (!vcookie) {
+				spin_unlock(&cache->object_list_lock);
+				cpu_relax();
+				continue;
+			}
 			list_del_init(&volume->cache_link);
 		}
 		spin_unlock(&cache->object_list_lock);
@@ -332,6 +341,7 @@ static void cachefiles_withdraw_volumes(
 			break;
 
 		cachefiles_withdraw_volume(volume);
+		fscache_put_volume(vcookie, fscache_volume_put_withdraw);
 	}
 
 	_leave("");
--- a/include/trace/events/fscache.h
+++ b/include/trace/events/fscache.h
@@ -35,12 +35,14 @@ enum fscache_volume_trace {
 	fscache_volume_get_cookie,
 	fscache_volume_get_create_work,
 	fscache_volume_get_hash_collision,
+	fscache_volume_get_withdraw,
 	fscache_volume_free,
 	fscache_volume_new_acquire,
 	fscache_volume_put_cookie,
 	fscache_volume_put_create_work,
 	fscache_volume_put_hash_collision,
 	fscache_volume_put_relinquish,
+	fscache_volume_put_withdraw,
 	fscache_volume_see_create_work,
 	fscache_volume_see_hash_wake,
 	fscache_volume_wait_create_work,
@@ -120,12 +122,14 @@ enum fscache_access_trace {
 	EM(fscache_volume_get_cookie,		"GET cook ")		\
 	EM(fscache_volume_get_create_work,	"GET creat")		\
 	EM(fscache_volume_get_hash_collision,	"GET hcoll")		\
+	EM(fscache_volume_get_withdraw,		"GET withd")            \
 	EM(fscache_volume_free,			"FREE     ")		\
 	EM(fscache_volume_new_acquire,		"NEW acq  ")		\
 	EM(fscache_volume_put_cookie,		"PUT cook ")		\
 	EM(fscache_volume_put_create_work,	"PUT creat")		\
 	EM(fscache_volume_put_hash_collision,	"PUT hcoll")		\
 	EM(fscache_volume_put_relinquish,	"PUT relnq")		\
+	EM(fscache_volume_put_withdraw,		"PUT withd")            \
 	EM(fscache_volume_see_create_work,	"SEE creat")		\
 	EM(fscache_volume_see_hash_wake,	"SEE hwake")		\
 	E_(fscache_volume_wait_create_work,	"WAIT crea")


Patches currently in stable-queue which might be from kroah.com@vger.kernel.org are

queue-6.9/cachefiles-fix-slab-use-after-free-in-cachefiles_withdraw_cookie.patch
queue-6.9/cachefiles-fix-slab-use-after-free-in-fscache_withdraw_volume.patch
queue-6.9/netfs-fscache-export-fscache_put_volume-and-add-fscache_try_get_volume.patch

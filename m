Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BA91EE02F;
	Tue, 30 Sep 2025 15:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246215; cv=none; b=hFBKfKYm1VEA0BvSHvm/VdkVZnJ9Hc6KRZ5Q1o6NA/Dr91S2HXFz4/NBMaKob5iULzs4PERxoRdigw84gWgH3liWEW4/fVOBbxTzc76qrxAwiJ9X3MaNay7NkClpH4UdBhnkIvZVMMPkSjHNF0oHeHMvuzWWzoX+wx2glKjowEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246215; c=relaxed/simple;
	bh=NPd5PBVGepgZes8u/6T+CUWPOKI5c/C9ePv95hXUlYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMa+Q/mJxS+9IdkeC2kKMGJDM+LePJSKDHVZuo2zxQ0YuN48wSHO8fY33FUFSdnLVEcMvPBow1NicHfnTIMYOdiV/WeyvT5o8W4z6YYAlQ9gOAQqJeTY9ULd2te+HTwX+57923CO+Ck6BMpxSxflC0/Bnl4i9XA0yXAePGpkGco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9p8ve+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9p8ve+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B12C4CEF0;
	Tue, 30 Sep 2025 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246215;
	bh=NPd5PBVGepgZes8u/6T+CUWPOKI5c/C9ePv95hXUlYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9p8ve+Kkymik67q/TolXYIzMlP7sD4ctmC6GB5fqmhJo/X1yuj1NoidX5od/DASV
	 G6PnegTsywH2Er0VTukBZ79ExAnCZ3s/eqFb+YjqZsrbP9XBB7VmCEt3NB+qJ5wNH7
	 A01RXIvWdOvrdlpk6w+PBkVwPRY0/kF7a4kM8Yfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	syzbot+80620e2d0d0a33b09f93@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 88/89] iommufd: Fix race during abort for file descriptors
Date: Tue, 30 Sep 2025 16:48:42 +0200
Message-ID: <20250930143825.535612772@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 4e034bf045b12852a24d5d33f2451850818ba0c1 ]

fput() doesn't actually call file_operations release() synchronously, it
puts the file on a work queue and it will be released eventually.

This is normally fine, except for iommufd the file and the iommufd_object
are tied to gether. The file has the object as it's private_data and holds
a users refcount, while the object is expected to remain alive as long as
the file is.

When the allocation of a new object aborts before installing the file it
will fput() the file and then go on to immediately kfree() the obj. This
causes a UAF once the workqueue completes the fput() and tries to
decrement the users refcount.

Fix this by putting the core code in charge of the file lifetime, and call
__fput_sync() during abort to ensure that release() is called before
kfree. __fput_sync() is a bit too tricky to open code in all the object
implementations. Instead the objects tell the core code where the file
pointer is and the core will take care of the life cycle.

If the object is successfully allocated then the file will hold a users
refcount and the iommufd_object cannot be destroyed.

It is worth noting that close(); ioctl(IOMMU_DESTROY); doesn't have an
issue because close() is already using a synchronous version of fput().

The UAF looks like this:

    BUG: KASAN: slab-use-after-free in iommufd_eventq_fops_release+0x45/0xc0 drivers/iommu/iommufd/eventq.c:376
    Write of size 4 at addr ffff888059c97804 by task syz.0.46/6164

    CPU: 0 UID: 0 PID: 6164 Comm: syz.0.46 Not tainted syzkaller #0 PREEMPT(full)
    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
    Call Trace:
     <TASK>
     __dump_stack lib/dump_stack.c:94 [inline]
     dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
     print_address_description mm/kasan/report.c:378 [inline]
     print_report+0xcd/0x630 mm/kasan/report.c:482
     kasan_report+0xe0/0x110 mm/kasan/report.c:595
     check_region_inline mm/kasan/generic.c:183 [inline]
     kasan_check_range+0x100/0x1b0 mm/kasan/generic.c:189
     instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
     atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:400 [inline]
     __refcount_dec include/linux/refcount.h:455 [inline]
     refcount_dec include/linux/refcount.h:476 [inline]
     iommufd_eventq_fops_release+0x45/0xc0 drivers/iommu/iommufd/eventq.c:376
     __fput+0x402/0xb70 fs/file_table.c:468
     task_work_run+0x14d/0x240 kernel/task_work.c:227
     resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
     exit_to_user_mode_loop+0xeb/0x110 kernel/entry/common.c:43
     exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
     syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
     syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
     do_syscall_64+0x41c/0x4c0 arch/x86/entry/syscall_64.c:100
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://patch.msgid.link/r/1-v1-02cd136829df+31-iommufd_syz_fput_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nirmoy Das <nirmoyd@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reported-by: syzbot+80620e2d0d0a33b09f93@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/68c8583d.050a0220.2ff435.03a2.GAE@google.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ applied eventq.c changes to fault.c, drop veventq bits ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/fault.c |    4 +---
 drivers/iommu/iommufd/main.c  |   34 +++++++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 6 deletions(-)

--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -415,7 +415,7 @@ int iommufd_fault_alloc(struct iommufd_u
 	fdno = get_unused_fd_flags(O_CLOEXEC);
 	if (fdno < 0) {
 		rc = fdno;
-		goto out_fput;
+		goto out_abort;
 	}
 
 	cmd->out_fault_id = fault->obj.id;
@@ -431,8 +431,6 @@ int iommufd_fault_alloc(struct iommufd_u
 	return 0;
 out_put_fdno:
 	put_unused_fd(fdno);
-out_fput:
-	fput(filep);
 out_abort:
 	iommufd_object_abort_and_destroy(ucmd->ictx, &fault->obj);
 
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -23,6 +23,7 @@
 #include "iommufd_test.h"
 
 struct iommufd_object_ops {
+	size_t file_offset;
 	void (*destroy)(struct iommufd_object *obj);
 	void (*abort)(struct iommufd_object *obj);
 };
@@ -97,10 +98,30 @@ void iommufd_object_abort(struct iommufd
 void iommufd_object_abort_and_destroy(struct iommufd_ctx *ictx,
 				      struct iommufd_object *obj)
 {
-	if (iommufd_object_ops[obj->type].abort)
-		iommufd_object_ops[obj->type].abort(obj);
+	const struct iommufd_object_ops *ops = &iommufd_object_ops[obj->type];
+
+	if (ops->file_offset) {
+		struct file **filep = ((void *)obj) + ops->file_offset;
+
+		/*
+		 * A file should hold a users refcount while the file is open
+		 * and put it back in its release. The file should hold a
+		 * pointer to obj in their private data. Normal fput() is
+		 * deferred to a workqueue and can get out of order with the
+		 * following kfree(obj). Using the sync version ensures the
+		 * release happens immediately. During abort we require the file
+		 * refcount is one at this point - meaning the object alloc
+		 * function cannot do anything to allow another thread to take a
+		 * refcount prior to a guaranteed success.
+		 */
+		if (*filep)
+			__fput_sync(*filep);
+	}
+
+	if (ops->abort)
+		ops->abort(obj);
 	else
-		iommufd_object_ops[obj->type].destroy(obj);
+		ops->destroy(obj);
 	iommufd_object_abort(ictx, obj);
 }
 
@@ -498,6 +519,12 @@ void iommufd_ctx_put(struct iommufd_ctx
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_ctx_put, IOMMUFD);
 
+#define IOMMUFD_FILE_OFFSET(_struct, _filep, _obj)                           \
+	.file_offset = (offsetof(_struct, _filep) +                          \
+			BUILD_BUG_ON_ZERO(!__same_type(                      \
+				struct file *, ((_struct *)NULL)->_filep)) + \
+			BUILD_BUG_ON_ZERO(offsetof(_struct, _obj)))
+
 static const struct iommufd_object_ops iommufd_object_ops[] = {
 	[IOMMUFD_OBJ_ACCESS] = {
 		.destroy = iommufd_access_destroy_object,
@@ -518,6 +545,7 @@ static const struct iommufd_object_ops i
 	},
 	[IOMMUFD_OBJ_FAULT] = {
 		.destroy = iommufd_fault_destroy,
+		IOMMUFD_FILE_OFFSET(struct iommufd_fault, filep, obj),
 	},
 #ifdef CONFIG_IOMMUFD_TEST
 	[IOMMUFD_OBJ_SELFTEST] = {



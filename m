Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CAD48094F;
	Tue, 25 Aug 2026 13:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664909; cv=none; b=V4DQBRxdntHSUIGZlYXXId68lcvMiEgvlP2E/MJUifous3luWNKTAFy3GH0OVdH6SWkY2witKULXX7AzAgVRmWEREoKoIbhF283DsSXdVrD1lAiziTyl/ABp4L8U+zYcbhPAmSqQyyQ4/3qI/7QSY0f/abPmDoM/CvVWsXQNGKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664909; c=relaxed/simple;
	bh=vfwGG5lK1vVfG1GGiAx5Q5iLusi2E5xIOP7xINIRS4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uebEhGbKuI0KzUvzoCnfAMjQiAlN+1KjXp0GLwNgvhffLd+RUVIUstD2FUy1BZrTNUpAusRyCi2eAIHHLU1GuBX7jwvgOuRDEbkEw/Nv4GC+rUwDVmidAS8wnBn4krfgjYmQcc42CUyA5Sq0qm5fdQkYwK0DwE7PC6kc65scKdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXFSr7cw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXFSr7cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AF71F000E9;
	Tue, 25 Aug 2026 13:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664907;
	bh=mva8VfsBoY3JcC4rxSQk9EK1EXpN3RIQMYstb5OHB1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXFSr7cwv3bvM1obQ8z7GbZnt7IoQOq2BZkRbtzlrAonYhfuk12e76zX+m0GA719s
	 Vv1SvzJTqRMje6pT/Pybm7TPg0XMRHWZohe0EwtyRdt5OIIaNNI2cS3O9orF84u8Cl
	 /QnIkPSm1r0KymEQc2jmzKQLp8UJUwGd8YxLxPuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 008/101] iommu/iommufd: Fix NULL pointer deref in iommufd_ioas_change_process when racing with iopt_map_file_pages
Date: Tue, 25 Aug 2026 15:24:46 +0200
Message-ID: <20260825132542.329350733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit d616de490ec0242dcf78f02f1adf7baa035c4d0d upstream.

iommufd_ioas_change_process() iterates every IOAS area while only
holding every IOAS iova_rwsem, so it assumes every area has a non-NULL
pages pointer. That assumption can be false when it runs concurrently
with iopt_map_file_pages().

iopt_map_pages() executes in two phases. It first creates the area and
inserts it into the interval tree under iova_rwsem, with area->pages
still NULL. It then drops iova_rwsem and later fills area->pages
under domains_rwsem. This leaves a window between area creation and
area->pages fill where a concurrent iommufd_ioas_change_process()
can observe the area and dereference a NULL area->pages pointer,
leading to a NULL pointer dereference:

BUG: kernel NULL pointer dereference, address: 00000000000000c0
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 4b655067 P4D 4b655067 PUD 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 0 UID: 0 PID: 11841 Comm: syz.1.628 Not tainted 7.1.0 #3 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:iommufd_ioas_change_process+0x419/0xd50 drivers/iommu/iommufd/ioas.c:538
Code: 48 89 c3 48 85 c0 0f 84 cc 00 00 00 e8 10 f5 cb fd 48 8d 7b 68 e8 a7 b5 eb fd 48 8b 6b 68 48 8d bd c0 00 00 00 e8 17 b2 eb fd <8b> ad c0 00 00 00 bf 01 00 00 00 89 ee e8 85 ef cb fd 83 fd 01 74
RSP: 0018:ffffc90015c17d28 EFLAGS: 00010246
RAX: ffff8880186d5328 RBX: ffff88801d25e240 RCX: 0000000080000000
RDX: 00000000000002d7 RSI: ffffffff83ba9e10 RDI: 00000000000000c0
RBP: 0000000000000000 R08: ffffffff8e781eb8 R09: 0000000000000000
R10: 00000000000000c0 R11: ffffffff83ba9e29 R12: ffff88802e216008
R13: ffff88802e216000 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f4aea3f66c0(0000) GS:ffff8880b1fa1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000c0 CR3: 000000004b75c000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 iommufd_fops_ioctl+0x287/0x400 drivers/iommu/iommufd/main.c:533
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x120/0x170 fs/ioctl.c:583
 x64_sys_call+0x1092/0x1fb0 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10a/0x680 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4aec1a82bd
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4aea3f6018 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4aec436090 RCX: 00007f4aec1a82bd
RDX: 0000200000000180 RSI: 0000000000003b92 RDI: 0000000000000003
RBP: 00007f4aec250295 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4aec436128 R14: 00007f4aec436090 R15: 00007ffd04ef23e0
 </TASK>
Modules linked in:
CR2: 00000000000000c0
---[ end trace 0000000000000000 ]---
RIP: 0010:iommufd_ioas_change_process+0x419/0xd50 drivers/iommu/iommufd/ioas.c:538
Code: 48 89 c3 48 85 c0 0f 84 cc 00 00 00 e8 10 f5 cb fd 48 8d 7b 68 e8 a7 b5 eb fd 48 8b 6b 68 48 8d bd c0 00 00 00 e8 17 b2 eb fd <8b> ad c0 00 00 00 bf 01 00 00 00 89 ee e8 85 ef cb fd 83 fd 01 74
RSP: 0018:ffffc90015c17d28 EFLAGS: 00010246
RAX: ffff8880186d5328 RBX: ffff88801d25e240 RCX: 0000000080000000
RDX: 00000000000002d7 RSI: ffffffff83ba9e10 RDI: 00000000000000c0
RBP: 0000000000000000 R08: ffffffff8e781eb8 R09: 0000000000000000
R10: 00000000000000c0 R11: ffffffff83ba9e29 R12: ffff88802e216008
R13: ffff88802e216000 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f4aea3f66c0(0000) GS:ffff8880b1fa1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000c0 CR3: 000000004b75c000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess):
   0:	48 89 c3             	mov    %rax,%rbx
   3:	48 85 c0             	test   %rax,%rax
   6:	0f 84 cc 00 00 00    	je     0xd8
   c:	e8 10 f5 cb fd       	call   0xfdcbf521
  11:	48 8d 7b 68          	lea    0x68(%rbx),%rdi
  15:	e8 a7 b5 eb fd       	call   0xfdebb5c1
  1a:	48 8b 6b 68          	mov    0x68(%rbx),%rbp
  1e:	48 8d bd c0 00 00 00 	lea    0xc0(%rbp),%rdi
  25:	e8 17 b2 eb fd       	call   0xfdebb241
* 2a:	8b ad c0 00 00 00    	mov    0xc0(%rbp),%ebp <-- trapping instruction
  30:	bf 01 00 00 00       	mov    $0x1,%edi
  35:	89 ee                	mov    %ebp,%esi
  37:	e8 85 ef cb fd       	call   0xfdcbefc1
  3c:	83 fd 01             	cmp    $0x1,%ebp
  3f:	74                   	.byte 0x74

Fix by mirroring the handling logic in iopt_unmap_iova_range(),
i.e. return -EBUSY if area->pages is NULL.

Fixes: 829ed626499c ("iommufd: Add IOMMU_IOAS_CHANGE_PROCESS")
Link: https://patch.msgid.link/r/7344B7A7B9957A65+20260806045059.1884737-1-peiyang_he@smail.nju.edu.cn
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/ioas.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -535,6 +535,10 @@ int iommufd_ioas_change_process(struct i
 		return rc;
 
 	for_each_ioas_area(&ioas_list, index, ioas, area)  {
+		if (!area->pages) {
+			rc = -EBUSY;
+			goto out;
+		}
 		if (area->pages->type != IOPT_ADDRESS_FILE) {
 			rc = -EINVAL;
 			goto out;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A105142067;
	Tue, 23 Jul 2024 18:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759569; cv=none; b=gfIeSMU2k4rwaUtzrAy7vjMfWDfW45qwtrf5LfT9bvlh078lcQr+FqOVJY0+K/n5ZMo5LSoLKXNV+8TBN6VTo0Qa0LWbxAfkWoZmTFe1O5QNAKygWBNQzctI7Io/a+3XK2gizoGp8GrjZ0RTHHPMjlhmSSOoqvCcaMtHzWeniUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759569; c=relaxed/simple;
	bh=sX2MMAJs+R8KKazn3rrX2k6woN0KQPeFW+ip2dJccPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLe3bjF/sv/ObeDk+Gl9KqPZFOrFyO1QFaYrmI6A71QK9drODiSB94cJ5J+EhzeHWjOFoRVbDoM/3oNoZbs5SNlSx4MYiMOKYpW/wNkDWNoHXI751IS9zakjitXGUdZKBMg/fYAbRsEIEqp3t5IWQnJEJzbCrJQF//ee8+9RSOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyqbxh6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyqbxh6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF412C4AF0B;
	Tue, 23 Jul 2024 18:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759569;
	bh=sX2MMAJs+R8KKazn3rrX2k6woN0KQPeFW+ip2dJccPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyqbxh6XZDytW0YiwZKjuEm+m4EPfbFqU/gHHSFeXDx0aCPk1mPVY3hPqSyIyjXz8
	 ExrqEv1JZ4TtDymkeQrk7OAZq8xXD7WC4RiAZct5bgcb03mshyAaNFbPI3RBJ9IBCU
	 CyBPpgfrn1fbCGOWTC20nyf6xmARde5H3mcK95QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/129] KVM: PPC: Book3S HV: Prevent UAF in kvm_spapr_tce_attach_iommu_group()
Date: Tue, 23 Jul 2024 20:23:22 +0200
Message-ID: <20240723180406.875977694@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit a986fa57fd81a1430e00b3c6cf8a325d6f894a63 ]

Al reported a possible use-after-free (UAF) in kvm_spapr_tce_attach_iommu_group().

It looks up `stt` from tablefd, but then continues to use it after doing
fdput() on the returned fd. After the fdput() the tablefd is free to be
closed by another thread. The close calls kvm_spapr_tce_release() and
then release_spapr_tce_table() (via call_rcu()) which frees `stt`.

Although there are calls to rcu_read_lock() in
kvm_spapr_tce_attach_iommu_group() they are not sufficient to prevent
the UAF, because `stt` is used outside the locked regions.

With an artifcial delay after the fdput() and a userspace program which
triggers the race, KASAN detects the UAF:

  BUG: KASAN: slab-use-after-free in kvm_spapr_tce_attach_iommu_group+0x298/0x720 [kvm]
  Read of size 4 at addr c000200027552c30 by task kvm-vfio/2505
  CPU: 54 PID: 2505 Comm: kvm-vfio Not tainted 6.10.0-rc3-next-20240612-dirty #1
  Hardware name: 8335-GTH POWER9 0x4e1202 opal:skiboot-v6.5.3-35-g1851b2a06 PowerNV
  Call Trace:
    dump_stack_lvl+0xb4/0x108 (unreliable)
    print_report+0x2b4/0x6ec
    kasan_report+0x118/0x2b0
    __asan_load4+0xb8/0xd0
    kvm_spapr_tce_attach_iommu_group+0x298/0x720 [kvm]
    kvm_vfio_set_attr+0x524/0xac0 [kvm]
    kvm_device_ioctl+0x144/0x240 [kvm]
    sys_ioctl+0x62c/0x1810
    system_call_exception+0x190/0x440
    system_call_vectored_common+0x15c/0x2ec
  ...
  Freed by task 0:
   ...
   kfree+0xec/0x3e0
   release_spapr_tce_table+0xd4/0x11c [kvm]
   rcu_core+0x568/0x16a0
   handle_softirqs+0x23c/0x920
   do_softirq_own_stack+0x6c/0x90
   do_softirq_own_stack+0x58/0x90
   __irq_exit_rcu+0x218/0x2d0
   irq_exit+0x30/0x80
   arch_local_irq_restore+0x128/0x230
   arch_local_irq_enable+0x1c/0x30
   cpuidle_enter_state+0x134/0x5cc
   cpuidle_enter+0x6c/0xb0
   call_cpuidle+0x7c/0x100
   do_idle+0x394/0x410
   cpu_startup_entry+0x60/0x70
   start_secondary+0x3fc/0x410
   start_secondary_prolog+0x10/0x14

Fix it by delaying the fdput() until `stt` is no longer in use, which
is effectively the entire function. To keep the patch minimal add a call
to fdput() at each of the existing return paths. Future work can convert
the function to goto or __cleanup style cleanup.

With the fix in place the test case no longer triggers the UAF.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Closes: https://lore.kernel.org/all/20240610024437.GA1464458@ZenIV/
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240614122910.3499489-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 93b695b289e99..395659f2f4c8e 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -129,14 +129,16 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 	}
 	rcu_read_unlock();
 
-	fdput(f);
-
-	if (!found)
+	if (!found) {
+		fdput(f);
 		return -EINVAL;
+	}
 
 	table_group = iommu_group_get_iommudata(grp);
-	if (WARN_ON(!table_group))
+	if (WARN_ON(!table_group)) {
+		fdput(f);
 		return -EFAULT;
+	}
 
 	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
 		struct iommu_table *tbltmp = table_group->tables[i];
@@ -157,8 +159,10 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 			break;
 		}
 	}
-	if (!tbl)
+	if (!tbl) {
+		fdput(f);
 		return -EINVAL;
+	}
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(stit, &stt->iommu_tables, next) {
@@ -169,6 +173,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 			/* stit is being destroyed */
 			iommu_tce_table_put(tbl);
 			rcu_read_unlock();
+			fdput(f);
 			return -ENOTTY;
 		}
 		/*
@@ -176,6 +181,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 		 * its KVM reference counter and can return.
 		 */
 		rcu_read_unlock();
+		fdput(f);
 		return 0;
 	}
 	rcu_read_unlock();
@@ -183,6 +189,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 	stit = kzalloc(sizeof(*stit), GFP_KERNEL);
 	if (!stit) {
 		iommu_tce_table_put(tbl);
+		fdput(f);
 		return -ENOMEM;
 	}
 
@@ -191,6 +198,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 
 	list_add_rcu(&stit->next, &stt->iommu_tables);
 
+	fdput(f);
 	return 0;
 }
 
-- 
2.43.0




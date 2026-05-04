Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9110A3B19D1;
	Mon,  4 May 2026 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903239; cv=none; b=J1dTm93b5bcR0ofaWfKz1xtB1DkDUkiy3x+X1bO8dpdEnPPIWkFbsXupB7gEZSwIGfNV2v8eZYFoWzx4GQcBDpaPwsjrqt2W6Zgo9xqL5WbNs1+h5y33+mKFiGvR1cb2CQsZiqKxsuyuyshrFbHhpVdkt7ICJ7PfOiqahDAZkGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903239; c=relaxed/simple;
	bh=g9VQ3of46AZBsyud49PAMfRXzcISOCE3tdZV23MPod8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOJvmmrRcMrxCUv7w7OYKOXhh5/IbckyNxrki2QGfTHqfGJq9m75qTwEf0no8v+ms6+DUjwBotYI30ah0+Gq22rp4WAS8CbPQEgOxH8b+eHSwJgz94Q02q01KcGz/GuEtPqBxts1vq+CEzG+N//7go5+qTRmMwNEVkK69YPOmtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wevn0jLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wevn0jLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24556C2BCB8;
	Mon,  4 May 2026 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903239;
	bh=g9VQ3of46AZBsyud49PAMfRXzcISOCE3tdZV23MPod8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wevn0jLHbPGvdfLkeGhwqIt42Y7pldKPMJHZjFmwfgvay2tJK/im04hYU5qGqyggc
	 ixCj2CfOCxm0Pn+SQn6W4WGb0glHN//OBuXGaLRBXW4bwYSMGj8AQ5WA9sdfGcA33o
	 PVxxj7SdhqZq6zS9E2l9/R77fRsdGsLsvELPFw+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Daniel J Blueman <daniel@quora.org>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 7.0 157/307] apparmor: Fix string overrun due to missing termination
Date: Mon,  4 May 2026 15:50:42 +0200
Message-ID: <20260504135148.746705776@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel J Blueman <daniel@quora.org>

commit 828bf7929bedcb79b560b5b4e44f22abee07d31b upstream.

When booting Ubuntu 26.04 with Linux 7.0-rc4 on an ARM64 Qualcomm
Snapdragon X1 we see a string buffer overrun:

BUG: KASAN: slab-out-of-bounds in aa_dfa_match (security/apparmor/match.c:535)
Read of size 1 at addr ffff0008901cc000 by task snap-update-ns/2120

CPU: 5 UID: 60578 PID: 2120 Comm: snap-update-ns Not tainted 7.0.0-rc4+ #22 PREEMPTLAZY
Hardware name: LENOVO 83ED/LNVNB161216, BIOS NHCN60WW 09/11/2025
Call trace:
show_stack (arch/arm64/kernel/stacktrace.c:501) (C)
dump_stack_lvl (lib/dump_stack.c:122)
print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
kasan_report (mm/kasan/report.c:597)
__asan_report_load1_noabort (mm/kasan/report_generic.c:378)
aa_dfa_match (security/apparmor/match.c:535)
match_mnt_path_str (security/apparmor/mount.c:244 security/apparmor/mount.c:336)
match_mnt (security/apparmor/mount.c:371)
aa_bind_mount (security/apparmor/mount.c:447 (discriminator 4))
apparmor_sb_mount (security/apparmor/lsm.c:719 (discriminator 1))
security_sb_mount (security/security.c:1062 (discriminator 31))
path_mount (fs/namespace.c:4101)
__arm64_sys_mount (fs/namespace.c:4172 fs/namespace.c:4361 fs/namespace.c:4338 fs/namespace.c:4338)
invoke_syscall.constprop.0 (arch/arm64/kernel/syscall.c:35 arch/arm64/kernel/syscall.c:49)
el0_svc_common.constprop.0 (./include/linux/thread_info.h:142 (discriminator 2) arch/arm64/kernel/syscall.c:140 (discriminator 2))
do_el0_svc (arch/arm64/kernel/syscall.c:152)
el0_svc (arch/arm64/kernel/entry-common.c:80 arch/arm64/kernel/entry-common.c:725)
el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:744)
el0t_64_sync (arch/arm64/kernel/entry.S:596)

Allocated by task 2120:
kasan_save_stack (mm/kasan/common.c:58)
kasan_save_track (./arch/arm64/include/asm/current.h:19 mm/kasan/common.c:70 mm/kasan/common.c:79)
kasan_save_alloc_info (mm/kasan/generic.c:571)
__kasan_kmalloc (mm/kasan/common.c:419)
__kmalloc_noprof (./include/linux/kasan.h:263 mm/slub.c:5260 mm/slub.c:5272)
aa_get_buffer (security/apparmor/lsm.c:2201)
aa_bind_mount (security/apparmor/mount.c:442)
apparmor_sb_mount (security/apparmor/lsm.c:719 (discriminator 1))
security_sb_mount (security/security.c:1062 (discriminator 31))
path_mount (fs/namespace.c:4101)
__arm64_sys_mount (fs/namespace.c:4172 fs/namespace.c:4361 fs/namespace.c:4338 fs/namespace.c:4338)
invoke_syscall.constprop.0 (arch/arm64/kernel/syscall.c:35 arch/arm64/kernel/syscall.c:49)
el0_svc_common.constprop.0 (./include/linux/thread_info.h:142 (discriminator 2) arch/arm64/kernel/syscall.c:140 (discriminator 2))
do_el0_svc (arch/arm64/kernel/syscall.c:152)
el0_svc (arch/arm64/kernel/entry-common.c:80 arch/arm64/kernel/entry-common.c:725)
el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:744)
el0t_64_sync (arch/arm64/kernel/entry.S:596)

The buggy address belongs to the object at ffff0008901ca000
which belongs to the cache kmalloc-rnd-06-8k of size 8192
The buggy address is located 0 bytes to the right of
allocated 8192-byte region [ffff0008901ca000, ffff0008901cc000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x9101c8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:-1 pincount:0
flags: 0x8000000000000040(head|zone=2)
page_type: f5(slab)
raw: 8000000000000040 ffff000800016c40 fffffdffe2d14e10 ffff000800015c70
raw: 0000000000000000 0000000800010001 00000000f5000000 0000000000000000
head: 8000000000000040 ffff000800016c40 fffffdffe2d14e10 ffff000800015c70
head: 0000000000000000 0000000800010001 00000000f5000000 0000000000000000
head: 8000000000000003 fffffdffe2407201 fffffdffffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected

Memory state around the buggy address:
ffff0008901cbf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
ffff0008901cbf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff0008901cc000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
^
ffff0008901cc080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff0008901cc100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

This was introduced by previous incorrect conversion from strcpy(). Fix it
by adding the missing terminator.

Cc: stable@vger.kernel.org
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Daniel J Blueman <daniel@quora.org>
Fixes: 93d4dbdc8da0 ("apparmor: Replace deprecated strcpy in d_namespace_path")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/path.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/security/apparmor/path.c b/security/apparmor/path.c
index 65a0ca5cc1bd..2494e8101538 100644
--- a/security/apparmor/path.c
+++ b/security/apparmor/path.c
@@ -164,14 +164,16 @@ static int d_namespace_path(const struct path *path, char *buf, char **name,
 	}
 
 out:
-	/* Append "/" to directory paths, except for root "/" which
-	 * already ends in a slash.
+	/* Append "/" to directory paths and reterminate string, except for
+	 * root "/" which already ends in a slash.
 	 */
 	if (!error && isdir) {
 		bool is_root = (*name)[0] == '/' && (*name)[1] == '\0';
 
-		if (!is_root)
+		if (!is_root) {
 			buf[aa_g_path_max - 2] = '/';
+			buf[aa_g_path_max - 1] = '\0';
+		}
 	}
 
 	return error;
-- 
2.54.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44A11DED65;
	Tue,  8 Oct 2024 13:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393156; cv=none; b=oz0xKYQqNAuIk9zOUE1ARQ+Qs1Vswgs00sSXs8eqRRjrEU5jWrjRuGhusMs2uH2DLfAALeJYs7ca3JocaZJbD3K2MogL7GeqHPqpYDQInQYmoTaSneXMvWk47NcLOXXtuV11hukYFGwjflE9+NztXuE5GwPH5Pw6qfdwxpQNDdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393156; c=relaxed/simple;
	bh=iE4MYChV5KJJVA+YdxdRAqrNMX+PMUM6fe7xTIVipVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lowxiPk01/vzCjhxIB2jGb7g5En/+qvGD2/drKn48b5Wc0fOQc8VvAmHipi3npClKx3cNjyfwQcAo3CJOiJZfRZRsP1+eS3hhTG29s6bblJ1dsNP1u3YjA6/bVWw0+1gtOnNqik6zCpXvsQXzKklbxn6nMogc1RnkdWe/We8d+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhCK5Y23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhCK5Y23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34CDC4CEC7;
	Tue,  8 Oct 2024 13:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393156;
	bh=iE4MYChV5KJJVA+YdxdRAqrNMX+PMUM6fe7xTIVipVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhCK5Y23pBWmWu9WOoy1EEO24ciwmz3fjuGClRE9ALu+P8jdLXULccjThRyurtbvD
	 vzRRZqAOnucVqbARIcSn1Y+rEsx2F6ys9dTwb8nGlRCRm1OCrRwUaBmk/ZfJUQ/W23
	 8PeZzY7VulIbUIjDXUfQr0lPkJ/7EqCenQGK0WhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Nishikawa <snishika@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/386] ACPI: PAD: fix crash in exit_round_robin()
Date: Tue,  8 Oct 2024 14:05:15 +0200
Message-ID: <20241008115632.217281533@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Seiji Nishikawa <snishika@redhat.com>

[ Upstream commit 0a2ed70a549e61c5181bad5db418d223b68ae932 ]

The kernel occasionally crashes in cpumask_clear_cpu(), which is called
within exit_round_robin(), because when executing clear_bit(nr, addr) with
nr set to 0xffffffff, the address calculation may cause misalignment within
the memory, leading to access to an invalid memory address.

----------
BUG: unable to handle kernel paging request at ffffffffe0740618
        ...
CPU: 3 PID: 2919323 Comm: acpi_pad/14 Kdump: loaded Tainted: G           OE  X --------- -  - 4.18.0-425.19.2.el8_7.x86_64 #1
        ...
RIP: 0010:power_saving_thread+0x313/0x411 [acpi_pad]
Code: 89 cd 48 89 d3 eb d1 48 c7 c7 55 70 72 c0 e8 64 86 b0 e4 c6 05 0d a1 02 00 01 e9 bc fd ff ff 45 89 e4 42 8b 04 a5 20 82 72 c0 <f0> 48 0f b3 05 f4 9c 01 00 42 c7 04 a5 20 82 72 c0 ff ff ff ff 31
RSP: 0018:ff72a5d51fa77ec8 EFLAGS: 00010202
RAX: 00000000ffffffff RBX: ff462981e5d8cb80 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000246 RDI: 0000000000000246
RBP: ff46297556959d80 R08: 0000000000000382 R09: ff46297c8d0f38d8
R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000000e
R13: 0000000000000000 R14: ffffffffffffffff R15: 000000000000000e
FS:  0000000000000000(0000) GS:ff46297a800c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffe0740618 CR3: 0000007e20410004 CR4: 0000000000771ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 ? acpi_pad_add+0x120/0x120 [acpi_pad]
 kthread+0x10b/0x130
 ? set_kthread_struct+0x50/0x50
 ret_from_fork+0x1f/0x40
        ...
CR2: ffffffffe0740618

crash> dis -lr ffffffffc0726923
        ...
/usr/src/debug/kernel-4.18.0-425.19.2.el8_7/linux-4.18.0-425.19.2.el8_7.x86_64/./include/linux/cpumask.h: 114
0xffffffffc0726918 <power_saving_thread+776>:	mov    %r12d,%r12d
/usr/src/debug/kernel-4.18.0-425.19.2.el8_7/linux-4.18.0-425.19.2.el8_7.x86_64/./include/linux/cpumask.h: 325
0xffffffffc072691b <power_saving_thread+779>:	mov    -0x3f8d7de0(,%r12,4),%eax
/usr/src/debug/kernel-4.18.0-425.19.2.el8_7/linux-4.18.0-425.19.2.el8_7.x86_64/./arch/x86/include/asm/bitops.h: 80
0xffffffffc0726923 <power_saving_thread+787>:	lock btr %rax,0x19cf4(%rip)        # 0xffffffffc0740620 <pad_busy_cpus_bits>

crash> px tsk_in_cpu[14]
$66 = 0xffffffff

crash> px 0xffffffffc072692c+0x19cf4
$99 = 0xffffffffc0740620

crash> sym 0xffffffffc0740620
ffffffffc0740620 (b) pad_busy_cpus_bits [acpi_pad]

crash> px pad_busy_cpus_bits[0]
$42 = 0xfffc0
----------

To fix this, ensure that tsk_in_cpu[tsk_index] != -1 before calling
cpumask_clear_cpu() in exit_round_robin(), just as it is done in
round_robin_cpu().

Signed-off-by: Seiji Nishikawa <snishika@redhat.com>
Link: https://patch.msgid.link/20240825141352.25280-1-snishika@redhat.com
[ rjw: Subject edit, avoid updates to the same value ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pad.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 7a453c5ff303a..71e25c7989762 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -131,8 +131,10 @@ static void exit_round_robin(unsigned int tsk_index)
 {
 	struct cpumask *pad_busy_cpus = to_cpumask(pad_busy_cpus_bits);
 
-	cpumask_clear_cpu(tsk_in_cpu[tsk_index], pad_busy_cpus);
-	tsk_in_cpu[tsk_index] = -1;
+	if (tsk_in_cpu[tsk_index] != -1) {
+		cpumask_clear_cpu(tsk_in_cpu[tsk_index], pad_busy_cpus);
+		tsk_in_cpu[tsk_index] = -1;
+	}
 }
 
 static unsigned int idle_pct = 5; /* percentage */
-- 
2.43.0




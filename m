Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0834E235358;
	Sat, 12 Sep 2026 07:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199591; cv=none; b=Na10KvjZxdYE9wBhjKGxOzXt3IcHnq9WSD/4Yr/BjrQoTGjjH83xzQYIg/H2plTCFwsm55kweHHsk631/hP6CXWq4q7ZdVF9IqBE6YvxfM5SAoHC5vSeccVsWJtgy/MdLGnvSV8kZ8aWkGoR1139QaxL8ELjiIII0R8pCIBX0Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199591; c=relaxed/simple;
	bh=s5wJRNZ0ZoIAUJRrwRtt8TCszuV5pgtGuZg7SbxVRGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myMkUrLXTTBtE07n1tRUIa/ybJOWJLjcGGHNtyWOdL1lj+9o7k/ffW9WRQsBvIycESB1VV2uTh7rgfy+89P54jfANR1qDJGp2xMwDk/Iih+BXnaf0VWwegXmsiIvdCHg4sQiMbYm0s9PuGA1BOV656iOhursCx1NRcsnd/vms4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xu8gLofg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xu8gLofg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B261F000FF;
	Sat, 12 Sep 2026 07:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199589;
	bh=Wdkib9pmmzdPqVmGoMW+8stN+zNPtpLAQZFI+ex486c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xu8gLofgHo6NFkH7R/rRGvy9fe5KFq83k83WEK4Pkhu5uOcOglmDzGfmJj/HyATcU
	 VOjMO7VvMsCyn5EnAP9ODcc2TiHcT9yDLHh54Mj0daZQrScAFV0lhVgEkXDCpUkoE6
	 VFu1mjVpXWqubJr5jot5XbrMLAjbzirTBnUWx184=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiong <xiongl24@chinatelecom.cn>,
	Xibo Wang <wangxb12@chinatelecom.cn>,
	Qianheng Peng <pengqh1@chinatelecom.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0616/1815] cpufreq: amd-pstate-ut: Skip tests when amd-pstate driver is not active
Date: Sat, 12 Sep 2026 08:39:26 +0200
Message-ID: <20260912065703.342977985@linuxfoundation.org>
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

From: Qianheng Peng <pengqh1@chinatelecom.cn>

[ Upstream commit 8d31bb1451643f328db0cea0e21e63ef54b4faf2 ]

The crash issue may occur when modprobe amd_pstate_ut on intel platform.

   amd_pstate_ut: 1    amd_pstate_ut_acpi_cpc_valid  success!
   amd_pstate_ut: 2    amd_pstate_ut_check_enabled   success!
   BUG: kernel NULL pointer dereference, address: 0000000000000080
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page
   PGD 0 P4D 0
   Oops: 0000 [#1] SMP NOPTI
   CPU: 0 PID: 20300 Comm: modprobe
   Kdump: loaded Tainted: G O 6.6.0-0010.rc1.ctl4.x86_64 #1
   Hardware name: FiberHome R2200 V5/Xeon Boards, BIOS 3.1a 02/24/2020
   RIP: 0010:amd_pstate_ut_check_perf+0x141/0x280 [amd_pstate_ut]
   Call Trace:
    <TASK>
    amd_pstate_ut_init+0x1b/0xff0 [amd_pstate_ut]
    ? __pfx_amd_pstate_ut_init+0x10/0x10 [amd_pstate_ut]
    do_one_initcall+0x42/0x2e0
    ? kmalloc_trace+0x26/0x90
    do_init_module+0x60/0x240
    __se_sys_init_module+0x185/0x1c0
    do_syscall_64+0x62/0x190
    entry_SYSCALL_64_after_hwframe+0x76/0x7e
    </TASK>

Add state detection to amd pstate driver to prevent amd_pstate_ut driver
from testing on non-AMD platforms.

Fixes: 14eb1c96e3a3 ("cpufreq: amd-pstate: Add test module for amd-pstate driver")
Suggested-by: Li Xiong <xiongl24@chinatelecom.cn>
Suggested-by: Xibo Wang <wangxb12@chinatelecom.cn>
Signed-off-by: Qianheng Peng <pengqh1@chinatelecom.cn>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://lore.kernel.org/r/1784191899-28957-1-git-send-email-pengqh1@chinatelecom.cn
(ML: adjust title)
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate-ut.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate-ut.c b/drivers/cpufreq/amd-pstate-ut.c
index 735b29f76438a..2142838ad6cc4 100644
--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -560,6 +560,11 @@ static int amd_pstate_ut_check_freq_attrs(u32 index)
 static int __init amd_pstate_ut_init(void)
 {
 	u32 i = 0, arr_size = ARRAY_SIZE(amd_pstate_ut_cases);
+	enum amd_pstate_mode mode = amd_pstate_get_status();
+
+	/* don't test if no running amd-pstate driver */
+	if (mode == AMD_PSTATE_UNDEFINED || mode == AMD_PSTATE_DISABLE)
+		return -EOPNOTSUPP;
 
 	for (i = 0; i < arr_size; i++) {
 		int ret;
-- 
2.53.0




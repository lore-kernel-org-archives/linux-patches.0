Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6B9414A1E;
	Wed, 16 Sep 2026 08:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545871; cv=none; b=NFkOJMdwz3nqvh8nnp/C4OmpE4gtsy//XeRjnm6TRjwCs/AF5d8pocM5VU+YZQdqCfVOgokCzmz1ilTQpRe4ewfVSNbJP6SztS8/lbFyZ+cx92S3btaX85VQsLZfSjU7f+4uw21Mh2UygYvdyRA7FBzzRunZZVwRYchOiQCMgT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545871; c=relaxed/simple;
	bh=BacB0fBmQ35qBjHPbqLS6rq6/nFfBz9/FCJTZIFWGhk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqkeUF0yohEli5dOPX/YojUaqMFVKR2BNR3PP9Jlc5AAh/n0OOn1SMGKPNQDSovpkJwx0u1Gv6oaYQw6ztWNWn8yrO+Ef3AAbTymbiRgafdO5aQQtPXmzy4L6yzV3/YlpBG0bBQv2JmNmf/RUQgTIS86jGPjyuWpjSL8FZNkNQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=4aES9vTm; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="4aES9vTm"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qi/8KmTACgzaOJUo6Ls2h+Iy6oJkE3czWFE7HPb7+BU=;
	b=4aES9vTmVc05dUs+HbF8lsBQYc+lpPG1KcvWDHRIel689opGbw1oG3uUyE1R6a4TWD5E8FWLa
	4isP6jr4lO3v/fw91IodAoXjzoe8fu4BbTr93m7BNLV5Qz9G3DAdjosYUgSfhWWUNCJHJW4hzz/
	10h4vFRehaW+dxOgTpQfenI=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hlB2g4Ktdz1K96s;
	Wed, 16 Sep 2026 15:53:15 +0800 (CST)
Received: from kwepemk300012.china.huawei.com (unknown [7.202.194.175])
	by mail.maildlp.com (Postfix) with ESMTPS id 6317840586;
	Wed, 16 Sep 2026 16:04:14 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemk300012.china.huawei.com (7.202.194.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 16 Sep 2026 16:04:13 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
	<linux@armlinux.org.uk>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
	<rostedt@goodmis.org>, <rmk+kernel@armlinux.org.uk>, <linusw@kernel.org>,
	<kuninori.morimoto.gx@renesas.com>, <arnd@arndb.de>, <xiqi2@huawei.com>,
	<ljs@kernel.org>, <wozizhi@huaweicloud.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-rt-devel@lists.linux.dev>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, <lisongze2@huawei.com>, <wangbing6@huawei.com>,
	Yadi.hu <yadi.hu@windriver.com>
Subject: [PATCH 5.10.y/5.15.y 3/4] ARM: ensure interrupts are enabled in __do_user_fault()
Date: Wed, 16 Sep 2026 16:00:10 +0800
Message-ID: <20260916080011.170295-3-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916080011.170295-1-xieyuanbin1@huawei.com>
References: <20260916080011.170295-1-xieyuanbin1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300012.china.huawei.com (7.202.194.175)

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 59e4f3b45b96a24fc9b7a89e5f8a2168b30f95af ]

__do_user_fault() may be called from fault handling paths where the
interrupts are enabled or disabled. E.g. do_page_fault() calls this
with interrupts enabled, whereas do_sect_fault()->do_bad_area()
will call this with interrupts disabled. Since this is a userspace
fault, we know that interrupts were enabled in the parent context,
so call local_irq_enable() here to give a consistent interrupt state.

This is necessary for force_sig_info() when PREEMPT_RT is enabled.

Reported-by: Yadi.hu <yadi.hu@windriver.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 arch/arm/mm/fault.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 4afb076383a8..8b31d7704626 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -137,7 +137,8 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 
 /*
  * Something tried to access memory that isn't in our memory map..
- * User mode accesses just cause a SIGSEGV
+ * User mode accesses just cause a SIGSEGV. Ensure interrupts are enabled
+ * for preempt RT.
  */
 static void
 __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
@@ -145,6 +146,8 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
 {
 	struct task_struct *tsk = current;
 
+	local_irq_enable();
+
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
@@ -254,6 +257,7 @@ do_kernel_address_page_fault(struct mm_struct *mm, unsigned long addr,
 		 * should not be faulting in kernel space, which includes the
 		 * vector/khelper page. Handle the branch predictor hardening
 		 * while interrupts are still disabled, then send a SIGSEGV.
+		 * Note that __do_user_fault() will enable interrupts.
 		 */
 		harden_branch_predictor();
 		__do_user_fault(addr, fsr, SIGSEGV, SEGV_MAPERR, regs);
-- 
2.55.0


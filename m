Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4EF394E8A;
	Thu, 17 Sep 2026 02:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612283; cv=none; b=iiUelXzQWI3yhsuI98IAwkYlklHdRpos44hfu35dP00gXgeceYrQHGqZIGG3EssFzZ9L1V6Bs8QWETZsAU4Zu+tH2xmuW2mJqpooXs06EVDTLZOGIa0XdXZYAdM6F70GZO5quLoCoL0nEmNiQZ0w1niyGVLwW/kVGH9sgqtJljE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612283; c=relaxed/simple;
	bh=GMDDHNUV8K+jWRx4wueZtHvHBvnQ0sSfw9cwYxdmeoY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FslUNMFQK6zuc1MaaHYKE+IK0RyXbzliNQRm+CVwQ6oeRREGKoaYH7fnFZFYSFPz0KsJA1h9xcr56nkx6AIkZMVU4Mrwl+t9xx/dWPo/QRDv3wo59aLyw6NlzepTpxU1xbyQkU5rK4xjX8sfRxDa04jiuKcjMoVcLJrSfUxzlYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Afbf6X7B; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Afbf6X7B"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lm2fU6VUAA2CcshNsS+yIrHI71OwF94jThA5xdU69NA=;
	b=Afbf6X7Bbv2cvH58IBnVCBfWLbO+BuHzxIRgq3MS/gKTU9eFLkULQKwza3cBJier2BVbBi5Nu
	lukb2TFfnUaOX9gAqL51uTva94FcFrAIP++92jVtHiuy61GC5MXPxk1Pb4B3HLUvYCRK242r1pU
	KNOTN0xrNv6V3fxW5095ZY0=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hlfZt543NzpSyG;
	Thu, 17 Sep 2026 10:19:18 +0800 (CST)
Received: from kwepemk300012.china.huawei.com (unknown [7.202.194.175])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E73140537;
	Thu, 17 Sep 2026 10:31:05 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemk300012.china.huawei.com (7.202.194.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 17 Sep 2026 10:31:04 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
	<linux@armlinux.org.uk>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
	<rostedt@goodmis.org>, <rmk+kernel@armlinux.org.uk>, <linusw@kernel.org>,
	<kuninori.morimoto.gx@renesas.com>, <arnd@arndb.de>, <xiqi2@huawei.com>,
	<ljs@kernel.org>, <wozizhi@huaweicloud.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-rt-devel@lists.linux.dev>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, <lisongze2@huawei.com>, <wangbing6@huawei.com>,
	Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: [PATCH v2 5.10.y/5.15.y 0/3] ARM: fix might_sleep() WARNING for mmap_write_lock() around show_pte()
Date: Thu, 17 Sep 2026 10:30:53 +0800
Message-ID: <20260917023056.2280-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
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

On linux-5.10.y and linux-5.15.y, commit 07e4d5380f2a844ab7a1 ("ARM:
9485/1: mm: acquire mmap write lock around show_pte() for user faults")
introduces a might_sleep() WARNING when using mmap write lock. This is
due to the lack of upstream commit 59e4f3b45b96a24fc9b7 ("ARM: ensure
interrupts are enabled in __do_user_fault()") and
commit e79ca91165d4fd18549c ("ARM: 9484/1: enable interrupts when
unhandled user faults are triggered") .

This series backports all these upstream patches into the linux-5.10.y:
1. commit 7733bc7d299d682f2723 ("ARM: fix hash_name() fault")
2. commit fd2dee1c6e2256f726ba ("ARM: fix branch predictor hardening")
3. commit 59e4f3b45b96a24fc9b7 ("ARM: ensure interrupts are enabled in
   __do_user_fault()")

In the upstream version, the following patches are a patch set:
a. commit dea20281ac8822661576 ("ARM: group is_permission_fault() with
   is_translation_fault()")
b. commit 40b466db1dffb41f0529 ("ARM: allow __do_kernel_fault() to report
   execution of memory faults")
c. commit 7733bc7d299d682f2723 ("ARM: fix hash_name() fault"):
   which is 1.
d. commit fd2dee1c6e2256f726ba ("ARM: fix branch predictor hardening"):
   which is 2.
The fixed issues by this patch set also exist in linux-5.10 && linux-5.15.
a. and b. do not need to be backported, and after c. and d.
is backported, 3. can be safely patched.

V1->V2: https://lore.kernel.org/20260916084807.176359-1-xieyuanbin1@huawei.com

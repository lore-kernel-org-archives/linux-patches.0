Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F0A43BDC0;
	Wed, 16 Sep 2026 08:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548499; cv=none; b=ohf71ExKaI3yZOl+WYezpWrsKJvaeJa9iMAcBICUOH17xbh64gSVJHVrqa1jupK+9VhFrfAZQTu7RloZvyEthIxjgt56p29XN71+0grDALqKpJVaDekYQ9nVxf93cQ3u+aY/I0IofaC8AZlOeQQK9exJ07pabCIrXYYRsjFYPlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548499; c=relaxed/simple;
	bh=HJfF8atFf+EtkQ0oArlq2aMYpWd3JdC3DOPSxbMrx9A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bQIjLIwcnSwzhtjaxGml0YrqiNrSI0kXgHimHaQBWACh0aryRgP0lYS9dsi+KpGi/Ju3NxI232C11WM1ByXi6KXCXRDHq+cuqsIKMcnwWdKLpNWny5UkweZRvu4mcdNGE63/9dl9xRcIsWMYxkhgNoUexrZZ9ajF0F1BX0wbPVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pwFpmz5v; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pwFpmz5v"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gLsBgp6/np47MXvoT7Gy3Dsz1JT/6o4ck60MxFMEbMs=;
	b=pwFpmz5vgTArTKuy9hoBMaxXTwMiImRuPfz1SMKaEY4dU87GFBeCYZzKgiyt7j3nWyPocpbir
	dGC4zhwfvAOZ8QlKI51gBGvKxSAC5Z4WcbRSxg+ABFESZINwusMyW9RiN1NR7O2pIqCAUmdsEhQ
	CSnC4mKrHAUWQRrBnVCTpNc=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hlC1B1LZ8zcb3J;
	Wed, 16 Sep 2026 16:37:02 +0800 (CST)
Received: from kwepemk300012.china.huawei.com (unknown [7.202.194.175])
	by mail.maildlp.com (Postfix) with ESMTPS id 87A952017D;
	Wed, 16 Sep 2026 16:48:13 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemk300012.china.huawei.com (7.202.194.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 16 Sep 2026 16:48:12 +0800
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
Subject: [PATCH 5.10.y/5.15.y 0/4] ARM: fix might_sleep() WARNING for mmap_write_lock() around show_pte()
Date: Wed, 16 Sep 2026 16:48:07 +0800
Message-ID: <20260916084807.176359-1-xieyuanbin1@huawei.com>
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
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
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
4. commit e79ca91165d4fd18549c ("ARM: 9484/1: enable interrupts when
   unhandled user faults are triggered")

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
is backported, 3. and 4. can be safely patched.

Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549BB1E7660
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 02:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789354676; cv=none; b=TDEpx2GpFaz16CQHBgVOEdiCYw0Qhc4BRG9xyxQutOnAGN8SPghbIqgTS3I2mI9TZiU8xwyx3vAzsw9RlXn8Qm+O2XUcwTILCOvxyIXesLald4p7awnw2/Z/BSa8BDW1Cv5xDGR4/e2vCYF1gGZlCCVEXwnV954+SsEIw3Aixfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789354676; c=relaxed/simple;
	bh=pc7EJcLoyg5ByNWtXPFFwmOctE8DUPqxqewq4Rs9QFQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YjTkBItIaxDwzqa17wkYuLAZFQqnULt64Fk5RWoX46gee0KYQ5W/fH+pNtRb7eQZU+SmsI2RvJjqh4hmmvbBUrHRK/3y0i2i3xS1hIEmKcJ24MYF8RFMJpDmx4lCJ4nEMv+qAeElqnPd2VMmALEDWkgZWrcpY3tQHJM6+oEbAgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=diqVx7Cs; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="diqVx7Cs"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pc7EJcLoyg5ByNWtXPFFwmOctE8DUPqxqewq4Rs9QFQ=;
	b=diqVx7CsG/GhnDygliV7nbarZ0eg3nd6qIftyEPqHrCMf8943FzapdQBcHY3fJM1UTDX/zYRd
	CJjgkrytVi4iWPBJZrvOOknQEBK4PODNOY1DqW3J41Iaj0g4rR0BMiZ6XRowl3mrsyEyRiK0CGu
	Wm7C4+FBvMuBhkBaWkCkrLo=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hjqKl02DPz12LF9;
	Mon, 14 Sep 2026 10:46:35 +0800 (CST)
Received: from kwepemk300012.china.huawei.com (unknown [7.202.194.175])
	by mail.maildlp.com (Postfix) with ESMTPS id 7F22C40561;
	Mon, 14 Sep 2026 10:57:44 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemk300012.china.huawei.com (7.202.194.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 14 Sep 2026 10:57:43 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <gregkh@linuxfoundation.org>
CC: <xieyuanbin1@huawei.com>, <bigeasy@linutronix.de>, <linusw@kernel.org>,
	<lisongze2@huawei.com>, <ljs@kernel.org>, <patches@lists.linux.dev>,
	<rmk+kernel@armlinux.org.uk>, <sashal@kernel.org>, <stable@vger.kernel.org>,
	<wangbing6@huawei.com>, <xiqi2@huawei.com>
Subject: Re: [PATCH 5.10 613/798] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Mon, 14 Sep 2026 10:56:52 +0800
Message-ID: <20260914025652.12173-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914024820.11063-1-xieyuanbin1@huawei.com>
References: <20260914024820.11063-1-xieyuanbin1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk300012.china.huawei.com (7.202.194.175)

On Mon, 14 Sep 2026 10:48:20 +0800, Xie Yuanbin wrote:
> This commit depends on commit e79ca91165d4fd18549c ("ARM: 9484/1: enable
> interrupts when unhandled user faults are triggered"), otherwise,
> mmap_write_lock() may trigger a might_sleep() WARNING.

commit 59e4f3b45b96a24fc9b7 ("ARM: ensure interrupts are enabled
in __do_user_fault()") is also needed.

Thanks!

Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5492D8376
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 02:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789354117; cv=none; b=KRz+a68zC6haJl4DyzMZ8zCEdLZl3UbwdM8J7X720yQhAyGJl/RMojmDPwgnXLawOb0/XRLrO/eQa4tUdL39Czdiiw71h0AA9UhLGIgtp/omNIu1Wo99XlEdVwZeh+5lQL/W6DVLUxIiPrkVasiMPytNEdyPpbI7iAVrMzWlCMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789354117; c=relaxed/simple;
	bh=OAEaxTZU8ednJEy7IsDAHycULjM7kfFxY+kkI8dWNwk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gew2iCJDlYJ1w/qrghQqlNf3admlh4yI7hZBqZ148utJ1H7BORl7eSTzDOxjqrlki/CGq86WMrH5I3DxqRSnfTZ7nd+LviKgDuYxYTmUcBe1pN52CxJ2nhwG8Vjf0zRQbSnna75mJRxYiN2ob22NSAwNPtR527DGcZLqfb2+MUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=NpnJFNYy; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="NpnJFNYy"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UI95So5q402GlNviaC2uYnbM8crUmdD4eDX5/vU60f4=;
	b=NpnJFNYyQzbyJwA8wfUEJmHAGygN/sH+lAktyPJEi6TKQ0+9bZPTgXA1C7v60utkLzeFdbYpx
	+t3KUVsppUO5SXyVKL2ltFleoadqr6pFUaB/O7BjNFBxvjYOCiholFURWlxVc/WJH6WtJr2P9el
	PHlQMbV0/ghaJmGkzw6lf7c=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hjq7G0z7bz1cyPY;
	Mon, 14 Sep 2026 10:37:30 +0800 (CST)
Received: from kwepemk300012.china.huawei.com (unknown [7.202.194.175])
	by mail.maildlp.com (Postfix) with ESMTPS id B75FE4056C;
	Mon, 14 Sep 2026 10:48:26 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemk300012.china.huawei.com (7.202.194.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 14 Sep 2026 10:48:26 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <gregkh@linuxfoundation.org>
CC: <linusw@kernel.org>, <ljs@kernel.org>, <patches@lists.linux.dev>,
	<rmk+kernel@armlinux.org.uk>, <sashal@kernel.org>, <stable@vger.kernel.org>,
	<xieyuanbin1@huawei.com>, <xiqi2@huawei.com>, <bigeasy@linutronix.de>,
	<wangbing6@huawei.com>, <lisongze2@huawei.com>
Subject: Re: [PATCH 5.10 613/798] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Mon, 14 Sep 2026 10:48:20 +0800
Message-ID: <20260914024820.11063-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065531.173869863@linuxfoundation.org>
References: <20260912065531.173869863@linuxfoundation.org>
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

On Sat, 12 Sep 2026 09:04:01 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Xie Yuanbin <xieyuanbin1@huawei.com>
>
> [ Upstream commit 1039bffd6ae9c75b42b7d148d6c1106134107b66 ]

This commit depends on commit e79ca91165d4fd18549c ("ARM: 9484/1: enable
interrupts when unhandled user faults are triggered"), otherwise,
mmap_write_lock() may trigger a might_sleep() WARNING.

commit e79ca91165d4fd18549c ("ARM: 9484/1: enable interrupts when
unhandled user faults are triggered") can be safely backported to the
previous version.

See also:
Links: https://lore.kernel.org/20260725020926.11440-1-xieyuanbin1@huawei.com

Thanks!

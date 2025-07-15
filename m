Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3C71B4231;
	Tue, 15 Jul 2025 13:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586658; cv=none; b=W23K+EwWzBDdcmwhMIlwTZgpm0jHKl/yc+N/DxA3IuYTCToqmncAMTIZDn+Ko5IUiILThGOZLa7bSXxq+nmx6tcynI/rbizcclk+tip6+rtlGoI+1KIOklkYOO+0euOxqGUhWjyrv7jL4kzLcFFi84kYixQpVk2o+984px518r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586658; c=relaxed/simple;
	bh=V8FsxPHOPXuj+T0rNaguzdJVVd/PTiP576+00vDCsS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+dSm5Fxo86VRV5gtKdmEO+DmP+xXn944VidO7/NonrQRhNkWa+BqckLGXdQTfB0ugCzGyAxbhQA8yqbomUdMCNm7Ec24QxFiReXEhy1jmB6yJw/Q6SpiAh/NHltKbmdHUuDxA4Qjvo89hLUK1vTWSTV81OS1jlGRWQp/5VflRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T71ZfWBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T71ZfWBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0D8C4CEE3;
	Tue, 15 Jul 2025 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586658;
	bh=V8FsxPHOPXuj+T0rNaguzdJVVd/PTiP576+00vDCsS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T71ZfWBsx2H4WjYiuDaYyfaHghGay2GPdvcUPyL+za86s9JKcr6Pl2WMSH8Cfzou1
	 OMyMW5Lza1QWC2QsEIgr0oQyn1ncgW+S5oj9By0VvnO/6Fs+/pOPyZ4lAscI7FMePD
	 J1qOzLxIhtcHDaVDwoWctPu3LvKkXsi3OQFSsroA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kito Xu <veritas501@foxmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/148] net: appletalk: Fix device refcount leak in atrtr_create()
Date: Tue, 15 Jul 2025 15:14:18 +0200
Message-ID: <20250715130805.731347782@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kito Xu <veritas501@foxmail.com>

[ Upstream commit 711c80f7d8b163d3ecd463cd96f07230f488e750 ]

When updating an existing route entry in atrtr_create(), the old device
reference was not being released before assigning the new device,
leading to a device refcount leak. Fix this by calling dev_put() to
release the old device reference before holding the new one.

Fixes: c7f905f0f6d4 ("[ATALK]: Add missing dev_hold() to atrtr_create().")
Signed-off-by: Kito Xu <veritas501@foxmail.com>
Link: https://patch.msgid.link/tencent_E1A26771CDAB389A0396D1681A90A49E5D09@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/appletalk/ddp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 70cd5f55628d3..46ca0f1354fde 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -562,6 +562,7 @@ static int atrtr_create(struct rtentry *r, struct net_device *devhint)
 
 	/* Fill in the routing entry */
 	rt->target  = ta->sat_addr;
+	dev_put(rt->dev); /* Release old device */
 	dev_hold(devhint);
 	rt->dev     = devhint;
 	rt->flags   = r->rt_flags;
-- 
2.39.5




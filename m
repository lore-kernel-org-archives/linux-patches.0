Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE042E6D2B;
	Tue, 15 Jul 2025 13:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587066; cv=none; b=UMhn7W1BJSLU3uKVWjbfwIN4Y30qRydn7ZKZIx+hcrAER8GVLdZZT3x0im1kvrVE8gqqShllqOiXd8ri5eNevR6Q/f02yBcgEbiAao9Kfh3rKey0NRqbX4C5aGpykCFIH+omes3DxQOhmg4u6W5Pn2tGALi91VqqNYizcx0/efM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587066; c=relaxed/simple;
	bh=r5Sp3KX0QqbpWlTkdM6QFp/dwTkcsMvejn1T+MFBcSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfX/FEj7Inge1ot6Df6ocYtKSywUPFcdGM5j0ZqBfNTumDQH1eIsuF+U7I52eNNthPAU4771NiFoQXZwHRmaTZdHs4wSQkwuC7PFqsomEwGHW0qjlPHxh/0DDIIPtKNi4WRwNle7zY9AEM3w4UXgErKidjjPxIPqHQ43mBw2hNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EoLKs4+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EoLKs4+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71908C4CEE3;
	Tue, 15 Jul 2025 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587065;
	bh=r5Sp3KX0QqbpWlTkdM6QFp/dwTkcsMvejn1T+MFBcSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoLKs4+XKTaTLgXEsAJC9YSpWcHWnmztyeUb/5ueCTdIh5d0Nn5YJu7PySu/kyo1G
	 TMHkJkpNfdaa7niTmomTicjf3UmssM8/IuYeqQ89rPTaMjmksDqwouC5TwAtFbeFIi
	 4+hcN20QHEvjHxjwrOwwTp0QZqetucZtT3qjKxEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kito Xu <veritas501@foxmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 152/192] net: appletalk: Fix device refcount leak in atrtr_create()
Date: Tue, 15 Jul 2025 15:14:07 +0200
Message-ID: <20250715130821.011750066@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b068651984fe3..fa7f002b14fa3 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -576,6 +576,7 @@ static int atrtr_create(struct rtentry *r, struct net_device *devhint)
 
 	/* Fill in the routing entry */
 	rt->target  = ta->sat_addr;
+	dev_put(rt->dev); /* Release old device */
 	dev_hold(devhint);
 	rt->dev     = devhint;
 	rt->flags   = r->rt_flags;
-- 
2.39.5




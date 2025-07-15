Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222732E8DF8;
	Tue, 15 Jul 2025 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586224; cv=none; b=KhlB+V1hQ9tY0zXuokySYWIEuEWL3FrgW0u7XWOYwk2eA0p1bIwkI+5Sw03SMFEsr/DoRxbZRuFifgrK+nOTfpiaME1ErG4122d36rmdx7AwzLMM/7whzxzLTyChllgJKPoWOlSxa7mNTUUjmrm/gQvYigw2Yx+VoZEb7cbfNYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586224; c=relaxed/simple;
	bh=W72veoatk05AUH3bakbJTZkel/C+KqLpyculeKUu6H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUlELny4OwWoOZRZih+vpIw4P06aMaaNo9rkHVW438jwGFYFylZZYfFuy0i+l9EhEoLApgkq6saqeRAB3TJpVLRvdsiMkXCsYT1l+my+/Ygpb+H/+FBwTf97auxGBwFeKwl11be6+iutXRtubjexmUmJJi+0iUwdVcR80bJiAC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZFDuIbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZFDuIbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A6DC4CEE3;
	Tue, 15 Jul 2025 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586224;
	bh=W72veoatk05AUH3bakbJTZkel/C+KqLpyculeKUu6H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZFDuIbZQBKKIE9GtxnYbBDk2xV4IZ/vRL4ljBBlu12rNz5ps00uuWZEW3BPocDAJ
	 1b2TUysMSPcmb0FzS4y5wYQz6Y/TdtrUmT5WACBbAQMxGj0az6q5jZLV7U5FK0Yw0J
	 WBQzWGv0vFky3OZgCKtA5eLw7+SC/79out9qrLLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kito Xu <veritas501@foxmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 61/77] net: appletalk: Fix device refcount leak in atrtr_create()
Date: Tue, 15 Jul 2025 15:14:00 +0200
Message-ID: <20250715130754.176745158@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8daa3a1bfa4cd..344a38905c48d 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -563,6 +563,7 @@ static int atrtr_create(struct rtentry *r, struct net_device *devhint)
 
 	/* Fill in the routing entry */
 	rt->target  = ta->sat_addr;
+	dev_put(rt->dev); /* Release old device */
 	dev_hold(devhint);
 	rt->dev     = devhint;
 	rt->flags   = r->rt_flags;
-- 
2.39.5




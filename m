Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0662E8DEA;
	Tue, 15 Jul 2025 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585988; cv=none; b=vEiZZFKP0busc44mLf4C2ddeMPTSBENjE9imK6Lwsgcr+hDBrywr4HfY+YF2t/HK0y82kAYI7Fvjeq/ksdGxBQ59YMt6+DDTEndZioPA3BpysrkSAmuJ0Vf3z9edku9+UJExPMmaIUhB16JV0R6h7UuE74SqO80D7ZS3ILx4HPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585988; c=relaxed/simple;
	bh=E55kbhzvuRT5cT7aEJXor8VajOZ/GAx6W+7kpaXBw00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4dwh4EWyZlPOYYV/17DFvRDNduow+pWR/Ekr+Q1zQva2AQ8h46NiepnWOGJSwml/bGMIvREjbZMxwqKvSM/YOE3YCqdE9BgCBCfTEC6pHjZZjkAefLwnAxRFQMXkyczUbu4gZBnLV1uEwjPUouck05o78sIKFuARu5I58sIfg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IThuZROE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IThuZROE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D247C4CEE3;
	Tue, 15 Jul 2025 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585988;
	bh=E55kbhzvuRT5cT7aEJXor8VajOZ/GAx6W+7kpaXBw00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IThuZROEQwE8EGNRkMbyLz6kztUZbdR2mAtwR3ikqHSwNayrsCENyqFw/+Z/1r51B
	 t6d5c5jhR/k3cQQ4SoiW9FEnQMUHnnURD0OVkWKnEGqI+AzKbdnXLjaXO5iSI6D+tB
	 E7kgc1oDrBBBlTcA4HlU8Hc7XG39Qh1wiB6NcZQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kito Xu <veritas501@foxmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/109] net: appletalk: Fix device refcount leak in atrtr_create()
Date: Tue, 15 Jul 2025 15:13:40 +0200
Message-ID: <20250715130802.243529271@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b070a89912000..febb1617e1a6a 100644
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




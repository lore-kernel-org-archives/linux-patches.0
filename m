Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB22013AA55;
	Tue, 27 Feb 2024 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041441; cv=none; b=uCOVgkhJTssRznA7sF6EKZvvVHC49bTOHZekPDQ5EpZlGz1yuOV54ItxC8Ey7Jp4PbQlzfgS4VrU/AaMEcEYymvdU1JyYjl2TtIv0v5PmtLVkjieOxPKan9hzAtBRRzfMfFHKtIjnXYMj8vEmsM5I8/aOjc7QukIfdBMCSCtv3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041441; c=relaxed/simple;
	bh=+UrnVBEFnIAcbVbggo+YRu8yTwF174bm/Zjg1dipNzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofRkP/BRj1/s4YUWMcMaEH1NMJndiLFUTam6hTJkKGTfyZb9MRDhnMRJtWAnsaIbuudqxe+KOxdzZEjVlfOUnCAjxPLL7fW9zA/GSEmrZ+JMMQjjzhCRr1B6L9lpYnv2ztLQMYbH1C8QLidSsPlP7PjJCLENT3vhoC/r/P3hets=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spwAKKyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spwAKKyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D080C433C7;
	Tue, 27 Feb 2024 13:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041440;
	bh=+UrnVBEFnIAcbVbggo+YRu8yTwF174bm/Zjg1dipNzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spwAKKyHwzLO9SS/7iHiJMuoJWXNVVkh5JBwXrqBdZupPSn9ixuyti6AM0EA48VNS
	 CL8N31Mx5KK3mp7XEwL+3voFRAVmX1ZEU7/gkwIabOkmXJn+L2wNbWEIsp4be5TNxl
	 BYD0POjNTWezClte55OX+H3cufeQflNyuC49Zv2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 315/334] net/sched: flower: Add lock protection when remove filter handle
Date: Tue, 27 Feb 2024 14:22:53 +0100
Message-ID: <20240227131641.256872898@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 1fde0ca3a0de7e9f917668941156959dd5e9108b ]

As IDR can't protect itself from the concurrent modification, place
idr_remove() under the protection of tp->lock.

Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20240220085928.9161-1-jianbol@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index efb9d2811b73d..6ee7064c82fcc 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2460,8 +2460,11 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 
 errout_idr:
-	if (!fold)
+	if (!fold) {
+		spin_lock(&tp->lock);
 		idr_remove(&head->handle_idr, fnew->handle);
+		spin_unlock(&tp->lock);
+	}
 	__fl_put(fnew);
 errout_tb:
 	kfree(tb);
-- 
2.43.0




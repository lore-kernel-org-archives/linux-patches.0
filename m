Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711281A6818;
	Mon, 23 Mar 2026 13:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274066; cv=none; b=Ie+IjzJVa+Kb/DKKIt4sJ6RChG7jr3HXPx/6i8mQEJmgs74bMgY7IfBgiCL1jSCb2jiNXIK7j335OYrvENYtLd368qpwOUOIZaBFWdY8osGZHM1A/Y1neb5UJi+BhrrbePZ+MqayxFR5/ygUd0drSiNzhantepjsdJS6rLWY/t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274066; c=relaxed/simple;
	bh=2f+2rcVWzFTTXJX/a4Xmu6MasNCreZ3o2y4k+i5lZZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RT0HOZEslOqGQEa6iprfdJMU5o1CUHtcmu2Id/l0391zdiRLU0VhQxHlAf3j5lwusKL7uXWjZmB0sbEedQinmrY2pJCm61y27w0YSxw+ox3y3urRoowO1otwzU0xGJHBSBVd1aZGxcstvXjrUCu6VFoBvDba0ZPLbz14vlTxXBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VukMmbuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VukMmbuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24F9C4CEF7;
	Mon, 23 Mar 2026 13:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274066;
	bh=2f+2rcVWzFTTXJX/a4Xmu6MasNCreZ3o2y4k+i5lZZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VukMmbukxVdBn/c/fJ2qf0oFC1MDOxmv7Mtm3JUD+iEelj6YYnjcciMRG8VD4g1T5
	 cMTFb2vlMSQGo3ZAJAx5WuWh7AIJ/jck9VwEALD1O7oR7GPOte3+USTGKe72uPMA8s
	 GjoWtyJ5obE6ho/HPtG6QHvws6Vy/T3VBQPnv9gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 098/220] cache: starfive: fix device node leak in starlink_cache_init()
Date: Mon, 23 Mar 2026 14:44:35 +0100
Message-ID: <20260323134507.694186018@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 3c85234b979af71cb9db5eb976ea08a468415767 ]

of_find_matching_node() returns a device_node with refcount incremented.

Use __free(device_node) attribute to automatically call of_node_put()
when the variable goes out of scope, preventing the refcount leak.

Fixes: cabff60ca77d ("cache: Add StarFive StarLink cache management")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cache/starfive_starlink_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cache/starfive_starlink_cache.c b/drivers/cache/starfive_starlink_cache.c
index 24c7d078ca227..3a25d2d7c70ca 100644
--- a/drivers/cache/starfive_starlink_cache.c
+++ b/drivers/cache/starfive_starlink_cache.c
@@ -102,11 +102,11 @@ static const struct of_device_id starlink_cache_ids[] = {
 
 static int __init starlink_cache_init(void)
 {
-	struct device_node *np;
 	u32 block_size;
 	int ret;
 
-	np = of_find_matching_node(NULL, starlink_cache_ids);
+	struct device_node *np __free(device_node) =
+		of_find_matching_node(NULL, starlink_cache_ids);
 	if (!of_device_is_available(np))
 		return -ENODEV;
 
-- 
2.51.0




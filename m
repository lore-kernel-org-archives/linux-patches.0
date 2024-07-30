Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F1D156F30;
	Tue, 30 Jul 2024 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358850; cv=none; b=Gwo8JIpatw166bJ7gCXVe7OIu3wOHBFZmyEHZl6HnB1bZPUxF0puqpqoqfd72jnr+sFwJJpKUMf6MOxNcbKN9dznGPqN2jJ9n/MX85IrcG5QWRIknGyp1ieSIkse/rYl6uzJI6/QbaVbjgHwt5snO915EaRkM+ry03KHdQnnAlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358850; c=relaxed/simple;
	bh=75UHLmRuJW3nJATfVNcFBFjJs6yOaSZGZgjG3pSPOKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDk3CA8VkyFc38GLFGZiIL95Ue2JTzQduUlpVvz/zdNx8J9JBRqq+htP0PljV2Fa9ORNUj9nsTMT6T4NKlbkpW94K2G8PSq1SFneSyioclS1hsOt+pgCG6r2dgbMBE2oeBh3ogFcY2nh4Mo8bd/+Va/ef9E18+Ylw1+pRybJ73g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MslnBZQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MslnBZQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D753C32782;
	Tue, 30 Jul 2024 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358850;
	bh=75UHLmRuJW3nJATfVNcFBFjJs6yOaSZGZgjG3pSPOKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MslnBZQgx4YrmN24wsRAfBteIqNuEsFheFhIA+6V9lSwqjgGwSeAwpH8RWPYGd00P
	 bJ9bb9mt2u6wy4bTT5DgrEfNPOvXUAkSzvziANGBH84slHRjcPZOYSrpNzmd8DiNRH
	 5/s1hDC1lSCd7yfwTMrTrIui0yu2RIUpCHsS5hy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 402/809] coresight: Fix ref leak when of_coresight_parse_endpoint() fails
Date: Tue, 30 Jul 2024 17:44:38 +0200
Message-ID: <20240730151740.564125726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit 7fcb9cb2fe47294e16067c3cfd25332c8662a115 ]

of_graph_get_next_endpoint() releases the reference to the previous
endpoint on each iteration, but when parsing fails the loop exits
early meaning the last reference is never dropped.

Fix it by dropping the refcount in the exit condition.

Fixes: d375b356e687 ("coresight: Fix support for sparsely populated ports")
Signed-off-by: James Clark <james.clark@arm.com>
Reported-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20240529133626.90080-1-james.clark@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-platform.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-platform.c b/drivers/hwtracing/coresight/coresight-platform.c
index 9d550f5697fa8..57a009552cc5c 100644
--- a/drivers/hwtracing/coresight/coresight-platform.c
+++ b/drivers/hwtracing/coresight/coresight-platform.c
@@ -297,8 +297,10 @@ static int of_get_coresight_platform_data(struct device *dev,
 			continue;
 
 		ret = of_coresight_parse_endpoint(dev, ep, pdata);
-		if (ret)
+		if (ret) {
+			of_node_put(ep);
 			return ret;
+		}
 	}
 
 	return 0;
-- 
2.43.0




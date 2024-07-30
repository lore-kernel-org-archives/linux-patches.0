Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD341A6169;
	Tue, 30 Jul 2024 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357482; cv=none; b=lOgV+1sclybPxyK+sb+mhPGcsb2iSkv0YmBHlUb4UB/ckI58GxTkqDNhl9WfUXndKghhHT5ipPaa28/Oabz5w1SWsSSGSno3EDZ7cNOL4PC1P6Jynw0RUO+8LvY7/64QCaZPuo9OkOGL1arJ8sIsefst2HMIadu1Nrw6uCcgawk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357482; c=relaxed/simple;
	bh=IoJlfuoCV+dctK33VXgRhCJ+rZ/U8cVKWw/JPIc+8Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwIx7ymzEzUKftztFGSbIQZyyz5/Zkw29Hl42h3eCMeAAGOYABqmlq1uxuyWFdW3bAsbFHODzZv/xBi8u1Agv7c9QfYNn394gppQTCrmXiW/1wUY79hJhs/klcmfz1y53LyW3/GFw2ykAiBcZncpivIJCNCRNwjxxLfyDDxqa/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yww149be; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yww149be"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2BCC4AF0C;
	Tue, 30 Jul 2024 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357482;
	bh=IoJlfuoCV+dctK33VXgRhCJ+rZ/U8cVKWw/JPIc+8Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yww149beuF6IhyNaPLS5MVmE+uZbuwsNrmxsDWIrDv//uoWTKrqJOM/Uaa93MeJbS
	 gWGWbs48Ij1CAGRRpxELgO3JaiODB5c/zDCbusCmFC9pf1ONJUQtPfzBJF8ZWA/EqQ
	 25uGg3zm3HLI6h8hoVa8/MjhY8PvD4bqKdigd4FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/568] coresight: Fix ref leak when of_coresight_parse_endpoint() fails
Date: Tue, 30 Jul 2024 17:46:06 +0200
Message-ID: <20240730151650.000664672@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




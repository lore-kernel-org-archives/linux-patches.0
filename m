Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F41A19DF9C;
	Thu, 15 Aug 2024 13:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729520; cv=none; b=Hfouy3tYtc9ci4tsqDrAFlVr7amETyEaUuHU983PdO1uMU/uhwH0aWV7LFxJjwHZx0V30bqP4mDqXwvUhKVE9hTmziXxyrBClJ9kiQ46+Jj6A5sML2Bchc8KorLBNIJ/+GWcYVg11/WLOKUFXTjXSlukqjXvWdW6NgK/buAIvgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729520; c=relaxed/simple;
	bh=q6BbllWiGiz6uz+/tdu6OFCfZVl7AXenS8eYATFU8VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw0PKmc6GEc1oBSMYGculagi55yYT/XWwoJP8K6qIyrGTI4kZy8EwGeS3r1RBArOqgFufXqd0vDtrw0sUav4U4pACUWOdHRn45xi11eq2AGDYD8wW/mhy3B+kS6JOY2dSQG4DIZLcPvSyzuT1dzFvA20BvM0FMdI6b76lm/DAAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoTgLvmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoTgLvmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A48C32786;
	Thu, 15 Aug 2024 13:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729519;
	bh=q6BbllWiGiz6uz+/tdu6OFCfZVl7AXenS8eYATFU8VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoTgLvmwRCChFsPySH/aGpfLPW8l6Xn4DorPZNiOdgBFJ6dXW4AUaNlfaNsDMgNfq
	 XQ6VT/B9Fv76PRrSW3YEgLvKvB3057olTTotmnp+50T9VwnOeFXBcDrwNHatXmNgiS
	 iOxPAK28R5x69jgn4ZBEa8hcF8HnOvI2QOJypaPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/484] coresight: Fix ref leak when of_coresight_parse_endpoint() fails
Date: Thu, 15 Aug 2024 15:19:41 +0200
Message-ID: <20240815131946.044828330@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c594f45319fc5..dfb8022c4da1a 100644
--- a/drivers/hwtracing/coresight/coresight-platform.c
+++ b/drivers/hwtracing/coresight/coresight-platform.c
@@ -323,8 +323,10 @@ static int of_get_coresight_platform_data(struct device *dev,
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




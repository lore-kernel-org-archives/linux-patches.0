Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFFA1A617E;
	Tue, 30 Jul 2024 16:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356378; cv=none; b=KAZA4LJIhytzVc7wA1EQc74/8U7kSVrgj0HTYBhbXnEEnOQDxnI6eziSSalCZJJfiZTyIdho+byEdOIwa8r10135CUZq6KbwZwiXdvYBy8N//U9aR0G4VDY4Em3qhfSFZxvZ6tRsPfQPD0kiLzehVowgdgvz58QQ9EpGgI5KVRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356378; c=relaxed/simple;
	bh=s+Pg4eub4TGFin7pM4uqTkPgu4JNtOAQOYV3n32vkQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgmmwIaUg2nLmt+tMWi42NrURnGrzqIoDv9eC542y5j3NkgqpQBnXKBnvEB7u9xNloviPERFLs3zsF6x0clEgUoqCgIX21+ohKv9qV+qs7lYXpwdaSvrUTURoBwiME+dOxrBDxSvbauFRMKo/j80PjI58jha4o1TXrLN0LBvAsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jO6iYgWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jO6iYgWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71374C32782;
	Tue, 30 Jul 2024 16:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356378;
	bh=s+Pg4eub4TGFin7pM4uqTkPgu4JNtOAQOYV3n32vkQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jO6iYgWKb9B925eV8WthmFElr3tB4objuKy8UIo7N7sw/o9Q+0ULLS5GABrUKeTrY
	 Cjn42UPLSMriPQ0n6W37d0O7qmoalKEhqXI37RbiCBuAAqDk56fN0NZ0P8M+Yitv8S
	 CbGLPwiLJpg4jFgkj9yLBJIGw0r3oBhVSXPH40Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/440] coresight: Fix ref leak when of_coresight_parse_endpoint() fails
Date: Tue, 30 Jul 2024 17:46:59 +0200
Message-ID: <20240730151623.139918592@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4758997141046..3f82ae07a18e5 100644
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




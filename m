Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4543525D525;
	Tue, 25 Mar 2025 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906349; cv=none; b=Q5Tu83HzrmPj1z3YW15ioPwdQwg69mZvrU7x7N/4g1N/cg0YY/iy+tZdbx+sPMY9WPUDmaQOAJ2AE/GsaL1gMjSjlIHf+YP7uZxeKUCJULcxsK9QTpzVH4FI4kqmWOT0R7ZO5pbghbNSiTwR2pfVasPy8YFw/SAsQdxi6FQq9UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906349; c=relaxed/simple;
	bh=jIGDIWxke1U76KELTLDa1FrZbDpb+6vaZBHxxAihR3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COBYRPLIG+zPZBpoLln5hGYbJ7dtJ7woEKckHjpHL4VTZ7ZD4o5VUujbQVhREmBWmI1dxg16JuQl1PWVWMzEu6InMW17A8mGtiszyBObdx3Q9JI+IYHBIK/pL8LAeX5YShuKZeQQMIX6/UnFRIHv0f2aDPHG8QBPLeBIxCrVGpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGe4Vp3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGe4Vp3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F50C4CEE4;
	Tue, 25 Mar 2025 12:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906349;
	bh=jIGDIWxke1U76KELTLDa1FrZbDpb+6vaZBHxxAihR3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGe4Vp3VEumlog3AHbQUAOm+jbcipZ91iG05+o7MUy2RYc0hn80oDM5TVeDj4mOqN
	 Qy8oFcI69xGSQbqv09JfYHN3r27UeE5l9B1+RmwjyvQ59OOZooLLMk/andAt8mRGAw
	 uuojLU0GYgBCg96psu4E8k8sp24fdW4njZNQUFqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/116] devlink: fix xa_alloc_cyclic() error handling
Date: Tue, 25 Mar 2025 08:22:07 -0400
Message-ID: <20250325122150.229582583@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit f3b97b7d4bf316c3991e5634c9f4847c2df35478 ]

In case of returning 1 from xa_alloc_cyclic() (wrapping) ERR_PTR(1) will
be returned, which will cause IS_ERR() to be false. Which can lead to
dereference not allocated pointer (rel).

Fix it by checking if err is lower than zero.

This wasn't found in real usecase, only noticed. Credit to Pierre.

Fixes: c137743bce02 ("devlink: introduce object and nested devlink relationship infra")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index f49cd83f1955f..7203c39532fcc 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -117,7 +117,7 @@ static struct devlink_rel *devlink_rel_alloc(void)
 
 	err = xa_alloc_cyclic(&devlink_rels, &rel->index, rel,
 			      xa_limit_32b, &next, GFP_KERNEL);
-	if (err) {
+	if (err < 0) {
 		kfree(rel);
 		return ERR_PTR(err);
 	}
-- 
2.39.5




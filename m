Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4952FD1DD;
	Tue, 30 Sep 2025 15:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245796; cv=none; b=KsnZiSGaaTejpiPHkC55Q4O6y19QvAwiBbgMFgQLQhmzYwwl1sgRbz2mho+tSNAYm+FrifDYZ6pEIUB8zkPT4mxwZvnQjLOXu0Fx2+Q53gKrjY8O5DPgyg6SERr2VN7HGDem0DqgM6PGIW4gLIBMN9koOMu2/MI930Hs54t+LFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245796; c=relaxed/simple;
	bh=OaML9MWwHuLo1pp4jiI9zYTOs1f+mxGHblojGl6Rces=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM4mbDHRIn9wUuMBIE4foRjKPJN6UfVKxlTs7hDd9xf3dP1hc+q+k59oLyNiTdxwoEIap1glvJ0QiTUjwG9GcIYQXkZrJznivNXj5NSI+MKM896s2NAQxTaV/YpkUvE04ENpZpTXKw+rRcomc3/bA2QANwqK4GJqGFtV+roWWJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMXrhL7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMXrhL7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4A2C4CEF0;
	Tue, 30 Sep 2025 15:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245796;
	bh=OaML9MWwHuLo1pp4jiI9zYTOs1f+mxGHblojGl6Rces=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMXrhL7edvUASIS+kP5+ApUjSApGoBummvLaMsboZcFhyDxt8vcPtcOegaDGiIc1U
	 juJFkA4gg/cdpGI1Z7f2dyNJcQV6tIwCsmNVkF7koNAjBmo24qhtV1CL2rHAIFXc+x
	 itMMb9eSwxNxhWZU9UNDTCsCWzjLLxRd/icUeUoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 51/91] octeontx2-pf: Fix potential use after free in otx2_tc_add_flow()
Date: Tue, 30 Sep 2025 16:47:50 +0200
Message-ID: <20250930143823.302970654@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d9c70e93ec5988ab07ad2a92d9f9d12867f02c56 ]

This code calls kfree_rcu(new_node, rcu) and then dereferences "new_node"
and then dereferences it on the next line.  Two lines later, we take
a mutex so I don't think this is an RCU safe region.  Re-order it to do
the dereferences before queuing up the free.

Fixes: 68fbff68dbea ("octeontx2-pf: Add police action for TC flower")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/aNKCL1jKwK8GRJHh@stanley.mountain
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 46bdbee9d38ad..635cfb9a3e2c5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -1116,7 +1116,6 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 
 free_leaf:
 	otx2_tc_del_from_flow_list(flow_cfg, new_node);
-	kfree_rcu(new_node, rcu);
 	if (new_node->is_act_police) {
 		mutex_lock(&nic->mbox.lock);
 
@@ -1136,6 +1135,7 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 
 		mutex_unlock(&nic->mbox.lock);
 	}
+	kfree_rcu(new_node, rcu);
 
 	return rc;
 }
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D5823506A;
	Tue, 30 Sep 2025 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244696; cv=none; b=oICuRemQAgeKUX1cQ/Obka2SM569Tf33g9oHdObX/LYN6oKEjjJj3OMfYH1hp7g3c6u4IWmimlinTgTxQv8PB8+qMWwzw6vhcSUglB7Qa6P+h4/rGKuSWHYcBuXRRoNHV4qXKrbA/VDSZIFTp99e7IiLHjSOpUfmYlPXcsuwuJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244696; c=relaxed/simple;
	bh=H89eo4J8OTdZIwHcaGOHuFgj49HEm1PsfEFU7N3YFEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnnyMu0WIKjugXjckuGyDFSar27+nTVcXtoQivnNnBl7+lD3VGNh9whcwp4A2Kk8qDTgERwyVuzc27WidpJJds1P4FchjA1iriVRqD5HQ3U/LWpxAmT6u0irI6ztRWGBTKzVZg/fachQMj3yfoOUB4iTU8EaF+3CxAGkvjH6G3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hm9dII+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hm9dII+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B83C113D0;
	Tue, 30 Sep 2025 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244696;
	bh=H89eo4J8OTdZIwHcaGOHuFgj49HEm1PsfEFU7N3YFEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hm9dII+pdTTWdhg2t8CifJRprLaa13NpMiLoXBGHiki02e9QHCvW/jcL0MdqV4jYU
	 Kk+2oOqb922S5BZMxPMA2Arf52k0kgb8+4EdbNEos17D1sbenJ7edb+SfjIX6wLKAZ
	 CL/dVwE29nrhtaX5ik+aprX54SwBugGYWEXn/4+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 085/143] octeontx2-pf: Fix potential use after free in otx2_tc_add_flow()
Date: Tue, 30 Sep 2025 16:46:49 +0200
Message-ID: <20250930143834.619969523@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 5f80b23c5335c..26a08d2cfbb1b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -1326,7 +1326,6 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 
 free_leaf:
 	otx2_tc_del_from_flow_list(flow_cfg, new_node);
-	kfree_rcu(new_node, rcu);
 	if (new_node->is_act_police) {
 		mutex_lock(&nic->mbox.lock);
 
@@ -1346,6 +1345,7 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 
 		mutex_unlock(&nic->mbox.lock);
 	}
+	kfree_rcu(new_node, rcu);
 
 	return rc;
 }
-- 
2.51.0




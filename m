Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DAA38B7A0;
	Tue, 10 Mar 2026 11:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142132; cv=none; b=RjE/Jge3gFRaHf0CBGsNHeIlgKYxq4Kjf9oV6HVwoPURApqUIbB+sH1MbtUiP01QguxVAvQ47LSZ3JccfnKMBxN50RmOSOXGB+b8FIBkPGHo9izPovqCJEr462F8I8KUVF3n0+oCAmC0IX+zWE6lYwhlnu9yy9l41Rw1pOeaAVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142132; c=relaxed/simple;
	bh=iA+bb7YCy2vJWAMJVjkWjekAw+Evvtm2/Scw9QkUAVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqSsBw0+HCLbzg8OGLhWQgXs7WtT0WI57fvBjIVHxO+m0bJO/f3zgfnDymSseiJoIwgP14ehGUJQloW5HqraLcQVw+7mH2Qf38o+MfKPlXx7ANw/sBWwySi7lepyIvBFzD51jj+OzwU4EK4Uz2wdec30dFaCbaplrt4Gu/Ytq2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeoF5qfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeoF5qfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A10EC2BC9E;
	Tue, 10 Mar 2026 11:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142132;
	bh=iA+bb7YCy2vJWAMJVjkWjekAw+Evvtm2/Scw9QkUAVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeoF5qfRakhjoF0MSL8yduJWQF2lMqbP+3FkAtBr/09v7xnLeTldLGYyYJb30+ytZ
	 zoMpWYD7zG07VbgwckQEPyuvTaMHT3EgfrWXxXbgZnyKdyvozVD3CZaMTu6+2BxE+1
	 brdBF2dkrbWa6MJKpZGFlsbBqwGDQ7TPVqq5svN01546oxTiF9so+pkl/bNFrCc1yZ
	 5/8g3mqE8mGaCDFvwbYJgkzekFDy7wKuPOKTkdgEkn/2V21YgPR0pGXptEPyYNeBjg
	 pxgQMkfIkYjWvGy9kt3OHZH5oYnEtBVUb299BE4JhRWc4SxvDTPYyOtIsveBjZHPw1
	 BTkLdwXBFzqFg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sreedevi Joshi <sreedevi.joshi@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 220/314] idpf: Fix flow rule delete failure due to invalid validation
Date: Tue, 10 Mar 2026 07:17:59 -0400
Message-ID: <572dbc6e73a26c3ff6eeef4233552db48e70adf6.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sreedevi Joshi <sreedevi.joshi@intel.com>

[ Upstream commit 2c31557336a8e4d209ed8d4513cef2c0f15e7ef4 ]

When deleting a flow rule using "ethtool -N <dev> delete <location>",
idpf_sideband_action_ena() incorrectly validates fsp->ring_cookie even
though ethtool doesn't populate this field for delete operations. The
uninitialized ring_cookie may randomly match RX_CLS_FLOW_DISC or
RX_CLS_FLOW_WAKE, causing validation to fail and preventing legitimate
rule deletions. Remove the unnecessary sideband action enable check and
ring_cookie validation during delete operations since action validation
is not required when removing existing rules.

Fixes: ada3e24b84a0 ("idpf: add flow steering support")
Signed-off-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index 3e191cf528b69..6c0a9296eccc8 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -291,9 +291,6 @@ static int idpf_del_flow_steer(struct net_device *netdev,
 	vport_config = vport->adapter->vport_config[np->vport_idx];
 	user_config = &vport_config->user_config;
 
-	if (!idpf_sideband_action_ena(vport, fsp))
-		return -EOPNOTSUPP;
-
 	rule = kzalloc(struct_size(rule, rule_info, 1), GFP_KERNEL);
 	if (!rule)
 		return -ENOMEM;
-- 
2.51.0


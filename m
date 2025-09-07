Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E114315A;
	Sun,  7 Sep 2025 20:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277635; cv=none; b=DyWnAlg3WJllEzla8DlvE2mX0vJBhDYt9UuLODf1ZiKdsmzy9JqLeAAlLqWvDxTfTgfixLdu2W/Vv+G7dPXpnn82L9gDwRq6LS29jNJb5pk5hixMtT49ol2AuhHyjUEaU3mrxVa1AdiKXoebBO+ct2vs2CfZB6S2lPOVxOVqf1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277635; c=relaxed/simple;
	bh=NU58ET4J7M6strQWVIRGP7SpqqmKykpjVr1eTonEZH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FATFsx/huxB2IbfYQ/qAJZIUmzo0aCGVCDjyC6tAtq69SaYzJdYf5I5Am21t4+FN91o0NdYAsophjRUV8cfssKIBbiSsogi2zc2GwbtYmnyNCDM7NSKy1dnfjJlt39tptlrSMmxPaubVqj76ZPyLreLz7nWi1H3+f0xCh/Mk9Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCDPE9iW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCDPE9iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7EAC4CEF0;
	Sun,  7 Sep 2025 20:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277635;
	bh=NU58ET4J7M6strQWVIRGP7SpqqmKykpjVr1eTonEZH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCDPE9iWq/IdLbFJ1u7NjnS2QUtpIB+tiESU+uw7UpbVjS9kMASG/D8lO5KS2BTd1
	 ibAmvnoHEx6Rk6vnrIv/2Kqf1DNpV3ULN86l+e5yVrpcUlYrtQAldrKzwpafWvkgsa
	 tbalFLn24vyAXrvWOS4mYWK2wQAnoWKHLIBjCZp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 069/183] i40e: Fix potential invalid access when MAC list is empty
Date: Sun,  7 Sep 2025 21:58:16 +0200
Message-ID: <20250907195617.435343994@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Ni <zhen.ni@easystack.cn>

[ Upstream commit a556f06338e1d5a85af0e32ecb46e365547f92b9 ]

list_first_entry() never returns NULL - if the list is empty, it still
returns a pointer to an invalid object, leading to potential invalid
memory access when dereferenced.

Fix this by using list_first_entry_or_null instead of list_first_entry.

Fixes: e3219ce6a775 ("i40e: Add support for client interface for IWARP driver")
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index 59263551c3838..0b099e5f48163 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -359,8 +359,8 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	if (i40e_client_get_params(vsi, &cdev->lan_info.params))
 		goto free_cdev;
 
-	mac = list_first_entry(&cdev->lan_info.netdev->dev_addrs.list,
-			       struct netdev_hw_addr, list);
+	mac = list_first_entry_or_null(&cdev->lan_info.netdev->dev_addrs.list,
+				       struct netdev_hw_addr, list);
 	if (mac)
 		ether_addr_copy(cdev->lan_info.lanmac, mac->addr);
 	else
-- 
2.50.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617B51B424F;
	Sun,  7 Sep 2025 20:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275949; cv=none; b=huWHzJ7oAMVCSdFaZNa3UmGxHfFpf9qp28F+I7uhC841mlqjurasWT8Ce2fqO9qW3khxPsLlxQN5flgrBnLRvcwAcQ8MhEzbIrpFvLQqC7jNLCXXiyO7vMtB7w5Y1/WGdD1r8rCnIVwvzcJQN9ouC0yPrURevUI7u1V/ZyyPTU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275949; c=relaxed/simple;
	bh=lAvU5x2uhqLG9Ur5/R6x6gnhAzw8UrCs6CSaEvu1ErY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bK3wGlYYswuQaz48MIzrsEZbY9wiormNzIgeyRlm3oOD2LPl6YRl9UUoauLB0sp2D6eJcIqXjGN+ssySDxAuuLPJ6fLy7hypjVNy73eB5zoZ/kacmN2mN1/zPoxyqf66QB/YowV0hh4QcjA7+Oge7ie86uAM/BfPKNU2CAQCo8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjxQZqej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjxQZqej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D806DC4CEF0;
	Sun,  7 Sep 2025 20:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275949;
	bh=lAvU5x2uhqLG9Ur5/R6x6gnhAzw8UrCs6CSaEvu1ErY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjxQZqejKK+lBV0mJaTDrBEKbmW0eUOBAZWFbzl00c6jz6PmUkJ/JjLAMaaNvpXl/
	 pIXjSQQMNFfNUyGUOiyMI6WEngu1AQ8dj7a3PNU15SDAKFjQiE1mPfSs2jR8fdl95Y
	 qRAug+7VtUJb+5WP18RxdnH4mPfk59OtkcKRij7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/64] i40e: Fix potential invalid access when MAC list is empty
Date: Sun,  7 Sep 2025 21:57:58 +0200
Message-ID: <20250907195603.851453929@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8bcb98b85e3d9..4af2a4c591067 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -362,8 +362,8 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
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




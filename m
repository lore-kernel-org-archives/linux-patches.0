Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DA8284B59;
	Sun,  7 Sep 2025 20:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277012; cv=none; b=JBBojQFqY4WL6cfXmHlmDO9CyIZHKNeRxj/o3b8taKG6MifjhStHnQCqAZqnCbUXada3ylmSySA7GqdqACthYpkxesfADzCBckR2vzURrjDp8kL/mRi8PUJCXHOmvoKR8zNZO4yjlQnj6Q1g2/IeFVfxKRyaQ7B1LBlgMS/oBxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277012; c=relaxed/simple;
	bh=VA1w/hAgWj7ON8GxW2S4y4lBmQgeMZxE9slGP1v9KW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2sjKBCzzWKQ6+o7W00WeiAlBP0PWC3+ioNHdNtWmkDTTtpwZLY8pRtNAgtUSCMWzI1voQc35tLMRQ2kR+z1MYDpmfpQPVNVwo81Z7RuTaamCf95Gy248UzPAKuWftKCZsi/PuEXC1UPiUJQ/Fad1stsPLIA6htbx0itNHLO49w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DO2w1/Cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DO2w1/Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799D9C4CEF0;
	Sun,  7 Sep 2025 20:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277011;
	bh=VA1w/hAgWj7ON8GxW2S4y4lBmQgeMZxE9slGP1v9KW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DO2w1/CzZA8CiDhlY7XvfWNzmILr4R/mt/FywVblFyR2cbY3yuhkuuQoUREPL+pID
	 K2lCHfUaz1rSI+y+tKxrJN2U7a4czdxNJkLF5TxL3raprlAmGkLCrH47l+oCmY3PrK
	 lNo044XDp4++e7ttuagQIOCc1RsPMQ3GF0H4SAaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/175] i40e: Fix potential invalid access when MAC list is empty
Date: Sun,  7 Sep 2025 21:57:33 +0200
Message-ID: <20250907195616.210973889@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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




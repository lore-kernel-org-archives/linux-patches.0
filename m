Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435FE1CDFAC;
	Sun,  7 Sep 2025 20:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275867; cv=none; b=PvZVh5OQciwIRmdxZl7uuQuXvAKyP9uvuqzzV5Z3lfBAsn4RnCyx9RxzeN1LE/C7vdwvbDBGzxSl1S/SAeLXwVJnrsbCY+paMMABgtqb7NePPeLni8RL/Ae/HfVxEnzE0k3aEvDSqDQFg94PcsNppRTx5q8z+bTCspnD3TmFxxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275867; c=relaxed/simple;
	bh=4nBV7uUXuf4pQ8FmdnSxKLWSOVM79yApOG+LCxzKdao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T40TUot+cO48KSSBmOpKQrWex00nbrWBO3EACDi0u5XX8dDzyLAZburhzLaZU7CmsEQKeJUSLaYToKWfy9yFZrtr6tPIg8PMQvhBLtpPOfQtskYFtR9ZCmT4XJcKAsERM6QXNGf6b0+lXt+hf9ncMDRYIVaEdwcduH35yYDMnBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9tIFnAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9tIFnAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA111C4CEF0;
	Sun,  7 Sep 2025 20:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275867;
	bh=4nBV7uUXuf4pQ8FmdnSxKLWSOVM79yApOG+LCxzKdao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9tIFnAYmP5yLMnBmhYNe7M64I2AzTLDgUYY5lkX9ynmJHHmaK9qyH36fCya9mQTJ
	 Qg+34juPvAwOy6F3jd+o1U3heaES3JxrS/S7+6Uk5UvG9V26nKCO6YKRDR/J/LfL/I
	 JK4q6HrWa9gSNBl0wgIo2PhHM/dIvzEtYlWBmf20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/45] i40e: Fix potential invalid access when MAC list is empty
Date: Sun,  7 Sep 2025 21:57:54 +0200
Message-ID: <20250907195601.205513770@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 10125b02d1543..b7c3625aec154 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -320,8 +320,8 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 		return;
 	}
 
-	mac = list_first_entry(&cdev->lan_info.netdev->dev_addrs.list,
-			       struct netdev_hw_addr, list);
+	mac = list_first_entry_or_null(&cdev->lan_info.netdev->dev_addrs.list,
+				       struct netdev_hw_addr, list);
 	if (mac)
 		ether_addr_copy(cdev->lan_info.lanmac, mac->addr);
 	else
-- 
2.50.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E671CDFAC;
	Sun,  7 Sep 2025 20:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275615; cv=none; b=iygF2BmjwkIziDd0s9qA3LL0RW5uJ8O8qX4x/bAh7tyPtm3JfMbqBBuQT8mYKr/TMo+u7A+9e4fVJWFPsnk3/V1J9DfNO5hMH24hMj7eadc2Kg913rYleYr6JQ5tvwbCLXKo6PsmMruQ5oefQ4tl+uiGG8N8Zd7aluA+ZNoD7uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275615; c=relaxed/simple;
	bh=nPQxtFuWq5SPfsur8T0HTOWWQ0xFxWWv2X6Io3jnZB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz4OH/rLwIj+8T91MvrDF0wM955XR/gF0DgIYsIrcoOOmsNWQ8qDk7y3q9Zk8YWVG0jV5zQlVSuTGGbZ9/ktuFRnOAUiDorM65fwJJ104I3ZjsrVb/NWxN8Aw77Qfyhcj6i0y/Irm3+baUJ7WargxbuxmO0kjvdDcUZBmqH7DAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghHsql4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghHsql4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AD8C4CEF0;
	Sun,  7 Sep 2025 20:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275614;
	bh=nPQxtFuWq5SPfsur8T0HTOWWQ0xFxWWv2X6Io3jnZB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghHsql4dS3zlk5wJGptHszrajrgbaAjN0uQGNzknkBQ0SKU6fKQ+Xh49cChRPwfvR
	 riGX1SpzxkuYNfNYz3Ot2D6yW1wkmlLtl4jI1vAbrpwSnH5sCyOV6+6fFRmCpA1tnZ
	 VQtH8QTZ4gOlR3WOHl7NLWds32KP1K37Nre6Te5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/52] i40e: Fix potential invalid access when MAC list is empty
Date: Sun,  7 Sep 2025 21:57:30 +0200
Message-ID: <20250907195602.273245761@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b3cb5d1033260..af65321a68886 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -318,8 +318,8 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
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




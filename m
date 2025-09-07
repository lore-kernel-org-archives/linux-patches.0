Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723D21A9FAA;
	Sun,  7 Sep 2025 20:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276544; cv=none; b=PH8YIekLgQ/F3JvQbNDC4Itx80b8mn8SPMXSjjFC1Tp68ZUB5C8PjK72Yh2lQamE8ZVTj9OMMI8BWozdRr0/jcl+Hb96KyKUnOt2dvp1P2cw2Blz6XSPRTybbCWV2dTjD7wtQOOU8oSVCCrS6vuk1VPdorinpqZ40tBqGw3gQfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276544; c=relaxed/simple;
	bh=WDFplE1AB3GI+VpN0aGegtvE2jAd/PVi89QwfCf1ElU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qV9gLvjQL0yIVqyjftUMATkoR8VyzhfVz7Ke8TAf8sYeR07kYad1IPn2ImhOI9LDrbCapUdJsD92vJXSBUxFQvDh7s8QvtZqL3OzVGD+IIkzE6zryxadDjeqX8AHBXWgPZFn2GbGum9z1WvKrOFnYN+mKvn+duKahMbuqrjUC2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CY7f/Pm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CY7f/Pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB42FC4CEF0;
	Sun,  7 Sep 2025 20:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276544;
	bh=WDFplE1AB3GI+VpN0aGegtvE2jAd/PVi89QwfCf1ElU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CY7f/Pmfj8hlNhaRgItA3VOmLsSbA2bTZr5r7eUNPeMYMFDjlrIdrHlq2PSylbFg
	 NxQxUi5dr0cTiceBLSILYX5qeyZ/QefutyRxjwqQUKWkU7z6TfsBen2yLUqR0Rb+J2
	 bgDcjF2qymzJLGD3KWx6q5fSspj4L8/PZwf4Q3fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/121] i40e: Fix potential invalid access when MAC list is empty
Date: Sun,  7 Sep 2025 21:57:48 +0200
Message-ID: <20250907195610.655819351@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 306758428aefd..a569d2fcc90af 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -361,8 +361,8 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062171F09BF;
	Sun,  7 Sep 2025 20:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276185; cv=none; b=o4LRjuXo4KcXh/GI52Te+/dd7Q8jYl6OeW2Msf0jGL5D6yB6DJjVke/Ql6v1DTBKayYl/mm67fgSDkC18u+OgnRdQTpm2lgOEcwAT4vMlD/Qk2+V2T88CGhXskzwr/WqGWguhZSomqmhES2kvMG+njNVZibrGtUaAX8DunwY67U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276185; c=relaxed/simple;
	bh=p+LcjsMegpbe276hux7Csf4d+hpC0M7FbQc8emt3r80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wfqu9NnA7uaP8Dm3ZG1KmIfGYxW//948OmnvSybcL+SGMQOGzmEQl1jJ3BECiP84A6fWVeHVPk01hhSwQDqnGQhOf4aUTyZYZ3/Pi3PtgFuQmrKYTazGAFxC8Gsf37cpd33Ut8vCtE7P5kYPys/Cjrtgsi/yharmXjfX2JWleWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfSI9naJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfSI9naJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37334C4CEF0;
	Sun,  7 Sep 2025 20:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276184;
	bh=p+LcjsMegpbe276hux7Csf4d+hpC0M7FbQc8emt3r80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfSI9naJJuAaRB3Yongi7khQGlrFd2c9pav8T8M+uZdMVUmJ7FB9DZei+BSTjQDqy
	 HE1abBdVN9+hwn77r8jbrxBoWqVwULmAroINww2AkOJRYghsy7GCj51gJrS1M1mda+
	 raFOPYAEblAjkfDBwmUKqG3lV9exd5l3S+yVIqms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/104] i40e: Fix potential invalid access when MAC list is empty
Date: Sun,  7 Sep 2025 21:57:42 +0200
Message-ID: <20250907195608.346152335@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a289f1bb3dbfc..86fd82412e9e4 100644
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




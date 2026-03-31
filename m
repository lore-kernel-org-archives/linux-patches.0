Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7E941B373;
	Tue, 31 Mar 2026 16:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976150; cv=none; b=b0wetrCRHPIA7lYT92spcqhxt1/8UU7X5M4oHqm3Pif5cezDmUl2oQTvJhOIVmORjZCkroKoQbYW1lnCr5xqe+Ojij/U9whZhQvUOgjh5YZg8SKZ16+QIuFA2FWh3tjdEHSH2rC3DsM6nmmiNwKYrkPN6CG+bEg8PiOjyy9urjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976150; c=relaxed/simple;
	bh=n4uPy9im4uA85AD6+cSENbxGVjUqHaozwivBFvMVmF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVMyjhE5JTPlDf1DtoNBwC9lqiKx/f6htZget+tQ/8z/ovaq9ZdJ6HppkXEwwWF9EEV7qsPknTPblGX/FGFzwDbSAIY/hhgWINzYY04jx9DssK8zYuqOeu3sd/KlC+oFUw2IH3lkynuc0NtjVuD3af4dgYI1kmv9ZgipS3Qn1vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFbhYDUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFbhYDUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BCDC19423;
	Tue, 31 Mar 2026 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976150;
	bh=n4uPy9im4uA85AD6+cSENbxGVjUqHaozwivBFvMVmF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFbhYDUbHTBi97EyMe48jwJmc6awbwvZ+5HgVWY6ukBJ/EcLnfGEOalLwVfO8v6q2
	 IIkhffUp6UkJ2/1Nm3hS7c1QnBXE1FBSYhYBiE7OEU71dkrV+pdCw4Fi865UhHcdlA
	 PsW8ZLntS1OCQTcbMSJSryKGNnna721os7mJdef8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/244] phy: ti: j721e-wiz: Fix device node reference leak in wiz_get_lane_phy_types()
Date: Tue, 31 Mar 2026 18:22:57 +0200
Message-ID: <20260331161750.150093385@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 584b457f4166293bdfa50f930228e9fb91a38392 ]

The serdes device_node is obtained using of_get_child_by_name(),
which increments the reference count. However, it is never put,
leading to a reference leak.

Add the missing of_node_put() calls to ensure the reference count is
properly balanced.

Fixes: 7ae14cf581f2 ("phy: ti: j721e-wiz: Implement DisplayPort mode to the wiz driver")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20260212-wiz-v2-1-6e8bd4cc7a4a@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-j721e-wiz.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index cbcc7bd5dde0a..84c655b427a00 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -1426,6 +1426,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 			dev_err(dev,
 				"%s: Reading \"reg\" from \"%s\" failed: %d\n",
 				__func__, subnode->name, ret);
+			of_node_put(serdes);
 			return ret;
 		}
 		of_property_read_u32(subnode, "cdns,num-lanes", &num_lanes);
@@ -1440,6 +1441,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 		}
 	}
 
+	of_node_put(serdes);
 	return 0;
 }
 
-- 
2.53.0




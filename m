Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BA5280CFB;
	Mon, 13 Apr 2026 16:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098084; cv=none; b=c7lEIoqw4rf52h+am/WJ44lGrkrBDKDZLZg9aLoM2+IfH+i36kTK/e1cb8GxVWMDn4hGM4MT6SUQjCyL5qLvgkPWp7TVW+8ap9IFqdyx+PuCXnWF9OPKtvwRUOfNDMXtBYYNUQyhONETjlu/QKq451ol3nBsRs9GqkOMQvWWh2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098084; c=relaxed/simple;
	bh=Y9ie98FYiHacl2VCSErzM7/QvVmXQeZlFeelpA53P+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNsAgKmPi92G6Xjp4q5XPIR9c6o4ztlIgOxhMDpElqgaCd9Xjm1r6fKOrJEkLu8MJpF4u9ZqA4kwOO1a/SbFDI9Bit/smbrzSH98xsgUhGkmvCqxIoWsaZOB/KApQD955adH8gbtHXralZSstUwWNrX0/r+zeUaOvJNF6J0z0+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfDIyN0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfDIyN0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E64C2BCAF;
	Mon, 13 Apr 2026 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098084;
	bh=Y9ie98FYiHacl2VCSErzM7/QvVmXQeZlFeelpA53P+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfDIyN0IcZI/Qo4ShBls+CUhyMlUKoSatn+evE0R/IsCgvNBUwp+jCm9GCwAmA160
	 waP1LvaQeMpPRCu5/7KYXb31mJzHWKoIa9+D23+JZJeYCzHahNkLKb986ID3/7N/oe
	 DTt67B/zQpq6TQsqBC+0ab5TeUjkIP58G4lEzm9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 387/570] phy: ti: j721e-wiz: Fix device node reference leak in wiz_get_lane_phy_types()
Date: Mon, 13 Apr 2026 17:58:38 +0200
Message-ID: <20260413155844.973864654@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8963fbf7aa73b..a3908a579115c 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -1116,6 +1116,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 			dev_err(dev,
 				"%s: Reading \"reg\" from \"%s\" failed: %d\n",
 				__func__, subnode->name, ret);
+			of_node_put(serdes);
 			return ret;
 		}
 		of_property_read_u32(subnode, "cdns,num-lanes", &num_lanes);
@@ -1128,6 +1129,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 			wiz->lane_phy_type[i] = phy_type;
 	}
 
+	of_node_put(serdes);
 	return 0;
 }
 
-- 
2.53.0




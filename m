Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FE728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641ACC433EF;
	Mon, 12 Dec 2022 13:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851047;
	bh=302vsy+hS5NOzLxXUHScNR/uDxhaNcReQrgoeOjrDZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJWhf6tg6wTjPfUi0hbTm6kzrpUdD9pVDLFUNnEY2oQCVBgXwU8ofVK56TN7c7l5h
	 DlE+MztXrh2WOAAIr12slryERi6PyR8wOsJBbnZIALk2izffjLyiehAkx2mHgFzpH1
	 svxAXIwA/vgjapyNAXeMLrh0zxRktynlljwymNzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/106] net: dsa: sja1105: fix memory leak in sja1105_setup_devlink_regions()
Date: Mon, 12 Dec 2022 14:10:41 +0100
Message-Id: <20221212130929.134698459@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 78a9ea43fc1a7c06a420b132d2d47cbf4344a5df ]

When dsa_devlink_region_create failed in sja1105_setup_devlink_regions(),
priv->regions is not released.

Fixes: bf425b82059e ("net: dsa: sja1105: expose static config as devlink region")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221205012132.2110979-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index ec2ac91abcfa..8e3d185c8460 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -95,6 +95,8 @@ static int sja1105_setup_devlink_regions(struct dsa_switch *ds)
 		if (IS_ERR(region)) {
 			while (--i >= 0)
 				dsa_devlink_region_destroy(priv->regions[i]);
+
+			kfree(priv->regions);
 			return PTR_ERR(region);
 		}
 
-- 
2.35.1




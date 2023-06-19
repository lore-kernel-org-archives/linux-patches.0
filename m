Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EE85381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490C3C433C0;
	Mon, 19 Jun 2023 10:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171314;
	bh=+apODNeNVrSyPqzAGIg1n/kEm6UQna9JsexIQrCyzwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcwZ1sTe9Pw0lxa4ODs6/zmAElhEwHB06FjgugeakMcerWoHr8p2+QZJsg48eyKl5
	 Gaw4tUUXhOzi3eZ1eFlSzsoDCpubqfgSFoXqhWbP+RE7d6P5YyER8O6IIpZRrrTefJ
	 aW53Mf+yB2wOFBHglb9pBFFK+5BefcdUpuc8n+fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/49] igb: fix nvm.ops.read() error handling
Date: Mon, 19 Jun 2023 12:30:15 +0200
Message-ID: <20230619102131.852293984@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit 48a821fd58837800750ec1b3962f0f799630a844 ]

Add error handling into igb_set_eeprom() function, in case
nvm.ops.read() fails just quit with error code asap.

Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index d0f5b92bead73..e19fbdf2ff304 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -811,6 +811,8 @@ static int igb_set_eeprom(struct net_device *netdev,
 		 */
 		ret_val = hw->nvm.ops.read(hw, last_word, 1,
 				   &eeprom_buff[last_word - first_word]);
+		if (ret_val)
+			goto out;
 	}
 
 	/* Device's eeprom is always little-endian, word addressable */
@@ -830,6 +832,7 @@ static int igb_set_eeprom(struct net_device *netdev,
 		hw->nvm.ops.update(hw);
 
 	igb_set_fw_version(adapter);
+out:
 	kfree(eeprom_buff);
 	return ret_val;
 }
-- 
2.39.2




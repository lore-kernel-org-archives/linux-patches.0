Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A721B31A068;
	Mon, 18 Aug 2025 12:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521554; cv=none; b=O8iWwuO1Ak/1LWalNTKpPTTqImteZYJAf4hGl4FmHDsq6kqMZ02iyn4NymYEfLT3jG26mbr2280cVD0wEXS1vwVpOW1B5T/xeek3efe3PonDSYPfyxvSlYHLbFlfI1pptajqZQW3EPJf9Qx88l1t6NdJZefcsowpgvpPL7dhydI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521554; c=relaxed/simple;
	bh=l6jKvAgwJaiOy+ajoMsw2A6A/+Gb5zwmPb9Fg6DLqMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9bTJ9o2EpPUz2V99lFMgiN9ovbBzf/roSY0nu/0wthKzG/5rRftf4WJL7pNkvAGyw8P65ePUwaZb9h/q7rpphImOk5U3ZBZsyiw/F7fIisjlZu788b/t/Snxf4hw9flVj2LFv7QIjHxtVxfDgfJcKleDgjwir9xSFuIiNqh3JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwJnQyOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwJnQyOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13685C4CEEB;
	Mon, 18 Aug 2025 12:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521554;
	bh=l6jKvAgwJaiOy+ajoMsw2A6A/+Gb5zwmPb9Fg6DLqMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwJnQyOP3xsZC8ejJBToskFT9xOvefTicgDSJxjXqReKUwE5AXXNR4F8eQimXnaPQ
	 8i2TAUwPrBHo0LDFkgPJGXGcxNngf+rF1OMxl5l5PdN/jobc9kVVDURW/+lTIC6mUG
	 P1TqHmWz+F5HBg9wVOrieGg6/LCQZMKBkekzD9qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/444] net: ti: icssg-prueth: Fix emac link speed handling
Date: Mon, 18 Aug 2025 14:41:22 +0200
Message-ID: <20250818124451.034593016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 06feac15406f4f66f4c0c6ea60b10d44775d4133 ]

When link settings are changed emac->speed is populated by
emac_adjust_link(). The link speed and other settings are then written into
the DRAM. However if both ports are brought down after this and brought up
again or if the operating mode is changed and a firmware reload is needed,
the DRAM is cleared by icssg_config(). As a result the link settings are
lost.

Fix this by calling emac_adjust_link() after icssg_config(). This re
populates the settings in the DRAM after a new firmware load.

Fixes: 9facce84f406 ("net: ti: icssg-prueth: Fix firmware load sequence.")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Message-ID: <20250805173812.2183161-1-danishanwar@ti.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index 0769e1ade30b..ddbc4624ae88 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -50,6 +50,8 @@
 /* CTRLMMR_ICSSG_RGMII_CTRL register bits */
 #define ICSSG_CTRL_RGMII_ID_MODE                BIT(24)
 
+static void emac_adjust_link(struct net_device *ndev);
+
 static int emac_get_tx_ts(struct prueth_emac *emac,
 			  struct emac_tx_ts_response *rsp)
 {
@@ -266,6 +268,10 @@ static int prueth_emac_common_start(struct prueth *prueth)
 		ret = icssg_config(prueth, emac, slice);
 		if (ret)
 			goto disable_class;
+
+		mutex_lock(&emac->ndev->phydev->lock);
+		emac_adjust_link(emac->ndev);
+		mutex_unlock(&emac->ndev->phydev->lock);
 	}
 
 	ret = prueth_emac_start(prueth);
-- 
2.50.1




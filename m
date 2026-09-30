Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14FD4BFE6D;
	Wed, 30 Sep 2026 15:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782996; cv=none; b=IW83DkVUFGJmF1cOGqjRxcI3sDWjCXYgbv5i82ffPZK9wjEbB7yXtCEKqhc+crATfMxVKPf7cqhuNJahQ/+1Gp55gsjYccWDYP23VwFjfRJ/sjeiCKR7qqknnluF0qE0dkQKmvD7klLcYPUMQRyWt/WL/WCfUuhuHxOcxXSfAnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782996; c=relaxed/simple;
	bh=cxfkXxb+dA8S9LJG+yCVz0gDj2/NzciqHBFcCdmM0lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBTPTj8/tympwBjopm7N3qBFagz1WUAIXgdUXhtjZ58+Lqhr8yvm/gdjXXgNXZ2r8Q6fCVsQX2mOSnz743pp/tVppkBMPbcPWH9s2Q8te+KJQM38p7Rd4cYC+3pzk/zqqMphVJhaAy8/5sRCN+SSbnEkJI2c54OkAJegY8urvSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTULFXFr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTULFXFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8EA1F00898;
	Wed, 30 Sep 2026 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782990;
	bh=wQTCUafmaHuAnZx1Ko5yvkoqh0qfgmGdB/GwgyjIGtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTULFXFrt2lfMgdjquroLpzdBYl38uTxTnNWQyS73wKk/8ipueOqrNTZJRlGvu4+Y
	 9CWyu5pJ4Q8fch65A9qW/fxNcVqtyAzlrqPOLeMx9yy+yscsTaKuVd0hMV518180AN
	 ITPiOJcB2obsapj5U24hDJ91E/S+IcMfnksr6rGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/595] net: dsa: bcm_sf2: bound the CFP rule dump by the callers buffer size
Date: Wed, 30 Sep 2026 17:22:13 +0200
Message-ID: <20260930152352.881113020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit cdb719f4b8596d9ccee2d56d204c2c4dce982f46 ]

bcm_sf2_cfp_rule_get_all() walks the whole cfp.unique bitmap into
rule_locs[] without consulting nfc->rule_cnt, which is how many entries
the caller had room for.  ETHTOOL_GRXCLSRLALL requires no CAP_NET_ADMIN
and the ioctl sizes the buffer from the rule_cnt userspace passes in, so
once an admin has installed CFP rules any user can ask for fewer slots
than there are rules and run off the end of the allocation.  A rule_cnt
of 0 leaves the buffer pointer NULL and the walk dereferences it.

Fixes: 7318166cacad ("net: dsa: bcm_sf2: Add support for ethtool::rxnfc")
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260903032611.3000029-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index cbf44fc7d03aa..5c24a8ce2941a 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -1092,6 +1092,8 @@ static int bcm_sf2_cfp_rule_get_all(struct bcm_sf2_priv *priv,
 	unsigned int index = 1, rules_cnt = 0;
 
 	for_each_set_bit_from(index, priv->cfp.unique, priv->num_cfp_rules) {
+		if (rules_cnt == nfc->rule_cnt)
+			return -EMSGSIZE;
 		rule_locs[rules_cnt] = index;
 		rules_cnt++;
 	}
-- 
2.53.0




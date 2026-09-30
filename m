Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB54A3D333C;
	Wed, 30 Sep 2026 19:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795235; cv=none; b=eazeDeyvAuE9qV3QCZ6NKZwcTY8Xkbs1rV8smurdpnawv0KPAHZmMo9Ww8CY9dFhjogKxy2dmG6TVnGCBT+1RtaYW5f1tyBUk9/dSkJbtp5f0bkwi5eQAvxE35/a8icYRQoqXxSMwdszsLL0GWxGlBwvWFkLEB1dzufQJY0J+II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795235; c=relaxed/simple;
	bh=fCejF0qR7UrRcc2CbTb1mseAHZIEmevW3zcWY8SnHwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVf8Op1Z6AyNBmUurgr7+SlRNpxZgIvmCXjJy99iZxRLdePzeE01as7JD1qC4/y08PjrLrjgjibjxrvkkKWsUxPruaMmORRoISB+xXLj7EJhWJDTRsTVptDTdoGbdvkLRYgJ6ybp8Nkt/uMoriBEs9yfm3Y/zCk+h5AQsmk1AVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmUveUo9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmUveUo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506391F000FF;
	Wed, 30 Sep 2026 19:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795233;
	bh=n3n7/T289AqmbIPvXgWj/L7lmyrV1qwj7lSQQ6lf86E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rmUveUo9x5EGCEkhn8C6aRNnpqJEUQOQdMz35AFD5wWRhGDrb4tDq5dZit6a56lJH
	 BQCqVPzK6BpxRibrpLR/ZsHms+2LnB17KvFJNva/OaF6AXfj+RXkBdO2dqYav6n2MF
	 AJ/IsHA4O8n7mrWl0X3iqbs9fRk/mT1p0T+FWkjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0490/1193] net: dsa: bcm_sf2: bound the CFP rule dump by the callers buffer size
Date: Wed, 30 Sep 2026 17:19:34 +0200
Message-ID: <20260930152445.037572843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c4010b7bf0899..f48ac7b021f37 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -1088,6 +1088,8 @@ static int bcm_sf2_cfp_rule_get_all(struct bcm_sf2_priv *priv,
 	unsigned int index = 1, rules_cnt = 0;
 
 	for_each_set_bit_from(index, priv->cfp.unique, priv->num_cfp_rules) {
+		if (rules_cnt == nfc->rule_cnt)
+			return -EMSGSIZE;
 		rule_locs[rules_cnt] = index;
 		rules_cnt++;
 	}
-- 
2.53.0




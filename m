Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17031296155;
	Mon, 12 May 2025 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072727; cv=none; b=HVNFB3bmbEEfm9OsJJeE4ifly1meLYKHzw/+2lXbVG5NK2J6K7rZg5IhqZf+hnK6MGVFJvcsrCk2sdDl2pEROz9m2JdXuntU5/USX+eM1rdvUc3Ku4nZD8aF464b8ryL+qKeBxogHR1KkZ3OnabzcExoXAr3Bl68e7lxVosBPEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072727; c=relaxed/simple;
	bh=FgdVhNGMTeNS4jAmWgB2GBQEdLsgZhVOVKmFiOAhTX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKbD+DcEk50lzr/FDkKX+Qy7kVktwN2cTGO1rJON/Zn5FQCysMtYXSU07H2vp3WnFxIfT2FuoByOnGBS+dEqYbvDOzpllGt4bl8am3OWUIlz7BesSEMbdH85F32FDhVhicKc/JiM+QLZ/SuJOU64pPX3KgOvz4GqWRJr3k+u18Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opWUU0Ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opWUU0Ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1D2C4CEE7;
	Mon, 12 May 2025 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072727;
	bh=FgdVhNGMTeNS4jAmWgB2GBQEdLsgZhVOVKmFiOAhTX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opWUU0TyOOieu+/gMXZyfsq1BLaOvp047sLWcIcO6VVrpqmLoY2aIwH2pidYlCOSE
	 E66Npv8vWrfrdha3ZeZ1s/ZULOD0VSbz2Ba+Rxzk6M7/Fu4re3QYy6HjV38EsUqnCl
	 cTAU1smZ25CQqP7KmoYBwyROE7vnF3j6SYy658g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/184] net: dsa: b53: fix flushing old pvid VLAN on pvid change
Date: Mon, 12 May 2025 19:43:59 +0200
Message-ID: <20250512172043.274636964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 083c6b28c0cbcd83b6af1a10f2c82937129b3438 ]

Presumably the intention here was to flush the VLAN of the old pvid, not
the added VLAN again, which we already flushed before.

Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-5-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 31d20552cdb08..d450100c1d020 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1575,7 +1575,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	if (!dsa_is_cpu_port(ds, port) && new_pvid != old_pvid) {
 		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
 			    new_pvid);
-		b53_fast_age_vlan(dev, vlan->vid);
+		b53_fast_age_vlan(dev, old_pvid);
 	}
 
 	return 0;
-- 
2.39.5




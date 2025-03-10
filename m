Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABE822D799;
	Mon, 10 Mar 2025 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627648; cv=none; b=gkuc7+1zv7xUKviEl/63o3NG+CuOWlm/O+gThX1UglT19WgMaoCUdY7/CO0ijfiBYe7ZUDeQMU9mNmHwQcqa48/wPwX/9bIt+iDRojilG1LR7dzHcPOcM+zVs/gg5LsE5/oNcQtY1baMCPULcbmQblOyiHIfiaVXxQeTzq1PswY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627648; c=relaxed/simple;
	bh=4l5RAmx2eXP9e/PrZaf2LJzux+mXvSORevZZSpIY8c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoxUh/UUfQPNQGBt3VdRqtiiB2omeeWtSjMmLm5qfxZwpaSxycoW4dL8zu3kM+g8XyOLexuWtNwG/PXhJ13QYc44hRDUpK5qiE2Y2HSSgHSmGbp5YOPt7VGJHp0Wu37ITu5mhiOv+uzEghNRFQjlNnW42A+E43t6UZFR1VRc30M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2Gs8aWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2Gs8aWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F26C4CEE5;
	Mon, 10 Mar 2025 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627648;
	bh=4l5RAmx2eXP9e/PrZaf2LJzux+mXvSORevZZSpIY8c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2Gs8aWnXci4gdoaWsbDGHmmX3cflP8wtSMs7mL8dJ4XM0nDNZujkk7/+pVVJ0UeN
	 GXs0HQkRyewJ8phBlBPPRK5EKPT8SJjMhl3EJpksK00oWRvnNAjmcrzMDqobTDvFnf
	 mjPKewZCK/DXP3WpcmzcICwAynW24W0sfbWXlaNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/269] net: dsa: mt7530: Fix traffic flooding for MMIO devices
Date: Mon, 10 Mar 2025 18:05:54 +0100
Message-ID: <20250310170505.707775599@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit ccc2f5a436fbb0ae1fb598932a9b8e48423c1959 ]

On MMIO devices (e.g. MT7988 or EN7581) unicast traffic received on lanX
port is flooded on all other user ports if the DSA switch is configured
without VLAN support since PORT_MATRIX in PCR regs contains all user
ports. Similar to MDIO devices (e.g. MT7530 and MT7531) fix the issue
defining default VLAN-ID 0 for MT7530 MMIO devices.

Fixes: 110c18bfed414 ("net: dsa: mt7530: introduce driver for MT7988 built-in switch")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Chester A. Unal <chester.a.unal@arinc9.com>
Link: https://patch.msgid.link/20250304-mt7988-flooding-fix-v1-1-905523ae83e9@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d84ee1b419a61..abc979fbb45d1 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2590,7 +2590,8 @@ mt7531_setup_common(struct dsa_switch *ds)
 	if (ret < 0)
 		return ret;
 
-	return 0;
+	/* Setup VLAN ID 0 for VLAN-unaware bridges */
+	return mt7530_setup_vlan0(priv);
 }
 
 static int
@@ -2686,11 +2687,6 @@ mt7531_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	/* Setup VLAN ID 0 for VLAN-unaware bridges */
-	ret = mt7530_setup_vlan0(priv);
-	if (ret)
-		return ret;
-
 	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
-- 
2.39.5




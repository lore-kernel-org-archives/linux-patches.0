Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253411C0DE7;
	Tue, 27 Aug 2024 15:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771265; cv=none; b=aBCS41SzG7rnnIStGHbPUU0F6u9AUORW3bTBUSet36Kzm1rMYAC70Z4yze15GCFgiJ5Nbo0GNJyVlV1Vnx/9pK4geIB6JReDXDHb+iQDLhIvmtYtDLpHgIB52cIRpYKWdI9IBPDEbV6O55BGIjuONcQCQ47zTVPmNb7MoYP+AUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771265; c=relaxed/simple;
	bh=oKerNYziGbt1zykAO1pdE94j69DQlxekujaz+zEfDKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkcNic3kg/2Xpak4rkLWb3sZ3UVrwLrxgoq3yU2ps4pSFGe1FEPg7Sb4QAVkXzOTgjFpgcFlTFmlg6wMQf6sERUBwiGYaB+YNMg4mF4UfPZceDzx2737E6cv66q1MhHNNbTacrFfo0pNbZcFXJ06W84enNQGsOFu64Da9m6nFWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Smk6R0F8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Smk6R0F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87597C61046;
	Tue, 27 Aug 2024 15:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771265;
	bh=oKerNYziGbt1zykAO1pdE94j69DQlxekujaz+zEfDKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Smk6R0F8yE1UMqwwts2XDmbVU3o5hv8DPG66jcSAumAKw0untoSrhNdbCqceiYm8j
	 kMKbIJntSWrbtnMl7D7w1c3z45aDcuyHE8pu2wlQl42dpNMMaSTWHKaR3IfQU6lMZg
	 iEJsBNCv4atlbWhpUlgZ8qpGd6q42rhw4P2cTcX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 095/273] net: dsa: vsc73xx: fix port MAC configuration in full duplex mode
Date: Tue, 27 Aug 2024 16:36:59 +0200
Message-ID: <20240827143837.027061764@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Dembicki <paweldembicki@gmail.com>

[ Upstream commit 63796bc2e97cd5ebcef60bad4953259d4ad11cb4 ]

According to the datasheet description ("Port Mode Procedure" in 5.6.2),
the VSC73XX_MAC_CFG_WEXC_DIS bit is configured only for half duplex mode.

The WEXC_DIS bit is responsible for MAC behavior after an excessive
collision. Let's set it as described in the datasheet.

Fixes: 05bd97fc559d ("net: dsa: Add Vitesse VSC73xx DSA router driver")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 4b031fefcec68..fc4030976bdce 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -817,6 +817,11 @@ static void vsc73xx_mac_link_up(struct phylink_config *config,
 
 	if (duplex == DUPLEX_FULL)
 		val |= VSC73XX_MAC_CFG_FDX;
+	else
+		/* In datasheet description ("Port Mode Procedure" in 5.6.2)
+		 * this bit is configured only for half duplex.
+		 */
+		val |= VSC73XX_MAC_CFG_WEXC_DIS;
 
 	/* This routine is described in the datasheet (below ARBDISC register
 	 * description)
@@ -827,7 +832,6 @@ static void vsc73xx_mac_link_up(struct phylink_config *config,
 	get_random_bytes(&seed, 1);
 	val |= seed << VSC73XX_MAC_CFG_SEED_OFFSET;
 	val |= VSC73XX_MAC_CFG_SEED_LOAD;
-	val |= VSC73XX_MAC_CFG_WEXC_DIS;
 	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG, val);
 
 	/* Flow control for the PHY facing ports:
-- 
2.43.0




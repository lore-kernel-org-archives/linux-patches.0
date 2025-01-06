Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4831EBA34;
	Mon,  6 Jan 2025 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177784; cv=none; b=rmWAn0cU4JOaRF2XHjAe/gIqnshTiefcD29aXThDa2O7AOWbrlFJrzNRUKKPmviyfHpoc2HG0qYMkcEIDXLJCdmxNDGYJycj7VosLc8LiiO3gxERJUrLGXaBv4pGIj/cdOoXKyWwhdftMAsKzYOz30MpHZpFKhaiPY5ka8jMhK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177784; c=relaxed/simple;
	bh=JU56k3UKws/h4y4hefOHZZNAiGUkYvw3y4fZW5sV3Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAcgipON2SinzOYQpZdzW4G42eAD/M4dlcx+yy9rervcQnjXUB714PAlu0FwIVVmvGKqSacGmuzpN+5atChdPYdhSuCdG2VrjoGsRX9hLwSoCW76EX19zs7PVf6KpwTWaEkVNtvhPi5ZUlY/oX7GH1mzV7vkCYl5l1TzxDb9qb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwIkzFVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwIkzFVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EA6C4CED2;
	Mon,  6 Jan 2025 15:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177783;
	bh=JU56k3UKws/h4y4hefOHZZNAiGUkYvw3y4fZW5sV3Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwIkzFVGUmIuKSKK97pQtysQcq9sBqXt4/sNEl3zV8AyyNnK/Ri4aY5UwY4gbfu8A
	 rt3RvzGr79oT6xFydJDemurysKzLWuYf0Hz6ACHVogIf1Pl7QTTs99jY7fCtjTWjqw
	 3wMxQ6HiJaLupcXvoVEpnzwkiE7hS23IWRrg0JIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/156] net: pse-pd: tps23881: Fix power on/off issue
Date: Mon,  6 Jan 2025 16:15:34 +0100
Message-ID: <20250106151143.544456103@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 75221e96101fa93390d3db5c23e026f5e3565d9b ]

An issue was present in the initial driver implementation. The driver
read the power status of all channels before toggling the bit of the
desired one. Using the power status register as a base value introduced
a problem, because only the bit corresponding to the concerned channel ID
should be set in the write-only power enable register. This led to cases
where disabling power for one channel also powered off other channels.

This patch removes the power status read and ensures the value is
limited to the bit matching the channel index of the PI.

Fixes: 20e6d190ffe1 ("net: pse-pd: Add TI TPS23881 PSE controller driver")
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20241220170400.291705-1-kory.maincent@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/tps23881.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/pse-pd/tps23881.c b/drivers/net/pse-pd/tps23881.c
index 5c4e88be46ee..8797ca1a8a21 100644
--- a/drivers/net/pse-pd/tps23881.c
+++ b/drivers/net/pse-pd/tps23881.c
@@ -64,15 +64,11 @@ static int tps23881_pi_enable(struct pse_controller_dev *pcdev, int id)
 	if (id >= TPS23881_MAX_CHANS)
 		return -ERANGE;
 
-	ret = i2c_smbus_read_word_data(client, TPS23881_REG_PW_STATUS);
-	if (ret < 0)
-		return ret;
-
 	chan = priv->port[id].chan[0];
 	if (chan < 4)
-		val = (u16)(ret | BIT(chan));
+		val = BIT(chan);
 	else
-		val = (u16)(ret | BIT(chan + 4));
+		val = BIT(chan + 4);
 
 	if (priv->port[id].is_4p) {
 		chan = priv->port[id].chan[1];
@@ -100,15 +96,11 @@ static int tps23881_pi_disable(struct pse_controller_dev *pcdev, int id)
 	if (id >= TPS23881_MAX_CHANS)
 		return -ERANGE;
 
-	ret = i2c_smbus_read_word_data(client, TPS23881_REG_PW_STATUS);
-	if (ret < 0)
-		return ret;
-
 	chan = priv->port[id].chan[0];
 	if (chan < 4)
-		val = (u16)(ret | BIT(chan + 4));
+		val = BIT(chan + 4);
 	else
-		val = (u16)(ret | BIT(chan + 8));
+		val = BIT(chan + 8);
 
 	if (priv->port[id].is_4p) {
 		chan = priv->port[id].chan[1];
-- 
2.39.5




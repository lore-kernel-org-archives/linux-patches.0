Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23675187543;
	Mon, 12 Aug 2024 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479868; cv=none; b=dW1NnUksFbtd3sgebU/SSHFE9pziXvlXXI0EYhIVe/Vl+UL1/eyfnmRagt6SQN1KFM2YrUvqMLVM+dsyQEqmAgFvlfzjXNYYSr1NHvQnIRCQ4a+9Lh7kggQi//U/19X0dFMrQIIIQnP2H5Ofz4weCMIYXZVPdGNARmA9iys41S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479868; c=relaxed/simple;
	bh=FmW31XRPqfkdL6FapBq7rRMNNyqn2e4MGMaA8GkS5Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI9JR75z/7j15jn/o1FxSTMDM+1KkF824WsVGdHdHC50ti86trjKrbATEGisCZQY73ueIF0L8IrRFO13IZyurfRzhbBsBw2RhrxZXtF2js1YS1MGNrJTJxqFTPliX7B1XhRCfnk/anJ1vwFTXJLUTEKE1HMLyfFv8hb5PZEU99A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpNqA29I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpNqA29I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C1DC4AF11;
	Mon, 12 Aug 2024 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479868;
	bh=FmW31XRPqfkdL6FapBq7rRMNNyqn2e4MGMaA8GkS5Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpNqA29Ia4jg1ejYfj305dJe4pdR1+CLN0yf+ZuLeSBrPGiziGJ+XXGEgYn6hgfv4
	 QHAWpUoLwkIwVYVlll4edTxK0GkdmzDY9fxmlj7MiUvvtErMpdC+S6Qs5ZW3au2gkJ
	 m12zLycyARNnQWoPbGw3YxFkB7A3Ams1WXzjU2Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 026/263] net: dsa: microchip: Fix Wake-on-LAN check to not return an error
Date: Mon, 12 Aug 2024 18:00:27 +0200
Message-ID: <20240812160147.542228590@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit c7a19018bd557c24072b59088ad2684fd83ea3f4 ]

The wol variable in ksz_port_set_mac_address() is declared with random
data, but the code in ksz_get_wol call may not be executed so the
WAKE_MAGIC check may be invalid resulting in an error message when
setting a MAC address after starting the DSA driver.

Fixes: 3b454b6390c3 ("net: dsa: microchip: ksz9477: Add Wake on Magic Packet support")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20240805235200.24982-1-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index baa1eeb9a1b04..077935cf5e381 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -3763,6 +3763,11 @@ static int ksz_port_set_mac_address(struct dsa_switch *ds, int port,
 		return -EBUSY;
 	}
 
+	/* Need to initialize variable as the code to fill in settings may
+	 * not be executed.
+	 */
+	wol.wolopts = 0;
+
 	ksz_get_wol(ds, dp->index, &wol);
 	if (wol.wolopts & WAKE_MAGIC) {
 		dev_err(ds->dev,
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ACF1F76B5;
	Tue, 17 Dec 2024 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455623; cv=none; b=pNLlwAHkfXN3yG54HlZDkZsv+1rzFVKkkhP8yDBq9MG/E0mpAHlCdOx/U9I2XSijnD/Q80Rd/KChgYkI+G8NZyaAfeOJ2g7qP8uuDsF+QU1Xk18THbNHNLG3EUqF7SAPSQHYXG5XpEvBnPm5VySqKyr9dthBAu0o6J54khgQkTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455623; c=relaxed/simple;
	bh=llGlQIw+otLO5/rFbqp5DsspE+/BTz2mZU7UdpjBPYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq5Sz8ypiewJD06WdLmD7ANnx+XVn+9eVmleoegfnYFnEOmSPWzubT6VkXQQPmk1PNcbypolNQVTfp6GGSQdGveLn7m32lRgnSnhC46aq2GttOLehFZ1XZHTz1tXzZ4RsEW/f+dMP3gUYiLLSxbhObc+A6t9upFuxuU3nmpiIv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntEiKhr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntEiKhr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A349C4CED3;
	Tue, 17 Dec 2024 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455623;
	bh=llGlQIw+otLO5/rFbqp5DsspE+/BTz2mZU7UdpjBPYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntEiKhr45jT0kJcPT6fYfACdycdfXkEYj+ID598FmyplMVI/Ieuw4NfQfX3d8RNcc
	 UqZCUDPmEVszDanGM25AWKo32CaSiSxqwhKkaYJZQvVXnjjoy3UYjr0uER1syOV9tN
	 2jQ554DcdItawp79OaZYf3QDxEMN3ilq/eiM3Zs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/51] net: sparx5: fix the maximum frame length register
Date: Tue, 17 Dec 2024 18:07:22 +0100
Message-ID: <20241217170521.482326018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit ddd7ba006078a2bef5971b2dc5f8383d47f96207 ]

On port initialization, we configure the maximum frame length accepted
by the receive module associated with the port. This value is currently
written to the MAX_LEN field of the DEV10G_MAC_ENA_CFG register, when in
fact, it should be written to the DEV10G_MAC_MAXLEN_CFG register. Fix
this.

Fixes: 946e7fd5053a ("net: sparx5: add port module support")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 8561a7bf53e1..0d9ff3db3144 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -1113,7 +1113,7 @@ int sparx5_port_init(struct sparx5 *sparx5,
 	spx5_inst_rmw(DEV10G_MAC_MAXLEN_CFG_MAX_LEN_SET(ETH_MAXLEN),
 		      DEV10G_MAC_MAXLEN_CFG_MAX_LEN,
 		      devinst,
-		      DEV10G_MAC_ENA_CFG(0));
+		      DEV10G_MAC_MAXLEN_CFG(0));
 
 	/* Handle Signal Detect in 10G PCS */
 	spx5_inst_wr(PCS10G_BR_PCS_SD_CFG_SD_POL_SET(sd_pol) |
-- 
2.39.5




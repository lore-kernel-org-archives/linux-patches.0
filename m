Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DEE32C941;
	Fri, 17 Oct 2025 15:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714190; cv=none; b=MytZOHE/sTYBzHlAx0YfkSZAEIRhVg/saJNbp4TF9StFDDZr8KOWoONibOQcH5M04/O0b76zn4Qis8JX2z0grb2NOBh2+ieSi497vITcvViQ2czxt0A22X1IfRa54gM1rmuzTjHMDPZs9YLFw6JIF4e12kaaOVspIF9oqMnKLYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714190; c=relaxed/simple;
	bh=UpL7ZziTZa/v5arQRUbBjmd0xOuYc1pl4dvU97QTcPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgHBT296AaauT2hvmZXSKIOHe1QTsSXNt/HZt8griZPPHtsmoJbVrY+D8gdXtX8dolJQK5g2klRoCTP5MnemnMaqHE1V/KEHQ0ORGzJgvpEduo7sMNvNbZWfnJYa6OYU9we4FwgOiiVJa5tSNPLO3DXPsXm/RVPWDhHtKNXMs2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEfOn5RX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEfOn5RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD02FC4CEE7;
	Fri, 17 Oct 2025 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714190;
	bh=UpL7ZziTZa/v5arQRUbBjmd0xOuYc1pl4dvU97QTcPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEfOn5RXxmUkke5pb4h7WQnZK1DmGR9ZZALdFZrLY3kO8hWSEQJFS2O8brLYfy/RF
	 wLqssg6ZVWXI5wgPyFT8+aCP1oAv2gVq3TPozj/2/9OypP5ms12qmsDJgigvta3Oow
	 4tLvmR7zLlBHGuIXB2c5nD8Giiu7r7ID+EjGqNq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/277] net: fsl_pq_mdio: Fix device node reference leak in fsl_pq_mdio_probe
Date: Fri, 17 Oct 2025 16:51:04 +0200
Message-ID: <20251017145149.226718863@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erick Karanja <karanja99erick@gmail.com>

[ Upstream commit 521405cb54cd2812bbb6dedd5afc14bca1e7e98a ]

Add missing of_node_put call to release device node tbi obtained
via for_each_child_of_node.

Fixes: afae5ad78b342 ("net/fsl_pq_mdio: streamline probing of MDIO nodes")
Signed-off-by: Erick Karanja <karanja99erick@gmail.com>
Link: https://patch.msgid.link/20251002174617.960521-1-karanja99erick@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fsl_pq_mdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fsl_pq_mdio.c b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
index 026f7270a54de..fb5d12a87872e 100644
--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -479,10 +479,12 @@ static int fsl_pq_mdio_probe(struct platform_device *pdev)
 					"missing 'reg' property in node %pOF\n",
 					tbi);
 				err = -EBUSY;
+				of_node_put(tbi);
 				goto error;
 			}
 			set_tbipa(*prop, pdev,
 				  data->get_tbipa, priv->map, &res);
+			of_node_put(tbi);
 		}
 	}
 
-- 
2.51.0




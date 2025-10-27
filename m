Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C93F2D6614;
	Mon, 27 Oct 2025 18:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591242; cv=none; b=gtIjc0EmumNeAWSpZ8ykBEVeTchcpAkM49WpU4Wb1QIKKGyWMJ8Z2iWAMS4Ljo5YrFdND/2oLOUSpeNChgzYBJjXDwwlTMfvG5+xEK+I2hIVHwCDSVUeyxUSvI0AJQHbEZPTh/1NZgDj38aaQaJ2vR11bK7MWpd0dmMYrgahfbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591242; c=relaxed/simple;
	bh=Hl1SX9o27Whblo5T/20hXEohYbc+mkBwaXgrXK7sxGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I44S8n66tCs9tL3GkLfpPF08tJ+XYMnn3yl5qqOy4//wEZef1tVTNW1z9Guz3Vq3QEo+EC8C8rh0nP82iCzEiRvEhNemwqEJcBBYO/dH9286Huejf1PBH5jPOVDtBjZUqWcEFQvoCgL4Tb0J8xL+Tf7mj7WDpdV7tPJ/p6d/JSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0elF1DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0elF1DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A203C4CEF1;
	Mon, 27 Oct 2025 18:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591241;
	bh=Hl1SX9o27Whblo5T/20hXEohYbc+mkBwaXgrXK7sxGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0elF1DYTmNi0q4bUdrzI+DlyfLbUWVGb0xjQQDpxTjvdjJ9jhui+azZyPTFdQuJl
	 BUhukwHncX4fv1zmidG39XMsrLXouWPC3wxE+XjYufadxcOq5KsT2yejRcIsNmKXY8
	 JBMmqYcWO4DAYSHQuWYH3B3agRLfG9muPbiKIZAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/332] net: fsl_pq_mdio: Fix device node reference leak in fsl_pq_mdio_probe
Date: Mon, 27 Oct 2025 19:32:47 +0100
Message-ID: <20251027183527.625618881@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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
index c6481bd612390..565a8bfe5692a 100644
--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -482,10 +482,12 @@ static int fsl_pq_mdio_probe(struct platform_device *pdev)
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




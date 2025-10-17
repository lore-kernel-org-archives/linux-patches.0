Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997C13370E3;
	Fri, 17 Oct 2025 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713068; cv=none; b=c5rDWj07ksPqU4GtbcczClKIMW2dyjO2JtXJyfj6jP8metK8LWFaXzk0RbmFJ8VGIcwxKxxJqartzkR9WWwcIL8MfKpnREFcLAPh/wkxW23PkCNZxthhDRDM11B48sH2bxTiyQAEaqxvqwAg3s/7e8EGASu0U6t5csix003HWIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713068; c=relaxed/simple;
	bh=I/N797+3E8Nqdh/REmB7FKzQ4OZoINtYXU1RXmCbSes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHrS4hc5oSrJQHUvqAr1df7iMdo8dQ1Mtu3j0M3Olp4OZRLbamp2DcIPM7uZaMLhRTjAlmScFWTvXsZUHiY/8/Vm/D63Hph0kxETY3JsbIdByIebMB5vMwT1G9akewopgYRwoBNGSduP1WzG58cs0YN8BLuL5AUKzRUVDXVbmuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBK+7NDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBK+7NDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C54C4CEE7;
	Fri, 17 Oct 2025 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713068;
	bh=I/N797+3E8Nqdh/REmB7FKzQ4OZoINtYXU1RXmCbSes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBK+7NDXWkCwW5eecMKaPvHM0riAqsiae3ltQAnaXWqvH75EZ/UORdUHsJE7LDcg+
	 I5Sw+hzmqMYCqWoFZNEjve/ktjY2k8++EktjREsT3AKD4lkyGIo1+Jr52WU7l2Lcos
	 MSpJTbTSs11kA1+ZuS/6T/Qsazy+1tkisF1gr6/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/168] net: fsl_pq_mdio: Fix device node reference leak in fsl_pq_mdio_probe
Date: Fri, 17 Oct 2025 16:51:55 +0200
Message-ID: <20251017145130.348229276@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d58d83344670..ea49b0df397e5 100644
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




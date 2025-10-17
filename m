Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7CF330B26;
	Fri, 17 Oct 2025 15:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716417; cv=none; b=OjmcbKIlJl6fOJrBUPsLJY2DK0oOksn/pGmI0GJF/RPCesrtbd14Tdw5fkwr0GLwommlBf6GU1UvfMZH7FT9WyMWeSfchyQlSodtRaEt+Nq/kR0zTRnudmDGIY6dakTvPpBj1aSA52idtkAzLszvzyQzZ/N95PIGWAV9uW6Cj5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716417; c=relaxed/simple;
	bh=JFLzFNlxbsQpCbCIxt4FiBE/fBGp918Jsg491B86ANQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8kXAUWJ3dyWHKlMSsoEqLTJ+l2Vli5pr1kvq/x3b9YxwCwVXjxGInP0qn45T9VVA4WGCud7pXAEIvNAPblbtFawPzd5DDZuaY0IFBY52YqkPfDk+VZqKGsrhTiP+RPrDSYql06Gg9wFYPmhbR6+mV3DmkDJnThCx1i2Xb35grQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCMXggS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCMXggS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DD3C4CEE7;
	Fri, 17 Oct 2025 15:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716417;
	bh=JFLzFNlxbsQpCbCIxt4FiBE/fBGp918Jsg491B86ANQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCMXggS0Gh792NGySLpiut3drMABqslMHX+V3VLXh05y3Cvbyjf4dHk7EZ2EidBhJ
	 ZASlWQpWz9RwdBU7+V12KHpowpq57e+4qp7901LKRQsGq+Gl6fLTo0a7ht27V8Mv1f
	 er0czuNrc29LheiexSjoZ8y5a3f1hXCo+boxVOdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/276] net: fsl_pq_mdio: Fix device node reference leak in fsl_pq_mdio_probe
Date: Fri, 17 Oct 2025 16:54:04 +0200
Message-ID: <20251017145147.991161149@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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




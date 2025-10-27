Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FC7320A0E;
	Mon, 27 Oct 2025 18:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590569; cv=none; b=jqBgUIj1QktqNR0fF8JzlMU7SpIkT0OjC76P9byVxOdhaWW7mwQTZUYTR1azDITVN8GBZuibIyyfuBKr8er20EophMl2mDMbhSD3YdviQDDad5Df2Vxwip/K7+RxVMAAddgv1amgOq5TC+deCr6zYmBiJC3zlsJCVudvSAr1AsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590569; c=relaxed/simple;
	bh=7G/g30N2ozZHXOeitc7GpoWI2HDhRKH7Km5wiY5eLcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjX2bry9qGq0lz+M5TgFFQ5xHo7bLY5Kp80Hcif4ArkcPKeV5TRmGzMk17Uy/QJdTVIwURVko1Rc8fezoHDBrIxINP/fLc+8fPlKGsa6Vi+a/cfanv8P30pTRspgH4Hh4lC+7789rs4uuiOzYKQCCFbxk8kziGuXCyFp8tObm18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKBI5r2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKBI5r2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C77C116B1;
	Mon, 27 Oct 2025 18:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590569;
	bh=7G/g30N2ozZHXOeitc7GpoWI2HDhRKH7Km5wiY5eLcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKBI5r2V8dLqDdEsOMWvXc8M0fW8GMnps8REpp9+9aRbDIVFPZc95FXtR4V6pCLix
	 WOBa2fCewggGIfQw5/VWxi4EMOiYL1G9RxivrUNlkSnOcIENPyw14Asgqn9knAtluZ
	 Nbryb+HvFKtALWV+5GeSpjiXtUztIDXg/26krj+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/224] net: fsl_pq_mdio: Fix device node reference leak in fsl_pq_mdio_probe
Date: Mon, 27 Oct 2025 19:33:59 +0100
Message-ID: <20251027183511.479886905@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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




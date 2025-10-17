Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0633C335071;
	Fri, 17 Oct 2025 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715180; cv=none; b=SQlvAjkDt20j6PywVXR7UVBUu2Xt6vNS5iidJakxqCyKl5tzxx9Kvndhl9h+gy8Lqngb8tQhtAP1JFbkzFUgnubnhup6hikYAvjGfgYUdb0240ZqR70j9Ke3cYgV4YhwL9Ot7fs/zw4Fpk2+jGH7Z7QjuTPnJ7PPzXRdMSQCJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715180; c=relaxed/simple;
	bh=dWZD5t5X4ZSAX+5wJYeGZYkmazQrqkZKHIDxBVnC7Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/KgOMzyBUOTR0vj83OmpOLbkXwJ2uTZNew1TUWVjFPHaALMvGc7bWsc+ANo2KoGkKBOXpdAjerUYukP4qa1+V6cq9Fa1xhvsYPeObT/nfWNbVHkfgcuCLWImvNv/Kou/RJ3UNrp+qw7rAWbrguGr9pqF6m2sWOs4M5Nvx+WX8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxBufGVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxBufGVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7B2C4CEE7;
	Fri, 17 Oct 2025 15:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715179;
	bh=dWZD5t5X4ZSAX+5wJYeGZYkmazQrqkZKHIDxBVnC7Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxBufGVMBla2QpVZyaq14rAUhy4vCaDqG69IW7q6Jjd5Qu76CBK9+Z4+ipZpcXgJj
	 unoWN162kF+qLTW9GGS5cWArfB7eykYP0dlzhWgwifEced0DmXDx7Vhk7z+Kq3TnB1
	 NukcAHLIRREDEky473juCzoud+NqxXMUlOt+sovs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 093/371] net: fsl_pq_mdio: Fix device node reference leak in fsl_pq_mdio_probe
Date: Fri, 17 Oct 2025 16:51:08 +0200
Message-ID: <20251017145205.304020467@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 577f9b1780ad6..de88776dd2a20 100644
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




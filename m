Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061DC3370E2;
	Fri, 17 Oct 2025 15:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713560; cv=none; b=origUtNuVbQfbso0c0QYNGA32cV7p5A8QTmGi2Szio5KuBt10r2BGGeMaHH1CNowy00XA32V2oN9FDaIhVGZ0CZfFH6IjVWc3PRGu6EFIPW4Cjl7x28eEdVMPRK9MjL+Ew4qH8UM2WApmhHmSW9ZUDuw9jHd+UKC799le2PbSGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713560; c=relaxed/simple;
	bh=pXXXAHY0Iq9ibxirjSpOcGYReGh7sHaJvJVY6WzSPNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTpsRzozx2xr05YcWBYLABcoZzLp5Gc+SFlgpxskG29QPaaNuTigdfk7dHrCtTPKLcwfFAPN7f94UZpinmYoqUG0fi3i0uj60cVoRcvtOwQXJCCZvMZ8tSsEGXhZmVQlsv37KxdtByBgbfTUmzKLKVVet3EeUQqR3Ir3VabEhAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UF35ZeXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UF35ZeXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805FAC4CEE7;
	Fri, 17 Oct 2025 15:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713559;
	bh=pXXXAHY0Iq9ibxirjSpOcGYReGh7sHaJvJVY6WzSPNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UF35ZeXT0Sv6xSWFwCXzKjHsA9WSkZ+avcdBbRYcnJ8RIUkM2ihK/XRi38jOlXOCN
	 hUe7NGzGFYtmdaCV/pyQc4ss9GlyKPU+IPyKPftlbo5JKKVqYJIUhlEhfoVsXRgbEL
	 PpEmRuv4/XcuzyWFCzApLB87P3+rlAaW/KvYWGCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/201] net: fsl_pq_mdio: Fix device node reference leak in fsl_pq_mdio_probe
Date: Fri, 17 Oct 2025 16:51:39 +0200
Message-ID: <20251017145136.144644772@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eee675a25b2c3..ef9adecb639ae 100644
--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -483,10 +483,12 @@ static int fsl_pq_mdio_probe(struct platform_device *pdev)
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




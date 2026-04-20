Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5796E244661;
	Mon, 20 Apr 2026 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700315; cv=none; b=A5metzZk5GLViR72f6WJYunSXe0RPf4DUjG2ajQJhHnniVkzO3s1jbhYwyqOtjX3JWj7YkrL6QOXaAOJGQdQklRbzbh/gfvRsKecSRkJLV3GzljY66z9dVzcnq/LJwXfuhXej10PRT9Cfvuhi60pDmoZUPsU/ygoE+OTHI/itNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700315; c=relaxed/simple;
	bh=uECNalsUlnGi5nPYBYwlUE1oGX+AIlrkC8mmezoYvug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8m0vDwB07oW5PLjNd9FmvXfN1rqkwBsq6rM2tDOx1MsqMhIX/wtsOyb9okIFQrFfsezmdROocAQv0b+yDHofMpD47bMZsa9zXqBwSo8p1X6mW9ESuX9j3HKBmJCJUO+tS072oVEnYZ3y66VUwOFr7lySgkgU74EdcjM2HzYSzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svDnFk6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svDnFk6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81F7C19425;
	Mon, 20 Apr 2026 15:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700315;
	bh=uECNalsUlnGi5nPYBYwlUE1oGX+AIlrkC8mmezoYvug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svDnFk6hgmY0aC+TXkGaW8GdAvVdCeHD4tsppW2sOakt/4OQzjqLAuzRDPXk+30Ys
	 cryB9OQQMLfkhTZLM8vZY9ZqFiXRgr9cF/raKKKM9o1ejHwuRlJVP009cbW8olvvks
	 gruaWr7u+rVwXqm0I5fzkSGIbQ+O2WS86o7xzTKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 124/220] net: mdio: realtek-rtl9300: use scoped device_for_each_child_node loop
Date: Mon, 20 Apr 2026 17:41:05 +0200
Message-ID: <20260420153938.493012471@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit c09ea768bdb975e828f8e17293c397c3d14ad85d ]

Switch to device_for_each_child_node_scoped() to auto-release fwnode
references on early exit.

Fixes: 24e31e474769 ("net: mdio: Add RTL9300 MDIO driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260405-rtl9300-v1-1-08e4499cf944@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-realtek-rtl9300.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-realtek-rtl9300.c b/drivers/net/mdio/mdio-realtek-rtl9300.c
index 405a07075dd11..8d5fb014ca06c 100644
--- a/drivers/net/mdio/mdio-realtek-rtl9300.c
+++ b/drivers/net/mdio/mdio-realtek-rtl9300.c
@@ -466,7 +466,6 @@ static int rtl9300_mdiobus_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct rtl9300_mdio_priv *priv;
-	struct fwnode_handle *child;
 	int err;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -487,7 +486,7 @@ static int rtl9300_mdiobus_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	device_for_each_child_node(dev, child) {
+	device_for_each_child_node_scoped(dev, child) {
 		err = rtl9300_mdiobus_probe_one(dev, priv, child);
 		if (err)
 			return err;
-- 
2.53.0




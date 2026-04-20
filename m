Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6473433DEDF;
	Mon, 20 Apr 2026 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700926; cv=none; b=Prr//jNzubEPACQdyuWU2D0uQV5BhptrmSwokVfAxRvnHq8A5nxSOk6j0tQrGIY7Whpjb4Hobl+TLfapdVLGcDckEGHerf5oZswW1V4nJoYbQXMDPrIBGYTfsyVY74vdlKNdIsizcv+3zWOrCr/WYG2hPB1+L1whGDz5ppg0/XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700926; c=relaxed/simple;
	bh=xMoDvuxpjP9hbepcewTMNsrRz2zyK2ymJDAfcBUocd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srJhAty+a7pMhdU+MM4L43ZOx8xoNn0iUN/zH1fGSAtaWv+rNfLGd/6wRYHEXZh9bKNYlxhROvj/4Ykc8XfspD05vZ8hFSKy95bdWejtIFr40MhklatSM80cjl+RzZvtiVHqv6ArMo40fJpckXwCKbO4eWblP46uyfZoZZn4pkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ji0FKI0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ji0FKI0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FD6C19425;
	Mon, 20 Apr 2026 16:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700926;
	bh=xMoDvuxpjP9hbepcewTMNsrRz2zyK2ymJDAfcBUocd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ji0FKI0W/u/7q15w2yUPDX9gUJrHwvDPHy1G9YotHL9V29jyufz3sRKwj8bCxmx4N
	 FncNXvQIv3HDAcitcwUYdYaob/nRUV7onNRl/0bEBjvLjuTebwBwGO3jNzDTTo8FcS
	 C9foa8+8R139mBCNzp9UJjre41brP0Zsw7IG8+b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/198] net: mdio: realtek-rtl9300: use scoped device_for_each_child_node loop
Date: Mon, 20 Apr 2026 17:41:25 +0200
Message-ID: <20260420153939.419961441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6084BCA6F;
	Mon, 13 Apr 2026 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097811; cv=none; b=cx5wfU23ddJqpeH+sxW3jP+1/cohtmsy4EsM1ftUt3MIQJeaETj7gDy//ur4WonVG1ol1pTw0S6NbMqNVZ+BtxbAQa1aSk99aUS3n2Wr/8UDIkgDhFFY0YvC2haGaBv1iZf4rqzhALBX1z/pMzrVAhG0ainn9h+fyffL9q+VUqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097811; c=relaxed/simple;
	bh=pvErh1mh1X8UoOz07BfsgtnQ8iHviwWr8k+anq0aVA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uO6DpMXPce77az660pciUTsFLTpS/zBmv4npsocEFTqS1m1wkG+ZHgEaLxADagQ9MKbNVcZhvdrVO+erc6hLP93e0A2tqRrPU/a2x9U6RKwTyDwerD8mIWOC9ZCUFTC2Cj2lGCkMbsSXhZQzUmQ0MuzAPLNCLdbwNvSSN31CKLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFXL8qO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFXL8qO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78E3C2BCAF;
	Mon, 13 Apr 2026 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097811;
	bh=pvErh1mh1X8UoOz07BfsgtnQ8iHviwWr8k+anq0aVA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFXL8qO+MXJ5gXx7EQQCRrgG4TDqz+yiEPXL0wdurawzIoSog802QIjHUTQTpeiSr
	 PpNDwwmYU0+4nzRK7PVt09nrQ6YAWTJKOBQq/BJ5Xq0juwN/Wh9ILK0Zt4+zUh9PyM
	 XBiVUgPYhJOIidNpIgJKjcuNsbtP6ZYHRKCYjdCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Anas Iqbal <mohd.abd.6602@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 281/570] net: dsa: bcm_sf2: fix missing clk_disable_unprepare() in error paths
Date: Mon, 13 Apr 2026 17:56:52 +0200
Message-ID: <20260413155841.017448223@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Anas Iqbal <mohd.abd.6602@gmail.com>

[ Upstream commit b48731849609cbd8c53785a48976850b443153fd ]

Smatch reports:
drivers/net/dsa/bcm_sf2.c:997 bcm_sf2_sw_resume() warn:
'priv->clk' from clk_prepare_enable() not released on lines: 983,990.

The clock enabled by clk_prepare_enable() in bcm_sf2_sw_resume()
is not released if bcm_sf2_sw_rst() or bcm_sf2_cfp_resume() fails.

Add the missing clk_disable_unprepare() calls in the error paths
to properly release the clock resource.

Fixes: e9ec5c3bd238 ("net: dsa: bcm_sf2: request and handle clocks")
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Anas Iqbal <mohd.abd.6602@gmail.com>
Link: https://patch.msgid.link/20260318084212.1287-1-mohd.abd.6602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index f259b0add5b2e..6105f4d8faf06 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -962,15 +962,19 @@ static int bcm_sf2_sw_resume(struct dsa_switch *ds)
 	ret = bcm_sf2_sw_rst(priv);
 	if (ret) {
 		pr_err("%s: failed to software reset switch\n", __func__);
+		if (!priv->wol_ports_mask)
+			clk_disable_unprepare(priv->clk);
 		return ret;
 	}
 
 	bcm_sf2_crossbar_setup(priv);
 
 	ret = bcm_sf2_cfp_resume(ds);
-	if (ret)
+	if (ret) {
+		if (!priv->wol_ports_mask)
+			clk_disable_unprepare(priv->clk);
 		return ret;
-
+	}
 	if (priv->hw_params.num_gphy == 1)
 		bcm_sf2_gphy_enable_set(ds, true);
 
-- 
2.51.0




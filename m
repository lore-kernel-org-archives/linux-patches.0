Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEE31F5FA;
	Thu, 11 Apr 2024 10:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830116; cv=none; b=IEM9UvNUM5KNcVi9qjtj/Jh9lLMMFyK2QqaxSLnUc6L3IaNdK2YxNNqyRIfPoV1EfRUhIevGMOGubWBa5Cgndz1OD7zSOYhM3SIKzB6MRTx2MHDLzjkeLyPEQgkQS29YEMs3SF9XjDQcAQGl+U+Bd6IXPu9TCnjVJXUKagfot1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830116; c=relaxed/simple;
	bh=zZeZv1WYJ4TaFALGKvaCqwOeAcX5KSyaT7JX9XTX3lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+A93YwH9rwtyLQkBygbKSEIE+9yfZ6noVGB0JGWr7DVfCig/Cc8ENIW3fKt/RWcIbQ3BHriI2ErDZGmvqMnJJ1CVt6HAzixFUABQ6+AWoEUGfiP54w3hxzx25Xf8NS015ZVHIz7dJAPYufo6jIkiDl3SHUwliprDUFRrUnAVhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcDJbH8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcDJbH8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625BEC433F1;
	Thu, 11 Apr 2024 10:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830116;
	bh=zZeZv1WYJ4TaFALGKvaCqwOeAcX5KSyaT7JX9XTX3lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcDJbH8pH8wYabNKS9nraYk3Nk36kuPdNwlgxC2GcyMtU/7BRd8XqWGgkW+Oy/2Gd
	 IiLzW5q18fZV301pXv6/ba0WNrWUQdxAVIBMMx1+V2X4ETYJb3FDlt8MzqdJbbD+ne
	 rZmkiK15uaSxi7R2C6eHw0ipGMIohZbaIQiVW4kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 013/143] net: dsa: qca8k: put MDIO controller OF node if unavailable
Date: Thu, 11 Apr 2024 11:54:41 +0200
Message-ID: <20240411095421.309930677@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 08932323ccf7f8c4c85db9cb12a791ed81264f66 ]

It was pointed out during the review [1] of commit e66bf63a7f67 ("net:
dsa: qca8k: skip MDIO bus creation if its OF node has status =
"disabled"") that we now leak a reference to the "mdio" OF node if it is
disabled.

This is only a concern when using dynamic OF as far as I can tell (like
probing on an overlay), since OF nodes are never freed in the regular
case. Additionally, I'm unaware of any actual device trees (in
production or elsewhere) which have status = "disabled" for the MDIO OF
node. So handling this as a simple enhancement.

[1] https://lore.kernel.org/netdev/CAJq09z4--Ug+3FAmp=EimQ8HTQYOWOuVon-PUMGB5a1N=RPv4g@mail.gmail.com/

Suggested-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 7a864329cb726..95d78b3181d1c 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -954,7 +954,7 @@ qca8k_mdio_register(struct qca8k_priv *priv)
 
 	mdio = of_get_child_by_name(dev->of_node, "mdio");
 	if (mdio && !of_device_is_available(mdio))
-		goto out;
+		goto out_put_node;
 
 	bus = devm_mdiobus_alloc(dev);
 	if (!bus) {
@@ -988,7 +988,6 @@ qca8k_mdio_register(struct qca8k_priv *priv)
 
 out_put_node:
 	of_node_put(mdio);
-out:
 	return err;
 }
 
-- 
2.43.0




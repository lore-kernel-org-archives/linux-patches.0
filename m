Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0885405845;
	Tue, 21 Jul 2026 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655917; cv=none; b=rg8nb+SoF2gMcXjUlj/AVr5oOU31Yv5bCIXI5+xLVRLwHzMEXiOYVAZ4zPyrNGlfMzTJllf2UT94b/LgPeeDPx0Md77u8byzAPmvwGJQpJ41FHzLPre4hpTux3InPaynFgtxbXXihVzQvuWX554tM/T/WNyEqojBhey+xR797vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655917; c=relaxed/simple;
	bh=vXp+DeuOTMoL5lSDDLPsi2kyzDYTMk9OhkE9GDi72Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dx5A0OVDi7dYym80z1H2D5KYpzZt1iS7x/NeQCAUPyCvXcAm7bTb9X1KBoQQBlue7K0LbHPSf/NmjY4XsaQTBJ8JzmC7eeomEZM80+LYAgdkkhcYQLjWk0gpiQYgsCdv5UDDdOoZYh3PTHfXY0DrPb1Ty+HGEC8DmMDMprU+Tvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcPKe9g2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcPKe9g2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F541F000E9;
	Tue, 21 Jul 2026 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655916;
	bh=lGlW40evn2mnvSOtTKtbNfqdcUtwQatjCQxEGYODh4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcPKe9g2vUNFZQ2PUPcWBPq2yLQu0VvmeTU0Kc2TTnlANf8VEGpljsnqeHACmImtx
	 TgBNO7MKZrdo6D5s5Y6KYjC8irLZ/l6v73Px1XC4XE0EADDF2finSDMMSb6hozyMsz
	 7kTGUl1hNez7xBzc5WKqB3y0S/KzZ7edSmen7mdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0146/1611] clk: scpi: Unregister child clock providers on remove
Date: Tue, 21 Jul 2026 17:04:22 +0200
Message-ID: <20260721152518.161685454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit b79d9b5747d961516c35ef4d5e91efa579fd3e9a ]

SCPI clock providers are registered for each child node in
scpi_clk_add(), but scpi_clocks_remove() unregisters the parent node on
each iteration.

of_clk_del_provider() matches providers by the node used at registration
time, so passing the parent node leaves the child providers registered.
This leaks the provider allocations and the node references held by the
clock provider core.

Pass the child node to of_clk_del_provider() so the remove path matches
the probe path.

Fixes: cd52c2a4b5c4 ("clk: add support for clocks provided by SCP(System Control Processor)")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260513090900.5323-1-sozdayvek@gmail.com
(sudeep.holla: Updated commit title and message a bit)
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-scpi.c b/drivers/clk/clk-scpi.c
index 0b592de7bdb2a0..e082474250fe31 100644
--- a/drivers/clk/clk-scpi.c
+++ b/drivers/clk/clk-scpi.c
@@ -258,7 +258,7 @@ static void scpi_clocks_remove(struct platform_device *pdev)
 	}
 
 	for_each_available_child_of_node(np, child)
-		of_clk_del_provider(np);
+		of_clk_del_provider(child);
 }
 
 static int scpi_clocks_probe(struct platform_device *pdev)
-- 
2.53.0




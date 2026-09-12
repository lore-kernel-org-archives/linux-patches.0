Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0F3415B7B;
	Sat, 12 Sep 2026 08:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202260; cv=none; b=o6Ti8nnObLEhLxIeWJiZPWiw125lC+Hi5qFOI4znotdRUwtCxLdPAjYdKiT9beMUeAKhRMmNjoRu4ucDaS5fGvuBYEjz2NonPkSe1jvnalfqGvjMnqUoMwCscjfuJ5A9AtCQwlUm9DPCV7V3JoM1DPNg5m2jSQkvCPAByFiCmyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202260; c=relaxed/simple;
	bh=3LJL/ZMC0LwlPnyHf4QMczJTwTmiXK0/ETfqFQKIAMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itbiGhNpm3JIhGzC1BUbsfGBSEFdj/3gXY4e0cmvErck+fCA92rHmoJk2QW6qcPKEf601cvLsid6K+ZNxUcHNsJbC/bCLx+kd4SPCsVvZc6DbteJ+5wOqf8ja1sALEV87jyURw/E65O6ULayx4gQkFtk/ZWTGEGen1cXsfUATzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YU/eo4Fn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YU/eo4Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D00B1F000FF;
	Sat, 12 Sep 2026 08:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202259;
	bh=OYBsrcR3CLhwnzuN/FMEjn6MHZ8cz9ux1SY7/R/dGvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YU/eo4FnVeZT9sTNrQ4Il7eZbnGGku/VZ3XCqS7W6G5mcbDb4CxhZcM0undmEVOon
	 ieB8MpHqqIAOFf9wDN/tE12ww4tiz82ZEl70dBMRjJP49Y8O4g+ec8TnjZCvP90mQh
	 nGBWevOzL+o2g0aJMgPNsGfBJUlcg9+kC+LddEPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1166/1815] phy: renesas: rcar-gen2: Fix double of_node_put on phy creation failure
Date: Sat, 12 Sep 2026 08:48:36 +0200
Message-ID: <20260912065716.388890032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit b780b8929c759cfa7a892d58625a5ad46cb1cbd2 ]

for_each_child_of_node_scoped() releases the node reference on scope
exit, so the explicit of_node_put(np) in the devm_phy_create() error
path drops it twice.

Drop the redundant of_node_put() and let the scoped cleanup handle it.

Fixes: b64b32791fb5 ("phy: renesas: rcar-gen2: Simplify with scoped for each OF child loop")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260803-rcar-gen2-v1-1-9aa35c36d7d7@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen2.c b/drivers/phy/renesas/phy-rcar-gen2.c
index 6c671254c6258..5a272e25e051c 100644
--- a/drivers/phy/renesas/phy-rcar-gen2.c
+++ b/drivers/phy/renesas/phy-rcar-gen2.c
@@ -405,7 +405,6 @@ static int rcar_gen2_phy_probe(struct platform_device *pdev)
 						   data->gen2_phy_ops);
 			if (IS_ERR(phy->phy)) {
 				dev_err(dev, "Failed to create PHY\n");
-				of_node_put(np);
 				return PTR_ERR(phy->phy);
 			}
 			phy_set_drvdata(phy->phy, phy);
-- 
2.53.0




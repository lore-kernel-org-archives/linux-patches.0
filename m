Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01961DB13A;
	Sat, 12 Sep 2026 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223786; cv=none; b=ptdn1e8Hqea3+cZUwyKgYZqmzF8ll4SyaRNJzdSDyiheVtEzMm0rsnHLGm2IORT6uHj4SydNypuHaZaeXpCfrxekMdacDIncdptsbHovwZDCAtphEiRe0STL17jLho5Q8wSUbU2t8dQbalU3IB1/hB1zVfhFpUsTZxABfytSR1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223786; c=relaxed/simple;
	bh=n1MmjD5p8tInMFtiYKTU+Fty3eXrTg11R3O9tJ6hKL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjHAo8FeD06f9TvYydfstUrSmMkRFqDrS9dvrzq9gaZHBfswGCsZrwvi/RcuwbgZ/2ZZDUko38u9UF8Tm9/oueOqC0Mr2UQusrhielVP67ADrGm10B+ccJ6rNsXwkWMax3zdjZ4d0llYoKBs+SoX6dFuManT6iVfFMKwSlZq7KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tdg9qU5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tdg9qU5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD081F000FF;
	Sat, 12 Sep 2026 14:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223785;
	bh=XeI+86H9N/Yyr7Xh3IU2L/nLECBeI7f6RQT/OBaI7T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tdg9qU5yqBD3+uwc0ZNWGELbqs2++n9Pw1nac+zB3bCPHA8upHOkQ7oZGJVjfLR44
	 wm/iKzWOTImnYf4ZIoGSzA8q8G+jvTGUf2EbEdm9rOJO58yN5OVRZGjuawKmP4KuHi
	 9en3gCfa9k1hi8x364DQcfkWqvga5pTZ2XVv/0Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0817/1424] phy: starfive: Fix runtime PM cleanup in JH7110 DPHY RX probe
Date: Sat, 12 Sep 2026 08:54:09 +0200
Message-ID: <20260912065625.598293829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 97bed336f6a25c9d1115ca95e3aa00e05c3bc271 ]

stf_dphy_probe() enables runtime PM before registering the PHY provider.
If devm_of_phy_provider_register() fails, probe returns with runtime PM
still enabled.

The driver also has no remove callback, so runtime PM is left enabled
on driver unbind after a successful probe.

Use devm_pm_runtime_enable() so runtime PM is disabled automatically
on later probe failures and on driver unbind.

Fixes: f8aa660841bc ("phy: starfive: Add mipi dphy rx support")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Changhuang Liang <changhuang.liang@starfivetech.com>
Link: https://patch.msgid.link/20260718090054.444513-3-pengcan@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/starfive/phy-jh7110-dphy-rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/starfive/phy-jh7110-dphy-rx.c b/drivers/phy/starfive/phy-jh7110-dphy-rx.c
index 037a9e0263cda..6dcd6d4b904f1 100644
--- a/drivers/phy/starfive/phy-jh7110-dphy-rx.c
+++ b/drivers/phy/starfive/phy-jh7110-dphy-rx.c
@@ -155,6 +155,7 @@ static int stf_dphy_probe(struct platform_device *pdev)
 {
 	struct phy_provider *phy_provider;
 	struct stf_dphy *dphy;
+	int ret;
 
 	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
 	if (!dphy)
@@ -195,7 +196,9 @@ static int stf_dphy_probe(struct platform_device *pdev)
 		return PTR_ERR(dphy->phy);
 	}
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 
 	phy_set_drvdata(dphy->phy, dphy);
 	phy_provider = devm_of_phy_provider_register(&pdev->dev,
-- 
2.53.0




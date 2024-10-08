Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA891DF976;
	Tue,  8 Oct 2024 12:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391394; cv=none; b=KxEueRw9aBHqtQzJ1bMAWMPzcq1LUWjRDTmij1ErzHREnWU+nwz8gP66tHi+aIQxQr9GHnHJ2urlZX7jJpQ4alo13Xkc46XqHRLGG5fHgm9bJ1or89F+/c48dN9Z2gmsn/7VhMzHFIbEU9FwyZ4fHeq7tHYeEtgYV4uxa/7j5u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391394; c=relaxed/simple;
	bh=rr3QYThYcXzvrABNb8BYE1NDY/Bz/HmjBHAkGhkTVZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mdl6Mso1tM9xu+G/J0JwHJ/s83kmmPnmjaOY/NLAKkLMfNfBJR/MEndoS6/yyC3k8/Z0+ups4APOFa/zZrcu6heDejYah2mSDwZ5SJ/4C+K4Jcg7PsT0d3m/QYEeIsO9mX7BYCsZEtClhJG/x6iA1MeqlnrkEqLLSPSlmo7XB9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGWDQqyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGWDQqyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA05C4CEC7;
	Tue,  8 Oct 2024 12:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391393;
	bh=rr3QYThYcXzvrABNb8BYE1NDY/Bz/HmjBHAkGhkTVZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGWDQqyr0OWB9zqfic5U5fXi6WSCalyD7G8AXbBim+s2IJVnDz4wVXj0hZkNOOSkt
	 xj35qEz4qKAkf48Ix3y3tb7U5ISwWLepwKoCmzOWJxZwUE6zMrbgKaHrpjLkNcKO87
	 vY8tXw0ORsnq0aPDNWZZwGGNCluv5k9xq4q7Y+Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 099/558] net: hisilicon: hns_mdio: fix OF node leak in probe()
Date: Tue,  8 Oct 2024 14:02:09 +0200
Message-ID: <20241008115706.265465148@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit e62beddc45f487b9969821fad3a0913d9bc18a2f ]

Driver is leaking OF node reference from
of_parse_phandle_with_fixed_args() in probe().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240827144421.52852-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index ed73707176c1a..8a047145f0c50 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -575,6 +575,7 @@ static int hns_mdio_probe(struct platform_device *pdev)
 						MDIO_SC_RESET_ST;
 				}
 			}
+			of_node_put(reg_args.np);
 		} else {
 			dev_warn(&pdev->dev, "find syscon ret = %#x\n", ret);
 			mdio_dev->subctrl_vbase = NULL;
-- 
2.43.0




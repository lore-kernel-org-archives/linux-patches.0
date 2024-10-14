Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4F71ABEA5;
	Mon, 14 Oct 2024 15:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918792; cv=none; b=oHdC4Bm5PzD8Yvx5TNkWJ00wYfnT7ejvN/TyZ5OEEUaB696mbSiIk1ncETubY3H8YwQLTB2QIXp0Pld4J1CWJGvOnDhTBAi/2Jex9jOft3sOHnf9nQD139/CabXuSlNXsq3MnZOdNKyn7zhm2R4VObQN01A0Dj/a6FyV+w0cxCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918792; c=relaxed/simple;
	bh=EPwFFLnff9T6kSmyMlrH0iMsBl2DZt/7mPAWoE8sHD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTB1ISL8U1sbDUHdJ8BeuK6FPxIHvDURM3AxpFrjidhfb6NJzsP+xw1dFResGXfiErivQnoQo4jNGpLaFwmP+DdK9tgvbojnzKiDLpuE2as66Brd75GIig9WYrarIcil0l8svopFqhOp/2NWL3Qxqpuz5t4uUTfFzsS5HyOiYPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qyjk67tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qyjk67tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C2FC4CEC3;
	Mon, 14 Oct 2024 15:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918792;
	bh=EPwFFLnff9T6kSmyMlrH0iMsBl2DZt/7mPAWoE8sHD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qyjk67tv1/WjivG95a9c8shdTaw1Vn7N6EeVCSjraQ8vdp8GgNU+goeV+3URYo5KC
	 PsgK2AZ68JHT48C7bmWYWnc4rccy0I3YLPL3CYaJrmqZgWyO+xAtZnpmAgcLaOiBss
	 haOIdX9nOpvw1a5+WTeLiW3hIHfQC2eDNr1KkoHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 424/798] net: hisilicon: hns_dsaf_mac: fix OF node leak in hns_mac_get_info()
Date: Mon, 14 Oct 2024 16:16:18 +0200
Message-ID: <20241014141234.607231468@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 5680cf8d34e1552df987e2f4bb1bff0b2a8c8b11 ]

Driver is leaking OF node reference from
of_parse_phandle_with_fixed_args() in hns_mac_get_info().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240827144421.52852-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index f75668c479351..616a2768e5048 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -933,6 +933,7 @@ static int hns_mac_get_info(struct hns_mac_cb *mac_cb)
 			mac_cb->cpld_ctrl = NULL;
 		} else {
 			syscon = syscon_node_to_regmap(cpld_args.np);
+			of_node_put(cpld_args.np);
 			if (IS_ERR_OR_NULL(syscon)) {
 				dev_dbg(mac_cb->dev, "no cpld-syscon found!\n");
 				mac_cb->cpld_ctrl = NULL;
-- 
2.43.0




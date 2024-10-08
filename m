Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EB833981;
	Tue,  8 Oct 2024 12:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389748; cv=none; b=c2qbaw2U6JtA+m5GnrzMp9hOEFiycmYVHTas50E+SXAVMEMSFel+FAa7pP1DxKRo8EUYE3TVix8DSO/1odWxsEnfJ1TS0/09R+VzNSE8TTu430Fz52hRpuHAkeJXZ13ZD2dizoeO/fKLugmb9hjesvWGBZcBVospX54f3Sr+xxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389748; c=relaxed/simple;
	bh=9gXO8L5J6m0Na6dQN/ku7GoKJwrSzuOdciv+2U8uYCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPq34yt81EW2medIcHuM8jhYh0aR6ZU6PtLQ4NM/Crmr00k20PFq9XEf8lebEB+vROXFtNd6F3Lg4p/fDeqUHu4nA48l1byX0TZVmmwGvP2WVxxOo4Uc1g7a3h/IENTWARYRBTjxrDIeVOIOwW7PICi9tIVbfRwpKuF+RFNHUxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdIhFAN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdIhFAN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D6AC4CEC7;
	Tue,  8 Oct 2024 12:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389748;
	bh=9gXO8L5J6m0Na6dQN/ku7GoKJwrSzuOdciv+2U8uYCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdIhFAN0INWMlpSxFv9G6bvVtExLTlAUpwOp0Bl0BZVz8A+Kat63YML3OZ0pvilDf
	 dfhAwipzXqL8F5YYGMYmWVXE0/jcK/CMVLlg8loPcgkezZzUpTGY6a5y5Pc8xg3TeC
	 WqqnUSqZySVm0OH2Li65iES4R673uR3qpN+wzbH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 083/482] net: hisilicon: hns_dsaf_mac: fix OF node leak in hns_mac_get_info()
Date: Tue,  8 Oct 2024 14:02:26 +0200
Message-ID: <20241008115651.572901311@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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




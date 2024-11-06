Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7D81D416E;
	Wed,  6 Nov 2024 12:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895235; cv=none; b=CRZHoISHtAWtZPRp4MAtOrH6m5xGtpbPlqPHNlgCA67psHGnd2WOKkOzON27GdE69kbcEj3U71pmH18OmGJ2SVpftN4vBHjunsKtIIpULcA4e0JksbpFaKLvgUp02JhTKHXRsJn+dCNPASnUqQl15BKoIHe86MynqKL24KWHHss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895235; c=relaxed/simple;
	bh=olfnTvCBj/Nhh48VkPiXrHa/OdsVu9nlVQYinC0phww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNRXYpuRQVuy8MRhymkYHjfm8+QrVFUxo6CyuE1k5kIgQBTNPRQxw5gLjVdk7BpSufHxxnyUAD7mmGXTaYGXkTrmHldjgJnNICcBiY5nVJm73gZYI2tn5fkMmhmJFiWppaahu0q9Vza9mFXhLFNxrqKtT+20H0oMIHGpEfuYh84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRDxmZBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRDxmZBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9961BC4CECD;
	Wed,  6 Nov 2024 12:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895235;
	bh=olfnTvCBj/Nhh48VkPiXrHa/OdsVu9nlVQYinC0phww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRDxmZBHd8KvaoIO9vWBzAQ6ojaKAIFhre2XDp5C8VRmW3aALhLqF0PgZehm+MYa5
	 cHajg6GbLWQflyRU5FaybMIFTqDh39ZXAIwtM3YTczIe6TnyRXpgUeLVj+ROVB9vVT
	 Si/DVA5JC2WnQk03tqrVXPHTBs4znekuan+X7vC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/350] net: hisilicon: hns_dsaf_mac: fix OF node leak in hns_mac_get_info()
Date: Wed,  6 Nov 2024 13:01:17 +0100
Message-ID: <20241106120324.596441563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d2791bcff5d49..5ee4317e5a524 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -937,6 +937,7 @@ static int hns_mac_get_info(struct hns_mac_cb *mac_cb)
 			mac_cb->cpld_ctrl = NULL;
 		} else {
 			syscon = syscon_node_to_regmap(cpld_args.np);
+			of_node_put(cpld_args.np);
 			if (IS_ERR_OR_NULL(syscon)) {
 				dev_dbg(mac_cb->dev, "no cpld-syscon found!\n");
 				mac_cb->cpld_ctrl = NULL;
-- 
2.43.0




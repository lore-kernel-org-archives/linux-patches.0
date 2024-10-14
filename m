Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ED01ADFE4;
	Mon, 14 Oct 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918796; cv=none; b=N0KKGIodVuco0aN05TkLAGnGkjQ0UkeKRl2YGNQjc2IebYh4vdrssywxe1Aek9i6rjEEO5J3EDM3jqeyWtL2v/G0cgE9zowdJIYGrFEp1OW7S2Pb6iL5vNLglvh9o1jlPkfTUo8cekD33PShCWX72QZ3zjcq9gHzYBUxrsP3Whw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918796; c=relaxed/simple;
	bh=U0DL+SOqct6qSElq0H0gAL6im3nEGSwlLIx5dHmFZDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6YhVK9YTu8M9iXSc+UGmm766WPn0Y+zFTWVbXh2ITRjxhNX4AgxlynUzr69b0awPLM09Bbccu2md5Mz4gH0DCUqNot2ouAq/kAvimhBKkGwJOLJYo2mwmTqidCR5Lb8gvFb1lD7uk46MZelO3ifK6N0CExcvgHlP2Ilgh+34M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USVO0wFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USVO0wFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729A2C4CEC3;
	Mon, 14 Oct 2024 15:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918796;
	bh=U0DL+SOqct6qSElq0H0gAL6im3nEGSwlLIx5dHmFZDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USVO0wFyie2fuBeGnF325JvtvT9cx3YA0Ur3v9gS+LcGIUIWPoniE0ooCHGQZ5r0N
	 xxjio/9fQuW0D5LXmvWCD8YX9SXREuduOcwCHwz+MS1EdfKg8cB7Et9tVwS3r7H4gE
	 V0oNk2adxQzDsydjSnEGCXlknPbOTF0zpPMY014Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 425/798] net: hisilicon: hns_mdio: fix OF node leak in probe()
Date: Mon, 14 Oct 2024 16:16:19 +0200
Message-ID: <20241014141234.647138645@linuxfoundation.org>
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
index c2ae1b4f9a5f9..8a9dce6017d84 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -497,6 +497,7 @@ static int hns_mdio_probe(struct platform_device *pdev)
 						MDIO_SC_RESET_ST;
 				}
 			}
+			of_node_put(reg_args.np);
 		} else {
 			dev_warn(&pdev->dev, "find syscon ret = %#x\n", ret);
 			mdio_dev->subctrl_vbase = NULL;
-- 
2.43.0




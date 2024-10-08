Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CBF192594;
	Tue,  8 Oct 2024 12:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391390; cv=none; b=HzTjoBWbsqwUQn3Bzul/+iecSCibvXPWqaNMCqFAU47IKzd5Q0l2ALrb46dThuN5Cq37M+agOQtSjzzohpva9atl8zQd4IdMVHDwT8HrAIKF9SMuYfOd81ASsiNAhwl/81SSYZsmrewNYqLK/7RX8Z/3Zjaf512F0Ao96h/kbvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391390; c=relaxed/simple;
	bh=3LlPfwUe+BRNS15IfCb05IXiX/49yv7kuHELMUcHXi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzCONjzCWMDn+5YPmPkwuGnDo9+4a0exDcwFWk8ksJuVvpnK8OIAy3a3BAwWzPHHC8GJLjGPjhhPMeIIFO/slljvp+fRXIgKhQJwF3fOrK3kE2Pm6yD2K+QA+CgpUtpmz1eEFOQd5LY7VpHxgYtJbmVhkYViFQlm1uDalPvjexE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4WdM6sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4WdM6sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0EFC4CEC7;
	Tue,  8 Oct 2024 12:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391390;
	bh=3LlPfwUe+BRNS15IfCb05IXiX/49yv7kuHELMUcHXi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4WdM6sk+4lvnt1cj4np3Ha6SSwnPj71mKUDATTSPx6g7BMV2REHun1vFun34S+EX
	 gDlcA8qcX86JtWTHB/ob7Qy7tX3bgPCVwyeXjjzdjlogu5JXzYvh3t5l+JzzbHWzfV
	 OB1WX/pcDF6Zke7r82N+psHucrjIokdILyZMj6XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 098/558] net: hisilicon: hns_dsaf_mac: fix OF node leak in hns_mac_get_info()
Date: Tue,  8 Oct 2024 14:02:08 +0200
Message-ID: <20241008115706.226257802@linuxfoundation.org>
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




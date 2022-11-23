Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0F51C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56483C433B5;
	Wed, 23 Nov 2022 09:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196607;
	bh=4KqGL/pJIMIXFHQvmVzGjYzTnB13LiHnPqW7dkr5xQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrYC32BU9WVZDBzi219tX5vMqNUtVHu9Zz+uIdmjdQfru38VcVtc6NS/I9HP1t2Tp
	 4PZe1JvUnVsxlpOG1xYaijG3aTmWTY/kwSxowZrqwlAfzCyCJMjUoa09+epJpPeO9b
	 zwwhrnGfescSB9I+86qWwk2OGn6z/tQSzt2qQ6Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 079/314] arm64: dts: qcom: sc8280xp: correct ref clock for ufs_mem_phy
Date: Wed, 23 Nov 2022 09:48:44 +0100
Message-Id: <20221123084629.053459341@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit f3aa975e230e060c07dcfdf3fe92b59809422c13 ]

The first UFS host controller fails to start on the SA8540P automotive
board (QDrive3) due to the following errors:

    ufshcd-qcom 1d84000.ufs: ufshcd_query_flag: Sending flag query for idn 18 failed, err = 253
    ufshcd-qcom 1d84000.ufs: ufshcd_query_flag: Sending flag query for idn 18 failed, err = 253
    ufshcd-qcom 1d84000.ufs: ufshcd_query_flag: Sending flag query for idn 18 failed, err = 253
    ufshcd-qcom 1d84000.ufs: ufshcd_query_flag_retry: query attribute, opcode 5, idn 18, failed
        with error 253 after 3 retries

The system eventually fails to boot with the warning:

    gcc_ufs_phy_axi_clk status stuck at 'off'

This issue can be worked around by adding clk_ignore_unused to the
kernel command line since the system firmware sets up this clock for us.

Let's fix this issue by updating the ref clock on ufs_mem_phy. Note
that the downstream MSM 5.4 sources list this as ref_clk_parent. With
this patch, the SA8540P is able to be booted without clk_ignore_unused.

Signed-off-by: Brian Masney <bmasney@redhat.com>
Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221006145529.755521-1-bmasney@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 92cbe84de0e5..cdc395d53c5a 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -891,7 +891,7 @@ ufs_mem_phy: phy@1d87000 {
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&rpmhcc RPMH_CXO_CLK>,
+			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
 			resets = <&ufs_mem_hc 0>;
-- 
2.35.1




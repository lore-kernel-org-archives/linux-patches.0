Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD6B6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6A5C433EF;
	Mon,  3 Apr 2023 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532857;
	bh=VJ8fSE6cPSnFA9ct74l+U//TUQbG/ORxZtqTFAi4G1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIhsnYtY0bd8aVMEClAjTv+lOPf8FHIhokMkfoK+W5cal0FyiYDQ3/ehxTyXyJYs+
	 66/mlA6DEO4LO68dwy6600YawXe3tKJx42OvNh18eMbfCHWntoHwGmn3Msvfmq79NP
	 969dEHgSfFdVT/iyafQ+SlEEKTgSeIsZAODn+BJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazan Shhady <yazan.shhady@solid-run.com>,
	Josua Mayer <josua@solid-run.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 143/181] net: phy: dp83869: fix default value for tx-/rx-internal-delay
Date: Mon,  3 Apr 2023 16:09:38 +0200
Message-Id: <20230403140419.702771263@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josua Mayer <josua@solid-run.com>

commit 82e2c39f9ef78896e9b634dfd82dc042e6956bb7 upstream.

dp83869 internally uses a look-up table for mapping supported delays in
nanoseconds to register values.
When specific delays are defined in device-tree, phy_get_internal_delay
does the lookup automatically returning an index.

The default case wrongly assigns the nanoseconds value from the lookup
table, resulting in numeric value 2000 applied to delay configuration
register, rather than the expected index values 0-7 (7 for 2000).
Ultimately this issue broke RX for 1Gbps links.

Fix default delay configuration by assigning the intended index value
directly.

Cc: stable@vger.kernel.org
Fixes: 736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")
Co-developed-by: Yazan Shhady <yazan.shhady@solid-run.com>
Signed-off-by: Yazan Shhady <yazan.shhady@solid-run.com>
Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230323102536.31988-1-josua@solid-run.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83869.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -588,15 +588,13 @@ static int dp83869_of_init(struct phy_de
 						       &dp83869_internal_delay[0],
 						       delay_size, true);
 	if (dp83869->rx_int_delay < 0)
-		dp83869->rx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->rx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	dp83869->tx_int_delay = phy_get_internal_delay(phydev, dev,
 						       &dp83869_internal_delay[0],
 						       delay_size, false);
 	if (dp83869->tx_int_delay < 0)
-		dp83869->tx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->tx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	return ret;
 }



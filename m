Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93C76FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BFBC433EF;
	Mon,  3 Apr 2023 14:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532372;
	bh=hxltqeVwF+oJAQ2pgzEC6pFDRZH34I2IvvmVhWIubOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=140tyhEt2X2wv913gntxhL1ai7XaPyAga3IfhCVrsxZ3mg178j92dIV61M9I5Os80
	 DFq2VjNM9EjCCnF8qmF1roNl8MrqYC97fUuRCwjB7M1g+flCB0OaHbK91MylQSuLZA
	 uvevu0KB6pD8Op8hQPl9PtOeqwIEUnjb5SR/+cwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 58/99] bnxt_en: Fix reporting of test result in ethtool selftest
Date: Mon,  3 Apr 2023 16:09:21 +0200
Message-Id: <20230403140405.583239219@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 83714dc3db0e4a088673601bc8099b079bc1a077 ]

When the selftest command fails, driver is not reporting the failure
by updating the "test->flags" when bnxt_close_nic() fails.

Fixes: eb51365846bc ("bnxt_en: Add basic ethtool -t selftest support.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 586311a271f21..9ac5f63784960 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3504,6 +3504,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 		bnxt_ulp_stop(bp);
 		rc = bnxt_close_nic(bp, true, false);
 		if (rc) {
+			etest->flags |= ETH_TEST_FL_FAILED;
 			bnxt_ulp_start(bp, rc);
 			return;
 		}
-- 
2.39.2




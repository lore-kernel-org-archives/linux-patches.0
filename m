Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529272566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA39FC433D2;
	Tue, 18 Apr 2023 12:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820675;
	bh=vP1CQ7n3A8UAdIcv9Up82ehRod7FV+KfCTpUhDT3sPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USPf9EOxpdn+KmA81epEMloKnw4qWMyEL2OYotSag52xm2kcFDwfc0H6IM0ncNnpS
	 tWyI9rS+1QYxy0ZJrn6Yuyel6medXz4ch+roBmQxAW2vavCqrrstM4y93MJnyEV/7s
	 +2NkMmiHcx38udyDOUHHJ3BXhHrJWeyIaADvqFtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Plotnikov <den-plotnikov@yandex-team.ru>,
	Simon Horman <simon.horman@corigine.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/37] qlcnic: check pci_reset_function result
Date: Tue, 18 Apr 2023 14:21:36 +0200
Message-Id: <20230418120255.606190752@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Denis Plotnikov <den-plotnikov@yandex-team.ru>

[ Upstream commit 7573099e10ca69c3be33995c1fcd0d241226816d ]

Static code analyzer complains to unchecked return value.
The result of pci_reset_function() is unchecked.
Despite, the issue is on the FLR supported code path and in that
case reset can be done with pcie_flr(), the patch uses less invasive
approach by adding the result check of pci_reset_function().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7e2cf4feba05 ("qlcnic: change driver hardware interface mechanism")
Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
index d344e9d438321..d3030bd967d5a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
@@ -629,7 +629,13 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
 	int i, err, ring;
 
 	if (dev->flags & QLCNIC_NEED_FLR) {
-		pci_reset_function(dev->pdev);
+		err = pci_reset_function(dev->pdev);
+		if (err) {
+			dev_err(&dev->pdev->dev,
+				"Adapter reset failed (%d). Please reboot\n",
+				err);
+			return err;
+		}
 		dev->flags &= ~QLCNIC_NEED_FLR;
 	}
 
-- 
2.39.2




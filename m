Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9972572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A78C433EF;
	Tue, 18 Apr 2023 12:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821833;
	bh=lVLKM0NOuTQExlSnMc3COC2k+sIlb8a9XFSwgYSHVBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CI0DtlN8hwH6lAuy8B9S0zJQtA8t1WIWLfn8FuWv+4ZmqeL/abkuDeD5sexMpHL+H
	 O4p8HupYO7JhLh4Ko7AIKBWOjApY8X8TxrFSQ8vWP+hu71jewYeQLl/pM5E8zTJx3C
	 zsGouY4JaBPPtCinQFCv91xnMmAgpnhHOXj4G+oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Plotnikov <den-plotnikov@yandex-team.ru>,
	Simon Horman <simon.horman@corigine.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/134] qlcnic: check pci_reset_function result
Date: Tue, 18 Apr 2023 14:21:55 +0200
Message-Id: <20230418120315.014699863@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
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
index 87f76bac2e463..eb827b86ecae8 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
@@ -628,7 +628,13 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0AF63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C5BC433D2;
	Mon, 20 Feb 2023 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901722;
	bh=a/UiooHYDOpNciVZOA7OSu8FGgn+oFJk1uIh2EFUeyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6/GRvM/Em6Eh99OJNEsv/Ex4M2igrHIieQl7Go5swNnhNI66KQUWsiZ1iSIlhiFN
	 pJU7nlNXHhESxec0a4HjsntVl/1inbc2XZJiPwKfJFeiOFumCHFzU5G14+A5hguDQS
	 JBPMzRxRSjViPpAynCQu9qiu0EklLK5GMIVShGBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongguang Gao <hongguang.gao@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 094/118] bnxt_en: Fix mqprio and XDP ring checking logic
Date: Mon, 20 Feb 2023 14:36:50 +0100
Message-Id: <20230220133604.150116718@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Chan <michael.chan@broadcom.com>

commit 2038cc592811209de20c4e094ca08bfb1e6fbc6c upstream.

In bnxt_reserve_rings(), there is logic to check that the number of TX
rings reserved is enough to cover all the mqprio TCs, but it fails to
account for the TX XDP rings.  So the check will always fail if there
are mqprio TCs and TX XDP rings.  As a result, the driver always fails
to initialize after the XDP program is attached and the device will be
brought down.  A subsequent ifconfig up will also fail because the
number of TX rings is set to an inconsistent number.  Fix the check to
properly account for TX XDP rings.  If the check fails, set the number
of TX rings back to a consistent number after calling netdev_reset_tc().

Fixes: 674f50a5b026 ("bnxt_en: Implement new method to reserve rings.")
Reviewed-by: Hongguang Gao <hongguang.gao@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9239,10 +9239,14 @@ int bnxt_reserve_rings(struct bnxt *bp,
 		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
 		return rc;
 	}
-	if (tcs && (bp->tx_nr_rings_per_tc * tcs != bp->tx_nr_rings)) {
+	if (tcs && (bp->tx_nr_rings_per_tc * tcs !=
+		    bp->tx_nr_rings - bp->tx_nr_rings_xdp)) {
 		netdev_err(bp->dev, "tx ring reservation failure\n");
 		netdev_reset_tc(bp->dev);
-		bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+		if (bp->tx_nr_rings_xdp)
+			bp->tx_nr_rings_per_tc = bp->tx_nr_rings_xdp;
+		else
+			bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 		return -ENOMEM;
 	}
 	return 0;



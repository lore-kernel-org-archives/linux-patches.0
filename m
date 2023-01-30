Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4894628EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34C3C433D2;
	Mon, 30 Jan 2023 14:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087679;
	bh=KFRINgm8KcJ1OURcJmVKkvn0OoSNh4bp4JQmh+bAYQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvLlCq6s2ouzpwsWLkqNpaY6w4HBjlH8qpVZbwEZRfxQQ5FtDSwY3ITlDqHJbhx9/
	 6H/ot3n+rThI3U1ai1+9ZaWIEBa74I5ED1OiK5Dvhg+ClFhrSGCn632X39Ke5gFlwo
	 sb5FYWcop3rBbKVZDuCW6ve6qDvMgfBUY3fH+TJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 288/313] net: ravb: Fix possible hang if RIS2_QFF1 happen
Date: Mon, 30 Jan 2023 14:52:03 +0100
Message-Id: <20230130134350.143708322@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit f3c07758c9007a6bfff5290d9e19d3c41930c897 ]

Since this driver enables the interrupt by RIC2_QFE1, this driver
should clear the interrupt flag if it happens. Otherwise, the interrupt
causes to hang the system.

Note that this also fix a minor coding style (a comment indentation)
around the fixed code.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 3f61100c02f4..0f54849a3823 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1101,14 +1101,14 @@ static void ravb_error_interrupt(struct net_device *ndev)
 	ravb_write(ndev, ~(EIS_QFS | EIS_RESERVED), EIS);
 	if (eis & EIS_QFS) {
 		ris2 = ravb_read(ndev, RIS2);
-		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_RFFF | RIS2_RESERVED),
+		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_QFF1 | RIS2_RFFF | RIS2_RESERVED),
 			   RIS2);
 
 		/* Receive Descriptor Empty int */
 		if (ris2 & RIS2_QFF0)
 			priv->stats[RAVB_BE].rx_over_errors++;
 
-		    /* Receive Descriptor Empty int */
+		/* Receive Descriptor Empty int */
 		if (ris2 & RIS2_QFF1)
 			priv->stats[RAVB_NC].rx_over_errors++;
 
-- 
2.39.0




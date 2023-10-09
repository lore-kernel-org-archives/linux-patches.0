Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82E518035
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkmrO7/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E68C433BA;
	Mon,  9 Oct 2023 13:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858867;
	bh=FzQXAIEPq73bbaLDPZZ2ws2vVbcg3NX4M3rc6zKEfgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkmrO7/rfNZm70DQZ6L2E/2cE6OJWHPLvCchgR3mrBPNwW+KkeqwROZIMhxf5/sqh
	 HjvjRbSgL2dYBcj/M1vcMfr7K2zhHeGNR3uyGoyiXOLvfO/wwuW3eMWA33re1pykuZ
	 ZFND7nqA1PmwsVGYPuLf+wNY4KwwZ3fuKPas4oZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johnathan Mantey <johnathanx.mantey@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/226] ncsi: Propagate carrier gain/loss events to the NCSI controller
Date: Mon,  9 Oct 2023 15:01:27 +0200
Message-ID: <20231009130130.067707273@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johnathan Mantey <johnathanx.mantey@intel.com>

[ Upstream commit 3780bb29311eccb7a1c9641032a112eed237f7e3 ]

Report the carrier/no-carrier state for the network interface
shared between the BMC and the passthrough channel. Without this
functionality the BMC is unable to reconfigure the NIC in the event
of a re-cabling to a different subnet.

Signed-off-by: Johnathan Mantey <johnathanx.mantey@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-aen.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
index 62fb1031763d1..f8854bff286cb 100644
--- a/net/ncsi/ncsi-aen.c
+++ b/net/ncsi/ncsi-aen.c
@@ -89,6 +89,11 @@ static int ncsi_aen_handler_lsc(struct ncsi_dev_priv *ndp,
 	if ((had_link == has_link) || chained)
 		return 0;
 
+	if (had_link)
+		netif_carrier_off(ndp->ndev.dev);
+	else
+		netif_carrier_on(ndp->ndev.dev);
+
 	if (!ndp->multi_package && !nc->package->multi_channel) {
 		if (had_link) {
 			ndp->flags |= NCSI_DEV_RESHUFFLE;
-- 
2.40.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352461C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D58C433D7;
	Wed, 23 Nov 2022 09:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196198;
	bh=D/WIh5R2adg4XBCeMwf3pUWG66pCNDtgGxKWD/bliWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvP1W1J0NfqAQfTZSlijIJ0SC/m0Z3u1i2VgkN0n2huF67N14G/JYAiQHD0d2fA/H
	 A+QqzSPuHQvyEjBpLc6NLlhLnj2xg252klh7JunsQxCidVaFHm77xhw1lRDDjSW5DL
	 GsSYgtGRsoEh/JkmRDLYkR8sKqHvE85exRKCxXh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 146/181] net: phy: marvell: add sleep time after enabling the loopback bit
Date: Wed, 23 Nov 2022 09:51:49 +0100
Message-Id: <20221123084608.675937796@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>

commit 18c532e44939caa17f1fa380f7ac50dbc0718dbb upstream.

Sleep time is added to ensure the phy to be ready after loopback
bit was set. This to prevent the phy loopback test from failing.

Fixes: 020a45aff119 ("net: phy: marvell: add Marvell specific PHY loopback")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
Link: https://lore.kernel.org/r/20221114065302.10625-1-aminuddin.jamaluddin@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1976,14 +1976,16 @@ static int m88e1510_loopback(struct phy_
 		if (err < 0)
 			return err;
 
-		/* FIXME: Based on trial and error test, it seem 1G need to have
-		 * delay between soft reset and loopback enablement.
-		 */
-		if (phydev->speed == SPEED_1000)
-			msleep(1000);
+		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+				 BMCR_LOOPBACK);
 
-		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
-				  BMCR_LOOPBACK);
+		if (!err) {
+			/* It takes some time for PHY device to switch
+			 * into/out-of loopback mode.
+			 */
+			msleep(1000);
+		}
+		return err;
 	} else {
 		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
 		if (err < 0)



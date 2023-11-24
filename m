Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3F73A8C5;
	Fri, 24 Nov 2023 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWouPX5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26821C433C7;
	Fri, 24 Nov 2023 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849950;
	bh=L5EJwMTPFDe7RRtMds+glArTTfEzsKjR5K0DYmexLkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWouPX5AYKCd112TBoO7mnVBj3Cv/ifXD81N2b6y75lUltHSpPXwMnrSawMjmGyKh
	 8PoSWie78EElxaReDyJ0D3d5sP9cHutPvDCNqXmgVItr49DvrBSRY4jyNmfT3fYtP/
	 wotqUOVGj5emACoX6xfG6OWt3RmBTvlBemqUTAoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Yeong <joshua.yeong@starfivetech.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 386/530] i3c: master: cdns: Fix reading status register
Date: Fri, 24 Nov 2023 17:49:12 +0000
Message-ID: <20231124172039.771515594@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Yeong <joshua.yeong@starfivetech.com>

commit 4bd8405257da717cd556f99e5fb68693d12c9766 upstream.

IBIR_DEPTH and CMDR_DEPTH should read from status0 instead of status1.

Cc: stable@vger.kernel.org
Fixes: 603f2bee2c54 ("i3c: master: Add driver for Cadence IP")
Signed-off-by: Joshua Yeong <joshua.yeong@starfivetech.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20230913031743.11439-2-joshua.yeong@starfivetech.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/i3c-master-cdns.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/i3c/master/i3c-master-cdns.c
+++ b/drivers/i3c/master/i3c-master-cdns.c
@@ -191,7 +191,7 @@
 #define SLV_STATUS1_HJ_DIS		BIT(18)
 #define SLV_STATUS1_MR_DIS		BIT(17)
 #define SLV_STATUS1_PROT_ERR		BIT(16)
-#define SLV_STATUS1_DA(x)		(((s) & GENMASK(15, 9)) >> 9)
+#define SLV_STATUS1_DA(s)		(((s) & GENMASK(15, 9)) >> 9)
 #define SLV_STATUS1_HAS_DA		BIT(8)
 #define SLV_STATUS1_DDR_RX_FULL		BIT(7)
 #define SLV_STATUS1_DDR_TX_FULL		BIT(6)
@@ -1623,13 +1623,13 @@ static int cdns_i3c_master_probe(struct
 	/* Device ID0 is reserved to describe this master. */
 	master->maxdevs = CONF_STATUS0_DEVS_NUM(val);
 	master->free_rr_slots = GENMASK(master->maxdevs, 1);
+	master->caps.ibirfifodepth = CONF_STATUS0_IBIR_DEPTH(val);
+	master->caps.cmdrfifodepth = CONF_STATUS0_CMDR_DEPTH(val);
 
 	val = readl(master->regs + CONF_STATUS1);
 	master->caps.cmdfifodepth = CONF_STATUS1_CMD_DEPTH(val);
 	master->caps.rxfifodepth = CONF_STATUS1_RX_DEPTH(val);
 	master->caps.txfifodepth = CONF_STATUS1_TX_DEPTH(val);
-	master->caps.ibirfifodepth = CONF_STATUS0_IBIR_DEPTH(val);
-	master->caps.cmdrfifodepth = CONF_STATUS0_CMDR_DEPTH(val);
 
 	spin_lock_init(&master->ibi.lock);
 	master->ibi.num_slots = CONF_STATUS1_IBI_HW_RES(val);



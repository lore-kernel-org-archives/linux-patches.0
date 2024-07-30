Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0B41A616E;
	Tue, 30 Jul 2024 16:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357078; cv=none; b=qQ2oqYCr2PYarT0czoN81g0LqzVCovxpAfS1cE1o4lMDQIUmGqtKOO196EfuoDDkvqF4dlkI09lctIyxE1z6KVzi3jJlF51pGV+qjaa7g8+XWgohQ24PuumrtptsnyEvSfqea38/rmoiIf1ki2RWahckhMnOhF6hSUl7gDfzDeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357078; c=relaxed/simple;
	bh=z0MzwLgoY6ArNDYmX2pQa+bis3BOKbuvk1sHRISiyQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D0qAFa9c5SsFEEFpJdTxPiOzntiBEPE/tKjl1SL6qE+YJTBgRnxrDmS0Bu7nkUi6dYcqasx6td9GA+tzTuoMfEaHcG4aCLh31x0otUXFWzEPHIsoBroHzetbQR1Tos2nXneACkgq9KbSKDJnR4FSLqRLlsCd/R96NrLZH39Uu2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZpggBDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZpggBDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4624C32782;
	Tue, 30 Jul 2024 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357078;
	bh=z0MzwLgoY6ArNDYmX2pQa+bis3BOKbuvk1sHRISiyQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZpggBDlwgZZi2NrkQfQKQuEjDjC8LTDWM5AQCDUD3hVXGi1nQCR16E5LH+RbDFjb
	 IQI7cARBUzxKfmeEmBzekGNQEvktG4W0lsymgS+7GYYj69+q3VXp6v53dAOJjmqTGa
	 8pxRFIkC7zyB/elHcKOT4Zjsi9JDhSUrQr82aGYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Csókás
Subject: [PATCH 6.10 201/809] net: fec: Fix FEC_ECR_EN1588 being cleared on link-down
Date: Tue, 30 Jul 2024 17:41:17 +0200
Message-ID: <20240730151732.546312624@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit c32fe1986f27cac329767d3497986e306cad1d5e ]

FEC_ECR_EN1588 bit gets cleared after MAC reset in `fec_stop()`, which
makes all 1588 functionality shut down, and all the extended registers
disappear, on link-down, making the adapter fall back to compatibility
"dumb mode". However, some functionality needs to be retained (e.g. PPS)
even without link.

Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")
Cc: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/netdev/5fa9fadc-a89d-467a-aae9-c65469ff5fe1@lunn.ch/
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 881ece735dcf1..fb19295529a21 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1361,6 +1361,12 @@ fec_stop(struct net_device *ndev)
 		writel(FEC_ECR_ETHEREN, fep->hwp + FEC_ECNTRL);
 		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
 	}
+
+	if (fep->bufdesc_ex) {
+		val = readl(fep->hwp + FEC_ECNTRL);
+		val |= FEC_ECR_EN1588;
+		writel(val, fep->hwp + FEC_ECNTRL);
+	}
 }
 
 static void
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD0618A922;
	Fri, 15 Nov 2024 06:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653970; cv=none; b=XzPL0Supm7FQP+08C8wVg1ceizu4o7yRdffh2sVHfGmLGVG/23hkTUx6WrBfcqKipMuwFdrFpwaFgD+55Bx2l+LzaJtElDvfgtljH2eHbIvRLnBnXDoybkHV1VI6iDwaCvpTGFugNLew70wmyz+yLI/n3DvCxaRwaThM24DyKEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653970; c=relaxed/simple;
	bh=aU5agX7tTLJgBCmwHosiSVY9DA2VpsTwNvYW2s+p2/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XioTIj6JBZv8Mf9XSjcId4dloOgrLhisaqtNe6O/MdvW0CDiXMoUuqc+X7zocqxgy1WQRHYNElIuhBmx1J6UvK9i62Ie1Yuhx1RcDhNirV6dt3uJY+x4dURS7Qsf/EeTTQhfgMKj1qwzlRJqyTMFEZMIufT5+F16yU+7c75nOag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2IsTjxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2IsTjxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A462C4CED7;
	Fri, 15 Nov 2024 06:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653970;
	bh=aU5agX7tTLJgBCmwHosiSVY9DA2VpsTwNvYW2s+p2/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2IsTjxJcXiJnoz2Qez9z/9fKxBuNTPGbURzSnLbgTQILKtMAgBKwcQLkAZ9b1eHC
	 Mlx8Y0n2Y+j6Pm2m+u4x/RAFz+SKnO8gGTBONjoXSPdeAr6hsRsfa/7ZNg4T9oCWOF
	 2msrEor5wh2FHe3BEK/VjHHodCeKLNuq8asxaN5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schuchmann <schuchmann@schleissheimer.de>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 69/82] net: phy: ti: take into account all possible interrupt sources
Date: Fri, 15 Nov 2024 07:38:46 +0100
Message-ID: <20241115063728.037843876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

commit 73f476aa1975bae6a792b340f5b26ffcfba869a6 upstream.

The previous implementation of .handle_interrupt() did not take into
account the fact that all the interrupt status registers should be
acknowledged since multiple interrupt sources could be asserted.

Fix this by reading all the status registers before exiting with
IRQ_NONE or triggering the PHY state machine.

Fixes: 1d1ae3c6ca3f ("net: phy: ti: implement generic .handle_interrupt() callback")
Reported-by: Sven Schuchmann <schuchmann@schleissheimer.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20210226153020.867852-1-ciorneiioana@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83822.c   |    9 +++++----
 drivers/net/phy/dp83tc811.c |   11 ++++++-----
 2 files changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -305,6 +305,7 @@ static int dp83822_config_intr(struct ph
 
 static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 {
+	bool trigger_machine = false;
 	int irq_status;
 
 	/* The MISR1 and MISR2 registers are holding the interrupt status in
@@ -320,7 +321,7 @@ static irqreturn_t dp83822_handle_interr
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
 	irq_status = phy_read(phydev, MII_DP83822_MISR2);
 	if (irq_status < 0) {
@@ -328,11 +329,11 @@ static irqreturn_t dp83822_handle_interr
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
-	return IRQ_NONE;
+	if (!trigger_machine)
+		return IRQ_NONE;
 
-trigger_machine:
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -256,6 +256,7 @@ static int dp83811_config_intr(struct ph
 
 static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
 {
+	bool trigger_machine = false;
 	int irq_status;
 
 	/* The INT_STAT registers 1, 2 and 3 are holding the interrupt status
@@ -271,7 +272,7 @@ static irqreturn_t dp83811_handle_interr
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
 	irq_status = phy_read(phydev, MII_DP83811_INT_STAT2);
 	if (irq_status < 0) {
@@ -279,7 +280,7 @@ static irqreturn_t dp83811_handle_interr
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
 	irq_status = phy_read(phydev, MII_DP83811_INT_STAT3);
 	if (irq_status < 0) {
@@ -287,11 +288,11 @@ static irqreturn_t dp83811_handle_interr
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
-	return IRQ_NONE;
+	if (!trigger_machine)
+		return IRQ_NONE;
 
-trigger_machine:
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;



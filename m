Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2AD33508C;
	Wed,  3 Dec 2025 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780850; cv=none; b=fzKDD7sR8UP6wC5b4CyShBl5GQWXJAfimsniANN1Q77ekd0/ZS6MaEx9xb1R+vYlFhBD1CCyMig5FU0rxXN4hsU0NToEVCEHuXhPphQXNZIvZSSKp42D5IaNl1UAi4iFjg/hqE0TrvDpga1R8wHP+SaXitJcTgqmcew6ueUyGrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780850; c=relaxed/simple;
	bh=AD2fip46Cd0zVFIDSjYsYfrPeB0t5H217I3Y1Xaw04A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHJktT3nm807wveycNv2eCOZCNatqT20Bt2qWweQq9OodJI8aQzDbSyMoQ4wYdRKDyWSphtDoBFSeyZONVBLpZvP6vN6KDTUkvzmlMsFbeJV1Z577bgxqL4eGQc5LT6qHVGTyjN8Cp3cdDQpXVLQ5mn0v90jERAUNAwKNJz4nLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptQtsy1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptQtsy1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE41C4CEF5;
	Wed,  3 Dec 2025 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780849;
	bh=AD2fip46Cd0zVFIDSjYsYfrPeB0t5H217I3Y1Xaw04A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptQtsy1h7KG7h5z70kIWHFRKRW/URcYDJOXa3XwDjBNFBhDQHw921e2YrOO/6gtAG
	 D4MlD1CMfe2TqB7zpT1PfcGoaCQI1ExHaMrb+mUjFgvDRnQ8ME5a7U/mzY8Hujgrty
	 +au2moazBjJgZROg4NazfbQ4X0hiEMD2vs32Y3KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 109/132] net: dsa: microchip: ptp: Fix checks on irq_find_mapping()
Date: Wed,  3 Dec 2025 16:29:48 +0100
Message-ID: <20251203152347.323068916@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>

commit 9e059305be41a5bd27e03458d8333cf30d70be34 upstream.

irq_find_mapping() returns a positive IRQ number or 0 if no IRQ is found
but it never returns a negative value. However, during the PTP IRQ setup,
we verify that its returned value isn't negative.

Fix the irq_find_mapping() check to enter the error path when 0 is
returned. Return -EINVAL in such case.

Cc: stable@vger.kernel.org
Fixes: cc13ab18b201 ("net: dsa: microchip: ptp: enable interrupt for timestamping")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
Link: https://patch.msgid.link/20251120-ksz-fix-v6-2-891f80ae7f8f@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_ptp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -1145,8 +1145,8 @@ int ksz_ptp_irq_setup(struct dsa_switch
 		irq_create_mapping(ptpirq->domain, irq);
 
 	ptpirq->irq_num = irq_find_mapping(port->pirq.domain, PORT_SRC_PTP_INT);
-	if (ptpirq->irq_num < 0) {
-		ret = ptpirq->irq_num;
+	if (!ptpirq->irq_num) {
+		ret = -EINVAL;
 		goto out;
 	}
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCFA34165B;
	Wed,  3 Dec 2025 16:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781179; cv=none; b=DdlX5wJ72NTqKssWgTBznlIQgaAEsSDqYvAviSgGfeY1yHZ93F1USNwmkJ/aqyZiUY3decyTNB4Fevn4wqrZSF35kUVGAhyPL2bEui2iBOPiCMgstAdjP2SVGfLhpG4MLf9EHfrTC+nPNNYuP0q9Eaz83bIzhowZ2Io2shpMKj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781179; c=relaxed/simple;
	bh=n2V9zA4wdRM74YY6A3f2WTt/zq3rw20Y9lc5YmeycqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3x7PQhgn6bkvIE/+j+TXOitC9xWIiQAjcBlo+iXYt0tVqOnjHU53U7iWHHq9WbyUrNgsfo2TEjgjFVtv6FIDla5lyTB/FC+HsGt21vzDws64XGUU5XliwBV3DL/YYKfYA0WImIuEPFlXd2i1ErfnHznhcsx+SkuOciwHSZdaLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7XKF6/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7XKF6/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F26C116C6;
	Wed,  3 Dec 2025 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781179;
	bh=n2V9zA4wdRM74YY6A3f2WTt/zq3rw20Y9lc5YmeycqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7XKF6/BcrlMlubmJqPdsa2cn+i5euGv4hftRZiIQ6684ZLKz4kX2Yq/QgF3mk3NI
	 /IufEDOphannOu7rFM7Xapd8dJ2TvgnuRHH6Jg0x1NTiidU/c8kBEvQOmELTkbNkEm
	 BiJ1zDwwWNxTWjCs3Yk4cL5VzruzIbt05CWef0YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 74/93] net: dsa: microchip: ptp: Fix checks on irq_find_mapping()
Date: Wed,  3 Dec 2025 16:30:07 +0100
Message-ID: <20251203152339.258372026@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 



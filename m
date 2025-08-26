Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60A929D26A;
	Tue, 26 Aug 2025 11:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208087; cv=none; b=glEIPA2wYjfjVpRmMmszc/OoZmhv1IWvBsndg6PlszPfEjudgU10z8lUPOKJNVZmlZySXrtfrDyzOuO1y1Red+iAFRw2ya7ZU3k1+Ea0tugHlVw0RGyBx4AaR8aJnPsomWfj3V1FWz93IKlTa52mX2LOpbQes8mfuU8wD2RQj5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208087; c=relaxed/simple;
	bh=ywSeUtFl8wD8rPvz4nvLYRjaRNmtqA2hQVVRE03aoT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mzg7WTZnzACVeK72ihp2xfglG9yitjkny2oFQOtmV86DgOYgJnm9hPl0qElj530jU9PKPQGVGqWF4eToruTpmkbzJXWAfKWoZ/E/2+zJktf5ppyDTOPK3hrvjQWylcnIS8pCMJkvvfs+buxctQw18gYpnRqAO83FPCxkzfg0ymI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h07HDWRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h07HDWRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E324C4CEF1;
	Tue, 26 Aug 2025 11:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208087;
	bh=ywSeUtFl8wD8rPvz4nvLYRjaRNmtqA2hQVVRE03aoT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h07HDWRMHe+rP3YLKrmRr/V9JGEFJQ3nP/ee45c7YGXhKpfTnOkPL0yXjB1lVA1xQ
	 jamJk4xexUppELjoMHKen9Czc6m0PoIusc6/2+2LwrQETmxlrcVTPG5buNku3QVPZ/
	 ANJrPJPk+pCepLXFfaZUA+s1rU9J5YlPbFgKLPCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Tristram Ha <tristram.ha@microchip.com>,
	=?UTF-8?q?=C5=81ukasz=20Majewski?= <lukma@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 433/457] net: dsa: microchip: Fix KSZ9477 HSR port setup issue
Date: Tue, 26 Aug 2025 13:11:57 +0200
Message-ID: <20250826110947.990802239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit e318cd6714592fb762fcab59c5684a442243a12f ]

ksz9477_hsr_join() is called once to setup the HSR port membership, but
the port can be enabled later, or disabled and enabled back and the port
membership is not set correctly inside ksz_update_port_member().  The
added code always use the correct HSR port membership for HSR port that
is enabled.

Fixes: 2d61298fdd7b ("net: dsa: microchip: Enable HSR offloading for KSZ9477")
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Reviewed-by: Łukasz Majewski <lukma@nabladev.com>
Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://patch.msgid.link/20250819010457.563286-1-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7c142c17b3f6..adef7aa327ce 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2347,6 +2347,12 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
 		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);
 	}
 
+	/* HSR ports are setup once so need to use the assigned membership
+	 * when the port is enabled.
+	 */
+	if (!port_member && p->stp_state == BR_STATE_FORWARDING &&
+	    (dev->hsr_ports & BIT(port)))
+		port_member = dev->hsr_ports;
 	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port);
 }
 
-- 
2.50.1




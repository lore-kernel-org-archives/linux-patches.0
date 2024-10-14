Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF391AB522;
	Mon, 14 Oct 2024 14:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916708; cv=none; b=iY4FtO0q2MC5PwpRXiWW6ieQgUleViGrq6Cn+zRZ2S3oscAcKvfpJWKlO+ks/IIeYqnbVhupOYLgEeXCcmpZL0st9lZMNTkxN41nF83lj4dz0Lwbo9G672VPBXubhQf2SJav0iR8kUhF0v6LwUVywMhVsSMhqvlBQDr6ccO770Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916708; c=relaxed/simple;
	bh=B+U+9+c2bUXrVI0sEv0EAed7w/usXCNmXYeoTgHJX/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d2FiXu26IqxiULftNHJQubRhYHyUNz0bvyZRU4c7++7LWrTx7NB+TEDNJ4Gd6mmTDWwdBr7/5V43sDHl9IzOs1YeAOIco7aLS32uaEEnI8qmkUVIiheDueELgCF7Hvm5o33tLqF/wwX7LeDivHesSObaNU+9WWdIm0ZuLRyHQjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMoxuetk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMoxuetk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35004C4CEC7;
	Mon, 14 Oct 2024 14:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916707;
	bh=B+U+9+c2bUXrVI0sEv0EAed7w/usXCNmXYeoTgHJX/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMoxuetklv/LFURy84VJAdMzsUPk+G2e0cBqSRfXfW/M/h6EdrCVwXdi28/6PdsMo
	 aMtQ9CyK/UeOroOKGPFUmKPac83j1qRwZ2DBdGuTbGBQ55vcFw7KKmZhXzUjzfnhNM
	 4vT37f3SWNGRXxiN1bZ+6DpqPVvJnOsgVa3gQUkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Wei Fang <wei.fang@nxp.com>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 002/213] net: fec: dont save PTP state if PTP is unsupported
Date: Mon, 14 Oct 2024 16:18:28 +0200
Message-ID: <20241014141043.065946661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit 6be063071a457767ee229db13f019c2ec03bfe44 upstream.

Some platforms (such as i.MX25 and i.MX27) do not support PTP, so on
these platforms fec_ptp_init() is not called and the related members
in fep are not initialized. However, fec_ptp_save_state() is called
unconditionally, which causes the kernel to panic. Therefore, add a
condition so that fec_ptp_save_state() is not called if PTP is not
supported.

Fixes: a1477dc87dc4 ("net: fec: Restart PPS after link state change")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/lkml/353e41fe-6bb4-4ee9-9980-2da2a9c1c508@roeck-us.net/
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://patch.msgid.link/20241008061153.1977930-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1058,7 +1058,8 @@ fec_restart(struct net_device *ndev)
 	u32 rcntl = OPT_FRAME_SIZE | 0x04;
 	u32 ecntl = FEC_ECR_ETHEREN;
 
-	fec_ptp_save_state(fep);
+	if (fep->bufdesc_ex)
+		fec_ptp_save_state(fep);
 
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
@@ -1321,7 +1322,8 @@ fec_stop(struct net_device *ndev)
 			netdev_err(ndev, "Graceful transmit stop did not complete!\n");
 	}
 
-	fec_ptp_save_state(fep);
+	if (fep->bufdesc_ex)
+		fec_ptp_save_state(fep);
 
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC



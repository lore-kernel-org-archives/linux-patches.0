Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267C0415F2D;
	Fri,  7 Aug 2026 15:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115537; cv=none; b=ZVwNMfnOugPmO1chq7/tyW/o6jrvPNWIoZ0CxlekbXao9uvExv8GWH62bWPmUaVc1diDu1RNwq3NACx5V890JPyWE/OtdESBfTUHHHsJru403EdQP4oX3oUCwWBLU1h75sjkHXwp41mHBWuiewwvQ5PGEiZo/vxK/1k28WAFx84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115537; c=relaxed/simple;
	bh=dwl3G85dpkBoGBHF1elWwyTHdrtVuFCMLIMIlId1Hv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1Vyol5ZWWCg9BsLH9FE4EsSccIC1XaQnVMVJEWmNzWpUD6qTEzSdw5qxRe5Ztk8k4iSejn0SpTCFODOn20zR2OcR5zle6rf/ke35ySmJX0OG1aNSCicel3xw/cjz0lG5WYYwO3lHXNiVu3LkdO4G06MFBEu9aES3jdGT1VNz48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQvVqxzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQvVqxzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40F01F00A3A;
	Fri,  7 Aug 2026 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115534;
	bh=yTknyh8JNB7bav6jgohNukVSfRn09ECAhTwD2QsI/sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQvVqxzd6hfhA6YHwfhtzX0NCEcZsDHsaaipW6ZKRnq5IOPpGApnyTYjNLITV5TSN
	 65Gehr2kTjs+qEAlUw/W3avQNmpjhcjVeKMiQRxnZP4Vst+Sgpec61887ar8L8XDNf
	 I5doGKjCEAdwYHhOCpy7Tp5cJN/sWKQztA9GbAfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 310/396] can: ctucanfd: handle bus error interrupts
Date: Fri,  7 Aug 2026 16:37:50 +0200
Message-ID: <20260807143430.956072176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

commit e74bae899529f49c0f375307983d12e8ecad7d4b upstream.

Include REG_INT_STAT_BEI in the top-level error interrupt condition.

BEI is enabled when CAN_CTRLMODE_BERR_REPORTING is requested and
ctucan_err_interrupt() already handles it. Without checking and
clearing BEI in the top-level handler, bus error interrupts are not
handled or acknowledged.

Fixes: 2dcb8e8782d8 ("can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://patch.msgid.link/20260723074403.131575-1-thnkslprpt@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -1136,8 +1136,12 @@ static irqreturn_t ctucan_interrupt(int
 		/* Error interrupts */
 		if (FIELD_GET(REG_INT_STAT_EWLI, isr) ||
 		    FIELD_GET(REG_INT_STAT_FCSI, isr) ||
-		    FIELD_GET(REG_INT_STAT_ALI, isr)) {
-			icr = isr & (REG_INT_STAT_EWLI | REG_INT_STAT_FCSI | REG_INT_STAT_ALI);
+		    FIELD_GET(REG_INT_STAT_ALI, isr) ||
+		    FIELD_GET(REG_INT_STAT_BEI, isr)) {
+			icr = isr & (REG_INT_STAT_EWLI |
+				     REG_INT_STAT_FCSI |
+				     REG_INT_STAT_ALI |
+				     REG_INT_STAT_BEI);
 
 			ctucan_netdev_dbg(ndev, "some ERR interrupt: clearing 0x%08x\n", icr);
 			ctucan_write32(priv, CTUCANFD_INT_STAT, icr);



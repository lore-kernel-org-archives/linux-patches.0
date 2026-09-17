Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B62B51DB1C;
	Thu, 17 Sep 2026 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665235; cv=none; b=Hn+0SoWzh354CVkSmBa+QXCid7okHA2Mkrh/KRwtfyiCdbPgo+9z3aEJm+9oEg8J4n5WQJvSR+7pDmuHg7MyQT8Qxxrj6vTPL8og9crb+8J6BuE6Gi5sWk/Ju0stsZs9GnkxAkv8w5J18MnJFOLRhxRT9b0Pb5kU7m2G8Pe3N9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665235; c=relaxed/simple;
	bh=eHGzkNsjs6S31F3MWn8/sFa6B3t0p9WspO9gUNncRA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAUoHwigBNJcLc0AmJlDZwzvItV/fczCCCHQMQaCm/Jj98sJn3v/JnCdloR8xpzvg5CuC+P9oYEeorxI+dm02LnfP0Eo7io0rRP/9FgVUL3oe/JREWPTxI1AmRMNSDOqpj/sHngVYaRlHx4Y/2KK06+r85J4Sow6KFBtyN/CU8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qw1dPJC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qw1dPJC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599261F00893;
	Thu, 17 Sep 2026 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665233;
	bh=LjUSs8OMPMoRVh7Wrd1jGr3rwc7WrpkjW/YbaPnAPPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qw1dPJC2bjINC5j4Mq/sFEhyaaw5gBMFb2la5OgxUrbDRKNa9exjekUk+OKIhbJwD
	 h8l6ZxR0Xm+36nXBJTtO/IlhLuXNul7FGD0qqTUDrsmu/8+jPAtBEpXFWpSN69BgjW
	 7HJJVQ2E8djVj1friYvbKPFlgrtA+lkLNedD7rMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Nugraha <aslan.jnn@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0636/1250] net: amd-xgbe: discard rx packets with bad FCS
Date: Thu, 17 Sep 2026 16:07:11 +0100
Message-ID: <20260917151609.127903471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: James Nugraha <aslan.jnn@gmail.com>

[ Upstream commit ac8d6b28d48c5d951dcd923d33e461588e762a6d ]

amd-xgbe driver currently sets the MAC_RCR.DCRCC bit whenever
RX is enabled. This disables hardware FCS validation, causing packets
with bad FCS to be accepted unconditionally.

This change unsets DCRCC so that packets with bad FCS will be dropped,
in-line with typical behaviours of many other network controllers.

Tests:
- Verified that packets with bad FCS are now dropped.
- Verified that receiving packets with bad FCS will increment the
  `rx_crc_errors` counter.

Fixes: c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver")
Signed-off-by: James Nugraha <aslan.jnn@gmail.com>
Link: https://patch.msgid.link/20260827232220.69907-1-aslan.jnn@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index e5391a2eca51d..bf10ad7cc9666 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -3299,7 +3299,7 @@ static void xgbe_enable_rx(struct xgbe_prv_data *pdata)
 	XGMAC_IOWRITE(pdata, MAC_RQC0R, reg_val);
 
 	/* Enable MAC Rx */
-	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, DCRCC, 1);
+	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, DCRCC, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, CST, 1);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, ACS, 1);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, RE, 1);
@@ -3310,7 +3310,6 @@ static void xgbe_disable_rx(struct xgbe_prv_data *pdata)
 	unsigned int i;
 
 	/* Disable MAC Rx */
-	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, DCRCC, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, CST, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, ACS, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, RE, 0);
-- 
2.53.0




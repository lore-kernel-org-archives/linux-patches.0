Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA9D4F85C5;
	Wed, 30 Sep 2026 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791282; cv=none; b=WDHGO75DI69XCVpLyLBusJoRv7ZoRiTr+HCO3zsL/I5d1rjsP7rhW7YGkCNv3BwIkEemxhTMyzVmKGknA02EpdboA0rViAzHJ85tFZSFMjsHWuXJjag/m5I83HRM+Uq+adjFAZ+PiCGGUCt0dbf0ZlelcYpAmIgIHfHxX+uOMcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791282; c=relaxed/simple;
	bh=F4Y0sha1/HSMx7KXZ7q0O0sLMqIChHlyBImaexcG+vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEE40+uxjM6rITBHNqikeukHXxrfDj2EfZSHkD8Yn7mtjXWR1wqQHd+q0/4iBJpc46/fL4o/IKr3/T4xo+b1oAwl+Hri7Z8aVQTvH01y1ObxKfJLqLbB/XpW2e+I7iuf04AflF4Y/oprBNYMq1C6WYmPVNCEpWDWamZTek2xwFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Za6bIFrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za6bIFrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665331F000FF;
	Wed, 30 Sep 2026 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791280;
	bh=tvxnmnBt1eJoF3DjcgY6tcowYuJ/MQfcl27R9y4Eca4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Za6bIFrNVSjuc+7oftA+hpbaca0CHHlm6ZPVNbU2W5k3N0sK01WYE7peXt78VvvPw
	 ulo3eauXyPxhm7Mza7xv4HKIwQJiedIqYrm971aLi5u2NNv74TpYUf0GD0gQgGop8v
	 hTcfDBByu4xTozxXMNLmQ10FBOzvXdjk6JIoVb48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Nugraha <aslan.jnn@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/752] net: amd-xgbe: discard rx packets with bad FCS
Date: Wed, 30 Sep 2026 17:21:57 +0200
Message-ID: <20260930152403.618275895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3cf7943b590cf..58c510e38add6 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -3388,7 +3388,7 @@ static void xgbe_enable_rx(struct xgbe_prv_data *pdata)
 	XGMAC_IOWRITE(pdata, MAC_RQC0R, reg_val);
 
 	/* Enable MAC Rx */
-	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, DCRCC, 1);
+	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, DCRCC, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, CST, 1);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, ACS, 1);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, RE, 1);
@@ -3399,7 +3399,6 @@ static void xgbe_disable_rx(struct xgbe_prv_data *pdata)
 	unsigned int i;
 
 	/* Disable MAC Rx */
-	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, DCRCC, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, CST, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, ACS, 0);
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, RE, 0);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7242175A99;
	Mon, 17 Aug 2026 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976860; cv=none; b=rAkN5DAz2b9AyJxZxxCt4OuLwMTM5dfWiMP4tERgOwgk47Yu5iyVtwbE37u/74NkcAqDH+wQUfRrl//FilaiiTnpunc2ucI0hljAAIxHfTTMDrxtuEgijzjII/4F1iNm9l5O/KWEOdWMVCVf4wBluFDskjt9yY9bhc/gi4WoTEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976860; c=relaxed/simple;
	bh=SBRZNMrx2dooXfiFZSWs+C3Ffwwwf5F7ssqtBBELV2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFPEI1BoH7nZhHfwiK+BR+pRrZbEo7Gz21MQJa+mIL90Pz+UsCAPMfjFPbeT5eCsARH3xZt2ec2Wr/pBRLJuzqhu5vMuFsruykLQhqFQiIM70Z/CMMUxhK9p7nLQ6QuuwhzlcjQxfkVEQNveR6buuELVkYGs8NBXZOqLqahd/D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3YY0QqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3YY0QqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4751F000E9;
	Mon, 17 Aug 2026 14:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976859;
	bh=h2IzBQS6I+C6SIN+rpd2XBlYvHc0dUNswBvmrtDa4X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3YY0QqEErgC+dKpqbloLsYojbWDWWhpb5wP8LYG9gWD+/jJHlpdGn81EXeI+4Bm0
	 Ucdr1eE//ivCCYUaAzw348i7ILtaD3u5T3N8qaC1sRYvTo2Gu9RgjH04nqy+6fmqgI
	 2sT+tVjQ2080pYG57guNZ2zqZUpjYSxy/BI8YHUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/456] dpaa2-eth: put MAC endpoint device on disconnect
Date: Mon, 17 Aug 2026 15:28:12 +0200
Message-ID: <20260817132544.086490722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b4b201cc93ff70150853aba03e14d314d1980ca0 ]

fsl_mc_get_endpoint() returns the MAC endpoint device with a reference
taken through device_find_child(). The Ethernet connect path stores that
device in mac->mc_dev and keeps it for the lifetime of the connected MAC
object.

However, the disconnect path only disconnects and closes the MAC before
freeing the dpaa2_mac object. It does not drop the endpoint device
reference stored in mac->mc_dev, so every successful connect leaks that
device reference when the MAC is later disconnected.

Drop the endpoint device reference after closing the MAC and before
freeing the dpaa2_mac object.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260708111738.750391-1-lgs201920130244@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index c6f20ceadede31..b21be20dcf8513 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4284,6 +4284,7 @@ static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 		dpaa2_mac_disconnect(mac);
 
 	dpaa2_mac_close(mac);
+	put_device(&mac->mc_dev->dev);
 	kfree(mac);
 }
 
-- 
2.53.0




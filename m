Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBA92FB975;
	Tue,  2 Sep 2025 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819930; cv=none; b=UZ9Q6HSQAP6NOuTRKu7QDdP9YB67Zpdcaug+LT542XDBTRKHonq+qvtsO7QNLg8w2volVyOvC2sIC1OmfMd8HzxAXunBf7l0CW2EzV94V04nM1Yd5WlJQ4DwmEXPDy03ykyd3ysZuwPYvP9z1Te8VMHb0tZzig4EQqQpw+wUtFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819930; c=relaxed/simple;
	bh=wI81BUUexpU8Iw+Lf4m5Fn7jy2zc06L2lng8TeLG86M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juKFQPFL03XyJL41jB92YCobNhUKzS+y2v5H1QP5mdFsQZhgSzmwi+J7SaP6K0JGRUMAZf6PME8tqlR7rwGOTEXs82bZs2oTdRMmKcAi3Tmb6eKPmkNlZCDpYS6I5I11F3CVgocFRTzMLgAP5HjHBq/gGoq9UwZwLWcjj2NfcRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrVfjol1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrVfjol1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B942FC4CEF4;
	Tue,  2 Sep 2025 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819930;
	bh=wI81BUUexpU8Iw+Lf4m5Fn7jy2zc06L2lng8TeLG86M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrVfjol19Dvv7kdW3S99GGEkXCu+cpUMdUsDY+MeldUnHTz6tzq5o8ijFHjMHueUN
	 0Aiqp/3z2F3reBbcq3Gty8X0GiVoI8pv8mfLKfzjrJle1flDBuIeXc8NFmCKrt0Snu
	 7wr6OZ1pkq2oH2AnyNy9BE+zOqO3MnehIHoDSiqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 40/95] net: dlink: fix multicast stats being counted incorrectly
Date: Tue,  2 Sep 2025 15:20:16 +0200
Message-ID: <20250902131941.146452360@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yeounsu Moon <yyyynoom@gmail.com>

[ Upstream commit 007a5ffadc4fd51739527f1503b7cf048f31c413 ]

`McstFramesRcvdOk` counts the number of received multicast packets, and
it reports the value correctly.

However, reading `McstFramesRcvdOk` clears the register to zero. As a
result, the driver was reporting only the packets since the last read,
instead of the accumulated total.

Fix this by updating the multicast statistics accumulatively instaed of
instantaneously.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-on: D-Link DGE-550T Rev-A3
Signed-off-by: Yeounsu Moon <yyyynoom@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250823182927.6063-3-yyyynoom@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dlink/dl2k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 787218d60c6b1..2c1b551e14423 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1091,7 +1091,7 @@ get_stats (struct net_device *dev)
 	dev->stats.rx_bytes += dr32(OctetRcvOk);
 	dev->stats.tx_bytes += dr32(OctetXmtOk);
 
-	dev->stats.multicast = dr32(McstFramesRcvdOk);
+	dev->stats.multicast += dr32(McstFramesRcvdOk);
 	dev->stats.collisions += dr32(SingleColFrames)
 			     +  dr32(MultiColFrames);
 
-- 
2.50.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549EC317141;
	Mon, 13 Apr 2026 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098833; cv=none; b=BlktUA8o/X9k8Qp2+wVgcGgR0/bzZuOxANOhcKAbRquTCNMySeOAsTknDd9KpPDnGO/Z42fRXs5UjjPTl+rdA/31EhQ4yCAgHMa6Ov4GqNPbnCjeYrLiYDR3dKSLaH5au52uHPYvi8oWObQw2muxM5oJ/hD9nejSNNZyBBNILDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098833; c=relaxed/simple;
	bh=hgWyUU342wGYeph9Qi//7k7jSLnLZFOdK5ue30BclrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBUXpoiDohpzvcaEtPNpPyjoRoSDFK1Gv1hlGOQRmRwZE0NnuwDwoqhU+N2WRNrIno+XLnkmCOFfSy/V0pJPJcTemPCejPRRkNbSFIgi8Y4uj4BgX6YihMUfO08JNbdkSoUFyQi667NAFvvj1T3DC++fvsK+dQidMt9xqD1B1rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SN99xEDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SN99xEDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AB8C2BCB6;
	Mon, 13 Apr 2026 16:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098833;
	bh=hgWyUU342wGYeph9Qi//7k7jSLnLZFOdK5ue30BclrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SN99xEDYHHtbz55mP0oE7lYv0Br+7w/J6HNlu+Hko747g+fTBB1oHFsiLLWo+pk3P
	 8H9NW40s0hiblv5eT8gYKwFUb6LnvPzMZe94D7SlnEaTY6OPnCW78dc+msT8G+QSpe
	 IVJNQrIHpOw5opP+sR+eAEBZmaxnvQDwIFFV/x60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyuan Li <2063309626@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/491] can: hi311x: hi3110_open(): add check for hi3110_power_enable() return value
Date: Mon, 13 Apr 2026 17:55:19 +0200
Message-ID: <20260413155821.817811528@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenyuan Li <2063309626@qq.com>

[ Upstream commit 47bba09b14fa21712398febf36cb14fd4fc3bded ]

In hi3110_open(), the return value of hi3110_power_enable() is not checked.
If power enable fails, the device may not function correctly, while the
driver still returns success.

Add a check for the return value and propagate the error accordingly.

Signed-off-by: Wenyuan Li <2063309626@qq.com>
Link: https://patch.msgid.link/tencent_B5E2E7528BB28AA8A2A56E16C49BD58B8B07@qq.com
Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
[mkl: adjust subject, commit message and jump label]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/hi311x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index a7d594a5ad36f..f651a8ba7d53e 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -751,7 +751,9 @@ static int hi3110_open(struct net_device *net)
 		return ret;
 
 	mutex_lock(&priv->hi3110_lock);
-	hi3110_power_enable(priv->transceiver, 1);
+	ret = hi3110_power_enable(priv->transceiver, 1);
+	if (ret)
+		goto out_close_candev;
 
 	priv->force_quit = 0;
 	priv->tx_skb = NULL;
@@ -798,6 +800,7 @@ static int hi3110_open(struct net_device *net)
 	hi3110_hw_sleep(spi);
  out_close:
 	hi3110_power_enable(priv->transceiver, 0);
+ out_close_candev:
 	close_candev(net);
 	mutex_unlock(&priv->hi3110_lock);
 	return ret;
-- 
2.51.0




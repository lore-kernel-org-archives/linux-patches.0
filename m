Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE4C2FFFBE;
	Mon, 13 Apr 2026 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097375; cv=none; b=KFUGpaP77I1hBniFwx3WBzkQe4FLfEKPQ+Y2BVtBY89f2+cYKEEQVTdfk7IjrXryHYdKRe9jTSNdWUcAa6obw9FGY6ks0+X1vDibj+d6QAbdBDg4BMbKEmKwAvomKsN19TEPMHYcXztdLU6FnGsEoY5sCdrVocBRYpdzdrtYnLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097375; c=relaxed/simple;
	bh=fvE28QhMzH4ZNafZQtqAKY6tXx6rNnYhZV+JKVErheI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhvN0sxt2UmZ6ZyAqyBFCCO1qWHpRmn2q5cDckTz7CRvnZKRReCZikhvKMMT+I2Rot0kmBEsUmAA7qHMcWbqy8+vggwAItsfFjyXI58qACvUgQ1J0N4XlOS1mR9ywfQ4ZoOYnp9y9/pHpcZ8V17SLz6QRLMQnc31r+9YvF2gQFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2mmly6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2mmly6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60276C2BCAF;
	Mon, 13 Apr 2026 16:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097375;
	bh=fvE28QhMzH4ZNafZQtqAKY6tXx6rNnYhZV+JKVErheI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2mmly6r+JZ3Q4y94c/PRpDQISw4ki6UH2hDHZylezKZazJPDS3AeQZzuKjAdtQ6a
	 EKZ6w0kC/ayDCEM67LYNacTcO8cHSrdIR9re7+60bRO4fwvxT5JP2ka5j0lTungGn3
	 9F6CocVr7Gs3bgxLcMNYqA30mlY5nQyElnprgMCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyuan Li <2063309626@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/570] can: hi311x: hi3110_open(): add check for hi3110_power_enable() return value
Date: Mon, 13 Apr 2026 17:54:03 +0200
Message-ID: <20260413155834.639218564@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index 6df2e6fae2687..cc7e20a0e8691 100644
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




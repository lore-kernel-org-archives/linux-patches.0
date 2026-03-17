Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89A33A4F46;
	Tue, 17 Mar 2026 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767308; cv=none; b=HT0iyJU+DMnWZ6xKngQYuXBa+y6p7iPBDFvkouLEE4aoB6ag9yb3NfUcakx29cvO40F7X8iYIyj8hCYfKqCLPWtJWpL+LXgxCJgX8uhB7TkM61ca5a6qYAkcF/jBL9EmzABenXKNYtB11eN6wYkgELlzRnQrX/QHiT3+ZAFzp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767308; c=relaxed/simple;
	bh=aPw+eFrgZ6u1cFf4GscXJXLJOzLxux3ThCRj5v1admo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAWSmVwGE2wUtlLSzxZNd41WYg9Db+vxVyEIBzrinMz7dcTegvDqQo/LFUK4q+JBwcxdGZlGywQ7rOWseadifjIu2GLPbSgW7UmGzvN4rSJrRpSazML4YwbNwTheI3+3ADkdCXSrb93gk0rDNsoVjL7ResZdE5PEUkihxTlxTDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n175BTKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n175BTKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55851C4CEF7;
	Tue, 17 Mar 2026 17:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767308;
	bh=aPw+eFrgZ6u1cFf4GscXJXLJOzLxux3ThCRj5v1admo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n175BTKBz7EK5DkgoheTGkJT5llDzCPxCjIwvUIOiV6K/6KtP6tU/2rDcgsGlqzeh
	 S3Kd9TZAxIKL5DsnsjFm878SX9bJh7v8r5i/sS4OPCCh2dXr+7/VnOl+PBLiRXnsXy
	 PCg1gvDpr7eV5BKacBbmDASwV53ct4oVd5635BEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyuan Li <2063309626@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/333] can: hi311x: hi3110_open(): add check for hi3110_power_enable() return value
Date: Tue, 17 Mar 2026 17:31:28 +0100
Message-ID: <20260317163001.558726208@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
index 6d4b643e135fd..5f5a7e7e547eb 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -755,7 +755,9 @@ static int hi3110_open(struct net_device *net)
 		return ret;
 
 	mutex_lock(&priv->hi3110_lock);
-	hi3110_power_enable(priv->transceiver, 1);
+	ret = hi3110_power_enable(priv->transceiver, 1);
+	if (ret)
+		goto out_close_candev;
 
 	priv->force_quit = 0;
 	priv->tx_skb = NULL;
@@ -790,6 +792,7 @@ static int hi3110_open(struct net_device *net)
 	hi3110_hw_sleep(spi);
  out_close:
 	hi3110_power_enable(priv->transceiver, 0);
+ out_close_candev:
 	close_candev(net);
 	mutex_unlock(&priv->hi3110_lock);
 	return ret;
-- 
2.51.0




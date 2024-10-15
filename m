Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8321D0492;
	Tue, 15 Oct 2024 11:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993379; cv=none; b=F7iwANadCWB+iniqC4FSRfUQS91IZMSwtl1MvRIrk3IljjdotPNOcB7GeQqRbzNweyFNmBWNy6BlAd8S92W5hR896Mh/G1gxE/MVFB+3DJxidCnG8c2h4ldaQzwrWmiYYSYgtA3x6u5oQj7JtfrBO6zSheEdcod81/HDIHQJIgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993379; c=relaxed/simple;
	bh=i9d1Ev6blk+gg4V70S76Ujm+DQBlSx8bGyNRHHESvtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7BpUm6HKdvVLrkD/gaoYAz8BNRSc6m3LB78hcEKllcKYOUUkxL1DokmNbYRywu3s32nBVqyjFn7wuw0trNlDl35FQRRgWQWRztZwQgBwFHg2lcVjfgKjhkZ5jUQAWzc2divtdI2iBUmg5QZZRLtdm0HKL/GP14/TgD4WIEzAug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hKri2/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hKri2/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAE3C4CEC6;
	Tue, 15 Oct 2024 11:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993378;
	bh=i9d1Ev6blk+gg4V70S76Ujm+DQBlSx8bGyNRHHESvtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hKri2/atU7oi/ajUx9VtrLEW8+PZE+CvVNhymAjrf7aVyBzPPPOyhNbIhzQo1L5a
	 jUBdoTfNrT/3Qti2B19mg+NQgZRuA7rGkuCUjRYTrGSWXrqid0WCZKDo73eoVtZiD9
	 qhLONAbsyVeR3DUzkI2m+1At74QeRz1M+oV7CUeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Michal Simek <michal.simek@xilinx.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 394/691] i2c: xiic: Fix broken locking on tx_msg
Date: Tue, 15 Oct 2024 13:25:42 +0200
Message-ID: <20241015112455.977628138@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit c119e7d00c916881913011e6f4c6ac349a41e4e2 ]

The tx_msg is set from multiple places, sometimes without locking,
which fall apart on any SMP system. Only ever access tx_msg inside
the driver mutex.

Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 1d4a1adbed25 ("i2c: xiic: Try re-initialization on bus busy timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 9652e8bea2d0b..7b9ec379733eb 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -170,7 +170,7 @@ struct xiic_i2c {
 #define xiic_tx_space(i2c) ((i2c)->tx_msg->len - (i2c)->tx_pos)
 #define xiic_rx_space(i2c) ((i2c)->rx_msg->len - (i2c)->rx_pos)
 
-static int xiic_start_xfer(struct xiic_i2c *i2c);
+static int xiic_start_xfer(struct xiic_i2c *i2c, struct i2c_msg *msgs, int num);
 static void __xiic_start_xfer(struct xiic_i2c *i2c);
 
 /*
@@ -701,15 +701,25 @@ static void __xiic_start_xfer(struct xiic_i2c *i2c)
 
 }
 
-static int xiic_start_xfer(struct xiic_i2c *i2c)
+static int xiic_start_xfer(struct xiic_i2c *i2c, struct i2c_msg *msgs, int num)
 {
 	int ret;
+
 	mutex_lock(&i2c->lock);
 
+	ret = xiic_busy(i2c);
+	if (ret)
+		goto out;
+
+	i2c->tx_msg = msgs;
+	i2c->rx_msg = NULL;
+	i2c->nmsgs = num;
+
 	ret = xiic_reinit(i2c);
 	if (!ret)
 		__xiic_start_xfer(i2c);
 
+out:
 	mutex_unlock(&i2c->lock);
 
 	return ret;
@@ -727,14 +737,7 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	if (err < 0)
 		return err;
 
-	err = xiic_busy(i2c);
-	if (err)
-		goto out;
-
-	i2c->tx_msg = msgs;
-	i2c->nmsgs = num;
-
-	err = xiic_start_xfer(i2c);
+	err = xiic_start_xfer(i2c, msgs, num);
 	if (err < 0) {
 		dev_err(adap->dev.parent, "Error xiic_start_xfer\n");
 		goto out;
@@ -742,9 +745,11 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 
 	if (wait_event_timeout(i2c->wait, (i2c->state == STATE_ERROR) ||
 		(i2c->state == STATE_DONE), HZ)) {
+		mutex_lock(&i2c->lock);
 		err = (i2c->state == STATE_DONE) ? num : -EIO;
 		goto out;
 	} else {
+		mutex_lock(&i2c->lock);
 		i2c->tx_msg = NULL;
 		i2c->rx_msg = NULL;
 		i2c->nmsgs = 0;
@@ -752,6 +757,7 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 		goto out;
 	}
 out:
+	mutex_unlock(&i2c->lock);
 	pm_runtime_mark_last_busy(i2c->dev);
 	pm_runtime_put_autosuspend(i2c->dev);
 	return err;
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F721C07FF;
	Tue, 15 Oct 2024 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997767; cv=none; b=RpVWVzaAgtUKxY2pOhtuHO8s2UUCt8CWv4gMOnDoiO1QuiJ9k0NVK9jwyFtDJRoaJJRJdDcST8q4LKxQA+GZo7ygHlOeJqPJhwAzJr1bFk5UGwaz3+67IB+7PdiuAKkB/DW73UN+Z0VkasPQ6A7czENxCjuztrB7RWtX8KsAZBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997767; c=relaxed/simple;
	bh=y6M5wzo5V3fRnK+ipfht1sACM64hivcu+e+jUYDL3NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNCb/MW0FusE8SWPnxOvU+KZv7bjJ+ZA49bX9OuuMF/xvifcO7zZ8KKjIJJcRGuLVN19rqIE99PK//jLyeoghojdmaE3fQeObU/QWH+zasXqdJJ8dKkgYK72K+JIG4LIw0VsKrX/FKfFYrRD3TsU1h9RErPuVCMJ+MIu3HjSFEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqqjit0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqqjit0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1784DC4CECF;
	Tue, 15 Oct 2024 13:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997767;
	bh=y6M5wzo5V3fRnK+ipfht1sACM64hivcu+e+jUYDL3NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqqjit0VYKusLN8em4dPkTYdepN32/bpipKqSVWxRL6BqMqXPor+uDQxHKEqplCuE
	 gVmaKs033GA+iazgfYfkceVXREObAUN5J3xBDsrwccNIA/S5nIE4X5pP3hT9+mdON+
	 NhlaSeG9dAfQKNjKbWL3e2/B3fi41hMQS5jax7EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Michal Simek <michal.simek@xilinx.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/518] i2c: xiic: Fix broken locking on tx_msg
Date: Tue, 15 Oct 2024 14:43:05 +0200
Message-ID: <20241015123927.837323365@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 568e97c3896d1..ae9ef3f7220e6 100644
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




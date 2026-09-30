Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDB851EDE0;
	Wed, 30 Sep 2026 17:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791200; cv=none; b=jv1vpO421bJyRwDZmnPE9TVwy6onwhbTT8kA4p2KzFDvSx5c05cgB9k7gWh1ZXsODJi5oq3usxnA4hGXtXbm3PdcGlAmXxTy0kCJNcWjlrpoBJTqU2UoXVrI5n4Dwep7XuwpgzJbAXDufSQSavfZJWpDPIdbKQD0P22Tbgrbhiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791200; c=relaxed/simple;
	bh=8Jlt3Pw8H+r8/XhYQZUKz/YMq0WmITNMjl6x9GUY2pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFbtuKAG0dfsHv9SK3MQwyez30b63sucWKYm4Bt8jzzyNx1RLoXcRcFH4/PAL8pGlWIzQTNJ16PB4aVKSXigvIBwva5UEvoQ8zyxlr4fHTGjZnPO6p91MJeEHF6NppAhQI0HS++6P9BbYSXxVu0+333W+Ro4absAoiiWafWOhEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bG/54+rN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bG/54+rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C02F1F000FF;
	Wed, 30 Sep 2026 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791199;
	bh=OCJoGkiuEdKIDSeRHO83IXO8uPuMr3gpWCFfnZDCLFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bG/54+rNwHcpZPlD368Q6QswmjcW3ZQSJ/YSrNHoFDIQ1OBf0BJqYqj4CovoP86yl
	 Qp8F9A7hZmLc0G9c180Dk9UNH+2iCI0Zf38L6kBTXM/OhlSFApeyaEQMkcaxvGUr62
	 hJ+iqqihJ5o7hCCN+/VzIuJi0UcfyC76OzpQTJOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/752] drm/gma500: return errors from Oaktrail HDMI I2C reads
Date: Wed, 30 Sep 2026 17:21:27 +0200
Message-ID: <20260930152402.948416261@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 9b5ce5c496efd20c1c662cedba88465d39ec1f93 ]

xfer_read() waits for the HDMI I2C transaction to reach
I2C_TRANSACTION_DONE, but it ignores both timeout and signal returns from
wait_for_completion_interruptible_timeout().  If the interrupt never
advances the transaction state, the loop can wait forever.

Return -ETIMEDOUT when the completion wait expires, propagate interrupted
waits, and make the I2C master_xfer callback return the first transfer
error instead of reporting a successful message count.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260625003240.6923-1-pengpeng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
index fc9a34ed58bd1..48a2adba94879 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
@@ -95,6 +95,7 @@ static int xfer_read(struct i2c_adapter *adap, struct i2c_msg *pmsg)
 	struct oaktrail_hdmi_dev *hdmi_dev = i2c_get_adapdata(adap);
 	struct hdmi_i2c_dev *i2c_dev = hdmi_dev->i2c_dev;
 	u32 temp;
+	int ret;
 
 	i2c_dev->status = I2C_STAT_INIT;
 	i2c_dev->msg = pmsg;
@@ -106,9 +107,14 @@ static int xfer_read(struct i2c_adapter *adap, struct i2c_msg *pmsg)
 	HDMI_WRITE(HDMI_HI2CHCR, temp);
 	HDMI_READ(HDMI_HI2CHCR);
 
-	while (i2c_dev->status != I2C_TRANSACTION_DONE)
-		wait_for_completion_interruptible_timeout(&i2c_dev->complete,
+	while (i2c_dev->status != I2C_TRANSACTION_DONE) {
+		ret = wait_for_completion_interruptible_timeout(&i2c_dev->complete,
 								10 * HZ);
+		if (ret < 0)
+			return ret;
+		if (!ret)
+			return -ETIMEDOUT;
+	}
 
 	return 0;
 }
@@ -127,7 +133,7 @@ static int oaktrail_hdmi_i2c_access(struct i2c_adapter *adap,
 {
 	struct oaktrail_hdmi_dev *hdmi_dev = i2c_get_adapdata(adap);
 	struct hdmi_i2c_dev *i2c_dev = hdmi_dev->i2c_dev;
-	int i;
+	int i, ret = 0;
 
 	mutex_lock(&i2c_dev->i2c_lock);
 
@@ -139,9 +145,11 @@ static int oaktrail_hdmi_i2c_access(struct i2c_adapter *adap,
 	for (i = 0; i < num; i++) {
 		if (pmsg->len && pmsg->buf) {
 			if (pmsg->flags & I2C_M_RD)
-				xfer_read(adap, pmsg);
+				ret = xfer_read(adap, pmsg);
 			else
-				xfer_write(adap, pmsg);
+				ret = xfer_write(adap, pmsg);
+			if (ret)
+				break;
 		}
 		pmsg++;         /* next message */
 	}
@@ -151,6 +159,9 @@ static int oaktrail_hdmi_i2c_access(struct i2c_adapter *adap,
 
 	mutex_unlock(&i2c_dev->i2c_lock);
 
+	if (ret)
+		return ret;
+
 	return i;
 }
 
-- 
2.53.0




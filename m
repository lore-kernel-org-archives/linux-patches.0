Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A251751EE1C;
	Wed, 30 Sep 2026 16:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784794; cv=none; b=T9kQMrogT44Iac7bB5FZEl2ZgvuO27gMCvY9ECvfB+TpJEANoY4D5gn6FCXF7uJ21MC7vd0sO7BVFM3rpFOw6UdoEsGWkv72DvRkJaD+FyPvNCwQKS03MorLCMLeK0hvX9earf6Pk34HyeBd9MSmdKa4zJapKiKoR/DUDjTKdbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784794; c=relaxed/simple;
	bh=aHpn1481yG3lfRHi65BK0MIDiof+cb0AakfcG77n8LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzUaxPNodQhnislwbpNDBNFPYbY/SnMNzsm1eXRWKMfXM4KFceni32ixMjV5U9Qi7zugO+V7z0Txamjvju3vNvlfRqilwupL+muQkzthAewCyiBWDYigiake2KrNwQI5dsR3oc7J8yf4ufaQLmR8J99yqHUQ+mNm13WmqBI80HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYKR1PnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYKR1PnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6052E1F000FF;
	Wed, 30 Sep 2026 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784787;
	bh=pvlc21iUsWHSg+61WIzzCogyiBq6aY84Uokz53Hfeq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYKR1PnAHlK0k31wwQKc6KFBkY8+QAqGw1A5tIHTcGJoMYU35nM13YAG17EMd3mH5
	 KiDVtcEd/uthdgCsGJ2dLwaEucxDRjO5NCs7vuxzKlM8Q18j25S2V0mmkYZhKUVzlW
	 sfr9Zml4uZA+SkSrSdLMtcDIi6FwcYUJaGDEjMRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 279/982] drm/gma500: return errors from Oaktrail HDMI I2C reads
Date: Wed, 30 Sep 2026 17:16:55 +0200
Message-ID: <20260930152422.791107311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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




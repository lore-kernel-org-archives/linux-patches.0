Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401134B44BF;
	Thu, 17 Sep 2026 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668491; cv=none; b=LjcLaLIX9Yw0APqzty6tV4EPaxH5hc0nl9y/qgY24sUm8mX6+NmcCmDadUc43rLulaOb83hbabdIin04n7lVUmA680+q5pKJsgciB9rV8C91MMlpkpmwUzgOD2PGBrbtwtcEPz2rDHFlTrWgzv19Isemwq0O5irpf/WTi7P2x2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668491; c=relaxed/simple;
	bh=gvS49tH1gybbOrTh/8WM4uE0lvyBz95tkv3sCpcGijE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkKD6JOKhGSe9ZEsrxAfTMX3gmMWKqm24R5npERnmFpVnUgA5h69I5SGi/09tBHxOOV/6iBR1CGyzw1607fkJwUZcBbif/iix8TnKdtpxVldZrOE507VRJIPYXTs3Fc/3l4rfHGrIkpzVox3YebadCVtZ6C4p0whvJ+jttLkH54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXZWm/NZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXZWm/NZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC421F000FF;
	Thu, 17 Sep 2026 18:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668490;
	bh=SMlbvNKyBibwvmknn/4y+SJ6YHYaUTLw6LJWImahNUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXZWm/NZkTMEH3McXNL3EAp8CNAgGD9UK6RZhU0ek9B1wFEmjAsJHA9K9W0PpY4q4
	 hTOiTavs1KKnLdvWvbPei7juXz2OwaTglmCLTnvBamajwLIvyi13dN9LPExpqC3vgp
	 XrDJUYCKWuT8LnkrenI/T7oF3TEvg4IaCreLxdZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0441/1102] drm/gma500: return errors from Oaktrail HDMI I2C reads
Date: Thu, 17 Sep 2026 16:06:24 +0100
Message-ID: <20260917151550.748367434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6daa6669ed237..4f1d095fc5a81 100644
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




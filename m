Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C850E3F8716;
	Fri, 15 May 2026 16:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862549; cv=none; b=ZTxwx82G15+vZIJWxGzHy5ns5XGLo0csutQTYumMAx8PnVg39iLcluhWRcfD0gTyronnn6Efoptm2yti3ct2FNjiTCV/2SAkPOOR2qWDK4SQ5v5TSJLD3atCfjA60KXK217dwv7jib9Ql21h83XH7BVjy7cQ7cPlSLFXCWwCMoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862549; c=relaxed/simple;
	bh=/9PdCli8yAvTVCrHx9KIyHYznlVqd6Z44dJVrcGrTmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DplBm/30WpRAVfURoMBRA8BupKqAKn0l3Jh6nu9oQ1Lp3XvGSCN3zFX59nHyPNO0kup2QJRRPEKdvw5sW5EbjTWmDSdD2+HmzeJce9W45T8cSZKiaHL/e1eBlEBMsaa+M4pgcIW7pty8iB+fwoI30L/GVuJOva/ltAOicFu2rkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/4slO4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/4slO4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA0DC2BCB0;
	Fri, 15 May 2026 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862549;
	bh=/9PdCli8yAvTVCrHx9KIyHYznlVqd6Z44dJVrcGrTmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/4slO4xoi7xHgkLB9RiFy9MHUzDqoxp2WPGZ8F5VyjF9mBk+IHpIP7qRTcriWIFC
	 lFQzm+Oqq9194vyaiTslx+tfKHqFO0uMwfxQrDxpNR/5FOZlFLC8AKBrDySLLOHvzo
	 0mQolNM3BLb+MVd25wD2Kyi4JE04WhQE+TVEpytk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 7.0 039/201] media: i2c: imx283: Enter full standby when stopping streaming
Date: Fri, 15 May 2026 17:47:37 +0200
Message-ID: <20260515154659.380925484@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <jai.luthra@ideasonboard.com>

commit bce1349dbf6348ddee47308e2ed08878356de317 upstream.

Use IMX283_STANDBY (bit 0) instead of IMX283_STBLOGIC (bit 1) when
stopping streaming. STBLOGIC only puts the sensor logic into standby but
leaves the MIPI interface (along with other components) in an
indeterminate state.

This (presumably) causes the CSI receiver (e.g. Raspberry Pi's CFE) to
miss the LP-11 to HS transition when streaming restarts, resulting in a
hang of 10+ seconds. The issue is most visible when immediately
restarting a full-resolution stream after stopping a 3x3 binned one, so
that runtime suspend hasn't yet been triggered.

Writing IMX283_STANDBY puts the entire sensor into standby. The
imx283_standby_cancel() sequence already handles the full wakeup from
this suspended state.

Cc: stable@vger.kernel.org
Link: https://github.com/raspberrypi/linux/issues/7153
Link: https://github.com/will127534/OneInchEye/issues/12
Fixes: ccb4eb4496fa ("media: i2c: Add imx283 camera sensor driver")
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Tested-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx283.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx283.c
+++ b/drivers/media/i2c/imx283.c
@@ -1158,7 +1158,7 @@ static int imx283_disable_streams(struct
 	if (pad != IMAGE_PAD)
 		return -EINVAL;
 
-	ret = cci_write(imx283->cci, IMX283_REG_STANDBY, IMX283_STBLOGIC, NULL);
+	ret = cci_write(imx283->cci, IMX283_REG_STANDBY, IMX283_STANDBY, NULL);
 	if (ret)
 		dev_err(imx283->dev, "Failed to stop stream\n");
 



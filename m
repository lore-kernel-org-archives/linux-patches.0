Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069ED33A6EB;
	Fri,  9 Oct 2026 14:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555972; cv=none; b=n6koVakbjDPirWnO8ZFb0VS1rvknZAt4aUcogXUeeWEdpOKGiWbM5WVxRlbKQX6OCQPi7VUj4Tw6uf6ZzT9EMPmD3M+DJhJt/jSg4GSoNLLt1vXQlVR2xq033zQC2nUWy1QCOqHtb68Lk78O/dXnktu0olhGIKD7cc9tRnOhWW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555972; c=relaxed/simple;
	bh=dnHV5BRK03xYBWDaPLsTpK7a21farD/CLb3UvJiZ/uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbEYh9QZmZRClEqu9q/+N1DfJfdzv2RBL1v8TAMPRhJW3Gk+TAO9cDDtcjkBH0fDCrUTx58QQdpoMr/6WiTmIy0d8nKhNwB1dBtgn9QFJM7GHMYyGfw8ewlEzwLS8zLxF9x5VxDTuzerLgNNeYL/Q9WgpBJqHULsH97gUfAnH4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqTo+duT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqTo+duT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667421F000FF;
	Fri,  9 Oct 2026 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555971;
	bh=+DTCfDFBbY7qI/Jlvme6dpwiHV9lGO50n41lbX1eheg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqTo+duTUTbl8lTxaZLUzFL3F069xTGVPP9l8DLwekpP3/dcZgiVB/sWFrr7HAUYp
	 tqYvGNu1nwaPKNHMBBjmSpue3ACSrZ7cLu8/THeFE0O6bXl53KEwFl2auoUWawcdQn
	 ZN+dIm134vQhHNhwFLP/PTPSYTQCiYsKtAqsa8nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 099/428] ASoC: SDCA: Set suspended flag after resuming within system suspend
Date: Fri,  9 Oct 2026 16:07:16 +0200
Message-ID: <20261009140948.390216346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit b16610e3770ef22fc8fcce818db0cd955332abf4 ]

drv->suspended path was executed before system suspension instead of
after, move it lower to correct it.

Fixes: 7a5214f769c7 ("ASoC: SDCA: Add basic system suspend support")
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260924095458.2683755-2-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_class_function.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sdca/sdca_class_function.c b/sound/soc/sdca/sdca_class_function.c
index 2fb2b043c979c..86e5d28511542 100644
--- a/sound/soc/sdca/sdca_class_function.c
+++ b/sound/soc/sdca/sdca_class_function.c
@@ -490,8 +490,6 @@ static int class_function_suspend(struct device *dev)
 	struct class_function_drv *drv = auxiliary_get_drvdata(auxdev);
 	int ret;
 
-	drv->suspended = true;
-
 	/* Ensure runtime resume runs on resume */
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
@@ -499,6 +497,8 @@ static int class_function_suspend(struct device *dev)
 		return ret;
 	}
 
+	drv->suspended = true;
+
 	sdca_irq_disable(drv->function, drv->core->irq_info);
 
 	ret = pm_runtime_force_suspend(dev);
-- 
2.53.0




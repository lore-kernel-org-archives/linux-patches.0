Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06EE3AFD15;
	Sat, 12 Sep 2026 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205602; cv=none; b=PX6bTU+Ih/Cr/pgWhwpkaaGC/9l9BSStq3W+dYh10JnZ+9nn1ZC23ThdlDctFMWXapA/fH4fWQBYa9rGdwtVO2kvSmgPbdm4syKcuyuF1ezxQV/+4v9/38vypDA+R0dIO5eYFWxhhyRQb5F22QQNQoiHxdbuTkelPE+m2Ppnc5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205602; c=relaxed/simple;
	bh=vIDHzDdCR93Bx4fauFrGjoT3ci+XGr9mPwAex/78JJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFq5z103roe47CFU6DrFCZ0NdPmkMwsMly9viXYOAr4uzJl/RjDbt/8VCaqfmb7XHuOaDlpb1V9qu19fU1LyGn+i7ktnVuI+8Axf4i82gg9SfJpaEr+9+9lNpDzui4rcrSSKeem4Ni01arISozOCNwEChbTZSisn1uufmX5ezt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+SsunCm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+SsunCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E781F00893;
	Sat, 12 Sep 2026 09:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205594;
	bh=nROsX6/ewgafb6A8Uu5RVNleLM1lUKVhnTZEUtRvHLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+SsunCmengX6w28gPMoraRZSFyBYNlDcM0nbgVupBU6nhqvGlFUonuVirYC0RQPe
	 Mn6AXxM1msJom+7e7W/kDuFuZ4l862f+mI9ofKev2nmvtJ92AbaDeFm6T6xMChgySl
	 guQSLOOdwvbO8vuIJh2JyxXLKno/c4S5hvNz/ueE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moksh Panicker <mokshpanicker.7@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0033/1518] iio: light: apds9306: fix PM reference leak in apds9306_read_data()
Date: Sat, 12 Sep 2026 08:36:42 +0200
Message-ID: <20260912065624.178395507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Moksh Panicker <mokshpanicker.7@gmail.com>

[ Upstream commit d378fceaafd79e0dc59d3546bda251a3058062c0 ]

apds9306_read_data() calls pm_runtime_resume_and_get() but several
error paths return directly without calling pm_runtime_put_autosuspend(),
leaking the runtime PM reference and preventing the device from
autosuspending.

Use PM_RUNTIME_ACQUIRE_AUTOSUSPEND() and PM_RUNTIME_ACQUIRE_ERR() to
automatically handle runtime PM reference release on all return paths.

Fixes: 620d1e6c7a3f ("iio: light: Add support for APDS9306 Light Sensor")
Signed-off-by: Moksh Panicker <mokshpanicker.7@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/apds9306.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/iio/light/apds9306.c
+++ b/drivers/iio/light/apds9306.c
@@ -471,9 +471,9 @@ static int apds9306_read_data(struct apd
 	int status = 0;
 	u8 buff[3];
 
-	ret = pm_runtime_resume_and_get(data->dev);
-	if (ret)
-		return ret;
+	PM_RUNTIME_ACQUIRE_AUTOSUSPEND(data->dev, pm);
+	if (PM_RUNTIME_ACQUIRE_ERR(&pm))
+		return PM_RUNTIME_ACQUIRE_ERR(&pm);
 
 	ret = regmap_field_read(rf->intg_time, &intg_time_idx);
 	if (ret)
@@ -537,8 +537,6 @@ static int apds9306_read_data(struct apd
 
 	*val = get_unaligned_le24(&buff);
 
-	pm_runtime_put_autosuspend(data->dev);
-
 	return 0;
 }
 



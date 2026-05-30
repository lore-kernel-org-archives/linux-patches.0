Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A296E19D8AC;
	Sat, 30 May 2026 17:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162253; cv=none; b=g0KrCBVLwlxntMTLcVloWyvhAFTWgu5NPsoO2za9Yithpkt5y8tZ/5vtcmydOAZjEUzXLhAbgg57INwOp2oyfqSioixVvl32I4Jsoj54q0Mserfga43v5qD+VwH6I+fddvuwhCRuk7Z2NRvFh1Eev/r5vvnZxC52ZMNeaUuLzl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162253; c=relaxed/simple;
	bh=VoGNJLmVC6MhAxR7fsjxrbfvxJhdgSz2oN6Ggr67CIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCYWU8UFSkGcakTKIIxrfevViUm6nZiCeoOeyxokJrjejJmtLGkVAX8aXeL0QFZcbU+C4BbJvwbfe4jNJ35jLrLsMXi7MTthep9+0M5RJHhxaZHDM3JeK70O7lJ7IaeNIouwJ0AorpbtP3we5ljubFtl4MRcwUyoqPtXTeBWR5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2CDxmj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2CDxmj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39961F00893;
	Sat, 30 May 2026 17:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162252;
	bh=ZH9emll4YyrZ5LKhfmDugGKGFYY7q3VbnbYSGM4u4q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2CDxmj0auhZh2Q5yW+iVxNwfzVyrdazstqSX7uTue313QVA4nM4mu3GJd1byfpch
	 RPnaFxiPDJB6BKzdy6YrNRkac6v4Ewz7A6BaDndpSjPRz6CW7JTqS9/4j66PkZFgem
	 4SfdNXYv4QSToY94FUhaV3X27zcQzn47J2ICc4yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.1 867/969] drm/bridge: chipone-icn6211: use devm_drm_bridge_add in i2c probe
Date: Sat, 30 May 2026 18:06:31 +0200
Message-ID: <20260530160324.618886694@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 73d01051e8040c0b1de7fd26b3b8d0c2ffa6895c upstream.

Use devm_drm_bridge_add() so the bridge is released if probe
fails after registration, and drop drm_bridge_remove() in chipone_i2c_probe.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Fixes: 8dde6f7452a1 ("drm: bridge: icn6211: Add I2C configuration support")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260430194944.78119-1-osama.abdelkader@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/chipone-icn6211.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/chipone-icn6211.c
+++ b/drivers/gpu/drm/bridge/chipone-icn6211.c
@@ -758,7 +758,9 @@ static int chipone_i2c_probe(struct i2c_
 	dev_set_drvdata(dev, icn);
 	i2c_set_clientdata(client, icn);
 
-	drm_bridge_add(&icn->bridge);
+	ret = devm_drm_bridge_add(dev, &icn->bridge);
+	if (ret)
+		return ret;
 
 	return chipone_dsi_host_attach(icn);
 }



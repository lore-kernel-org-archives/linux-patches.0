Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25D9330B2D;
	Thu, 28 May 2026 19:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998253; cv=none; b=IycGXn1P9IAPurL/fsRbNQHrtvRmO6cuvHGdwj8r5/wX+wYiXFmQj3qjKNwQNj3KUaTdbtJ0ELoAzsi5QhxvFwf8MZtApiNai9O8CKYjoBqDt3efL340ZOaOXRxGjnlzL/tAg826NQMoF7auoPhNxAxnjzRhCs1NOk0ToKdkN7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998253; c=relaxed/simple;
	bh=k9m/ZAXX3bhkG/LrxCnwDQyqwjatva7h+zyE/pTnWQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmqsBizYsEA1uiyVcyxX2D4b8AmsanIm+Cs/pgATsP0/L7dQrij5vy/Yrk4u4wKZo5W0eb9kgYGvSlG4mDpH+3iIklE9dczfXb75tWHiBwmFKszurWVNqpAOuA1ql76EhWchgbRWb7Ayl3rxam7CMVi4KqgxZbyGLIDruc+ij8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=159R5DCF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="159R5DCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3291F000E9;
	Thu, 28 May 2026 19:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998252;
	bh=Q9B4Xg3hvo2DAxveRbPK8CS6C44JNRclGVFwtQ6FW00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=159R5DCFs2ba+6o7Nnxcenbt8Jq9QJSrtGICGQvYMbCjJBNXSede/CwBPku76MNdf
	 4o4Kf1TRVvxQm0k9JJ0d0HptT0cCaJEwCRxHyQ+K5jXuhGnDGmyYlaJzKMf0MZJYhV
	 lEZ2ltRyTTxBxliyTHiLDizVts8yQicVRDTSLGJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 7.0 107/461] drm/bridge: chipone-icn6211: use devm_drm_bridge_add in i2c probe
Date: Thu, 28 May 2026 21:43:56 +0200
Message-ID: <20260528194650.062568649@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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



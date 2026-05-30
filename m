Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6863E2690D5;
	Sat, 30 May 2026 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160654; cv=none; b=sV6ffwyKNt9LJuC9yTZxVNWU+8CEBvZ/sYyC68d/oWvwvPB6ZvCLPL1I/m1cCXRscFmS3gq140qSmZnBLNHevqMqo+iSU0Y8xoycd6o2x3MK2X+WwZ+azMC9s6c3jNoRG5QaYDj/gQ6pYXeRiX+7RbncHJ2dRr7OSPN2P9sAlKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160654; c=relaxed/simple;
	bh=lcTLr2H+l1maouyfoiC4XetT8fQKqsqwetqC4nWoMVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEYqMB6ekz4jmW1+VkkQbz6TQHOFKTa8wCO5Tp+0lzgLX6VMGQA5nczjYtF7UZgum21kg1TjhjjNiKZJxJ1IUP3PXJvsLdpD7exN0wKjgsVJjiG7YPHftmoq+iQUUKDCtncgMc2woshE22IOrr/OKHn4ulJDTghYclwEJi1bvCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ic97vR9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ic97vR9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD291F00893;
	Sat, 30 May 2026 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160653;
	bh=cuI2LtiqvNzqjZDAeIHzkBK8vj4m/KRScjoxO0G9Xmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ic97vR9H1S/gh2bPx3vxCCeVeBbR1aTx5ZBifnoP4ApYBqAQlL+m9acfDvnTiHLmN
	 T9I1wvkHmY+S9daxHNuVZMGVPRjF5H9GC1SrhckquraeZc4SYL9zs+i2PhTbPdnxor
	 tIiz/3fmxAccGiQJJifPpB89rhwtstKV+0Wbl65Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 396/969] media: i2c: imx412: Assert reset GPIO during probe
Date: Sat, 30 May 2026 17:58:40 +0200
Message-ID: <20260530160311.232001270@linuxfoundation.org>
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

From: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>

commit 8467c5ff5acae28513bc1e0af535e06b41b04344 upstream.

Assert the reset GPIO before first power up. This avoids a mismatch where
the first power up (when the reset GPIO defaults deasserted) differs from
subsequent cycles.

Signed-off-by: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
Fixes: 9214e86c0cc1 ("media: i2c: Add imx412 camera sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx412.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -934,7 +934,7 @@ static int imx412_parse_hw_config(struct
 
 	/* Request optional reset pin */
 	imx412->reset_gpio = devm_gpiod_get_optional(imx412->dev, "reset",
-						     GPIOD_OUT_LOW);
+						     GPIOD_OUT_HIGH);
 	if (IS_ERR(imx412->reset_gpio)) {
 		dev_err(imx412->dev, "failed to get reset gpio %ld\n",
 			PTR_ERR(imx412->reset_gpio));



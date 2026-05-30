Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986F03BD646;
	Sat, 30 May 2026 18:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165705; cv=none; b=HVcdiEywzXqYJVUuMeghRHnmTMOTlNIpg7DnYTkmoIMxULWp6n6opMsQ5vYTxYayxlnLK4Eu9nI5/iiS2G6Esz2puvd4cxRxlekUARFHxUPlSMU0aUpFDsK2jJoezHWM0bdIDM/kY37w+E9qosAJ2geWOAOMU1y9JgwsfRpryZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165705; c=relaxed/simple;
	bh=8gmpeLG7v9D/6u0OE63Ehz0DE+QgxE6aclUt7DHRbOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqPI5tyFGaMptWm8TaCSN2kiXkk7LOsk1Q6B7XP0rilAOzCzxuccgYsafWz21QCF4SEN3/2cWPCuFfcZeAj2E2fJ32Jk7zh/3YxyYk0Ia2vYUex8Hl2n/4uZ5YxxqOz5Ahfhb3/ayUUvgW3cH5fBCUeToHpwhKJhByFLflUrgpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQ0/q8OK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQ0/q8OK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A120D1F00893;
	Sat, 30 May 2026 18:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165704;
	bh=2Mol8x8mTiKR5RO0QCFqZ9HzbmYmh4206a+L5RrQj+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQ0/q8OKB0YagyaGUyeaxOpHqA33L8/M96IW69srQ+Gbs+QuUhtQAQ/hiL/A0IJpS
	 iyv2g/is2RF4j0v+b7t9EJhja17DnkblEKwvRp7OiKssaMqsP3PpCNdzRZ17rLgxMp
	 /kOWi8B5oIZ7MaGVEKyqBk33GkT92/FVZp1tDuqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 157/589] media: i2c: imx219: Check return value of devm_gpiod_get_optional() in imx219_probe()
Date: Sat, 30 May 2026 18:00:38 +0200
Message-ID: <20260530160228.912465720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit 943b1f27a3eead21b22e2531a5432ea5910b60eb upstream.

The devm_gpiod_get_optional() function may return an error pointer
(ERR_PTR) in case of a genuine failure during GPIO acquisition,
not just NULL which indicates the legitimate absence of an optional
GPIO.

Add an IS_ERR() check after the function call to catch such errors and
propagate them to the probe function, ensuring the driver fails to load
safely rather than proceeding with an invalid pointer.

Fixes: 1283b3b8f82b ("media: i2c: Add driver for Sony IMX219 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -1420,6 +1420,9 @@ static int imx219_probe(struct i2c_clien
 	/* Request optional enable pin */
 	imx219->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						     GPIOD_OUT_HIGH);
+	if (IS_ERR(imx219->reset_gpio))
+		return dev_err_probe(dev, PTR_ERR(imx219->reset_gpio),
+				     "failed to get reset gpio\n");
 
 	/*
 	 * The sensor must be powered for imx219_identify_module()



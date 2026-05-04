Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3C740DFD4;
	Mon,  4 May 2026 14:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903861; cv=none; b=AX2zg0V+iwP1VAKSakXXmzm08Xzy/s7sh+irUnvS0Zlsas/2T2YebpIXnz9d6w5fRc9cP5GO9jqMOaPiqecDVRJHG9xBcbGUh9tlPs/fhKdGpfcrHmobYSi1iQ5hJ2pbJjGn668lA1NG///EYceIyK2jsDPKgjpeh/X32QS+hS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903861; c=relaxed/simple;
	bh=af4u5aiCCZme5pTlIqy+faZ+GaIMrGJN3x14MFqMNVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxVaZSvdKXdVb5pmGWPLpda6mTYF/dpWsk96avUAcnLiJXMr467Q7Q+LwNyEMU59pt7DJl5bO3+Hs3UPzRi9eoTupRTUOhzAkywLs+ykDVntahz6Xn4Pgb1s3cNFzQSuaI+nzQciVFIUymGGqKIsxETGosKG1rEj3dqzgSccKDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIvrr5dX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIvrr5dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4913C2BCB8;
	Mon,  4 May 2026 14:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903861;
	bh=af4u5aiCCZme5pTlIqy+faZ+GaIMrGJN3x14MFqMNVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIvrr5dXL8KLr0+vHZ86c6Kaqjyk8gomYu+CeHT/kJi6INna9/9YitjyHKmkSfidc
	 Lvc59UsOuapVvZpvmEwVNbabWtmDDoldRRSpyVrtvST6utrj/ojZ4++CATCaj8AFmp
	 MUHViUfmw/nkKv76Yxx4kQYjoCiDQ+BTBf8KyGJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.18 057/275] media: i2c: imx219: Check return value of devm_gpiod_get_optional() in imx219_probe()
Date: Mon,  4 May 2026 15:49:57 +0200
Message-ID: <20260504135145.053182542@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -1211,6 +1211,9 @@ static int imx219_probe(struct i2c_clien
 	/* Request optional enable pin */
 	imx219->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						     GPIOD_OUT_HIGH);
+	if (IS_ERR(imx219->reset_gpio))
+		return dev_err_probe(dev, PTR_ERR(imx219->reset_gpio),
+				     "failed to get reset gpio\n");
 
 	/*
 	 * The sensor must be powered for imx219_identify_module()



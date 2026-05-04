Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5217D29BD9A;
	Mon,  4 May 2026 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903015; cv=none; b=ES1ovWrRXTQCHw/MDU9cI58bB1I7TnN+/umD3kl3nsnqB+jFER1GO/xVUEHNffybanSm1+wMKLw7iyRZ/N+qW8NLKRZ+rmlEQitH2s9E3ywKMwiqm2CeV3Vu3lw8yLrCofq7OND3UbuczPFimaz4ZG9p4vA7KamM/S/J5lEdERU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903015; c=relaxed/simple;
	bh=7JB18xqs2P5fNUVxKQ6Iucp+WoE26MZ/wecEsddSq9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AR+X2/PmHF3LZRsC/ONyuweeHr9vovmcE5wDMa6GFPXGPYQFKE/5De9VaPG0b0hJ2zZjJ1sFZm50qvwRixVqrxFO5rQD8hykJrE7HeuTC0Mc+BXhYIRkEKrS48KR9WKEon/zhbvBWl298ZBhTv3dFY4znjHLGTxr7NfWK3n2yf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGo1Zq2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGo1Zq2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3EAC2BCF4;
	Mon,  4 May 2026 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903015;
	bh=7JB18xqs2P5fNUVxKQ6Iucp+WoE26MZ/wecEsddSq9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGo1Zq2qk4LAsKprERPvb0FGeOLeNtGEdfywwgtotqNNhg776pvel12ScEs4dXIbD
	 ZcrqODlH8MtiXDWhGABZIPopqR278UhPNz9JpRpCSWvc9v1Mxu+UU8c4wDwVH/RK8L
	 g9cpGo9jdeVerlI01RmTX6PNjUih++vXoUuJtuIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 7.0 063/307] media: i2c: imx219: Check return value of devm_gpiod_get_optional() in imx219_probe()
Date: Mon,  4 May 2026 15:49:08 +0200
Message-ID: <20260504135145.189403038@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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
@@ -1218,6 +1218,9 @@ static int imx219_probe(struct i2c_clien
 	/* Request optional enable pin */
 	imx219->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						     GPIOD_OUT_HIGH);
+	if (IS_ERR(imx219->reset_gpio))
+		return dev_err_probe(dev, PTR_ERR(imx219->reset_gpio),
+				     "failed to get reset gpio\n");
 
 	/*
 	 * The sensor must be powered for imx219_identify_module()



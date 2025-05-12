Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F5F298CCE;
	Mon, 12 May 2025 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073324; cv=none; b=H8XXuacwnGMiXnEXfxWqE2vRk1/s6H5GnNNBQZuxwmZFpeO2JtZQ1l2+bKdWhYNr2+gt8XMPQdh1JwqMrtUWyAVoByBXnFA9H5aZg+JmPJ7jqJEV3MbcFbAFC67Eu+BlGB/YeJxRj7fztb+SPGHRFbs75SFoyXClUJxsRKtPE1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073324; c=relaxed/simple;
	bh=4T1Ng7L+5YtW9Udc3Hn2ibIwak2zRpDdE81ZsJBCu0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4CS1/pvSWnP4IAnmTdRJZp01jKrq7WpPoT5QwxjPgxRgQpRt3hG3dsmA6ncBujJTdnGfjDL2OdJ23qudmIwWfa+BRJu9uOIT6rjHKHxAMIXvxYqihEbyg5UMYf9I2NpUtiQiTG0Vcb3pZo+tkrHncVLeB1BKF1mLeaLkuj3S2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gewz4ZhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gewz4ZhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6846C4CEF5;
	Mon, 12 May 2025 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073324;
	bh=4T1Ng7L+5YtW9Udc3Hn2ibIwak2zRpDdE81ZsJBCu0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gewz4ZhFOUjDaHDI8ylbSZ5QxNWIgDOjGq/FjUNjSf4gRx+bLdO8t2PlgAlP3oCZd
	 jL9+JtDFTEQldvKnCVJr/ZAE38Riiat/w98YHx6HPFbobfFPMPmJ/2sXAT1ahGfDYZ
	 voko9Pa9Zn3o4U3L8GjXTG7PNgZga3npgSwde9Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>
Subject: [PATCH 6.6 039/113] staging: axis-fifo: Correct handling of tx_fifo_depth for size validation
Date: Mon, 12 May 2025 19:45:28 +0200
Message-ID: <20250512172029.261846085@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 2ca34b508774aaa590fc3698a54204706ecca4ba upstream.

Remove erroneous subtraction of 4 from the total FIFO depth read from
device tree. The stored depth is for checking against total capacity,
not initial vacancy. This prevented writes near the FIFO's full size.

The check performed just before data transfer, which uses live reads of
the TDFV register to determine current vacancy, correctly handles the
initial Depth - 4 hardware state and subsequent FIFO fullness.

Fixes: 4a965c5f89de ("staging: add driver for Xilinx AXI-Stream FIFO v4.1 IP core")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Link: https://lore.kernel.org/r/20250419012937.674924-1-gshahrouzi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/axis-fifo/axis-fifo.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -775,9 +775,6 @@ static int axis_fifo_parse_dt(struct axi
 		goto end;
 	}
 
-	/* IP sets TDFV to fifo depth - 4 so we will do the same */
-	fifo->tx_fifo_depth -= 4;
-
 	ret = get_dts_property(fifo, "xlnx,use-rx-data", &fifo->has_rx_fifo);
 	if (ret) {
 		dev_err(fifo->dt_device, "missing xlnx,use-rx-data property\n");



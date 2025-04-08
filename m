Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699C9267F5B;
	Tue,  8 Apr 2025 12:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114695; cv=none; b=SANa5Vf5osvtwvD+sIRqMCt3h5iKnXcQoFVcLVrjo3tbbJ7feti2DwDxHJO38fABTR6bFc+xVHDRv/ddhJrCWAXqzOuAhiudniU+gs7a6gckxR68lnixDa9W2Jb1loeKaDVREXz+c9DLMruyXU/LftKo/beUfnLkhGxq9AMVmXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114695; c=relaxed/simple;
	bh=ucQTgKOIFCoJRN8wfKCbnTxhTUpPkBjeeCsY85QRoL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndM0/rrmbp1um63WyH9ql/3mcYJUx8/zbHaxYIfPsG3dTMHpJ0Mh9Q/BZpHpqa6vc5No/FkBg3bwr6CA4MHQhdXEjt7ffAkWlRmNevMj7Idl2DUXwN7i5BpXhZWeCCiqmFElmLY1KachcL2Q80tBZC+iE+nu4Jk2JVJPQT1iESQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JY8+H06s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JY8+H06s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE959C4CEE5;
	Tue,  8 Apr 2025 12:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114695;
	bh=ucQTgKOIFCoJRN8wfKCbnTxhTUpPkBjeeCsY85QRoL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JY8+H06saYeRYaZju+3vU2M78utoIJjibzOXnKc3ow+770qSuQaEfop2LwfBR5VZW
	 E70xQVds8q4OoNyl8CIs9/8lwpSuS6v1oM3ci7yJU4GJCvrYEZrU0Ijp2FhE8gjp7H
	 1U014uYDZeJnSJ24T0DsKuqdu+4m9IXnVEHEHP9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Christoph Winklhofer <cj.winklhofer@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 200/499] w1: fix NULL pointer dereference in probe
Date: Tue,  8 Apr 2025 12:46:52 +0200
Message-ID: <20250408104856.184501903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 0dd6770a72f138dabea9eae87f3da6ffa68f0d06 ]

The w1_uart_probe() function calls w1_uart_serdev_open() (which includes
devm_serdev_device_open()) before setting the client ops via
serdev_device_set_client_ops(). This ordering can trigger a NULL pointer
dereference in the serdev controller's receive_buf handler, as it assumes
serdev->ops is valid when SERPORT_ACTIVE is set.

This is similar to the issue fixed in commit 5e700b384ec1
("platform/chrome: cros_ec_uart: properly fix race condition") where
devm_serdev_device_open() was called before fully initializing the
device.

Fix the race by ensuring client ops are set before enabling the port via
w1_uart_serdev_open().

Fixes: a3c08804364e ("w1: add UART w1 bus driver")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Acked-by: Christoph Winklhofer <cj.winklhofer@gmail.com>
Link: https://lore.kernel.org/r/20250111181803.2283611-1-chenyuan0y@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/masters/w1-uart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/w1-uart.c b/drivers/w1/masters/w1-uart.c
index a31782e56ba75..c87eea3478067 100644
--- a/drivers/w1/masters/w1-uart.c
+++ b/drivers/w1/masters/w1-uart.c
@@ -372,11 +372,11 @@ static int w1_uart_probe(struct serdev_device *serdev)
 	init_completion(&w1dev->rx_byte_received);
 	mutex_init(&w1dev->rx_mutex);
 
+	serdev_device_set_drvdata(serdev, w1dev);
+	serdev_device_set_client_ops(serdev, &w1_uart_serdev_ops);
 	ret = w1_uart_serdev_open(w1dev);
 	if (ret < 0)
 		return ret;
-	serdev_device_set_drvdata(serdev, w1dev);
-	serdev_device_set_client_ops(serdev, &w1_uart_serdev_ops);
 
 	return w1_add_master_device(&w1dev->bus);
 }
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313B52236FC;
	Tue,  8 Apr 2025 12:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116508; cv=none; b=CWVYXLjP+ufbXU1F3HUgSptPdArDQmMB5hdDzUbtObQUR0V9PphrHuTLMawrsMofVYA8kCjDn6ir81ScgnwMY/nxN3M1U9BFO2+RlY0voO0azYpbkUTU0qprd5O56KqwJum5iHthZyMnvIsFBFIJVRiKpT3tweTJqYGu9IbNgos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116508; c=relaxed/simple;
	bh=Mm2gBzuYpkVA3qcg5xFkvYPdLddrsT9kcspdwZvbRRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2HY7Pb/AWTVqRLT8lBlN9/XWeNRGR/pde7TthmH1CDiFBlCaVwAUUZHVNIFMp4U6pi8ztNjfSFDndXP8qstSI/++VfBmLfADQFnZhYE6ME8VUnleynkQaC4NtdKR2Ne5Ja137X7VbYJxtoZh1GTNgljy5W2oIhjfCXlxwCqe/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3kH5iAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3kH5iAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B25C4CEE5;
	Tue,  8 Apr 2025 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116508;
	bh=Mm2gBzuYpkVA3qcg5xFkvYPdLddrsT9kcspdwZvbRRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3kH5iAfrgKFJF0nAOf7AV8c5ZO46ybXqaNNcTZcilBPLlsj1U5W0tzSLpTJFdDy3
	 jzbaXxw+uZLv2pZIb5+Obz6TBsn3T3sQexKZAUkav7JhQ2EwvpTel3t7uWkjgUqXxw
	 brSMEJk6OtpH7y+OkAcbSFqtQJg0jTJe85JAyMVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Christoph Winklhofer <cj.winklhofer@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/423] w1: fix NULL pointer dereference in probe
Date: Tue,  8 Apr 2025 12:48:10 +0200
Message-ID: <20250408104849.558008440@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




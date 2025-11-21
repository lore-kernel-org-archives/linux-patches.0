Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCCC2765FF;
	Fri, 21 Nov 2025 13:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731752; cv=none; b=Kig3/B50tjBDlcuPXfrsou39GW9w7HrJHI+WDUeLp2lqOSR2fQUJkxLZgQP0ONhLISqyVcB6evhOHzQD7gMJ999ahMVtEZr1I7MtSNhJx0M9uQtRrZ9KJG+dtxyshP39jkZvBUUZYvF8grliOYXAHwk9T1WuOmxo2x7B/S9vgSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731752; c=relaxed/simple;
	bh=0qtrjcL2rk+T6cyFtB9nEahQOMudTjvb59RSeWfr2bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frTRFhndcmDsevh9KMSD59yoMEwk/kPYZ0RgkJuveFCeGy2Meb1/ZPqisdiMSGS6bgsyW8WFvHrUSyzEJ31bUnjUWFXPynM4czyte1UlnB3es4E/ozYeAs8XK4d8vtURM+sPWotACuABDd09eAiyLSn078IJuWNIp59qsmD6Lw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBxr3LVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBxr3LVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4556C4CEF1;
	Fri, 21 Nov 2025 13:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731752;
	bh=0qtrjcL2rk+T6cyFtB9nEahQOMudTjvb59RSeWfr2bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBxr3LVJ8i07QejVqKW6I1oAW5DXxcvrbVZnUvvVSnWcLLNTfEQ3K8EsBJ6hri+D0
	 tkOPHhJp+am2nl5G8Has6zZEI3GuTc3PJQhGc6hnQX5vUZb5LhrortR+5+e5oAdAU2
	 OxiZYXujlLZiw96F7iXPWmrTU/hLV4oxIVjaUNK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/185] regulator: fixed: fix GPIO descriptor leak on register failure
Date: Fri, 21 Nov 2025 14:11:35 +0100
Message-ID: <20251121130146.329569605@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 636f4618b1cd96f6b5a2b8c7c4f665c8533ecf13 ]

In the commit referenced by the Fixes tag,
devm_gpiod_get_optional() was replaced by manual
GPIO management, relying on the regulator core to release the
GPIO descriptor. However, this approach does not account for the
error path: when regulator registration fails, the core never
takes over the GPIO, resulting in a resource leak.

Add gpiod_put() before returning on regulator registration failure.

Fixes: 5e6f3ae5c13b ("regulator: fixed: Let core handle GPIO descriptor")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251028172828.625-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 1cb647ed70c62..a2d16e9abfb58 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -334,6 +334,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		ret = dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
 				    "Failed to register regulator: %ld\n",
 				    PTR_ERR(drvdata->dev));
+		gpiod_put(cfg.ena_gpiod);
 		return ret;
 	}
 
-- 
2.51.0




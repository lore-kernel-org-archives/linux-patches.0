Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128473624A9;
	Wed,  3 Dec 2025 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781027; cv=none; b=Q7/GWJu2CL9jzPIqoqayL+mi8CwJN2zW5CMgtdHWpYZO0RL8/ZnhcPpZ617Loh2yRns/0LcbC/TlgX6uX2U/2ob7/tPpAsvtnCnd+ukVuarAYeiUzSDrx+qiHSd34+0lI1nEZo2MGWpbTubBUsuAsOfCTzoVs5aF8rmSM+8Sd24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781027; c=relaxed/simple;
	bh=xHi34vRyJ8HhZfccKP6aVA8E0/mrZQAQ/MyFQ02kF0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDihsgBICCmwVOE3eaPwzI0TrsOcuyCCBCJvGDrs9F/VOA6IM3mp1JipZm5v8HpY4W/I2QJ7rGFQYToehQZ8fni08czFqsV2KN3sYX9hFYk7H9u47MHwzMl8yGjhrnrhdGkghfnWJRRCpyNIO5rH+aY+58Kwg/r0cBFxBZ9HdiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxfKzmLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxfKzmLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52056C4CEF5;
	Wed,  3 Dec 2025 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781026;
	bh=xHi34vRyJ8HhZfccKP6aVA8E0/mrZQAQ/MyFQ02kF0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxfKzmLW8pL1ZsiHGeOJdjCT9Kl9M6nhFkzLOAQ1hqkVOOCZn3toepkQ+E1mZIDEj
	 9WmrljBpwR3PMHOtCd8pvQB1wngEl3XUhnwv4JXYy4Q4OaZnGbgnTcOnmZz0/pSwJo
	 WGDL9S4+oFeXqfhQ8tZOK+lnOiwm9JLMA8/1P6dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/93] spi: amlogic-spifc-a1: Handle devm_pm_runtime_enable() errors
Date: Wed,  3 Dec 2025 16:29:20 +0100
Message-ID: <20251203152337.520292195@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit a90903c2a3c38bce475f46ea3f93dbf6a9971553 ]

devm_pm_runtime_enable() can fail due to memory allocation. The current
code ignores its return value, potentially causing runtime PM operations
to fail silently after autosuspend configuration.

Check the return value of devm_pm_runtime_enable() and return on failure.

Fixes: 909fac05b926 ("spi: add support for Amlogic A1 SPI Flash Controller")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251124015852.937-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spifc-a1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-amlogic-spifc-a1.c b/drivers/spi/spi-amlogic-spifc-a1.c
index fadf6667cd51c..b430bca4f8bce 100644
--- a/drivers/spi/spi-amlogic-spifc-a1.c
+++ b/drivers/spi/spi-amlogic-spifc-a1.c
@@ -349,7 +349,9 @@ static int amlogic_spifc_a1_probe(struct platform_device *pdev)
 
 	pm_runtime_set_autosuspend_delay(spifc->dev, 500);
 	pm_runtime_use_autosuspend(spifc->dev);
-	devm_pm_runtime_enable(spifc->dev);
+	ret = devm_pm_runtime_enable(spifc->dev);
+	if (ret)
+		return ret;
 
 	ctrl->num_chipselect = 1;
 	ctrl->dev.of_node = pdev->dev.of_node;
-- 
2.51.0




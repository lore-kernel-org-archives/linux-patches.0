Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEAF1EFFB9;
	Wed, 23 Apr 2025 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421532; cv=none; b=sDxfFa6ouqXZucx9GrOZiIAuGciwPLGMfHgpNed6x4b8sIPmEGE5oRn/iAEJYiVI0ht4H/R9kWyETxb8cqi09rtOUSzrgxxKAQmIh+N1QY+JkSVjsgfAJKLLLJduxYcO9YAvnxIuE7DrlSetx58tKCNAinabF/OScMDPAKvbeLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421532; c=relaxed/simple;
	bh=IXmoqCKD1j1Ro4KzIn21GdZtTuwpW/Lu+et8hwmf+LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWj8Q3hhNct6vG5mXO19+1OFe+X/hUhr8+O+mCtOUWgATUleiPxzFvnmgpzdLniE7o7hyuGp814jFQpEFLaZ2D2Nt5ldp6Oj0u2WBYsXcScyf+gTU2VexUwzMUDySoDMBTZQQKTOS6U9YmT/6o5gWtBVFrD5+42c5WymGnPdsXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTUYJTv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTUYJTv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71559C4CEE2;
	Wed, 23 Apr 2025 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421531;
	bh=IXmoqCKD1j1Ro4KzIn21GdZtTuwpW/Lu+et8hwmf+LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTUYJTv+KhODQMY7AJT8eRFYTlyZm59l6wlKJOeylhrp0kEipjpgbaE3OU9w/QCit
	 DeI4FefbA4kf2PR/tlgZ8354JFxJhauB61iCL+tw6BdVw1Yt6ozB1KO59ppz4JJtjC
	 tmyYlqrzwDbGdU3zHrQGwvyAIH2pebOtrop4amRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.1 147/291] gpio: zynq: Fix wakeup source leaks on device unbind
Date: Wed, 23 Apr 2025 16:42:16 +0200
Message-ID: <20250423142630.409422076@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit c5672e310ad971d408752fce7596ed27adc6008f upstream.

Device can be unbound, so driver must also release memory for the wakeup
source.

Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406202245.53854-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-zynq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -1012,6 +1012,7 @@ static int zynq_gpio_remove(struct platf
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
 		dev_warn(&pdev->dev, "pm_runtime_get_sync() Failed\n");
+	device_init_wakeup(&pdev->dev, 0);
 	gpiochip_remove(&gpio->chip);
 	clk_disable_unprepare(gpio->clk);
 	device_set_wakeup_capable(&pdev->dev, 0);



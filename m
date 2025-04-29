Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E11132103;
	Tue, 29 Apr 2025 17:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948768; cv=none; b=Zq3NsV39xxi+WLzZ1WFTqouDbqUDYsqxyBJRfrfcWpfW2cB3sfgp+4lxF28WiX9kPyIN6adk+p+elspymmQUz+RR/TjOJNMRPVrx4O+FzYCHKXQSr1oZ1kG9u8sY+a6cWv3vsEl2V/SSJQYcX77zya5iCiZaAl2NAj0lPjEnzFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948768; c=relaxed/simple;
	bh=wDWh7O2mR2dXX00IYwv55rmD2npTf3KgqeJ1Mteu5tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUQOiwm6ashKl7oQzPluNmiCdTudWBz7ouKmBcd4nCArwR3IuoMqdF97v9o0N8SySgY0KF8aJGOQiKB6Ip2TCPQFmyMejDYXKmpLtup5yTr2ba9Nid4BpE+Ph5Fxzf7wzYBArLvDH1EHksTvxYtPeqt/adDMNZ5Lx8D5SCj7bik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAgEoPn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAgEoPn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA36BC4CEE3;
	Tue, 29 Apr 2025 17:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948768;
	bh=wDWh7O2mR2dXX00IYwv55rmD2npTf3KgqeJ1Mteu5tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAgEoPn4AgRHu5HfFBhEqgAzoe2Tzjd3wqvbxcFJqrU42rYQ/S11jPmC3yNPT6IAI
	 vYltYNc0KvIAKrC9hnnLRy5mC/K89LB0RNQifDlRS4cQfd634FRqWLirCIMIJRb4Zr
	 CtTuc/Z/bRF0xLwLbqmlzr9HaV4qBzuNqVSu2+uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.15 107/373] gpio: zynq: Fix wakeup source leaks on device unbind
Date: Tue, 29 Apr 2025 18:39:44 +0200
Message-ID: <20250429161127.572873954@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



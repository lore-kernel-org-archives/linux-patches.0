Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C3264A83;
	Thu, 17 Apr 2025 18:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914885; cv=none; b=cfY/wz2iTG+Xg9l7iV9QpkQAGSnOTS+Q3ESG2NkO++U5dZVxWxtdMDeOmUl8OVcUsKiv+RccvG3GOHNlY9TB7yARXuI/TtoyQQCxMhnkKYV4cLU4zWnPI+z8+Lxf59/3XuRY4CYIS5nZSSPKSMnMMgNbmdFK0GF8TDVbSIDi948=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914885; c=relaxed/simple;
	bh=hdtkuwQefprGfcEH9pMGafuqlBK3ouK4HwBwM/z+6GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pt6+pjzaPJjJQQA8T+c0gLADc+NFX8+3IWM0Mo6kF8YBt2csmHb7lXNiQsIMxle3mlut1+QEvWCU2YPPz8PIba5mm5J4MFhm03WJlAD7oJcgFc8f1E+sex6h2yioe+3q4J/AcO3wjt6d+vGeev0JCR9g3dgSH0Ahz7Z9ap2W6b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjN7+TKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjN7+TKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD334C4CEE4;
	Thu, 17 Apr 2025 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914885;
	bh=hdtkuwQefprGfcEH9pMGafuqlBK3ouK4HwBwM/z+6GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjN7+TKBOSAg2CxdRjRZyzb/shsWslywNC5PpYUh0ZkTJsI1ZQUwsvmOcN2fIal9Y
	 ae1JrukZRLZ6QrNckSgEeQOPUV9F0/Cs8UB7vGEw9MPznsyLjG01rrzahkdL5q4Xca
	 qJ0FWcasS0irYC7scHanVEQATHkRIPUwdgQZHWYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.13 362/414] gpio: zynq: Fix wakeup source leaks on device unbind
Date: Thu, 17 Apr 2025 19:52:00 +0200
Message-ID: <20250417175126.019533331@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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
@@ -1011,6 +1011,7 @@ static void zynq_gpio_remove(struct plat
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
 		dev_warn(&pdev->dev, "pm_runtime_get_sync() Failed\n");
+	device_init_wakeup(&pdev->dev, 0);
 	gpiochip_remove(&gpio->chip);
 	device_set_wakeup_capable(&pdev->dev, 0);
 	pm_runtime_disable(&pdev->dev);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B9F254B1D;
	Thu, 17 Apr 2025 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913706; cv=none; b=pmpVsbMqDVxGOhqNF1VZPVcvP3iu0lD4adx5asow+hJSxY8J7QvmOz/RENklGD6//2BI5RGQEhbhsEeqqrFHo5ueKTS+u2OqlKwWT8lL0xY8eJxJMUOtk6aBqE8XkfqOwcLKXR9YkT/kZgbekJmMnt2MnZzEWoPbaw5P/v9Uymg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913706; c=relaxed/simple;
	bh=6QFvfNdDeRN6SbWNx/CBUe9L/hCGm7pV4OLW7OuyFm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDRPuw5bFK4kIhLzspJQGHxf3s7fRcqmUeeM4fpBdJdG0+yvxCLTD0oUVcOtRKOgHpMwRG6JsENbCzvHPe90ok+U6M5kTT+xxXfNVGMnuYsQTIV9wx62HMZhwPGbZhGS9Jt5JcHXLUHQEEBS69EfK8Bns67WDjHzwZ+6HQA8uxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yR1HXZ8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yR1HXZ8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4061C4CEE4;
	Thu, 17 Apr 2025 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913706;
	bh=6QFvfNdDeRN6SbWNx/CBUe9L/hCGm7pV4OLW7OuyFm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yR1HXZ8NLckhOpJb+n+zXCSYIH8EbpvTtJxmfD752wEWQTOW2S6ZMSnIoUScuVYLv
	 8YmzYDA9J7ebcrtIlj+8ByPIhGFTtPDUg9oBU7AIFheM0A0kouDtavENeHpxyeQ2Gc
	 7ht9A1t5GoxRbNWcPcXuwL9SDgciVPEleI37iGzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.14 397/449] gpio: mpc8xxx: Fix wakeup source leaks on device unbind
Date: Thu, 17 Apr 2025 19:51:25 +0200
Message-ID: <20250417175134.244878007@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit da47605e43af9996eb46c8a060f259a8c34cc3c5 upstream.

Device can be unbound, so driver must also release memory for the wakeup
source.

Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406202245.53854-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mpc8xxx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -410,7 +410,9 @@ static int mpc8xxx_probe(struct platform
 		goto err;
 	}
 
-	device_init_wakeup(dev, true);
+	ret = devm_device_init_wakeup(dev);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to init wakeup\n");
 
 	return 0;
 err:



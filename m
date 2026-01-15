Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F52B2FDC4D;
	Thu, 15 Jan 2026 17:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496992; cv=none; b=TJH3ujCxAsuLPlEMs9+jr9bcPTmp7tYTnyzEluMmvGX7bUsjTtigyGoNHPZtz7k/eDoS/LaiF9+XGV3dLEHbszqFhOyaaOdFFPrarg7iK44CzGIs30xVcVxQ07VBN6OLGJvrmjRAKcCb2L4WDLs1cDymcB5XAaXHeGVV3jdC6Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496992; c=relaxed/simple;
	bh=HJzcbuw1H9TBtZOimglvbFEi2Dr20Hm16PQyNukZ2is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5I8gTPpNDm8IH2AUkewaX/UO6a5HBPKPzSFBVwQiprJAmZa9au8CL39MZz9cDWwAgYLUi/u7aV91OOKr2cA+Oj4plZ8RofyucBY1pi0MU4MfgPMhjm19OjOGwv5vGLOEv8VCaqU/3pAWCGjkZGUf6Lhuwucc6MsaF3kYjhk3gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzutn010; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzutn010"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B412AC116D0;
	Thu, 15 Jan 2026 17:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496992;
	bh=HJzcbuw1H9TBtZOimglvbFEi2Dr20Hm16PQyNukZ2is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzutn010SeZ6mKOYU/iwDhjo0Zr6SPMDngD3GqelBzlvfOpE+GsxxN8EymAzCFREf
	 Zq+EDaW4ZirGYmPidEanwZXiFtUL+34tORZf5Zh1+yBoZm6wyA1mvTjpxWNqyMHdC6
	 JfSBdwDXtVd2qCNfGKX4r5ZzL/Vyet9gz4fPUzXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 88/88] gpio: pca953x: fix wrong error probe return value
Date: Thu, 15 Jan 2026 17:49:11 +0100
Message-ID: <20260115164149.500602298@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 0a1db19f66c0960eb00e1f2ccd40708b6747f5b1 upstream.

The second argument to dev_err_probe() is the error value. Pass the
return value of devm_request_threaded_irq() there instead of the irq
number.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Fixes: c47f7ff0fe61 ("gpio: pca953x: Utilise dev_err_probe() where it makes sense")
Link: https://lore.kernel.org/r/20250616134503.1201138-1-s.hauer@pengutronix.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pca953x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -989,7 +989,7 @@ static int pca953x_irq_setup(struct pca9
 					IRQF_ONESHOT | IRQF_SHARED, dev_name(dev),
 					chip);
 	if (ret)
-		return dev_err_probe(dev, client->irq, "failed to request irq\n");
+		return dev_err_probe(dev, ret, "failed to request irq\n");
 
 	return 0;
 }



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5AE1F428D;
	Wed,  6 Nov 2024 12:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897530; cv=none; b=FhLRKLVZ9G6jx2wtdDpRCi7PnZlpH2Hgwcs5g5Bnb1/nh8/3sL205QppmB+s8l9BfRhZv47E7DWZZsOMhxE2cbgWSm1zWUQFhbpSZ/6zsPUyJ0o3eICCmZh3A+OkKoDvc8QtXhF9JtfG0MXWcqEJhLgNhzVV3iunQBefw6m3zKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897530; c=relaxed/simple;
	bh=ViEwyOIs9bAMX/Lbas8x/4KDLn4HLB2Jw7lqfaFnpfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCONEUTbJtPXAIdEsqHA6t8Ou4YLPnubLANGcZHV9gqgHtbvnw+kYMoISMEp3sxpPF+/JRu+UNF3Nz//EBcK5laVu39pwDGi5HtQSn/zQwjFhw5QJfzgtDReh8RUPae2Siepzj7AREV4DhDFkjXmX96ysFLTnNX0z1gMSQvkNIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOYu17ZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOYu17ZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E23C4CECD;
	Wed,  6 Nov 2024 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897530;
	bh=ViEwyOIs9bAMX/Lbas8x/4KDLn4HLB2Jw7lqfaFnpfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOYu17ZHZtP2a+CMQmOR9U+4FaBqOWyaC6Qzs5MJ8DbMfCRtk6yzQw/DdwjwVG0t1
	 sO4fH6cuyyFgWpaFwi/TfSDnY2fXm0rebY+chpdE5zMK4WiayaA/xoevWV4QawqbVn
	 r5S8K0H78pA7Bu0ODN7wTOKwbS5s5qtaIT2HHwlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 085/151] phy: qcom: qmp-usb: fix NULL-deref on runtime suspend
Date: Wed,  6 Nov 2024 13:04:33 +0100
Message-ID: <20241106120311.202670975@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johan Hovold <johan+linaro@kernel.org>

commit bd9e4d4a3b127686efc60096271b0a44c3100061 upstream.

Commit 413db06c05e7 ("phy: qcom-qmp-usb: clean up probe initialisation")
removed most users of the platform device driver data, but mistakenly
also removed the initialisation despite the data still being used in the
runtime PM callbacks.

Restore the driver data initialisation at probe to avoid a NULL-pointer
dereference on runtime suspend.

Apparently no one uses runtime PM, which currently needs to be enabled
manually through sysfs, with this driver.

Fixes: 413db06c05e7 ("phy: qcom-qmp-usb: clean up probe initialisation")
Cc: stable@vger.kernel.org	# 6.2
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240911115253.10920-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -2173,6 +2173,7 @@ static int qmp_usb_probe(struct platform
 		return -ENOMEM;
 
 	qmp->dev = dev;
+	dev_set_drvdata(dev, qmp);
 
 	qmp->cfg = of_device_get_match_data(dev);
 	if (!qmp->cfg)



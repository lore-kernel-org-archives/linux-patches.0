Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43891D2784;
	Wed,  6 Nov 2024 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896173; cv=none; b=PBYWfgDwvbom7ykU64YHRzuMPiLUiquh3SR4xLgfL1xby6NX3QiFrCgSrjRWWieAkK7tzO2IaJDxxX5VUUpOcHY/3Vg7ybomPCUxkAN4fqar4Uxr09V7KZHI/mVdi06mns+nQj5kv6KrIRoYawLnLMSUYYgVA+J4OrvibmwxxdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896173; c=relaxed/simple;
	bh=hdjDZlcaEPia/3IDtb2+EkHpQEuqc6DAgIU48/oHiFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt5TafNgojS1JossMqXtdEcxHGeXgDql2TD8Q3LdFZbzru+EW//6Y7NYvJNorfhrzQYNLwRoBNPCKJokHCGtRmJTZU8SqB+6wdtgp/DHPpDkCIITLK6N9a0atzmPVsNWj1etmwHfs/cI1lXMHR7fwm7uGoYKEW3lwT117kL3hVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPLM51JY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPLM51JY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A16DC4CECD;
	Wed,  6 Nov 2024 12:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896173;
	bh=hdjDZlcaEPia/3IDtb2+EkHpQEuqc6DAgIU48/oHiFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPLM51JYZfFGuwH557LGSqJy44AQZGmiv0z9uL8PttbESjGq7MHRZTUnyKsYy814I
	 RMEA8/PHnrYM6V4nk/1wvlSu6TZfG/m7XJIU8rqZxM6MpG2VhBkTISC55M27oAHyU5
	 JI5PUesE6+HArZrUAqUfv5KwXQJW1jV1HK1JLRMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.11 113/245] phy: qcom: qmp-usb: fix NULL-deref on runtime suspend
Date: Wed,  6 Nov 2024 13:02:46 +0100
Message-ID: <20241106120322.001123184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2179,6 +2179,7 @@ static int qmp_usb_probe(struct platform
 		return -ENOMEM;
 
 	qmp->dev = dev;
+	dev_set_drvdata(dev, qmp);
 
 	qmp->cfg = of_device_get_match_data(dev);
 	if (!qmp->cfg)



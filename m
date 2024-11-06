Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566281F428D;
	Wed,  6 Nov 2024 12:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897533; cv=none; b=jflcTaMY6z+87Pscq+P5KYlJ1gt2YrFFePAlrvnio5/LaVuMr5Ap7JyYV0y23gQYmk72az/fgu4f8/Vp2vilzglgcsuaD3mW6mct2TKseroKeKX8e8vuV6Ep84BNel+8GH9KXrUAIzuPASI7zaOhv7Oi9nZ/UFCy0vtRS2GUeuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897533; c=relaxed/simple;
	bh=cNK793dmOY6FQdl1X4WH/Pae/4HulG4Uo2iPpqMxZqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qInm135hsk9bh0iLYcch9AN+Ot85fElncLDTMqt7+0LMRNtwczNpmE4+QUiRtKKmEwqh5KlaP11nPts2s5BcS1SbeJXkuOIVJ/De4VlJZv1clBCMc11w8A/AwGuuwp4iN8AuNckbUcB6YBtNeafPXx44PDJs0ofI77bykPtVrYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnCiV9xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnCiV9xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FC7C4CECD;
	Wed,  6 Nov 2024 12:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897533;
	bh=cNK793dmOY6FQdl1X4WH/Pae/4HulG4Uo2iPpqMxZqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnCiV9xuCgaZBLWK7+UlC6O0+nicpRCzjhNoIrLdg9yCVNqKy6S8eoazrAZyvjqH0
	 tXrhX11lyMyfVGbOvDdHTrnidKOziWLKR6b9k1Mt1nzvig261bkeEnvhhImv4eflOd
	 /hEGGWC+IVGn3VBoGFi3kt+2pBNxZy2TXRmV8lv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 086/151] phy: qcom: qmp-usb-legacy: fix NULL-deref on runtime suspend
Date: Wed,  6 Nov 2024 13:04:34 +0100
Message-ID: <20241106120311.230415845@linuxfoundation.org>
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

commit 29240130ab77c80bea1464317ae2a5fd29c16a0c upstream.

Commit 413db06c05e7 ("phy: qcom-qmp-usb: clean up probe initialisation")
removed most users of the platform device driver data from the
qcom-qmp-usb driver, but mistakenly also removed the initialisation
despite the data still being used in the runtime PM callbacks. This bug
was later reproduced when the driver was copied to create the
qmp-usb-legacy driver.

Restore the driver data initialisation at probe to avoid a NULL-pointer
dereference on runtime suspend.

Apparently no one uses runtime PM, which currently needs to be enabled
manually through sysfs, with these drivers.

Fixes: e464a3180a43 ("phy: qcom-qmp-usb: split off the legacy USB+dp_com support")
Cc: stable@vger.kernel.org	# 6.6
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240911115253.10920-3-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c
@@ -1302,6 +1302,7 @@ static int qmp_usb_legacy_probe(struct p
 		return -ENOMEM;
 
 	qmp->dev = dev;
+	dev_set_drvdata(dev, qmp);
 
 	qmp->cfg = of_device_get_match_data(dev);
 	if (!qmp->cfg)



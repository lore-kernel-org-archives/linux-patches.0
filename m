Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9208D1D2784;
	Wed,  6 Nov 2024 12:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896179; cv=none; b=gICRI+Matks0McmGROWvVBdBB6P0mhwXyOr3XDWIi0MfcQBqDJ2WbbC5Jm5J04fd/OucihqLekmrrjSwUUCIvimT1R8PPtNmcbL4VqmVosQBC9CssknxTIBDvlTixSppHQa8dyqqMGOIiHpT8OWsNJXLgkoUrQFF1syjyknbfWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896179; c=relaxed/simple;
	bh=kOw/woW92YIl1ImYUVK3S5Pevdu9UZAPeZUSSrb5ync=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUYLFf12WhivYEj9DZhJMC9bC/F+Z0jjHX2lm2lu4ukRbJyWURgt0hBSW3kivUTbb/MepS0OeCKhdDSvg/dc+d12kiES2qo5gA8tM2cAjcQL5OXkyWMo6CBLEUedJJkYLQXTSCXHN6Sm2rT9PWNomikorX6/Qouf/w0AJaYF0qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSNot3uV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSNot3uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEF6C4CECD;
	Wed,  6 Nov 2024 12:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896179;
	bh=kOw/woW92YIl1ImYUVK3S5Pevdu9UZAPeZUSSrb5ync=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSNot3uV4h3tgrX3CiIYTIcnDl8tTjb4PK8PSVFmkPhhbBBijM7f/8abrOfiGvuDX
	 GykK1YsaoI0mtNQZ1TaGJm09naee36TA3i9uMfGVbbxXAAbK4cR8WXUaCzJWnb1AGo
	 xDt/oXW7XgsVHqRjX04RBeJXfrMy393sgLwZJLxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.11 115/245] phy: qcom: qmp-usbc: fix NULL-deref on runtime suspend
Date: Wed,  6 Nov 2024 13:02:48 +0100
Message-ID: <20241106120322.049644649@linuxfoundation.org>
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

commit 34c21f94fa1e147a19b54b6adf0c93a623b70dd8 upstream.

Commit 413db06c05e7 ("phy: qcom-qmp-usb: clean up probe initialisation")
removed most users of the platform device driver data from the
qcom-qmp-usb driver, but mistakenly also removed the initialisation
despite the data still being used in the runtime PM callbacks. This bug
was later reproduced when the driver was copied to create the qmp-usbc
driver.

Restore the driver data initialisation at probe to avoid a NULL-pointer
dereference on runtime suspend.

Apparently no one uses runtime PM, which currently needs to be enabled
manually through sysfs, with these drivers.

Fixes: 19281571a4d5 ("phy: qcom: qmp-usb: split USB-C PHY driver")
Cc: stable@vger.kernel.org	# 6.9
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240911115253.10920-4-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usbc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-usbc.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usbc.c
@@ -1049,6 +1049,7 @@ static int qmp_usbc_probe(struct platfor
 		return -ENOMEM;
 
 	qmp->dev = dev;
+	dev_set_drvdata(dev, qmp);
 
 	qmp->orientation = TYPEC_ORIENTATION_NORMAL;
 



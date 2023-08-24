Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DB611C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E29C433C8;
	Thu, 24 Aug 2023 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888838;
	bh=hmTw7dDUE37M+EfxXfZICbjw5EgPKiXrMCcbuz9kjek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzPN+u7jCU9wTGDpPLr394vpBTeA4GwiI3p4k8L56AKo5LtL92jp2W2m9Iwaayy8E
	 RzK9RxlGL3ZWXnQ13aei6lTbNSEz6lCeXEPJPR2ZsiVD2aQn5doY+jSJ9dKVDX8F4k
	 pv+/MwfoD/tzFmgFOhCGOjJ3zfHJAiu/DUzUAaoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <jun.li@nxp.com>,
	Sandeep Maheswaram <quic_c_sanm@quicinc.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/139] USB: dwc3: fix use-after-free on core driver unbind
Date: Thu, 24 Aug 2023 16:49:43 +0200
Message-ID: <20230824145026.235900069@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit e3dbb657571509044be15184a13134fa7c1fdca1 ]

Some dwc3 glue drivers are currently accessing the driver data of the
child core device directly, which is clearly a bad idea as the child may
not have probed yet or may have been unbound from its driver.

As a workaround until the glue drivers have been fixed, clear the driver
data pointer before allowing the glue parent device to runtime suspend
to prevent its driver from accessing data that has been freed during
unbind.

Fixes: 6dd2565989b4 ("usb: dwc3: add imx8mp dwc3 glue layer driver")
Fixes: 6895ea55c385 ("usb: dwc3: qcom: Configure wakeup interrupts during suspend")
Cc: stable@vger.kernel.org      # 5.12
Cc: Li Jun <jun.li@nxp.com>
Cc: Sandeep Maheswaram <quic_c_sanm@quicinc.com>
Cc: Krishna Kurapati <quic_kriskura@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Message-ID: <20230607100540.31045-3-johan+linaro@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index ac119a88e6c76..6377b9cf81a59 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1719,6 +1719,11 @@ static int dwc3_remove(struct platform_device *pdev)
 	pm_runtime_allow(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
+	/*
+	 * HACK: Clear the driver data, which is currently accessed by parent
+	 * glue drivers, before allowing the parent to suspend.
+	 */
+	platform_set_drvdata(pdev, NULL);
 	pm_runtime_set_suspended(&pdev->dev);
 
 	dwc3_free_event_buffers(dwc);
-- 
2.40.1




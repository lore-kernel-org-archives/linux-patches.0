Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BBC5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14026C433C9;
	Mon, 19 Jun 2023 10:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171595;
	bh=FDlPLZ11yp7rdcLQZ4Yrhjuclb2oiXsUBqeB06nAucg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRXlA6vP3ObrmSH0RKmMiFng0KTT+obnl/lfOx8c+FgrCrGrXjHMFThOaOHRBXkd3
	 vO+/AuJi42YaCogRKWsQpV1wf33GuAic+xTbDGzylZFM89vca7XG6Qv+Cvifr6IJwb
	 l8apF9U428t4diN2wYb7e8Fr8P07dA9Y8wP1f3OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <jun.li@nxp.com>,
	Sandeep Maheswaram <quic_c_sanm@quicinc.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.1 088/166] USB: dwc3: fix use-after-free on core driver unbind
Date: Mon, 19 Jun 2023 12:29:25 +0200
Message-ID: <20230619102159.071083515@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
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

commit e3dbb657571509044be15184a13134fa7c1fdca1 upstream.

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
---
 drivers/usb/dwc3/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1982,6 +1982,11 @@ static int dwc3_remove(struct platform_d
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



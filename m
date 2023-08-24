Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D0A11C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB35C433C8;
	Thu, 24 Aug 2023 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889303;
	bh=VvB8+NnBnafph951BpQm6JZe0mqA2YpDjVOxFkGhMbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nb3CmQ7NXTRv1s6Yy6qlnVXn3z9Zd6arl9Yq57Elcon+BYP9v4PJJ5E2zMgfeQxDP
	 eRHSHxg7fz0+2FetmH6mu58k6zLTzAj5B5YfyMDfZe3cLhqtZVZ5TeV5oWQZdl6ahE
	 82xZXowOOImZaPG90fqwz4GEri+VDFmZciLZqHJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sandeep Maheswaram <quic_c_sanm@quicinc.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/135] USB: dwc3: qcom: fix NULL-deref on suspend
Date: Thu, 24 Aug 2023 16:50:01 +0200
Message-ID: <20230824145029.401701153@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
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

[ Upstream commit d2d69354226de0b333d4405981f3d9c41ba8430a ]

The Qualcomm dwc3 glue driver is currently accessing the driver data of
the child core device during suspend and on wakeup interrupts. This is
clearly a bad idea as the child may not have probed yet or could have
been unbound from its driver.

The first such layering violation was part of the initial version of the
driver, but this was later made worse when the hack that accesses the
driver data of the grand child xhci device to configure the wakeup
interrupts was added.

Fixing this properly is not that easily done, so add a sanity check to
make sure that the child driver data is non-NULL before dereferencing it
for now.

Note that this relies on subtleties like the fact that driver core is
making sure that the parent is not suspended while the child is probing.

Reported-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/all/20230325165217.31069-4-manivannan.sadhasivam@linaro.org/
Fixes: d9152161b4bf ("usb: dwc3: Add Qualcomm DWC3 glue layer driver")
Fixes: 6895ea55c385 ("usb: dwc3: qcom: Configure wakeup interrupts during suspend")
Cc: stable@vger.kernel.org	# 3.18: a872ab303d5d: "usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup"
Cc: Sandeep Maheswaram <quic_c_sanm@quicinc.com>
Cc: Krishna Kurapati <quic_kriskura@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Message-ID: <20230607100540.31045-2-johan+linaro@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index ec8c43231746e..3973f6c18857e 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -306,7 +306,16 @@ static void dwc3_qcom_interconnect_exit(struct dwc3_qcom *qcom)
 /* Only usable in contexts where the role can not change. */
 static bool dwc3_qcom_is_host(struct dwc3_qcom *qcom)
 {
-	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
+	struct dwc3 *dwc;
+
+	/*
+	 * FIXME: Fix this layering violation.
+	 */
+	dwc = platform_get_drvdata(qcom->dwc3);
+
+	/* Core driver may not have probed yet. */
+	if (!dwc)
+		return false;
 
 	return dwc->xhci;
 }
-- 
2.40.1




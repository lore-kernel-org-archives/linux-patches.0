Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9AC524C2;
	Thu, 30 Nov 2023 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nlzj+agz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19826C433C8;
	Thu, 30 Nov 2023 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361682;
	bh=tvY0xLDs+Vv1qWkx082jhy5BaqYDtd/z09r4fsregMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nlzj+agzEZWrxn6p7rN1zZJo716lYej9w2E3zbHTHa634e0TmToaFQ4mGKYl7pO7J
	 KXRFJ9zx5I6y3PbXYlUK+NtsqmHDgX0ZRPlmTCRmLGgQ0iRl656BRd88McOjoAHCD0
	 BsiNUUS+tVwLuWCMsaRUvFIp/CfOkOtvcjEIWRfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.6 111/112] USB: dwc3: qcom: fix software node leak on probe errors
Date: Thu, 30 Nov 2023 16:22:38 +0000
Message-ID: <20231130162143.803518544@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

commit 9feefbf57d92e8ee293dad67585d351c7d0b6e37 upstream.

Make sure to remove the software node also on (ACPI) probe errors to
avoid leaking the underlying resources.

Note that the software node is only used for ACPI probe so the driver
unbind tear down is updated to match probe.

Fixes: 8dc6e6dd1bee ("usb: dwc3: qcom: Constify the software node")
Cc: stable@vger.kernel.org      # 5.12
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20231117173650.21161-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -949,10 +949,12 @@ static int dwc3_qcom_probe(struct platfo
 interconnect_exit:
 	dwc3_qcom_interconnect_exit(qcom);
 depopulate:
-	if (np)
+	if (np) {
 		of_platform_depopulate(&pdev->dev);
-	else
+	} else {
+		device_remove_software_node(&qcom->dwc3->dev);
 		platform_device_del(qcom->dwc3);
+	}
 	platform_device_put(qcom->dwc3);
 free_urs:
 	if (qcom->urs_usb)
@@ -975,11 +977,12 @@ static void dwc3_qcom_remove(struct plat
 	struct device *dev = &pdev->dev;
 	int i;
 
-	device_remove_software_node(&qcom->dwc3->dev);
-	if (np)
+	if (np) {
 		of_platform_depopulate(&pdev->dev);
-	else
+	} else {
+		device_remove_software_node(&qcom->dwc3->dev);
 		platform_device_del(qcom->dwc3);
+	}
 	platform_device_put(qcom->dwc3);
 
 	if (qcom->urs_usb)



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC6651002;
	Thu, 30 Nov 2023 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruEPW7SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B18C433C8;
	Thu, 30 Nov 2023 16:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361892;
	bh=6mN9YeLRIDcqmn58HpIMexWIF7GaTuo2/h8vb95M7P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruEPW7SRnla5SxR7Oh7wYf4KUSY2DXYSW4Z6nhHbfZ/R71fpisFZ3V6mAS0G86XL5
	 tz/xILmG8pWjf+N5s+vl0vQjSfXd6fMuyiAVwF55xXWkt7GKGEmRPK0oJ/ussNCk89
	 m3ezbcF++tszSjkUhMi+e10or7WGvG6upF8xchWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.1 80/82] USB: dwc3: qcom: fix software node leak on probe errors
Date: Thu, 30 Nov 2023 16:22:51 +0000
Message-ID: <20231130162138.533084132@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -951,10 +951,12 @@ static int dwc3_qcom_probe(struct platfo
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
@@ -977,11 +979,12 @@ static int dwc3_qcom_remove(struct platf
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



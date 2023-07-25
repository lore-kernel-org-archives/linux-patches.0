Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678AE1ED3A
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA23C433C9;
	Tue, 25 Jul 2023 11:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284129;
	bh=i9kUr/w0TkSEPnMpgwaKWoZA7Dz2vgcwMyhdFcNYmiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pgm9b/15UF9AR1TyYSByqOmBM5N9OAFQRJiYpRTx2T011TT2DR196W/Q8SMFdcBVC
	 rqIlyNvODHodaVddVzpiCDI+D2mJLUEu/CxW9faa4xW3dW7WmzXxt2/B/3hv+rOAoU
	 gUE5Ou0qVNoryLlM1yNUCPEfIHDy9ViGWxGGmW68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andrew Halaney <ahalaney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/509] usb: dwc3: qcom: Fix an error handling path in dwc3_qcom_probe()
Date: Tue, 25 Jul 2023 12:43:03 +0200
Message-ID: <20230725104604.928084613@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4a944da707123686d372ec01ea60056902fadf35 ]

If dwc3_qcom_create_urs_usb_platdev() fails, some resources still need to
be released, as already done in the other error handling path of the
probe.

Fixes: c25c210f590e ("usb: dwc3: qcom: add URS Host support for sdm845 ACPI boot")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Message-ID: <b69fa8dd68d816e7d24c88d3eda776ceb28c5dc5.1685890571.git.christophe.jaillet@wanadoo.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -786,9 +786,10 @@ static int dwc3_qcom_probe(struct platfo
 			if (IS_ERR_OR_NULL(qcom->urs_usb)) {
 				dev_err(dev, "failed to create URS USB platdev\n");
 				if (!qcom->urs_usb)
-					return -ENODEV;
+					ret = -ENODEV;
 				else
-					return PTR_ERR(qcom->urs_usb);
+					ret = PTR_ERR(qcom->urs_usb);
+				goto clk_disable;
 			}
 		}
 	}



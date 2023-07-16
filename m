Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B688F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32314C433C7;
	Sun, 16 Jul 2023 20:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540708;
	bh=rdJAI9EbsBAXhn0C9LVplba24PBsH/+/m+vs0Edv/XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L03MNc4TnAOcsbyFbcLCdUitO4NiG7bsjM62SimxB9wF6/AatEpXc2NtzmNJyrR5h
	 ST1H4BJrPn3XeRZhLGlPL6djehGCMk0rRlSSXM9U9o5wvBSnNg+l6fSLiI2fvKWvi3
	 oBGMzPfiuRmO4rBuDbUikb1Yh2iDUZ15XWE/0ue0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andrew Halaney <ahalaney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/591] usb: dwc3: qcom: Fix an error handling path in dwc3_qcom_probe()
Date: Sun, 16 Jul 2023 21:49:32 +0200
Message-ID: <20230716194935.116810765@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
 drivers/usb/dwc3/dwc3-qcom.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 9c01e963ae467..72c22851d7eef 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -865,9 +865,10 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
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
-- 
2.39.2




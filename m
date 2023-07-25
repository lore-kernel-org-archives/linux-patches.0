Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AC31ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B6CC433C7;
	Tue, 25 Jul 2023 11:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284082;
	bh=WKNu9Y88XnbLL+iQ/ppEwtB1NNWzf2Yd84/AoouYMK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISGKBtdV4xnTb33WeEg5sP++PTxJJ3Fq99v9BLPbzXkVp2BA9fWXahYvUPiGCZmVE
	 N6yduM6UY+VLC8Gfz9z6Pt7EaFV/M3O22CcroZjN6K1mNByAtQbXXhH+fUdAtuiblM
	 d9tjY0s2KNUXWMP55PBU7QNWU9gk1zV9PKzqMrKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladislav Efanov <VEfanov@ispras.ru>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/509] usb: dwc3: qcom: Fix potential memory leak
Date: Tue, 25 Jul 2023 12:42:48 +0200
Message-ID: <20230725104604.248595608@linuxfoundation.org>
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

From: Vladislav Efanov <VEfanov@ispras.ru>

[ Upstream commit 097fb3ee710d4de83b8d4f5589e8ee13e0f0541e ]

Function dwc3_qcom_probe() allocates memory for resource structure
which is pointed by parent_res pointer. This memory is not
freed. This leads to memory leak. Use stack memory to prevent
memory leak.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2bc02355f8ba ("usb: dwc3: qcom: Add support for booting with ACPI")
Signed-off-by: Vladislav Efanov <VEfanov@ispras.ru>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20230517172518.442591-1-VEfanov@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index dac13fe978110..5c66efb05d7f7 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -722,6 +722,7 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 	struct device		*dev = &pdev->dev;
 	struct dwc3_qcom	*qcom;
 	struct resource		*res, *parent_res = NULL;
+	struct resource		local_res;
 	int			ret, i;
 	bool			ignore_pipe_clk;
 
@@ -772,9 +773,8 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 	if (np) {
 		parent_res = res;
 	} else {
-		parent_res = kmemdup(res, sizeof(struct resource), GFP_KERNEL);
-		if (!parent_res)
-			return -ENOMEM;
+		memcpy(&local_res, res, sizeof(struct resource));
+		parent_res = &local_res;
 
 		parent_res->start = res->start +
 			qcom->acpi_pdata->qscratch_base_offset;
-- 
2.39.2




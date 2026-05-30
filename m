Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B701B87C0;
	Sat, 30 May 2026 18:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166560; cv=none; b=l7Gba5MVd41jhv8e/1Az3SB6PukJ8ht7vAcsA17tYHNu8lJ5JncEdS9bYBdAOvte5bZiIODPPnliypEBCwXNoxKEI7GJyL6sUO9jouJchd9yv4furaTf4QdvD2vhUki61HMq3CTNPQEOD9zAAAHFJDNm45Wlxk08Yga/lTPwCio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166560; c=relaxed/simple;
	bh=gklWDrHcnUIm2T0yUoraVhZ6N4uo3BCRUN9RRzCnoac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kijYnMxd8lDfFit/OcOCUXovaSB85+NC1sF0CbvZg7uW4jVv4+u5vu7Me8sPK3pafaUK72xH0bv2sQEHxWCqNbcpRzST7aDZ2DlYOFk9lPHXxfpeDi7/dKwqxL1LZYRuWMcYoAIR54AmsO4bAvIOL0/iVN31IJP5pf4uYtLFAiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1m+nI5P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1m+nI5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903171F00893;
	Sat, 30 May 2026 18:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166559;
	bh=6d7DqKc+iep44ljDBZ/zN0XvlS9mjnPSWdsvjGp4Qec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1m+nI5Py2Xcp6cznpKt75jmlI2KzGP2H1RZwSmm5ET+g3Vt+GpCkMxa6ltnveHif
	 QJzs53RY4loLsIH97eIuthDppTi01m7QvQcVh0efnvjNUpCSRRbMkXY66sa05Npxa1
	 XYeSw11neBaL8TBPTuwD7IrcgSuYknqY7w1Qp3Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/589] soc: qcom: ocmem: return -EPROBE_DEFER is ocmem is not available
Date: Sat, 30 May 2026 18:04:04 +0200
Message-ID: <20260530160234.380167678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 91b59009c7d48b58dbc50fecb27f2ad20749a05a ]

If OCMEM is declared in DT, it is expected that it is present and
handled by the driver. The GPU driver will ignore -ENODEV error, which
typically means that OCMEM isn't defined in DT. Let ocmem return
-EPROBE_DEFER if it supposed to be used, but it is not probed (yet).

Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260323-ocmem-v1-3-ad9bcae44763@oss.qualcomm.com
[bjorn: s/ERR_PTR(dev_err_probe)/dev_err_ptr_probe/
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index bfebdcaf88146..620f171bf0658 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -212,10 +212,9 @@ struct ocmem *of_get_ocmem(struct device *dev)
 
 	ocmem = platform_get_drvdata(pdev);
 	put_device(&pdev->dev);
-	if (!ocmem) {
-		dev_err(dev, "Cannot get ocmem\n");
-		return ERR_PTR(-ENODEV);
-	}
+	if (!ocmem)
+		return dev_err_ptr_probe(dev, -EPROBE_DEFER, "Cannot get ocmem\n");
+
 	return ocmem;
 }
 EXPORT_SYMBOL(of_get_ocmem);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94E328DC4;
	Wed, 20 May 2026 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298392; cv=none; b=FsN440yfnzLaBkhmAPktc4XTUg8Z9Opj52KAr7HgKmgXp0bWAuo6w9HDbH+m7ibv48c7Nb0ybhf5B4fyzRGnWh3xUDPdBWgD36bHS2Rx+3AAKjcFqu7LvsEKdLGZuDhMPoWwHX2dYndvMWwQYZrDW8JBvMMFTPMeoyb4B2z/Y1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298392; c=relaxed/simple;
	bh=T6/C3ogyVJNMoy/ME4xSDBYIo2mU1mZ7EnMYOgeon18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4aWcpVxXJKyfCsy9HLGOBSBBbQSWm+tNaHoDlcYOdG67zeDP1gv11yJxnsIe9B8/vjBuwM9wR+3DkmCnSFXb97B7Ne1CaAuNgnBVoHo/wcJC6eIkxE09sBlSum9mlxZADMWJHWO8vzAo6mB/2Jp9fG2BMk3MNry3kfIPjKo6R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ukQsJop; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ukQsJop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597B11F000E9;
	Wed, 20 May 2026 17:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298391;
	bh=yR3aSvRgvKB+npaI3SHQ+vy1Dhwy2WZohwom9pSfMSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ukQsJopH6rgSYBTK+sbJM+td8Opdli9PKYLhbh7V+xFNaH3DGgrus2RDbXYEFUQ+
	 p7BZ/3E88Sb84ZcDnVcYfKDutS4XFCzv6/7iuJDKYNUnRouSdLVEqrFPDciVbfUFgc
	 aHQ3tzOi6BHS9shn9Gdp+quuGjNBh4ePRXWjx5rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/957] soc: qcom: ocmem: return -EPROBE_DEFER is ocmem is not available
Date: Wed, 20 May 2026 18:14:34 +0200
Message-ID: <20260520162143.007915315@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ed77fdc76c9b2..37ea6b86aebcb 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -203,10 +203,9 @@ struct ocmem *of_get_ocmem(struct device *dev)
 
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
 EXPORT_SYMBOL_GPL(of_get_ocmem);
-- 
2.53.0




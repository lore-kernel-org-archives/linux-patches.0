Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D8D134AC;
	Mon, 12 Aug 2024 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479973; cv=none; b=aJ2m2N2Es8qpe4Q3hSvLwIzREnS+8CxCdZEuWQys0nxNtkNWknXUG3owYlA6fVbiH+8yye7neCLKxTQUeI1MU7ddn4Ipc3UBWOgg+PG13mSlet3RnPFo7GfDIp5AdRbTLRsNE5BVGOxkvEB68QrOEaCzz+ALzYms6tHv7RPnCn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479973; c=relaxed/simple;
	bh=tDt8qdHMK2uml5/wEqVwCgqjV4K7rILetWu3dTa8ZjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXd8/VDxN8V6siR/+Pqye1mXNWr4xsMgtwYdEwOHqdLSr3VYgBUz5EUx+wEofx0ygdnLYlqKEFBUDA9HPRRZVPbE7i+QLBqMd3Prs28Twc0hDJcswObydwhBX1YG5ZGEleOV9h+1ItRZ+dDgVeD/N9zYOvLXA4xQz2Aq0o6h7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLoYlREh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLoYlREh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D08C32782;
	Mon, 12 Aug 2024 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479973;
	bh=tDt8qdHMK2uml5/wEqVwCgqjV4K7rILetWu3dTa8ZjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLoYlREhFumeXvPREJoKls47RZcRfyh46E0/IpTtqJxF/aEPZqXJx3FUD3xS1XFPM
	 UGA8xH4GsRymFFukse7oKAx7FsT2SzGy2DDnVYfkUr/SLmnePKImqCJC6uBIIaFffn
	 k4ZLNm56vuoIy4Dn+bUwXsx1pb9lLk/by9now1PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 058/263] soc: qcom: icc-bwmon: Allow for interrupts to be shared across instances
Date: Mon, 12 Aug 2024 18:00:59 +0200
Message-ID: <20240812160148.764925572@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit dc18836435e7f8dda019db2c618c69194933157f ]

The multiple BWMONv4 instances available on the X1E80100 SoC use the
same interrupt number. Mark them are shared to allow for re-use across
instances.

Using IRQF_SHARED coupled with devm_request_threaded_irq implies that
the irq can still trigger during/after bwmon_remove due to other active
bwmon instances. Handle this race by relying on bwmon_disable to disable
the interrupt and coupled with explicit request/free irqs.

Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240624092214.146935-4-quic_sibis@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/icc-bwmon.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/icc-bwmon.c b/drivers/soc/qcom/icc-bwmon.c
index ecddb60bd6650..e7851974084b6 100644
--- a/drivers/soc/qcom/icc-bwmon.c
+++ b/drivers/soc/qcom/icc-bwmon.c
@@ -783,9 +783,14 @@ static int bwmon_probe(struct platform_device *pdev)
 	bwmon->dev = dev;
 
 	bwmon_disable(bwmon);
-	ret = devm_request_threaded_irq(dev, bwmon->irq, bwmon_intr,
-					bwmon_intr_thread,
-					IRQF_ONESHOT, dev_name(dev), bwmon);
+
+	/*
+	 * SoCs with multiple cpu-bwmon instances can end up using a shared interrupt
+	 * line. Using the devm_ variant might result in the IRQ handler being executed
+	 * after bwmon_disable in bwmon_remove()
+	 */
+	ret = request_threaded_irq(bwmon->irq, bwmon_intr, bwmon_intr_thread,
+				   IRQF_ONESHOT | IRQF_SHARED, dev_name(dev), bwmon);
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to request IRQ\n");
 
@@ -800,6 +805,7 @@ static void bwmon_remove(struct platform_device *pdev)
 	struct icc_bwmon *bwmon = platform_get_drvdata(pdev);
 
 	bwmon_disable(bwmon);
+	free_irq(bwmon->irq, bwmon);
 }
 
 static const struct icc_bwmon_data msm8998_bwmon_data = {
-- 
2.43.0




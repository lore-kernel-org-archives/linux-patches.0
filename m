Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DFE4E36E9;
	Wed, 30 Sep 2026 16:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784263; cv=none; b=pHsnzUmSa6+2ISgb0kZWRsrfR6ywgJwQSPplIw+4tSk27+DAO4eHe8gFnGGEa64A1dtpk1jG0lUbUQg4KeLDKcQbS4y3roO+yLLlAbLQOCKAWYe+bxTCIFKFeCeQEcpK3bbY2ETaXn6ymcS3QP2tp9F/M0D59G/FFLH8nM/5tcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784263; c=relaxed/simple;
	bh=Hqz57n7o69tAFQBZZt0vhX2rVKa9jAOQM5qB7qfLxOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERfAvVBXG4aXZEfhkDrER04blN2vVZQQ/Yg1THrZh8syz0WhuYSpAc3CM0hLpuu+ePT4Y3fcubK525NBD/Se2Pp0LhWfl0sywuL3jVHUERd0jhhGOT1xMeyLKT1QXeUhbjKFhzmvlCh39udvw8/Wnp8fmF/YndNV83Wk1jtz+a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNB2eEHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNB2eEHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B391F00899;
	Wed, 30 Sep 2026 16:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784261;
	bh=nXSSXO0l9Kf14f9Z6L18a5egV86Z1rY108T9DOK56KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNB2eEHr03QXE/J8Pk8tAhq3puDWZIp+nlb76lKPhsigbRgnWN/QAa9+zoXo6Cj2r
	 gh9FmVex+hQZ6sznbbu83koACOPVTwAzmyRSwFG9OA8kUSR8RXGqCo8vwIcjvgacug
	 mGjVwt36Ma+Ka6Y+c5prt0J69eN6XzcE2gqVBNJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/982] iio: adc: qcom-spmi-iadc: balance enable_irq_wake() on driver unbind
Date: Wed, 30 Sep 2026 17:13:49 +0200
Message-ID: <20260930152418.809605198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 929fec2964f71d4b1ac664ee963d8226c5cf01c6 ]

iadc_probe() calls enable_irq_wake() after a successful
devm_request_irq(), but the driver has no remove callback or
matching disable_irq_wake(), so the wake reference count on the
IRQ is leaked on module unload or driver unbind.

Check the IRQ request error first, then register a devm action
that calls disable_irq_wake() so the wake reference is released
in the same scope as the enable. While here, drop the inverted
"if (!ret) ... else return ret" in favour of the standard
"if (ret) return ret;" pattern.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/qcom-spmi-iadc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/qcom-spmi-iadc.c b/drivers/iio/adc/qcom-spmi-iadc.c
index acbda6636dc58..c57c50aeeffd7 100644
--- a/drivers/iio/adc/qcom-spmi-iadc.c
+++ b/drivers/iio/adc/qcom-spmi-iadc.c
@@ -482,6 +482,11 @@ static const struct iio_chan_spec iadc_channels[] = {
 	},
 };
 
+static void iadc_disable_irq_wake(void *data)
+{
+	disable_irq_wake((unsigned long)data);
+}
+
 static int iadc_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
@@ -539,9 +544,16 @@ static int iadc_probe(struct platform_device *pdev)
 	if (!iadc->poll_eoc) {
 		ret = devm_request_irq(dev, irq_eoc, iadc_isr, 0,
 					"spmi-iadc", iadc);
-		if (!ret)
-			enable_irq_wake(irq_eoc);
-		else
+		if (ret)
+			return ret;
+
+		ret = enable_irq_wake(irq_eoc);
+		if (ret)
+			return ret;
+
+		ret = devm_add_action_or_reset(dev, iadc_disable_irq_wake,
+					       (void *)(unsigned long)irq_eoc);
+		if (ret)
 			return ret;
 	} else {
 		device_init_wakeup(iadc->dev, 1);
-- 
2.53.0




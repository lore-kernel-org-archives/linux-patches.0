Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CC321D3DD;
	Mon, 23 Jun 2025 21:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714743; cv=none; b=Km9WTdQKpSkHzI44wpGkxvfPeOr4KlvsM7kaqQUygqOPUX3n+Befkt4hmxZfoGTqvvW93JWVqbX/uENeh94UZOeN+q4NiZPheBq6H364Ts3CAoMsTCOjnRwWimfW6AwhI/mtFtbcoE0TF6IAVfxrb/Sp8ib/tK798KGqVAtPQFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714743; c=relaxed/simple;
	bh=zBuEFA9h5RPk3YWsTyQgUYRrKG8mzdqtlQlZJcEAj4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIBux5NK5G4Bhcsmnan0bch3bFhWWViW8JtbZJUJOvDslUi+sV8CbRZ5wv7bJ+PN8ddmcQ8Q/JsGgeFgSdk0Oyfid+jksbdOuH2o1IaKak749aSJLJmgffqwXL9kvyDV+ZnrHm32a3VNTwdxccpY00N/pGDRueij6h5EaETFKNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQZkCFIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQZkCFIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8AAC4CEEA;
	Mon, 23 Jun 2025 21:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714743;
	bh=zBuEFA9h5RPk3YWsTyQgUYRrKG8mzdqtlQlZJcEAj4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQZkCFIwz0ctSm0A8BF+3fdeO/S4CojmhO3H9l1yxM8m0KITmeA7rC7rpfcZJwFv7
	 R/R6pRst6HyApVL6DavrNqIP7STtzFaz6AMC6vicRZVKOmgI+TM2USbdhrgH7dkb/B
	 +wNIqsbwKNIrS1NCCVxLzren5EiEYNTe2Wa4ONks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/355] drm/msm/hdmi: add runtime PM calls to DDC transfer function
Date: Mon, 23 Jun 2025 15:07:07 +0200
Message-ID: <20250623130633.538749440@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 531b4e2c206e5f7dead04d9da84dfa693ac57481 ]

We must be sure that the HDMI controller is powered on, while performing
the DDC transfer. Add corresponding runtime PM calls to
msm_hdmi_i2c_xfer().

Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/651727/
Link: https://lore.kernel.org/r/20250505-fd-hdmi-hpd-v5-8-48541f76318c@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_i2c.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_i2c.c b/drivers/gpu/drm/msm/hdmi/hdmi_i2c.c
index de182c0048434..9c78c6c528bea 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_i2c.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_i2c.c
@@ -107,11 +107,15 @@ static int msm_hdmi_i2c_xfer(struct i2c_adapter *i2c,
 	if (num == 0)
 		return num;
 
+	ret = pm_runtime_resume_and_get(&hdmi->pdev->dev);
+	if (ret)
+		return ret;
+
 	init_ddc(hdmi_i2c);
 
 	ret = ddc_clear_irq(hdmi_i2c);
 	if (ret)
-		return ret;
+		goto fail;
 
 	for (i = 0; i < num; i++) {
 		struct i2c_msg *p = &msgs[i];
@@ -169,7 +173,7 @@ static int msm_hdmi_i2c_xfer(struct i2c_adapter *i2c,
 				hdmi_read(hdmi, REG_HDMI_DDC_SW_STATUS),
 				hdmi_read(hdmi, REG_HDMI_DDC_HW_STATUS),
 				hdmi_read(hdmi, REG_HDMI_DDC_INT_CTRL));
-		return ret;
+		goto fail;
 	}
 
 	ddc_status = hdmi_read(hdmi, REG_HDMI_DDC_SW_STATUS);
@@ -202,7 +206,13 @@ static int msm_hdmi_i2c_xfer(struct i2c_adapter *i2c,
 		}
 	}
 
+	pm_runtime_put(&hdmi->pdev->dev);
+
 	return i;
+
+fail:
+	pm_runtime_put(&hdmi->pdev->dev);
+	return ret;
 }
 
 static u32 msm_hdmi_i2c_func(struct i2c_adapter *adapter)
-- 
2.39.5




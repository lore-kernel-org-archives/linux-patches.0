Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC8457982C;
	Wed,  9 Sep 2026 14:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962681; cv=none; b=MBC+SfhCtX8Kk3G+/5Gkp4sy5U66+amOTHPxDAICmLknR2aByteX61VEVY5FPwyTkvgKVhuPhoQ+7bNXxmK0txhF2BwbRIaSGX3lF4ppZ9p/v4M6LMuR1OBNl2OyKxeWf7h/OxoBpm8fJ8zm4Q1eQz0h+MafYjAQOkusVKZDRzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962681; c=relaxed/simple;
	bh=3/ks60NE7AdUBd7+a4eYdcgufzLhnE4sWk+vwR5aH8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toFp5zC5XSd2ae/gQj/409BEJc3NaeJ7lPfn+Hl11jzZpsJtOoQLiQXbt82NZzmz6CHv4mEZEV22iWrhM/oztXc86WUw1IAVsALVZMtHJ1dTxMPiwDjhr/DF0ZpKT/Prr2x9HUfOSJDClMFR1RWtXjipeJCrPVr16HOuR3dextY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfusISdP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfusISdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B501F00A3F;
	Wed,  9 Sep 2026 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962679;
	bh=/fIox7tAtpH1WO8u32aQ3/kKy74WSHmThWv5n9EcyHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfusISdPFCULamP3lohnDi36Qx9A7ElH5d0A4FMRLteDDo/u/WhZVnQz5R0yTF7JP
	 8C7fboPrqNwqGGAM1y6OTIRlaGVVfWXLJsGqmCqh5RlKTKgBWsJL07GHx4OTEkO9Cg
	 ++qXqEFqYiyRIJjnyVRQYL/Oi6Pa6RS561ILETQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 7.2 373/556] media: iris: Enumerate cap->bus_info to differentiate between encoder and decoder
Date: Wed,  9 Sep 2026 15:40:53 +0200
Message-ID: <20260909134243.814763519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 94ef75095d5e76df848a2e5508d71a4532a6ce23 upstream.

commit 66c744e28b69 ("media: venus: assign unique bus_info strings for
encoder and decoder") introduced the naming convention
plat:node-addr:video-codec{enc|dec}. Right now Iris does not replicate this
naming convention.

When we do v4l2-ctrl --list -devices we see:
Iris Decoder (platform:aa00000.video-codec):
	/dev/video0
	/dev/video1

Enumerate the bus_info field of the capabilities structure for namespace
parity and appropriate differentiation:
Iris Decoder (plat:aa00000.video-codec:dec):
	/dev/video0

Iris Encoder (plat:aa00000.video-codec:enc):
	/dev/video1

Fixes: 5ad964ad5656 ("media: iris: Initialize and deinitialize encoder instance structure")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vidc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -449,14 +449,21 @@ static int iris_enum_frameintervals(stru
 
 static int iris_querycap(struct file *filp, void *fh, struct v4l2_capability *cap)
 {
+	struct iris_core *core = video_drvdata(filp);
 	struct iris_inst *inst = iris_get_inst(filp);
+	char *info;
 
 	strscpy(cap->driver, IRIS_DRV_NAME, sizeof(cap->driver));
 
-	if (inst->domain == DECODER)
+	if (inst->domain == DECODER) {
 		strscpy(cap->card, "Iris Decoder", sizeof(cap->card));
-	else
+		info = "dec";
+	} else {
 		strscpy(cap->card, "Iris Encoder", sizeof(cap->card));
+		info = "enc";
+	}
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+		 "plat:%s:%s", dev_name(core->dev), info);
 
 	return 0;
 }



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F13577E32;
	Wed,  9 Sep 2026 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964069; cv=none; b=hkxZP2gxd8QrGrK/mrw9YYlgtlBVzXITqD6vRClig4QkctiE5VI0U+g6dnG5IlqGcPTuPudHqaUDWB3m8KOlXCOEAIiM5ol1YThI/Vry6RX9so3kKt3OIm2yKF2fuci/dTnZlvAno48XnCQ2VopKv4naLT8vr3sDNkw02u/OBYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964069; c=relaxed/simple;
	bh=3doeVSLT/qW/j9oBvraAjEzgFxKTQvmVTW8PboXyAIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gduc5jn/DG41p4h7CudHHVlLIRLAelgWzNTheGJYcgfkfgsiwqJaugqbZEh+t/jZQO6TBUGXX5MQeBvvOKFCAdzK0qh4vbdHQt3S7jps/CV95MiYHUuCEZcIwrSit8/fy/uyiSTIwGdPdYgH1DRhWtTwprSxBZAt/kKs/J1BybI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIxyn3PK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIxyn3PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC5A1F00A3A;
	Wed,  9 Sep 2026 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964067;
	bh=Tpk077mXaDh6nKbfLkdgsNvtpRYud7l5ahDvS/iA76w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIxyn3PKLIrDLn6W0d9W46jTw7GvyZXWLh0zIHczGz1AmkNg7LdhxC4hA1nrmFqgC
	 9HnSvITonyhZX9Q3TCjEQeIL3EHT3PDcYLfInk2gQ40ABFvd3CaXvln/HH5KyXqgRl
	 8GnSHf468whT3pWEd23hZo2nvNFDRRwHfqgqXjpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.18 295/583] media: iris: Enumerate cap->bus_info to differentiate between encoder and decoder
Date: Wed,  9 Sep 2026 15:39:40 +0200
Message-ID: <20260909134248.251761612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -450,14 +450,21 @@ static int iris_enum_frameintervals(stru
 
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



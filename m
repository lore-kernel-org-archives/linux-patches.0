Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0852A22969B;
	Thu, 12 Dec 2024 16:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022065; cv=none; b=O92mu5QHGCjBG7rtGEgp0Ygsx+02pMprLXiUFqXRcyuymfwkW/YWbmyh79UlSd3mFKxyZi3jpEbdYTZ9RRbeXzgyH7iOSH8rZy/qLqfxFZPU8KMI6a8GxDvl2jqgyuNBPnHxQ/Ms4XwNHSnb/pNoNwwAK5dIvQf0lOxvOTpT658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022065; c=relaxed/simple;
	bh=n65otuL08phRPcqScI7XVO53vN6TK02IoreN1T+I210=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aziWq8za82P1xNQ8kgXBP7+bA7m01U6YqiMCMrajK1P78dv63Zc4NIP1C7kW2fMGQrEltsBiBiJmHbWij0Z4OP1DyzKtJcr6bRwfhl/uJ/GhXyW7xkschyvBFNYxfW1pm0xMpuHJ19Hgzvk1FVWF7Z6XoH6SJsFbMI7dzG0FYEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKRhW6BV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKRhW6BV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD14C4CED3;
	Thu, 12 Dec 2024 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022064;
	bh=n65otuL08phRPcqScI7XVO53vN6TK02IoreN1T+I210=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKRhW6BVvd3iJZVpqAk8d4cAmVHOfFNNXaNBXJzWjnQuV+4VKdwl24SPJ612uAh0l
	 MixAlRzhj/K/OzN0yig1PJDDxzH26R436yAeOuppWSxbghuJBQJqEQlzZm1VspNKkw
	 gkaoncYL4VSZxBQkvTprQ0iKLBHFdyYRsUNvPpyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viswanath Boma <quic_vboma@quicinc.com>,
	Vikash Garodia <vgarodia@qti.qualcomm.com>,
	Dikshita Agarwal <dikshita@codeaurora.org>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/565] media: venus : Addition of EOS Event support for Encoder
Date: Thu, 12 Dec 2024 15:55:33 +0100
Message-ID: <20241212144316.935152168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viswanath Boma <quic_vboma@quicinc.com>

[ Upstream commit 70b2a5463dcdc18cd94d41f6dc170aa29cfcb922 ]

V4l2 encoder compliance expecting End of stream Event registration
support for Encoder.

Signed-off-by: Viswanath Boma <quic_vboma@quicinc.com>
Signed-off-by: Vikash Garodia <vgarodia@qti.qualcomm.com>
Signed-off-by: Dikshita Agarwal <dikshita@codeaurora.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 6c9934c5a00a ("media: venus: fix enc/dec destruction order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/venc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 8720606cdd95a..2c23d83273a85 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -509,6 +509,19 @@ static int venc_enum_frameintervals(struct file *file, void *fh,
 	return 0;
 }
 
+static int venc_subscribe_event(struct v4l2_fh *fh,
+				const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_EOS:
+		return v4l2_event_subscribe(fh, sub, 2, NULL);
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct v4l2_ioctl_ops venc_ioctl_ops = {
 	.vidioc_querycap = venc_querycap,
 	.vidioc_enum_fmt_vid_cap = venc_enum_fmt,
@@ -534,7 +547,7 @@ static const struct v4l2_ioctl_ops venc_ioctl_ops = {
 	.vidioc_g_parm = venc_g_parm,
 	.vidioc_enum_framesizes = venc_enum_framesizes,
 	.vidioc_enum_frameintervals = venc_enum_frameintervals,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = venc_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-- 
2.43.0




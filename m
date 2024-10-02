Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EA21D0420;
	Wed,  2 Oct 2024 13:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877578; cv=none; b=Z28lH0YKISpuXwSmPAmvsOCgaeJI2Hzfd6dja5RcOyi1JVl5/bbOS4SOsJb6FLqBSUjSm3XQjS+ERAoyqrsP6lvuu+ZulwDIKBx3nnSe/hCIdXl3yDuWGsv6W2MRTtt3TRRd1ejgd3t94j/JBZwPMCypnjPmWMoCuZigRvqUGb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877578; c=relaxed/simple;
	bh=KVcNBarLARJgAqVLTeKt55QRiGUj6OV1ihvGyrjoLDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVzxSJvob82f+aHwPusdiZYOonRmnplJ7l51Dg9NPRY5PYJtHUSvpq7GgkoySC/dAgL+PTdKj0zE1XTTgKT55sQisfSdAqeqBH8WQI3kiZ0bl1Fwn8Xho5BGJLirgPWpT32CT8zMBteiyziUHfUlS1JkifpJhdTJat6m0sq0/ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUjVd1QG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUjVd1QG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0200C4CEC2;
	Wed,  2 Oct 2024 13:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877578;
	bh=KVcNBarLARJgAqVLTeKt55QRiGUj6OV1ihvGyrjoLDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUjVd1QGELpaRi86n+DJuTMmU8UBWxM88WIr2lxC3kO0R6a9LXIZRfdDm7AONVCFD
	 hjCFvfDAZ/ZX0wOkL8jGG5RSIdWjS4SSN8zuBrD2R3sxedtn4Iy6EKV6jrRzI0iFFM
	 fmOkrhK2d1zFHO7EoQxpFpp8qJuascAE9vrMwobA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 122/634] firmware: qcom: scm: Disable SDI and write no dump to dump mode
Date: Wed,  2 Oct 2024 14:53:42 +0200
Message-ID: <20241002125815.928262014@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Mukesh Ojha <quic_mojha@quicinc.com>

[ Upstream commit 79cb2cb8d89b7eca87e8dac031dadea4aeafeaa7 ]

SDI is enabled for most of the Qualcomm SoCs and as per commit
ff4aa3bc9825 ("firmware: qcom_scm: disable SDI if required")
it was recommended to disable SDI by mentioning it in device tree
to avoid hang during watchdog or during reboot.

However, for some cases if download mode tcsr register already
configured from boot firmware to collect dumps and if SDI is
disabled via means of mentioning it in device tree we could
still end up with dump collection. Disabling SDI alone is
not completely enough to disable dump mode and we also need to
zero out the bits download bits from tcsr register.

Current commit now, unconditionally call qcom_scm_set_download_mode()
based on download_mode flag, at max if TCSR register is not mentioned
or available for a SoC it will fallback to legacy way of setting
download mode through command which may be no-ops or return error
in case current firmware does not implements QCOM_SCM_INFO_IS_CALL_AVAIL
so, at worst it does nothing if it fails.

It also does to call SDI disable call if dload mode is disabled, which
looks fine to do as intention is to disable dump collection even if
system crashes.

Fixes: ff4aa3bc9825 ("firmware: qcom_scm: disable SDI if required")
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/20240708155332.4056479-1-quic_mojha@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 68f4df7e6c3c7..77dd831febf5b 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1875,14 +1875,12 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	 * will cause the boot stages to enter download mode, unless
 	 * disabled below by a clean shutdown/reboot.
 	 */
-	if (download_mode)
-		qcom_scm_set_download_mode(true);
-
+	qcom_scm_set_download_mode(download_mode);
 
 	/*
 	 * Disable SDI if indicated by DT that it is enabled by default.
 	 */
-	if (of_property_read_bool(pdev->dev.of_node, "qcom,sdi-enabled"))
+	if (of_property_read_bool(pdev->dev.of_node, "qcom,sdi-enabled") || !download_mode)
 		qcom_scm_disable_sdi();
 
 	/*
-- 
2.43.0




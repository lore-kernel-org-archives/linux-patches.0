Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3A41D0433;
	Wed,  2 Oct 2024 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875547; cv=none; b=YEEXfFJBDybHv2OAsUhgfURIRcay1as7Lp+wRZkIVmzvBFyfNxLOnfZtv2s4iHvfKfwc0XGKvuWo+RwjVvbM3kUMC/fd0cGTtvvl2VvgZdYMyGB1kSFIsGnnR0QYeoESlX7usQSA1aW2XSi+JsEiW5akRovHlKA79su4V8fojbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875547; c=relaxed/simple;
	bh=ojqZEsnbaNNh8I7bNcMl6Ls0KOOUrt2MmEZafJgiZBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4IUB5i7nER5edHU/iX3u8RKKT8GJGJgAM0+bMi6Bcf3XZco5js5FbqYyL2JT0Ox5KIH0cV+d/R9HjTTVWfRnEmiJ3bSEasrNrG8xiNFp9dzXyjo1kWzgAuKH2w1IHv3Y0HlvVAtn+sbrvd1oLy/geMz9Ke1rjLU5bZojJbJlGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTmhzW8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTmhzW8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EEEC4CEC5;
	Wed,  2 Oct 2024 13:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875547;
	bh=ojqZEsnbaNNh8I7bNcMl6Ls0KOOUrt2MmEZafJgiZBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTmhzW8P0kTi+zS5E0Ep/fDGUCPDHGYf9J1j5ep+akdoVFbIJMXkh4y6T7rTRlGAT
	 HzaSR/Ccrg3GCAYsjt7qQUBgkQ/w89LiddFz2sa7cOrZuAfcU+iCrp5R0jxAJmSjvi
	 m8xMjBjqMBcs46Sn6JxhgDI/bNX6Q2zcP5G8w7TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 138/695] firmware: qcom: scm: Disable SDI and write no dump to dump mode
Date: Wed,  2 Oct 2024 14:52:16 +0200
Message-ID: <20241002125827.995591032@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 00c379a3ccebe..0f5ac346bda43 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1954,14 +1954,12 @@ static int qcom_scm_probe(struct platform_device *pdev)
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
 
 	ret = of_reserved_mem_device_init(__scm->dev);
-- 
2.43.0




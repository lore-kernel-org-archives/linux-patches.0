Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE97357718;
	Tue, 16 Dec 2025 12:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886572; cv=none; b=GsnUIObwvMpuBnjJ5fXYxrR4nQQBq5/HAPCKMALxIqW5LvcXwk4ANj25j5yrJSknRJykUwY72cuNxn7dR99NodHak7asu7mcVk831Vc0srPDFZdM+nxpgFogZn7E0L+GaP8JQccT+jQEcaxEc4qu9ItFvDvun9yrJoCHl2RwdL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886572; c=relaxed/simple;
	bh=1eiIldV0LSdXIomS/UZPtDi+Wu21jWoLb7MZLbpdUTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkGh5+PE1hZdsQje70veJ5P6Ed65aCw9HRpj0PFbW3j/Ra3MyajT+ZQAZBlQUaSMeNEE0T581IGUPKkZ3YdX5xfBJ9mHw6iM+6pYv+hZwPcZVC1DWsVmOpiMXrT6SHudsg2xNAy2PvL5PHXbbU3hysPI9vO2sCkgQJGBiebYdz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txQsTMi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txQsTMi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0930C4CEF1;
	Tue, 16 Dec 2025 12:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886572;
	bh=1eiIldV0LSdXIomS/UZPtDi+Wu21jWoLb7MZLbpdUTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txQsTMi9FPLD/zCx2ATpUHR0lLWJWfoBHomLxuGMX0m8mqDgMT1oyHFLkJjPloov+
	 wsEtfE1XYHcIs3QNfYOEXWnzmcFQI+pWiB2iEwlsRx1iXcDxHxHrAGGSlAgTuPSQE0
	 VTNVvBGriJ+i6s/W/Gr1JSW4+WbpuKtIIFNnWs70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Link Mauve <kernel@linkmauve.fr>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 476/507] rtc: gamecube: Check the return value of ioremap()
Date: Tue, 16 Dec 2025 12:15:17 +0100
Message-ID: <20251216111402.687711729@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit d1220e47e4bd2be8b84bc158f4dea44f2f88b226 ]

The function ioremap() in gamecube_rtc_read_offset_from_sram() can fail
and return NULL, which is dereferenced without checking, leading to a
NULL pointer dereference.

Add a check for the return value of ioremap() and return -ENOMEM on
failure.

Fixes: 86559400b3ef ("rtc: gamecube: Add a RTC driver for the GameCube, Wii and Wii U")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Link Mauve <kernel@linkmauve.fr>
Link: https://patch.msgid.link/20251126080625.1752-1-vulab@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-gamecube.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/rtc/rtc-gamecube.c b/drivers/rtc/rtc-gamecube.c
index c828bc8e05b9c..045d5d45ab4b0 100644
--- a/drivers/rtc/rtc-gamecube.c
+++ b/drivers/rtc/rtc-gamecube.c
@@ -242,6 +242,10 @@ static int gamecube_rtc_read_offset_from_sram(struct priv *d)
 	}
 
 	hw_srnprot = ioremap(res.start, resource_size(&res));
+	if (!hw_srnprot) {
+		pr_err("failed to ioremap hw_srnprot\n");
+		return -ENOMEM;
+	}
 	old = ioread32be(hw_srnprot);
 
 	/* TODO: figure out why we use this magic constant.  I obtained it by
-- 
2.51.0




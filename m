Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503A451FCD7;
	Wed, 30 Sep 2026 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784826; cv=none; b=Bf/ohrUR4YOZ3Ic3HUvVGQrKwF41NVB/4eXViOQEtfNeTLIESXhN7wY47rpUcDbxCU9rPjueY0ADsSEw3zljb2EtHDUsrGvIc9VR8dWzsNQif6LiZVN2jf/dvnYrZNc7LlP6hJxZmqm9EBxOiaBZ7N8LxIFx4tICbxDJ6xjnN5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784826; c=relaxed/simple;
	bh=hwfKOBg4Ce+EtSGnU+cU1RD1+UoKDcUsC3G9HlM0syM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIuLnq2+NwS+7JqmU7wdWCo6ZJo2V5bMsNMsU1G0kHB05KpL5IeS/A1S83sYnwdn1JZFwu/QSF1VmrUo8/RA/oGgkJEByzrL4vnt5+YAOa56xJbPICgQjKkrI+9lyvlzEqVuMtKxaLjepfiDLyc+p5pgVDmVEtSe4DwetQf/CPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpB+nkr3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpB+nkr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381A01F00893;
	Wed, 30 Sep 2026 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784821;
	bh=W9lIZMAJdkgFo70ZQRHigsIOQxt8cNen5C3eBDed3MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpB+nkr3ILhqWIjOM+MMlThC1ov6cR2t80Zl/BRXFHPNInS1SFBrnpZM0k0IAsoDe
	 EjfQM7PpAmIQMGDCBU3myAZiRjzr26c+jNYp0kC5hjdIss3OUD1OrC/5tH+BFVI7oD
	 fHwstOlmFp+88L/PTF9VJLr8BwQ5IaD8HBw/1aAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 290/982] spi: dw: fix wrong RX_SAMPLE_DLY setting after resume
Date: Wed, 30 Sep 2026 17:17:06 +0200
Message-ID: <20260930152423.035382177@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 133c71b2c0bc976a4751f9e05ef7cdea67f964e5 ]

On platforms which need a non-zero rx sample delay, the RX_SAMPLE_DLY
reg setting is lost after resume. The reason is that the reg may be
reset to 0 after resuming, but dws->cur_rx_sample_dly doesn't know
this fact. Fix this issue by clearing dws->cur_rx_sample_dly in
dw_spi_shutdown_chip().

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Suggested-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260803135925.12622-1-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 62f82024a706e..0366f069d1955 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -282,6 +282,7 @@ static inline void dw_spi_shutdown_chip(struct dw_spi *dws)
 	dw_spi_enable_chip(dws, 0);
 	dw_spi_set_clk(dws, 0);
 	dws->current_freq = 0;
+	dws->cur_rx_sample_dly = 0;
 }
 
 extern void dw_spi_set_cs(struct spi_device *spi, bool enable);
-- 
2.53.0




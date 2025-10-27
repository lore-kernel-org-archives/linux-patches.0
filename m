Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28652BE037;
	Mon, 27 Oct 2025 19:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592663; cv=none; b=kPlhzg1M/P8dMB9BqJIbe86ZSUmU5n6k1WeLeBoXe11SFpiH8gTmbCV1mLhTFxgidn37wp9xE18Vm0uKk16ppivlmvsers1qHPutEruIfhCIvIms6DH/k7OM3kalSl2nJAv9vAhKP1htriPS8DRWKXpY0amtnsfe79HFL/Jb3Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592663; c=relaxed/simple;
	bh=/wkQIwWRHIjnO+qfR781hZq5MqQXkBm2nh4tTrTOjVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSy/cLWz2rbcW515BPfsumH0xGkJpXN6e5vkRqVjuWTMDPTWUIYyYQEj8tOZAMLx/OsyGO63nNYhp3tGnqQajQQIxti1j5QO1KytFYd0OTsf4mLZ0/xCfi3OMq/XdzSHsP9pxldTRzCQY1VgBi829NQEGDPU6qD4bbJhaRi7OyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHYhXdc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHYhXdc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF80C4CEF1;
	Mon, 27 Oct 2025 19:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592663;
	bh=/wkQIwWRHIjnO+qfR781hZq5MqQXkBm2nh4tTrTOjVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHYhXdc8n4ebn4gYR9KhZk4kFteWpTDdTG3MqUayioRmDKNQk/TyOyDC22et+6j90
	 TLKPhMnCcP8E2xQN8DFzq72LJE+WekTh7XDvdYrfuCe7uIMg6gv5pBwWU02vbZvzI1
	 3RLHShjqplU3N9VWk32EA3dWTi3dsMZ74Qh14MEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 49/84] spi: spi-nxp-fspi: add extra delay after dll locked
Date: Mon, 27 Oct 2025 19:36:38 +0100
Message-ID: <20251027183440.126292963@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

[ Upstream commit b93b4269791fdebbac2a9ad26f324dc2abb9e60f ]

Due to the erratum ERR050272, the DLL lock status register STS2
[xREFLOCK, xSLVLOCK] bit may indicate DLL is locked before DLL is
actually locked. Add an extra 4us delay as a workaround.

refer to ERR050272, on Page 20.
https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf

Fixes: 99d822b3adc4 ("spi: spi-nxp-fspi: use DLL calibration when clock rate > 100MHz")
Signed-off-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20250922-fspi-fix-v1-2-ff4315359d31@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index bc6c086ddd43f..731504ec7ef8b 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -665,6 +665,12 @@ static void nxp_fspi_dll_calibration(struct nxp_fspi *f)
 				   0, POLL_TOUT, true);
 	if (ret)
 		dev_warn(f->dev, "DLL lock failed, please fix it!\n");
+
+	/*
+	 * For ERR050272, DLL lock status bit is not accurate,
+	 * wait for 4us more as a workaround.
+	 */
+	udelay(4);
 }
 
 /*
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDC0155335;
	Mon, 16 Sep 2024 12:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488441; cv=none; b=XfV6fHaBUY0e2d8rQxW+DGWuRCHn86z+gDtwPsrpYI9E+sUYgcEob9MWnfoVZ83tqaodVnKTG9uU2DcI6BW8knuh1+m29Bdto8lV53bFAniFoa+jWFywDKc4/TfmcGlAeW5NZkenpJ/Qd7b+myvx8Oa9Joy4GODXJ0C+ZsbDwek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488441; c=relaxed/simple;
	bh=q8oZTD57xpIZDFBDQMmV7inKMX0z9qbzxcKej0BFvHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeizzLP3mH7l+BaT8oKZVPJ14SbXoL4kRMWsPXd25ypXV597s4nrMZK+/jR9j9D6L+JSrS4+JWr/QJYRcKXYKshzX1Kup71ywqfiORGXYGqo33raPyZpNLWRGqZDLZRRvDbv/8MUmYsQAwVWF+4GQk/kRCtd8PcM1pBgwzCHEUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jHoZMCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jHoZMCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2393BC4CEC4;
	Mon, 16 Sep 2024 12:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488441;
	bh=q8oZTD57xpIZDFBDQMmV7inKMX0z9qbzxcKej0BFvHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jHoZMCajTuoUsOhgGEOVhn/CErToshZ3Km4N1m7BHOt2P+CYso4LkJRUv67S96se
	 jJXScsYFlOdQoXTKtB6YZDeCRRUhBvu4yUeIkuxRHLUqYoo0EnzS2kXIedFynGaV/B
	 AxAmXsMMy2rsoSO2mLmp1l5ibrMMzrHQUR/ym6vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 114/121] spi: geni-qcom: Fix incorrect free_irq() sequence
Date: Mon, 16 Sep 2024 13:44:48 +0200
Message-ID: <20240916114232.870839632@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit b787a33864121a565aeb0e88561bf6062a19f99c ]

In spi_geni_remove(), the free_irq() sequence is different from that
on the probe error path. And the IRQ will still remain and it's interrupt
handler may use the dma channel after release dma channel and before free
irq, which is not secure, fix it.

Fixes: b59c122484ec ("spi: spi-geni-qcom: Add support for GPI dma")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patch.msgid.link/20240909073141.951494-3-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index fef522fece1b..6f4057330444 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -1170,9 +1170,9 @@ static void spi_geni_remove(struct platform_device *pdev)
 	/* Unregister _before_ disabling pm_runtime() so we stop transfers */
 	spi_unregister_controller(spi);
 
-	spi_geni_release_dma_chan(mas);
-
 	free_irq(mas->irq, spi);
+
+	spi_geni_release_dma_chan(mas);
 }
 
 static int __maybe_unused spi_geni_runtime_suspend(struct device *dev)
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F881990D7;
	Thu,  5 Sep 2024 09:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529975; cv=none; b=UBrduE006eU6pGhqH5fhHXkrkOKS77VRNbb/e3lEAVte97McLArbsmiI4MyONXumd5TPkUElxbxs4k76KZ8gNqpcfJ+PbXZ1ZINYE5FMI4ALZ3bAaprziI7brqduvIZfyLS9965VChT0M8puKmx0SXYQJImaVNjfntbeY79j6aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529975; c=relaxed/simple;
	bh=15KYb5dJJpQEMD/Y1apW+itIf7EtzkJA0qx/bpf78O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrIm0oWPObJmayXdgkJ6JzJnMUAiJxQuo0ynvHCDSauEk6arg/HDTu8gw9raHWTEH84W9OBgROFheaHBwSAWSw1or92TIVxQfn3UGuUck3xXxNvZ+KJRf6JCL8atPqrXXEHclV0GJaVveSbksv8Xuer4jR9lWU+9u0lrySVojkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRc2pkg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRc2pkg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7055DC4CEC4;
	Thu,  5 Sep 2024 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529974;
	bh=15KYb5dJJpQEMD/Y1apW+itIf7EtzkJA0qx/bpf78O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRc2pkg1RJ0Tpc0nBnmEqNYoHoGPBEZaUDRkjUxbHKM9F1fq8wz7K+b2HmF1onb7y
	 MWkm0ao03Yh39OCAQrH/sxP3lqfzfMD/LyjA5mGHzillTYiAYzQQF7K+mYL0ws6OeH
	 Nm4ajXH1X2+mtUCm79QfLqQP2chZ5W4WwAQY+ebw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@huawei.com>,
	Jay Fang <f.fangjian@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/132] spi: hisi-kunpeng: Add validation for the minimum value of speed_hz
Date: Thu,  5 Sep 2024 11:40:03 +0200
Message-ID: <20240905093722.869290069@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devyn Liu <liudingyuan@huawei.com>

[ Upstream commit c3c4f22b7c814a6ee485ce294065836f8ede30fa ]

The speed specified by the user is used to calculate the clk_div based
on the max_speed_hz in hisi_calc_effective_speed.  A very low speed
value can lead to a clk_div larger than the variable range. Avoid this
by setting the min_speed_hz so that such a small speed value is
rejected.  __spi_validate() in spi.c will return -EINVAL for the
specified speed_hz lower than min_speed_hz.

Signed-off-by: Devyn Liu <liudingyuan@huawei.com>
Reviewed-by: Jay Fang <f.fangjian@huawei.com>
Link: https://patch.msgid.link/20240730032040.3156393-2-liudingyuan@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 77e9738e42f60..6910b4d4c427b 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -495,6 +495,7 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	host->transfer_one = hisi_spi_transfer_one;
 	host->handle_err = hisi_spi_handle_err;
 	host->dev.fwnode = dev->fwnode;
+	host->min_speed_hz = DIV_ROUND_UP(host->max_speed_hz, CLK_DIV_MAX);
 
 	hisi_spi_hw_init(hs);
 
-- 
2.43.0




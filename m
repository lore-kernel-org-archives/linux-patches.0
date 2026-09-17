Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8D33CB54B;
	Thu, 17 Sep 2026 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665139; cv=none; b=fvbkc94L5WLITCvLJZSM5urBVV0820Q5VyRGR7fOuZxjZN/tVAmUw9RJYZiQSQ+EhE8wusewulJh3lWKnZnE8mt324foog+RvjpkgQoUJgSJQDg3hsJhFa+VuQpUChgtQ/+hpsH9LoC2KeltfMz/BT1FV1IAFshS4YN3PI/XbHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665139; c=relaxed/simple;
	bh=3ozns91y/L9upM9qBAF0SesX1U6vKrGBKGnZA5cayro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7+O84LHZJ2BVzbBa2+OxLZDesdnsNt+EM3xU+jT7hHhPB//Fwe8twfmKJ/PnVCx4IaLYwoPTKNp5Uo5+CjIaYwhfwLUhrtvMqqzZwpUbeCurxmtYn4lVcPk7j9BqrsdDo5Zxvkb8pMHNWbBhYhSltL5WlEtkXzLFaVk16b7qiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4vxLNO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4vxLNO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BDB1F000FF;
	Thu, 17 Sep 2026 17:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665138;
	bh=XpJm2hjnVBctTek5XPHCnTrDCsQcXTsWGpwSDmnAzYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4vxLNO1azuhfEnxzU9QPAZpjYtmBSEfUc5RNJhDbRiLbNiwJWaBKorf+1FZSqXp6
	 EhfqpIKhHUMgstoIV3ZQIGQbW0Ghyw/dU+VQN93CgTyLWYKP+j1IawGMZPSC8JTc0W
	 LMTHsKtW4cadinOgzpH8lSHPRWY4fn4WHej7DnX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0562/1250] spi: dw: fix wrong RX_SAMPLE_DLY setting after resume
Date: Thu, 17 Sep 2026 16:05:57 +0100
Message-ID: <20260917151607.159245386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 8a3c085c85e07..81609d2a3da6e 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -283,6 +283,7 @@ static inline void dw_spi_shutdown_chip(struct dw_spi *dws)
 	dw_spi_enable_chip(dws, 0);
 	dw_spi_set_clk(dws, 0);
 	dws->current_freq = 0;
+	dws->cur_rx_sample_dly = 0;
 }
 
 extern void dw_spi_set_cs(struct spi_device *spi, bool enable);
-- 
2.53.0




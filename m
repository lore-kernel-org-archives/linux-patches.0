Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF5635EDBD;
	Tue, 21 Jul 2026 17:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655928; cv=none; b=uBGsjc788GJaqDEH0DXIwCOZ2zIyZL3AUvbV+V+m6IcdepTRcyI6F0/QUbwRYegZPGOpj3HSSkmkHAjosTlRVz6QbH6a2c57ogMp8lE88u6Js5+5VxCnHFHbuCOJBw229uFMaUMTr/3EHVPlXFuHx1otGoEgrMqOqYfrcpWHhXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655928; c=relaxed/simple;
	bh=ThZqh4D2ARxWUO4KtpE+KN2Dq03Q2711ng+9VnTBX0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leqjoL41DqUCel7kvaaXW/LP3KYREzr4CbJm8x4o73GOSXTXJ38S9yRuX0w7q1f4s4xsFy/QAZjGPd5RWh9hMNDzHfnUG5W1ihTlnV3YNeGxx4aKQci5IIPTLD/3WyErPll+AfBb6uIxYp0J85M8FH5yclY8+l48d+oN1KC5xDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEoOT9kU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEoOT9kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA8C1F000E9;
	Tue, 21 Jul 2026 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655927;
	bh=DqrM0iRrYpVh7Fnk1tv3Y1zzOBSY0gwsI63Ijt3ftfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEoOT9kUrWy40B13WYgDRWvjkP8xnVPcw+AfZWwTCyL6fB3QsWb+xgQOfUfHx6ro6
	 FUPdUoVJUVPMKlleVXXerDemSO0BlV98qFBQgnUjyroedUqfHfxM1QRFPj+ouZ7zPz
	 koCd7R1NKHLXsQy/0MF57R3RhKkCzTgVnA8T/1g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0150/1611] spi: hisi-kunpeng: Use dev_err_probe() for host registration failure
Date: Tue, 21 Jul 2026 17:04:26 +0200
Message-ID: <20260721152518.252636198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

[ Upstream commit 59b991990a04b1d1ce95373983b7c8b65bdf7acc ]

When the SPI core registers the Kunpeng controller it may need to acquire
chip-select GPIO descriptors. If the GPIO provider has not probed yet,
spi_register_controller() returns -EPROBE_DEFER.

On a Kunpeng system this currently prints an alarming error even though the
next deferred-probe retry succeeds:

  hisi-kunpeng-spi HISI03E1:00: failed to register spi host, ret=-517
  hisi-kunpeng-spi HISI03E1:00: hw version:0x30 max-freq:12500 kHz

Use dev_err_probe() so that -EPROBE_DEFER is reported through the deferred
probe mechanism instead of as a hard error, while preserving normal error
reporting for real registration failures.

Fixes: c770d8631e18 ("spi: Add HiSilicon SPI Controller Driver for Kunpeng SoCs")

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Link: https://patch.msgid.link/20260515102620.1926930-1-maqianga@uniontech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index a38dcae6271ff3..f004920600ae7e 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -518,10 +518,8 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	}
 
 	ret = spi_register_controller(host);
-	if (ret) {
-		dev_err(dev, "failed to register spi host, ret=%d\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to register spi host\n");
 
 	if (hisi_spi_debugfs_init(hs))
 		dev_info(dev, "failed to create debugfs dir\n");
-- 
2.53.0




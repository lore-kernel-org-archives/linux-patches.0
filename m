Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C71246AA71;
	Tue, 21 Jul 2026 15:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648485; cv=none; b=N2Cdn20OtTc6rWvE+oA0hiR0BpxonbxqkN1/Dx+SFkGW78Jgo8LdZuJ1dhfA1wlV6Qf2VKMYmGUNS9eJYwi4X2Ad2vtdPu7sqBNTu1XmwzXVFVntL74tWJWqzBJdOKc0LPi3zPZX+3KrzAprGNZCc6MFmOQorWZMe5Sbt/9q8B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648485; c=relaxed/simple;
	bh=rOzytU+cPKaCLcleeUs8RdTYacCPaUDi8pn6h4Ot66o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3ke1pGN6dSaEfI4IQBAslXJ/6nTRv+U16k8TJHmF6kzQYG4QSGZVMJ1RJN5zOx11D8AMQPQa3H9i49uWL3uT7OgDN9UyWV3NEwQBlJQJgStdTNUxsxgfBrcbzzaRqzxaXTS6jbddMw69H194K8tGjrL2QuLEP1ixDzCD1IE/eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XsCXSqP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XsCXSqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C521F000E9;
	Tue, 21 Jul 2026 15:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648484;
	bh=OwSnZIdC7fEPnHdHktNcWy38nw2sC5f+4M+j3FJ9eYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XsCXSqPRGyQPqxBKztMOT4VWOF+36CprPxuEujPkkrr6WjS1PQBxoL2LRpFP51Vq
	 JmSLomEpq0QDitx9vI2peiejVBpvcyLRGZ5OJk7NrD6xug+H171KwRSURluwNSnupF
	 HbY9OrJPbaq9wiw+QXTqiV8E3+4oop+wFy1wI/nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0215/2077] spi: hisi-kunpeng: Use dev_err_probe() for host registration failure
Date: Tue, 21 Jul 2026 16:58:08 +0200
Message-ID: <20260721152557.753277021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 046bd894040b10..395214b81179ec 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -520,10 +520,8 @@ static int hisi_spi_probe(struct platform_device *pdev)
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




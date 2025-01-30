Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D064383;
	Thu, 30 Jan 2025 14:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246627; cv=none; b=GYF/Yh0SzUop6umaqsHGfo54JTie0FPbm2QRFM1DH5jYJccJJa8tXiGIfEDkTJlptfKbB+JMi142KSn/pQ/U82x9UXjhKZZRfahhQ7rwwMqdDJavNeo0kcw/ICe9z4wwM0o8SqNBQ4yvyqQANDp/gVuHaY4DnXrt1ecwQFeRvRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246627; c=relaxed/simple;
	bh=KRQZTuoVNO61zkQ4R9XEYgJaf+Y/DlHNmpaLJBZ+N3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYtdqOLv9rlX8lhyknD1KhFOvci502JhAdCvhvOHkhsMJSLE2or0MeoFMungy/O3v2yVVW3dD4dJQhQ/shJrKW2DHoOCO52UteO8vLj6EqzVYmcltbq2/cIIBHfmasoCvcglMu8nHBD4wzFGZfE1HbtG3FzgQa5R84s/ybTQzc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiejFLsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiejFLsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE2AC4CEE2;
	Thu, 30 Jan 2025 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246627;
	bh=KRQZTuoVNO61zkQ4R9XEYgJaf+Y/DlHNmpaLJBZ+N3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiejFLsSC8nEP13L6PgJr5gIdl6FeHUDZ974woFmjy6tPafZFw4qdtd9tNM+3PmhG
	 9ODiEOatyWor0citvXADXk1eJzH2Da+nYA/aktM7lC9gMGz/8QCTES9TSGZaQ7wATK
	 LJcxUklNWmVJBtoKMuLlgZT+4v2dIfbokQOBedQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Simon Horman <horms@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/91] ieee802154: ca8210: Add missing check for kfifo_alloc() in ca8210_probe()
Date: Thu, 30 Jan 2025 15:00:24 +0100
Message-ID: <20250130140133.888154125@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit 2c87309ea741341c6722efdf1fb3f50dd427c823 ]

ca8210_test_interface_init() returns the result of kfifo_alloc(),
which can be non-zero in case of an error. The caller, ca8210_probe(),
should check the return value and do error-handling if it fails.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/20241029182712.318271-1-keisuke.nishimura@inria.fr
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index fdbdc22fe4e5..d394e2b65054 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -3124,7 +3124,11 @@ static int ca8210_probe(struct spi_device *spi_device)
 	spi_set_drvdata(priv->spi, priv);
 	if (IS_ENABLED(CONFIG_IEEE802154_CA8210_DEBUGFS)) {
 		cascoda_api_upstream = ca8210_test_int_driver_write;
-		ca8210_test_interface_init(priv);
+		ret = ca8210_test_interface_init(priv);
+		if (ret) {
+			dev_crit(&spi_device->dev, "ca8210_test_interface_init failed\n");
+			goto error;
+		}
 	} else {
 		cascoda_api_upstream = NULL;
 	}
-- 
2.39.5




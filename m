Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62125248BB6;
	Wed, 15 Jan 2025 10:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937901; cv=none; b=X9M3fdQuluXG7OlieFl1ZaXU1x2GZSTr9B4NyvlJWvO/Q5gDVxAZ5jtDdD6t1TnrbxBZ+ubTEg5l52Ok1vcUaFoNWZNQELHN7xxvlAphUHJbCy0Vbi9vMa6/WnMlEl6K7aw9WN8LeS9/YFVAeBakEMZTk29/6/+1Fsruazz4+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937901; c=relaxed/simple;
	bh=iwdcRfTfa1bg+UTeXN0UHNMP4fTTuYGsKvoRTmxEEPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlSJ3AjN9ix3W+91ZNMgrqI91+bUn+Oreldhz27JTCeZcBFvjekwW0L4/836uGPWKo++SxTLaZuKYi/4Uriljj1DC4IRJegSnmmggCGTpiisiaIuU/Ooojhr+y5tllCFGiqpJChBRaO3N+Ag4ABJfPuGQR9bs/fs+UXnhTq5JqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StWZakkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StWZakkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA298C4CEDF;
	Wed, 15 Jan 2025 10:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937901;
	bh=iwdcRfTfa1bg+UTeXN0UHNMP4fTTuYGsKvoRTmxEEPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StWZakkbVhirQ2JWVWW3LAKM4v43utilmDbG2kiAUgvgFwucqV7jkeuoPlvXdTzE8
	 PhhCPzP7AtzyrnIokPNXXLkp+aF0zw5RzpomuuoVmBTwSBrEYQTpWbNUbHqkBeIQw9
	 gXzg916Cu2Z3XRf9NhpgDr3ckFwK5JDZ6s52Hygc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Simon Horman <horms@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/189] ieee802154: ca8210: Add missing check for kfifo_alloc() in ca8210_probe()
Date: Wed, 15 Jan 2025 11:35:20 +0100
Message-ID: <20250115103607.325695811@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e685a7f946f0..753215ebc67c 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -3072,7 +3072,11 @@ static int ca8210_probe(struct spi_device *spi_device)
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




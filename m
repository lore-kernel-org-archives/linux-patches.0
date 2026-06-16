Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5F53D810C;
	Tue, 16 Jun 2026 19:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636700; cv=none; b=j9ovDHiCI8RxrTmx7bk00HKpzQYuhZ9H05JCLS/IH0lr8gyJ5aiUt8QI5iSt9Wz6OHSAOHL9k9iDUi4slH/wAKLhen8ltG+HAWcukUsnKWH2RLg/7O2JWxglCP+7o+G0fw+onUJMx/oBKSbDyimfaHkoIoMGTs/Rp/UhVB2PK54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636700; c=relaxed/simple;
	bh=tJG/cmFWWruoSFajVeZ9Ivu33u4IfEy70G6/b9WGg7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qw8RbjeruI7sLNbZGhWJFDrC7jnoIVVVpQGvc86Afe0n3N8Ur+eodxUEaN936j6QceOiJD2DOeqjMEM1GSWT/JumZ080pF/gL7Fx/nkH2qWYEkM/vMw5y/zcDA8IcwqoWwNhKmbgTsHV6IlGBY6FQ+9P729GDP2buNXTCLYhPfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJZZpinF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJZZpinF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06C01F000E9;
	Tue, 16 Jun 2026 19:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636699;
	bh=NhbuBQ38YFgonQsQgvY5mSPweQohB7KCVqdzWOYtqB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJZZpinFr7r27dBzsxg6D8z3HvKYTywAdItcCdK0A3pfUM232ntM6ukyoMHUurYJE
	 h2ZiF3yE6gfFdTaY+l2KJjx5oir0bvK/GqaNlXwE03J5KQSvKBSaQcc1hA92tLjfR6
	 JiV9T+/HIW1/Xb5qUaXWE7w6qmn7amr1WAVU5Jt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahisa Kojima <masahisa.kojima@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/342] spi: syncuacer: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:12 +0530
Message-ID: <20260616145100.178735483@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 75d849c3452e9611de031db45b3149ba9a99035f ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: b0823ee35cf9 ("spi: Add spi driver for Socionext SynQuacer platform")
Cc: stable@vger.kernel.org	# 5.3
Cc: Masahisa Kojima <masahisa.kojima@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-21-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed spi_controller/host to spi_master/master and kept int return type with `return 0;` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-synquacer.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -719,7 +719,7 @@ static int synquacer_spi_probe(struct pl
 	pm_runtime_set_active(sspi->dev);
 	pm_runtime_enable(sspi->dev);
 
-	ret = devm_spi_register_master(sspi->dev, master);
+	ret = spi_register_master(master);
 	if (ret)
 		goto disable_pm;
 
@@ -740,10 +740,16 @@ static int synquacer_spi_remove(struct p
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct synquacer_spi *sspi = spi_master_get_devdata(master);
 
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	pm_runtime_disable(sspi->dev);
 
 	clk_disable_unprepare(sspi->clk);
 
+	spi_master_put(master);
+
 	return 0;
 }
 



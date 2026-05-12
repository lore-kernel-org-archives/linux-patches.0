Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF033ADBA;
	Tue, 12 May 2026 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609321; cv=none; b=AmtXuufMsK6CDy62T/Ji6+GTCnI6EygAloNrIbD1fw97oTW3vCxMQJFTCtLEPcuKb01vQ05/eNzaCn3McN47zPm+ch9XNd66zTeOguVprpBQFwJ0UH08ntZwIpeMB3I6TdR3ctDL/FSnIPYPWvq5WJx8fqr+bEdauH7Gx6yde1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609321; c=relaxed/simple;
	bh=rX9+V+5lgpt0ItY5+9sOqMIv4svWBeJzzdSliDHBQcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/nhcMo33TL3C2W2jTTtKZRKlI/43kRUc+W4gAXqS6HG0jR6z1drzYMnINQlxWZ5JJjddPwPxuoTmv6NdRGksHQ2P6QbqSrt/BnQiL+YPnsXhXrSLIhQey8yShku43bbprkmA7v6jDjiS1nq1+0e6wmP5kPFsUCAX53wh/PEMp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbUSEHdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbUSEHdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4ABC2BCB0;
	Tue, 12 May 2026 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609321;
	bh=rX9+V+5lgpt0ItY5+9sOqMIv4svWBeJzzdSliDHBQcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbUSEHdfyUdyU26AuSFRfkN9gKICfMPys4z/+7XN6WLyuWc/Qkat0d8upZR0L761D
	 8YCkN5saULWsJyXzVZzltMzQU7N4cAAXJoagWeiHMeM1fHXj4ogDGEYke0PF8VgRZA
	 mrt2I9Ai4lHpqBid9WORzX5jjUMYoGm0E6NisWg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 149/307] spi: microchip-core-spi: fix controller deregistration
Date: Tue, 12 May 2026 19:39:04 +0200
Message-ID: <20260512173943.272654555@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit d00d722ebad46cf7a9886684f26a26337b5ee3f4 upstream.

Make sure to deregister the controller before disabling underlying
resources like interrupts during driver unbind.

Fixes: 059f545832be ("spi: add support for microchip "soft" spi controller")
Cc: stable@vger.kernel.org	# 6.19
Cc: Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260409120419.388546-20-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-microchip-core-spi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-microchip-core-spi.c b/drivers/spi/spi-microchip-core-spi.c
index a4c128ae391b..be01c178e2b0 100644
--- a/drivers/spi/spi-microchip-core-spi.c
+++ b/drivers/spi/spi-microchip-core-spi.c
@@ -384,7 +384,7 @@ static int mchp_corespi_probe(struct platform_device *pdev)
 
 	mchp_corespi_init(host, spi);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		mchp_corespi_disable_ints(spi);
 		mchp_corespi_disable(spi);
@@ -399,6 +399,8 @@ static void mchp_corespi_remove(struct platform_device *pdev)
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct mchp_corespi *spi = spi_controller_get_devdata(host);
 
+	spi_unregister_controller(host);
+
 	mchp_corespi_disable_ints(spi);
 	mchp_corespi_disable(spi);
 }
-- 
2.54.0




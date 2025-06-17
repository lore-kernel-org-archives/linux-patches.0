Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56762FA630;
	Tue, 17 Jun 2025 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179205; cv=none; b=C/PYny+o2Urvcw5UM2t5GWOm/40rB3u8ZM8EmM+SOjV2OqFmk4Tn3rSA38kKDUt9MgPYF4HOlyJSmbd8iG9x7/5ruBWAEqySg0Uz6aQ4XuubnZpgt+yDuBSj9FWxaLDw55kwuNzd7yAhu0GUzGRqopa2Int9ewbKj4iQCZE9vtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179205; c=relaxed/simple;
	bh=gWlXe0kjZ+D4772gRWD9hyPzszpm6yNBpi1CHj9GN74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kK8IAtDtWlHVUGhP6/rMOjE/2dl+TzqvzbSrOwnFasn8sqvpyzJQ2lsZjsNbHcHEFyuoZ/Zkwvm2a5aNowr12bZ7C4jxqfefhFZtxJU3Ylfszsi60sfatDbuQkOnY2cDiErfVQ5Fg5ey8lc8gE+GgjWglr+QtJfHEtZ1T7PBy40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0a60AWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0a60AWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F1AC4CEE3;
	Tue, 17 Jun 2025 16:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179205;
	bh=gWlXe0kjZ+D4772gRWD9hyPzszpm6yNBpi1CHj9GN74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0a60AWsscpnTw0fBIidXfzT6ltEmmH2DVGYS7aVXR/rXxhgnBnBcbNubBTosJPTu
	 UU8u97lYdNlh/nPKeR6n3jhKR47GiShzCP8goHKlf/Fdu4bgs9rBUVZV1nliuOR5R+
	 KH/dEUWV78zS/icEM1xk1fFy17TQR0hDPunCnxN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?F=C3=A9lix=20Pi=C3=A9dallu?= <felix.piedallu@non.se.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 681/780] spi: omap2-mcspi: Disable multi mode when CS should be kept asserted after message
Date: Tue, 17 Jun 2025 17:26:29 +0200
Message-ID: <20250617152519.209954277@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Félix Piédallu <felix.piedallu@non.se.com>

[ Upstream commit a5bf5272295d3f058adeee025d2a0b6625f8ba7b ]

When the last transfer of a SPI message has the cs_change flag, the CS is kept
asserted after the message.
Multi-mode can't respect this as CS is deasserted by the hardware at the end of
the message.

Disable multi-mode when not applicable to the current message.

Fixes: d153ff4056cb ("spi: omap2-mcspi: Add support for MULTI-mode")
Signed-off-by: Félix Piédallu <felix.piedallu@non.se.com>
Link: https://patch.msgid.link/20250606-cs_change_fix-v1-1-27191a98a2e5@non.se.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 29c616e2c408c..e834fb42fd4ba 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1287,9 +1287,15 @@ static int omap2_mcspi_prepare_message(struct spi_controller *ctlr,
 			mcspi->use_multi_mode = false;
 		}
 
-		/* Check if transfer asks to change the CS status after the transfer */
-		if (!tr->cs_change)
-			mcspi->use_multi_mode = false;
+		if (list_is_last(&tr->transfer_list, &msg->transfers)) {
+			/* Check if transfer asks to keep the CS status after the whole message */
+			if (tr->cs_change)
+				mcspi->use_multi_mode = false;
+		} else {
+			/* Check if transfer asks to change the CS status after the transfer */
+			if (!tr->cs_change)
+				mcspi->use_multi_mode = false;
+		}
 
 		/*
 		 * If at least one message is not compatible, switch back to single mode
-- 
2.39.5




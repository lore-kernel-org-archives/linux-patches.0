Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556E9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D0DC433C7;
	Sun, 13 Aug 2023 21:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962822;
	bh=EnlOqSZzYVL4gqDBVzyfLjHH9R2SKtoMEjbfxtC1vEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qlok4vK9rw//wB2peelBDb9dyVOEaDX10LTnOq/oz1n3x1splySI4HOLGdb4B9Sj3
	 WG9f95C8+WwkEFhYkRZSTGMm0P7JxlHc32Dg7XSIla0h0NU4QMVQc/H+uR/YrU7Ryg
	 AJv2X3j/RVuaHLsh9Ke7Ziae5TIMWbhYRX/KIXSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergei Antonov <saproj@gmail.com>,
	Jonas Jensen <jonas.jensen@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 02/68] mmc: moxart: read scr register without changing byte order
Date: Sun, 13 Aug 2023 23:19:03 +0200
Message-ID: <20230813211708.223822135@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergei Antonov <saproj@gmail.com>

commit d44263222134b5635932974c6177a5cba65a07e8 upstream.

Conversion from big-endian to native is done in a common function
mmc_app_send_scr(). Converting in moxart_transfer_pio() is extra.
Double conversion on a LE system returns an incorrect SCR value,
leads to errors:

mmc0: unrecognised SCR structure version 8

Fixes: 1b66e94e6b99 ("mmc: moxart: Add MOXA ART SD/MMC driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230627120549.2400325-1-saproj@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/moxart-mmc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -339,13 +339,7 @@ static void moxart_transfer_pio(struct m
 				return;
 			}
 			for (len = 0; len < remain && len < host->fifo_width;) {
-				/* SCR data must be read in big endian. */
-				if (data->mrq->cmd->opcode == SD_APP_SEND_SCR)
-					*sgp = ioread32be(host->base +
-							  REG_DATA_WINDOW);
-				else
-					*sgp = ioread32(host->base +
-							REG_DATA_WINDOW);
+				*sgp = ioread32(host->base + REG_DATA_WINDOW);
 				sgp++;
 				len += 4;
 			}



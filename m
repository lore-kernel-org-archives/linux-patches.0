Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803311BDEC;
	Wed,  3 Jan 2024 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm2JehzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD043C433C7;
	Wed,  3 Jan 2024 17:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301943;
	bh=aotni/XZ2AlzqObCohBr6gE5u0ICkT3Kd63JrY28BAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm2JehzPls2Ub/3D+BjLzbMtCJxb7slP3OC+Sv1amaKbC/A/tg9xSBnX0ojdHBDFJ
	 uCv34lzb7iuceb0mhhxW52E8+zI3tK3EX5PW2cH1ECDE28vN3uxGOhurJAujAUmx9Z
	 jJVg2BhrWjzT1dh6rGsytAWhMpC6xbdlFeV+2Pbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ville Baillie <villeb@bytesnap.co.uk>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 75/75] spi: atmel: Fix PDC transfer setup bug
Date: Wed,  3 Jan 2024 17:55:56 +0100
Message-ID: <20240103164854.303231245@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Baillie <villeb@bytesnap.co.uk>

commit 75e33c55ae8fb4a177fe07c284665e1d61b02560 upstream.

atmel_spi_dma_map_xfer to never be called in PDC mode. This causes the
driver to silently fail.

This patch changes the conditional to match the behaviour of the
previous commit before the refactor.

Fixes: 5fa5e6dec762 ("spi: atmel: Switch to transfer_one transfer method")
Signed-off-by: Ville Baillie <villeb@bytesnap.co.uk>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210921072132.21831-1-villeb@bytesnap.co.uk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-atmel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1315,7 +1315,7 @@ static int atmel_spi_one_transfer(struct
 	 * DMA map early, for performance (empties dcache ASAP) and
 	 * better fault reporting.
 	 */
-	if ((!master->cur_msg_mapped)
+	if ((!master->cur_msg->is_dma_mapped)
 		&& as->use_pdc) {
 		if (atmel_spi_dma_map_xfer(as, xfer) < 0)
 			return -ENOMEM;
@@ -1394,7 +1394,7 @@ static int atmel_spi_one_transfer(struct
 		}
 	}
 
-	if (!master->cur_msg_mapped
+	if (!master->cur_msg->is_dma_mapped
 		&& as->use_pdc)
 		atmel_spi_dma_unmap_xfer(master, xfer);
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9853723AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2003CC433D2;
	Wed, 28 Dec 2022 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246747;
	bh=0Z1WykKJ+4YJpdOfdslu/bsFMASDIA3vEl0636o0UtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMWunACgLlzClFDNuoLLAYOy6zJ8m6mlCDIeY+8z3WRMVMQgRjY6EszfegxKrpGo8
	 5zEvQ/2/rGBU0eJMxSm0m/Z9/4R8oD06Hek50uHX5xl2ZxFXeQiq97avcjzZo5GONp
	 9XzWV5ojFL5Mhx0LjdF/bkXZhp4OsEnIwHmurT0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 1124/1146] spi: fsl_spi: Dont change speed while chipselect is active
Date: Wed, 28 Dec 2022 15:44:23 +0100
Message-Id: <20221228144400.676730888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 3b553e0041a65e499fa4e25ee146f01f4ec4e617 upstream.

Commit c9bfcb315104 ("spi_mpc83xx: much improved driver") made
modifications to the driver to not perform speed changes while
chipselect is active. But those changes where lost with the
convertion to tranfer_one.

Previous implementation was allowing speed changes during
message transfer when cs_change flag was set.
At the time being, core SPI does not provide any feature to change
speed while chipselect is off, so do not allow any speed change during
message transfer, and perform the transfer setup in prepare_message
in order to set correct speed while chipselect is still off.

Reported-by: Herve Codina <herve.codina@bootlin.com>
Fixes: 64ca1a034f00 ("spi: fsl_spi: Convert to transfer_one")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/8aab84c51aa330cf91f4b43782a1c483e150a4e3.1671025244.git.christophe.leroy@csgroup.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-spi.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 731624f157fc..93152144fd2e 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -333,13 +333,26 @@ static int fsl_spi_prepare_message(struct spi_controller *ctlr,
 {
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(ctlr);
 	struct spi_transfer *t;
+	struct spi_transfer *first;
+
+	first = list_first_entry(&m->transfers, struct spi_transfer,
+				 transfer_list);
 
 	/*
 	 * In CPU mode, optimize large byte transfers to use larger
 	 * bits_per_word values to reduce number of interrupts taken.
+	 *
+	 * Some glitches can appear on the SPI clock when the mode changes.
+	 * Check that there is no speed change during the transfer and set it up
+	 * now to change the mode without having a chip-select asserted.
 	 */
-	if (!(mpc8xxx_spi->flags & SPI_CPM_MODE)) {
-		list_for_each_entry(t, &m->transfers, transfer_list) {
+	list_for_each_entry(t, &m->transfers, transfer_list) {
+		if (t->speed_hz != first->speed_hz) {
+			dev_err(&m->spi->dev,
+				"speed_hz cannot change during message.\n");
+			return -EINVAL;
+		}
+		if (!(mpc8xxx_spi->flags & SPI_CPM_MODE)) {
 			if (t->len < 256 || t->bits_per_word != 8)
 				continue;
 			if ((t->len & 3) == 0)
@@ -348,7 +361,7 @@ static int fsl_spi_prepare_message(struct spi_controller *ctlr,
 				t->bits_per_word = 16;
 		}
 	}
-	return 0;
+	return fsl_spi_setup_transfer(m->spi, first);
 }
 
 static int fsl_spi_transfer_one(struct spi_controller *controller,
-- 
2.39.0




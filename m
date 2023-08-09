Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32441773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2641CC433C8;
	Wed,  9 Aug 2023 11:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579808;
	bh=mewNc5/AW7N/T05NJYg1MeouL1J2XIc/JMk04u5Ul38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5ml49aHXykJj20etO2lvWEzh0WGkVwBDpBqUJ/nA9pyfFVR/K4KfKaD2fmnWbPm4
	 b5aOvOmAvXOsxiEVzz++3vVKc5ejxJ6ZUNe/JE+pu7l0CoL7qfWX8uiAPMV0p7ytaT
	 2SyHmuH1D447j/kZy6Ngxw3c3k4uMHn1lpr5gAjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	Mark Brown <broonie@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 4.19 123/323] spi: spi-fsl-spi: allow changing bits_per_word while CS is still active
Date: Wed,  9 Aug 2023 12:39:21 +0200
Message-ID: <20230809103703.748542135@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

commit a798a7086c38d91d304132c194cff9f02197f5cd upstream.

Commit c9bfcb315104 (spi_mpc83xx: much improved driver) introduced
logic to ensure bits_per_word and speed_hz stay the same for a series
of spi_transfers with CS active, arguing that

    The current driver may cause glitches on SPI CLK line since one
    must disable the SPI controller before changing any HW settings.

This sounds quite reasonable. So this is a quite naive attempt at
relaxing this sanity checking to only ensure that speed_hz is
constant - in the faint hope that if we do not causes changes to the
clock-related fields of the SPMODE register (DIV16 and PM), those
glitches won't appear.

The purpose of this change is to allow automatically optimizing large
transfers to use 32 bits-per-word; taking one interrupt for every byte
is extremely slow.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-spi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -339,7 +339,7 @@ static int fsl_spi_do_one_msg(struct spi
 	struct spi_transfer *t, *first;
 	unsigned int cs_change;
 	const int nsecs = 50;
-	int status;
+	int status, last_bpw;
 
 	/*
 	 * In CPU mode, optimize large byte transfers to use larger
@@ -378,21 +378,22 @@ static int fsl_spi_do_one_msg(struct spi
 		if (cs_change)
 			first = t;
 		cs_change = t->cs_change;
-		if ((first->bits_per_word != t->bits_per_word) ||
-			(first->speed_hz != t->speed_hz)) {
+		if (first->speed_hz != t->speed_hz) {
 			dev_err(&spi->dev,
-				"bits_per_word/speed_hz cannot change while CS is active\n");
+				"speed_hz cannot change while CS is active\n");
 			return -EINVAL;
 		}
 	}
 
+	last_bpw = -1;
 	cs_change = 1;
 	status = -EINVAL;
 	list_for_each_entry(t, &m->transfers, transfer_list) {
-		if (cs_change)
+		if (cs_change || last_bpw != t->bits_per_word)
 			status = fsl_spi_setup_transfer(spi, t);
 		if (status < 0)
 			break;
+		last_bpw = t->bits_per_word;
 
 		if (cs_change) {
 			fsl_spi_chipselect(spi, BITBANG_CS_ACTIVE);



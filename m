Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3251174EE
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74376C433C9;
	Wed,  9 Aug 2023 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579126;
	bh=XrdkNDoIq2yvrGccPxLw9yteSjjPHvRpviM85Fy9Yy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNGGb6BDda2JooZgcFPL5eYkpim5eDjt9kPcBTNKuxdOgZVCquMbp+TEYPENEexn3
	 WilxRjKryIEeypKq0t500vq9J36WwtIM6d3TWQ2hhXf2lo7SHlBIWS9rPhh5tzV0ZQ
	 mP2dlt8YVsEu+nYJoKVSSEOOMryUIMqZSE9zHC+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	Mark Brown <broonie@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 4.14 085/204] spi: spi-fsl-spi: relax message sanity checking a little
Date: Wed,  9 Aug 2023 12:40:23 +0200
Message-ID: <20230809103645.498901314@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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

commit 17ecffa289489e8442306bbc62ebb964e235cdad upstream.

The comment says that we should not allow changes (to
bits_per_word/speed_hz) while CS is active, and indeed the code below
does fsl_spi_setup_transfer() when the ->cs_change of the previous
spi_transfer was set (and for the very first transfer).

So the sanity checking is a bit too strict - we can change it to
follow the same logic as is used by the actual transfer loop.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-spi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -373,13 +373,15 @@ static int fsl_spi_do_one_msg(struct spi
 	}
 
 	/* Don't allow changes if CS is active */
-	first = list_first_entry(&m->transfers, struct spi_transfer,
-			transfer_list);
+	cs_change = 1;
 	list_for_each_entry(t, &m->transfers, transfer_list) {
+		if (cs_change)
+			first = t;
+		cs_change = t->cs_change;
 		if ((first->bits_per_word != t->bits_per_word) ||
 			(first->speed_hz != t->speed_hz)) {
 			dev_err(&spi->dev,
-				"bits_per_word/speed_hz should be same for the same SPI transfer\n");
+				"bits_per_word/speed_hz cannot change while CS is active\n");
 			return -EINVAL;
 		}
 	}



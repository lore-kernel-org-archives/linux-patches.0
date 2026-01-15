Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59CA2868B0;
	Thu, 15 Jan 2026 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499433; cv=none; b=C4bbBdTbuBJKOIGhHsp4O29qqi6/wXE+wxjW8//OMvNpz0Gox4uA/OjELRpdzdIV+d3Fr+4SMGxX0hnYbQ8MacRmVanTBGzYWFfsx9T4hSoE//vKcfsu2rsqLEZqQ0vU9LihoJu2q9t95Plwkc3gQ7nrbKiF6/+Nt2S7MrK9PlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499433; c=relaxed/simple;
	bh=p693OxGC5xArWPs4T50G79aqrTJv5oSovp5kmtCL/Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H36ZLouWytyw6nSf3Ej8nbA5nE914iNIK90y7ryhxACHwXK8rDMES+lMIMPTn+r0emD/JNbmb5rp290n6emLj4MHb97SlqOdYPFtql9BV+39IiB/d5rmRv4O0LVOuwTZrFawvTphx1uUMKrESgixjPf2FJNTMM1YBP1ndOqOkJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWH6UUuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWH6UUuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2352CC19423;
	Thu, 15 Jan 2026 17:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499433;
	bh=p693OxGC5xArWPs4T50G79aqrTJv5oSovp5kmtCL/Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWH6UUuF9e4ruSgUI9XY7wtigCTIrP+17z7zuoUbVJAvr78ZpKl8GkNSlUOH2OUvt
	 SIVwalPI3o3FLtOX2MosWYbnuBbp/TFeuGBXOTj2ujKa8HbjbyR+VG05wRipnMzId9
	 +5jlXEc6jN4z8FfCyBMSwCyqZPukd1AkdJv1KagU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sverdlin Alexander <alexander.sverdlin@siemens.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 198/451] spi: fsl-cpm: Check length parity before switching to 16 bit mode
Date: Thu, 15 Jan 2026 17:46:39 +0100
Message-ID: <20260115164238.064515701@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 1417927df8049a0194933861e9b098669a95c762 upstream.

Commit fc96ec826bce ("spi: fsl-cpm: Use 16 bit mode for large transfers
with even size") failed to make sure that the size is really even
before switching to 16 bit mode. Until recently the problem went
unnoticed because kernfs uses a pre-allocated bounce buffer of size
PAGE_SIZE for reading EEPROM.

But commit 8ad6249c51d0 ("eeprom: at25: convert to spi-mem API")
introduced an additional dynamically allocated bounce buffer whose size
is exactly the size of the transfer, leading to a buffer overrun in
the fsl-cpm driver when that size is odd.

Add the missing length parity verification and remain in 8 bit mode
when the length is not even.

Fixes: fc96ec826bce ("spi: fsl-cpm: Use 16 bit mode for large transfers with even size")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/638496dd-ec60-4e53-bad7-eb657f67d580@csgroup.eu/
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Sverdlin Alexander <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/3c4d81c3923c93f95ec56702a454744a4bad3cfc.1763627618.git.christophe.leroy@csgroup.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -369,7 +369,7 @@ static int fsl_spi_do_one_msg(struct spi
 			if (t->bits_per_word == 16 || t->bits_per_word == 32)
 				t->bits_per_word = 8; /* pretend its 8 bits */
 			if (t->bits_per_word == 8 && t->len >= 256 &&
-			    (mpc8xxx_spi->flags & SPI_CPM1))
+			    !(t->len & 1) && (mpc8xxx_spi->flags & SPI_CPM1))
 				t->bits_per_word = 16;
 		}
 	}



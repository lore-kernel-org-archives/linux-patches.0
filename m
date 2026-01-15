Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091943BFE50;
	Thu, 15 Jan 2026 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497919; cv=none; b=RwiGaCociLOzr7Kp8PBa74uwInI+I7ONeDoJDveG87F8M/MUIGYot0Am2aZmDLtizJHZM2EiielN6X18OgXW2m4S7GPwpr+NVqccVMc0JKyX1Y/SG0PYtoVuxKYHopciEgTCEUkKep5Tf60shHaWnpgZdkA5iQAp7+ezDDYpVTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497919; c=relaxed/simple;
	bh=E+Ak4Q4Jeyubnzsk/JuRWrpUzvS6291IS4+2QseEPrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XF4s6Lxft616D0RlSPrtjwGnGBtyqe5L9Y0/TsiNTGpmAZdnEW4dYVmsacPc04qh8IIyV939wZdZq87lTrT+inuSoCbEnzeE+G8uVtb7zaarpJ68qYMaD4g4G6Yopozhr3UNDlF/CZGQ6wSDv703kdBXi6NTCdMDYQf3qM2U8qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXr7eJZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXr7eJZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89935C116D0;
	Thu, 15 Jan 2026 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497918;
	bh=E+Ak4Q4Jeyubnzsk/JuRWrpUzvS6291IS4+2QseEPrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXr7eJZ8sC81yZfL0hOy4xUrBZL6tOXLyDlubM2gfYqwZbxr/hvsFUaao+cR7Hlzz
	 dnVXsgqxza6989ARslhMG9NK5O2lSey9KmX6pPXDOP+QoSGEo7Dv4BxB2eDAKAS8xx
	 HAnsr7fRzbzC9s0pOjxphWt4Fh+puWEYjSOnRyhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sverdlin Alexander <alexander.sverdlin@siemens.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 250/554] spi: fsl-cpm: Check length parity before switching to 16 bit mode
Date: Thu, 15 Jan 2026 17:45:16 +0100
Message-ID: <20260115164255.287983223@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



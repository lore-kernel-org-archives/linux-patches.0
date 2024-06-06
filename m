Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00D11A1891;
	Thu,  6 Jun 2024 14:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683725; cv=none; b=lnCRTBbEg/QPhSQIi1xsHsqvqptYptdaKG0qpgs5ZuYhP1uRni/PrhpL/Qr0adG7F7VWLMccJO1u4GDc8Rx0DioNS8URXDEnkbZc1CjzKeb6ugpFyZyuA8Aw0lutdqw1sxs8vqlM305ev6zObu6B0azeqEDUL2RUhc1OZ9xu+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683725; c=relaxed/simple;
	bh=he67L2f6ZWtnA8qmywBPUa2Jb3mBFqXNTGJ8ugxnHnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFhVhHhJNmIbAwnoiRBpjJYLlgCau95OcyFU7LsEiBrspnVwOgXVW+AiZm5YK50/IDxD1crWQfNWbXHIqFNfk9TfqpVPMYOTlbvhwkEGjvs4PnIe2rhJVxxr4P9KvH/v5LKwNoLdfpp59RHm/VSjmslk1axb7gGFemePgZIJEoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTbwU3+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTbwU3+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE347C32781;
	Thu,  6 Jun 2024 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683724;
	bh=he67L2f6ZWtnA8qmywBPUa2Jb3mBFqXNTGJ8ugxnHnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTbwU3+5aCh4ScLljzwf7kimC6bXch+yukBQrEkyOzhkX82xclEF9iaAH+P5EDpr7
	 HWR+D9imiSF2O3fUG+Hjkry+nHGqeaUfUwaB9yGxLTRRcCxy020LIzd+nXBITDYnrX
	 h2MZnPajCKFMXHu5SoPTh6rUPyg7A+4gXrkZrML0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew R. Ochs" <mochs@nvidia.com>,
	Carol Soto <csoto@nvidia.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 671/744] tpm_tis_spi: Account for SPI header when allocating TPM SPI xfer buffer
Date: Thu,  6 Jun 2024 16:05:43 +0200
Message-ID: <20240606131754.001681463@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew R. Ochs <mochs@nvidia.com>

[ Upstream commit 195aba96b854dd664768f382cd1db375d8181f88 ]

The TPM SPI transfer mechanism uses MAX_SPI_FRAMESIZE for computing the
maximum transfer length and the size of the transfer buffer. As such, it
does not account for the 4 bytes of header that prepends the SPI data
frame. This can result in out-of-bounds accesses and was confirmed with
KASAN.

Introduce SPI_HDRSIZE to account for the header and use to allocate the
transfer buffer.

Fixes: a86a42ac2bd6 ("tpm_tis_spi: Add hardware wait polling")
Signed-off-by: Matthew R. Ochs <mochs@nvidia.com>
Tested-by: Carol Soto <csoto@nvidia.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_spi_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_spi_main.c b/drivers/char/tpm/tpm_tis_spi_main.c
index c5c3197ee29f0..4bdad9e3667fa 100644
--- a/drivers/char/tpm/tpm_tis_spi_main.c
+++ b/drivers/char/tpm/tpm_tis_spi_main.c
@@ -37,6 +37,7 @@
 #include "tpm_tis_spi.h"
 
 #define MAX_SPI_FRAMESIZE 64
+#define SPI_HDRSIZE 4
 
 /*
  * TCG SPI flow control is documented in section 6.4 of the spec[1]. In short,
@@ -247,7 +248,7 @@ static int tpm_tis_spi_write_bytes(struct tpm_tis_data *data, u32 addr,
 int tpm_tis_spi_init(struct spi_device *spi, struct tpm_tis_spi_phy *phy,
 		     int irq, const struct tpm_tis_phy_ops *phy_ops)
 {
-	phy->iobuf = devm_kmalloc(&spi->dev, MAX_SPI_FRAMESIZE, GFP_KERNEL);
+	phy->iobuf = devm_kmalloc(&spi->dev, SPI_HDRSIZE + MAX_SPI_FRAMESIZE, GFP_KERNEL);
 	if (!phy->iobuf)
 		return -ENOMEM;
 
-- 
2.43.0




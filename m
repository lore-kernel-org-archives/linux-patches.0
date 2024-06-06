Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF4C198853;
	Thu,  6 Jun 2024 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683044; cv=none; b=N4h2FHfmfG9LU4gIWG8C/4mmrqk7oeY8dmqrqFXJA8HKu7A9d1XkaVmOWJCZum0fIHhk/eSDwiAOVIguF45W1zXw65HU8tKs3oj0LYaSWIwKucVv/UTvTNSzPSVRS830akNfObqEPC/yj5ctNYIK02PUHMz71phCm2BAcl8di6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683044; c=relaxed/simple;
	bh=6NuEWt/8e4XhGjFGNCZ+BwPTy6e/h37/CrJJDgSdDjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNsIZLrvQXpL9OlhT+hx8vQfjdNcF5UxEe9aPxSFIXMPYCf8ZSbl7M1CRio1m3lxaU5lW2sH0dfF7PSykNdZYYltStL9awM2ObQ3hdZjnWnIBm5SPOax9/qGdYAdUhhSBuebbbpPQqiWQMhRTD7mkJsBIBmJ/q3ja5N8KWbfBK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrsiJqHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrsiJqHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99638C32781;
	Thu,  6 Jun 2024 14:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683043;
	bh=6NuEWt/8e4XhGjFGNCZ+BwPTy6e/h37/CrJJDgSdDjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrsiJqHWVhSoDtHfvUCe80zC8M7aYEjvcFoJIgNAh7piXU71nF+Focsgh/dZYufK/
	 8LV4lyLYPsHPLd0qBxqy0/lwJJsRk03OHq1Z3MVkfCAjY+0O2L7+rIO7EqgctIh+wx
	 NrCVVpvd8CjYbVaLATkEm+M54Kos4y/QYsFStex4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew R. Ochs" <mochs@nvidia.com>,
	Carol Soto <csoto@nvidia.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 281/374] tpm_tis_spi: Account for SPI header when allocating TPM SPI xfer buffer
Date: Thu,  6 Jun 2024 16:04:20 +0200
Message-ID: <20240606131701.312661443@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 3f9eaf27b41b8..c9eca24bbad47 100644
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




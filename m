Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCA5322520;
	Mon, 27 Oct 2025 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590885; cv=none; b=mu4GQahDXNB8jX/qLb66GQyV1Eq09ktUkfpx7uJ0UbXwWdfs5UQDFnKHQtI3DiRaPI8Wm88i/6KbRvBeYURii4w4wdO5FPW19Py2H9h6PoDojQE6KFf9RXUn2YaX5HTarxGxv27bK0Nc1Vjz4YiTt3PM8hJyoFQgnV+N9/QPu/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590885; c=relaxed/simple;
	bh=r8SqktkVs3ZcmvcoNvRcPNnSDmFoAeIZr4Tutt5wK1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRMxINXzjSR1raRFkZYUi1kN7f6kR0LyBDsEqa3wTkHbq3dgVYnesqinbp3DPeBnvZWnrcvHNAyp8mGPDIDZex+8tawU2lyRmfdH23o/Y9HXyO1jYiCcQoOS5SidxPSmRW/0NDxUwTbNkif6f85w4TNRaRTi4GifG4cNR+s349U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMi1PLsj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMi1PLsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1EAC4CEF1;
	Mon, 27 Oct 2025 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590884;
	bh=r8SqktkVs3ZcmvcoNvRcPNnSDmFoAeIZr4Tutt5wK1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMi1PLsjZw6PimD4W6Ya0u2GgmwpIq9utPo4yzcnuM/Vv5PHd49nRojopFzxuDbWK
	 Yjr7uhXueQgEMV9GHNv0L35L9XXdY51zNLtHENx2z40NsdM+35akHeq7UayXhQy/3p
	 XOWbwJZU/whOH+ys0a9U54+6n4ml422dJgD+Cv3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 212/224] spi: cadence-quadspi: Flush posted register writes before DAC access
Date: Mon, 27 Oct 2025 19:35:58 +0100
Message-ID: <20251027183514.429575969@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <pratyush@kernel.org>

[ Upstream commit 1ad55767e77a853c98752ed1e33b68049a243bd7 ]

cqspi_read_setup() and cqspi_write_setup() program the address width as
the last step in the setup. This is likely to be immediately followed by
a DAC region read/write. On TI K3 SoCs the DAC region is on a different
endpoint from the register region. This means that the order of the two
operations is not guaranteed, and they might be reordered at the
interconnect level. It is possible that the DAC read/write goes through
before the address width update goes through. In this situation if the
previous command used a different address width the OSPI command is sent
with the wrong number of address bytes, resulting in an invalid command
and undefined behavior.

Read back the size register to make sure the write gets flushed before
accessing the DAC region.

Fixes: 140623410536 ("mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller")
CC: stable@vger.kernel.org
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Santhosh Kumar K <s-k6@ti.com>
Message-ID: <20250905185958.3575037-3-s-k6@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[ backported to drivers/mtd/spi-nor ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/cadence-quadspi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/spi-nor/cadence-quadspi.c
+++ b/drivers/mtd/spi-nor/cadence-quadspi.c
@@ -496,6 +496,7 @@ static int cqspi_read_setup(struct spi_n
 	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
 	reg |= (nor->addr_width - 1);
 	writel(reg, reg_base + CQSPI_REG_SIZE);
+	readl(reg_base + CQSPI_REG_SIZE); /* Flush posted write. */
 	return 0;
 }
 
@@ -609,6 +610,7 @@ static int cqspi_write_setup(struct spi_
 	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
 	reg |= (nor->addr_width - 1);
 	writel(reg, reg_base + CQSPI_REG_SIZE);
+	readl(reg_base + CQSPI_REG_SIZE); /* Flush posted write. */
 	return 0;
 }
 



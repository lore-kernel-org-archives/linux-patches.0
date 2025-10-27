Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372CA326D6D;
	Mon, 27 Oct 2025 19:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591772; cv=none; b=aCgHAFVcDgyrHKqOk940MeytA1bcrCW0eE1ghQ9DiwnqoK17VD9spTgcjiIUiU4eNHlGc4XHqfamTrY7LPacLodXblaRPSKlP3K4FexcRtzOnMvHKZMvFaYe9plnUPW0ZIEDavDcSouzhkau1FN3qKQQThDgA1vrhGgnaaS36LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591772; c=relaxed/simple;
	bh=w9MxumZhcMvYTkgpgUF6qvMZyYGmhulj17biXQKiPjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1bPPDO83o1RDXa02/+/h29zJh7My8kHoJJPyxkrVLtqNzvBlv/HPwUqsLr4oNiOwQoVAp/Vj0f4Qck6y1wGSvUKMbKlkNfDQMm1X0NaawrIOtTxME+xVCPlpOpWWzQFyvBu8L/dePzeZNYegs4e3/iXuzJhjwB9QKjcBsQBQmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qd/zD1OJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qd/zD1OJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE367C4CEF1;
	Mon, 27 Oct 2025 19:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591772;
	bh=w9MxumZhcMvYTkgpgUF6qvMZyYGmhulj17biXQKiPjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qd/zD1OJIKETXGPIlbPImqlPwRASO90vkzQOTzcbzDtbbfFKEBNQazyReF5pDd9uX
	 unWM2FaL3CHyvWLl9wcUVmfmTSo0lEz7f2ktCjElrDQPaXbdRolqN9VnAI4qcxNBX7
	 xstyViL1o7fBqNPInKwdvi3VCSyzdkVC6cNnZJ1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/332] spi: cadence-quadspi: Flush posted register writes before DAC access
Date: Mon, 27 Oct 2025 19:36:17 +0100
Message-ID: <20251027183533.430287896@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -474,6 +474,7 @@ static int cqspi_read_setup(struct cqspi
 	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
 	reg |= (op->addr.nbytes - 1);
 	writel(reg, reg_base + CQSPI_REG_SIZE);
+	readl(reg_base + CQSPI_REG_SIZE); /* Flush posted write. */
 	return 0;
 }
 
@@ -587,6 +588,7 @@ static int cqspi_write_setup(struct cqsp
 	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
 	reg |= (op->addr.nbytes - 1);
 	writel(reg, reg_base + CQSPI_REG_SIZE);
+	readl(reg_base + CQSPI_REG_SIZE); /* Flush posted write. */
 	return 0;
 }
 



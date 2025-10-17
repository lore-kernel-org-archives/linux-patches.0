Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F439337110;
	Fri, 17 Oct 2025 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713312; cv=none; b=SDHnpC1QJvE6+urDX46/45EZhg545e8l23jIyHdV+wCjgJYcYoTBAZri811eI372KkMNEtkeMVW7527w4Rw0F87WZ0fNPk3GE8BOrk6D7kHr3nM1kmKR1Lk1rkZSJjOtqYtwNXhOs8feCkr0nVo+H9NzoZru897svIKwHdX7kwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713312; c=relaxed/simple;
	bh=XQcDrxrskb4viGDgSVa4sdg4gCezV87l8i05kRBMNa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDswegtHHCoS6NiNFuI5yz5eqhVjea6j3kAFMqXMdA8vtrEYxdCw5BVZy3OB8ahUzm/adZZuCx5dxiZiea82PqfuXaWiO1pmoAKouHoCalINmeTgonw2V8kS8oUW24DPPZtnngAwgi1URjV0pPjFKqGHGZfNfamsn+dLsgMnO9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQzyq/Zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQzyq/Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD66C4CEE7;
	Fri, 17 Oct 2025 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713311;
	bh=XQcDrxrskb4viGDgSVa4sdg4gCezV87l8i05kRBMNa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQzyq/ZpcEhmt4SqMluo1FFy4m/q+XIdmiQ/Q/lgoMmFQJagCkbISQ7f7gNqJY5e9
	 9gyL+U1OLv85xSiW1kaY2qRKR3ppHcLUBR+Qeq/Wkcd7FtKVZqHt2YCHiKebnZ1XpF
	 uQucFrFlif2Y/xI1TWorUIVTc4BfD6mKSWUqsbyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 120/168] spi: cadence-quadspi: Flush posted register writes before DAC access
Date: Fri, 17 Oct 2025 16:53:19 +0200
Message-ID: <20251017145133.447410720@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <pratyush@kernel.org>

commit 1ad55767e77a853c98752ed1e33b68049a243bd7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -655,6 +655,7 @@ static int cqspi_read_setup(struct cqspi
 	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
 	reg |= (op->addr.nbytes - 1);
 	writel(reg, reg_base + CQSPI_REG_SIZE);
+	readl(reg_base + CQSPI_REG_SIZE); /* Flush posted write. */
 	return 0;
 }
 
@@ -944,6 +945,7 @@ static int cqspi_write_setup(struct cqsp
 	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
 	reg |= (op->addr.nbytes - 1);
 	writel(reg, reg_base + CQSPI_REG_SIZE);
+	readl(reg_base + CQSPI_REG_SIZE); /* Flush posted write. */
 	return 0;
 }
 



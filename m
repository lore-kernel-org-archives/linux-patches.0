Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F40242935;
	Fri, 17 Oct 2025 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714570; cv=none; b=jL6x0Nbdr/Z3PcrXB85ly3Dkt7Dg+bbgRgl51ofnGlQ4D+m4mReaXyKygRSHw4Z4L/Ml7T47gmVfdzVNaglU8SVSSd2QneInM5GGzTN0imtZfjIOyFdo5z+at03auDPQshfk4+bZXgonL/gh22Ls49m871YnSAyAZ2yiQ0AXUJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714570; c=relaxed/simple;
	bh=tJ1YVDi6JQyRekZDsGJ4FUfNltpvNAIhtKw0uKVZAQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvebIfUPglyiQKrjMjjcMHstXcY52wiQsfnNvxO62gGa3yvy1F5Wr0K6dVd+4f9nnxpJAJIXcW0oztOW/752GKL2UW0Qmu2zNWIsRUdjPw4yr2aw91PNHsvNKy48oqh1aAlwewhKahpPNoDBVZx9oAnPEhKzwUSqgBo5hqJlF98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5nJ6f4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5nJ6f4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5368BC4CEE7;
	Fri, 17 Oct 2025 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714570;
	bh=tJ1YVDi6JQyRekZDsGJ4FUfNltpvNAIhtKw0uKVZAQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5nJ6f4qiMffYLCObDCF+hhqZOcPESTzRzQ0zgWSvkkfzp/i31GxRGb8E4tVyR1id
	 Bxr7UuW4vOLE2ilETjwxei2nFv/ZoG6AtKPmoFRjw6VJv8U7UrFSd3HobPonVambDN
	 DOWElxRIvhpIK4zi0+tf/mxbLPC09BonYgA7af4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 191/277] spi: cadence-quadspi: Flush posted register writes before DAC access
Date: Fri, 17 Oct 2025 16:53:18 +0200
Message-ID: <20251017145154.095336018@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -712,6 +712,7 @@ static int cqspi_read_setup(struct cqspi
 	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
 	reg |= (op->addr.nbytes - 1);
 	writel(reg, reg_base + CQSPI_REG_SIZE);
+	readl(reg_base + CQSPI_REG_SIZE); /* Flush posted write. */
 	return 0;
 }
 
@@ -1034,6 +1035,7 @@ static int cqspi_write_setup(struct cqsp
 	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
 	reg |= (op->addr.nbytes - 1);
 	writel(reg, reg_base + CQSPI_REG_SIZE);
+	readl(reg_base + CQSPI_REG_SIZE); /* Flush posted write. */
 	return 0;
 }
 



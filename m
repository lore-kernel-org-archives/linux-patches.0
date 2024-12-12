Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CD8222D74;
	Thu, 12 Dec 2024 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020272; cv=none; b=u/e1ecVW+61n9TfJa1eH1S1OmkNKaXa/+wTUIhDP/ccki/xI4SPZQVkRFIibDFXCTGzfnkwBtOwldpTaeix3BYaXE09hpv0Ila8WzU+w0/6r6dUA45e4L9RW1X+CtNzfp7COjKaIIAPSsB2dhpyaFs0zJa7g/Rx9pKRIF8cOe58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020272; c=relaxed/simple;
	bh=4ZxFQWY9J3qyDv/t6j0Pma8/wwdo3V0aVshGOOr5dPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmAxy7Z0KZmL1fNUiZTcJ+Wn9dd96HzYtZEY891HBa4mF/9tWKUBlUBShi+Focdy0FI4IahBpRFrAv5oAy8DSiGxyfM4CR4ieXP0Vz0LiOtuvkejaZmzFH7ZHhA0rG+div+lpxewHS0lJqv1VDAyjp15GvdpZfVKU7p0CeQm8jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIynLEEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIynLEEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A4DC4CECE;
	Thu, 12 Dec 2024 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020272;
	bh=4ZxFQWY9J3qyDv/t6j0Pma8/wwdo3V0aVshGOOr5dPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIynLEEuBOrpnCqnEW2pZbN+iqDbBP2O/9/t06zMjWIB7FWzu6JjWHFxWNWUWj/68
	 qcImPvABQ65aDpT/m1YHf2T6+rilv0CRywpW/BSECXxCJ31w1yxyRnf5eOUKE10/oF
	 e73WF6MIkx+wCc6mk55Z2gactZOJZytdwOmmKY5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Cheng Ming Lin <chengminglin@mxic.com.tw>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 6.1 393/772] mtd: spi-nor: core: replace dummy buswidth from addr to data
Date: Thu, 12 Dec 2024 15:55:38 +0100
Message-ID: <20241212144406.153780656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Ming Lin <chengminglin@mxic.com.tw>

commit 98d1fb94ce75f39febd456d6d3cbbe58b6678795 upstream.

The default dummy cycle for Macronix SPI NOR flash in Octal Output
Read Mode(1-1-8) is 20.

Currently, the dummy buswidth is set according to the address bus width.
In the 1-1-8 mode, this means the dummy buswidth is 1. When converting
dummy cycles to bytes, this results in 20 x 1 / 8 = 2 bytes, causing the
host to read data 4 cycles too early.

Since the protocol data buswidth is always greater than or equal to the
address buswidth. Setting the dummy buswidth to match the data buswidth
increases the likelihood that the dummy cycle-to-byte conversion will be
divisible, preventing the host from reading data prematurely.

Fixes: 0e30f47232ab ("mtd: spi-nor: add support for DTR protocol")
Cc: stable@vger.kernel.org
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Cheng Ming Lin <chengminglin@mxic.com.tw>
Link: https://lore.kernel.org/r/20241112075242.174010-2-linchengming884@gmail.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -90,7 +90,7 @@ void spi_nor_spimem_setup_op(const struc
 		op->addr.buswidth = spi_nor_get_protocol_addr_nbits(proto);
 
 	if (op->dummy.nbytes)
-		op->dummy.buswidth = spi_nor_get_protocol_addr_nbits(proto);
+		op->dummy.buswidth = spi_nor_get_protocol_data_nbits(proto);
 
 	if (op->data.nbytes)
 		op->data.buswidth = spi_nor_get_protocol_data_nbits(proto);



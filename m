Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF8614F9F4;
	Fri,  6 Dec 2024 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498180; cv=none; b=TGwJfGz2doUg8zCLrlqFzEPKKkk1/rq18IGqtnqOuTUJNtJR0JrnB7AMWgGT9XVDGjlbZZdZojw8Q2WWBvKjvnh6u48EOyoLb032nENlEXO7vPIObSjNy6GyqG1EatuL+je8Fo41LIjjoZFMKS3WGpY11OJxJ5ydw9xxv7esYmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498180; c=relaxed/simple;
	bh=VvDi/DZdjWBvMCM9MsOv0mLI+gM2sZrMlKt4m4EdZFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjvfyjTg6NaDsP2wD1H+HHis3FG9QUbxpLXk7idDCwmu4bYUEK5F0BeXwHUcLuOJQLdjjTOUAHRak2n9TTmp3QsUFkgwgDYx3VDYrSbjQsbq0P0IwckmgWoJJQq4lO8BsgLo//hG82rPBlu1F117UBV8pr6k3E0AsIHDYJgxSRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a98YREiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a98YREiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D02BC4CED1;
	Fri,  6 Dec 2024 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498180;
	bh=VvDi/DZdjWBvMCM9MsOv0mLI+gM2sZrMlKt4m4EdZFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a98YREiwdTSeE70gfI1dlQa/w6NxvHiSLqu/fcYv4AIKFR5hLyFeAwUcbFyOru17K
	 HAqUlPt/D+4EOue9aehvhuQqsVqln94581o7+bwdZK9kUw9m+KjeYaLGUX61EvmYef
	 a0gumWqn6paR47B5hMqbTekQRUt6cQmCmBBZ+rag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Cheng Ming Lin <chengminglin@mxic.com.tw>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 6.6 508/676] mtd: spi-nor: core: replace dummy buswidth from addr to data
Date: Fri,  6 Dec 2024 15:35:27 +0100
Message-ID: <20241206143713.197828463@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
@@ -89,7 +89,7 @@ void spi_nor_spimem_setup_op(const struc
 		op->addr.buswidth = spi_nor_get_protocol_addr_nbits(proto);
 
 	if (op->dummy.nbytes)
-		op->dummy.buswidth = spi_nor_get_protocol_addr_nbits(proto);
+		op->dummy.buswidth = spi_nor_get_protocol_data_nbits(proto);
 
 	if (op->data.nbytes)
 		op->data.buswidth = spi_nor_get_protocol_data_nbits(proto);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2761F540C;
	Tue, 21 Jan 2025 18:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482615; cv=none; b=IJX23bktiMHf8HfsXexcYT6AhgwpHKLfsstuYk0a2VXgqHm47yHjaUj2CQ4JCQ77jEDdDRzjQvnOhY5QNqv+YptvU5BYPoF/DDrELmRVAynou481bnEwLC2JBTT+Q7qdnP4IT66TePeKNFNBClKQxWdjBZD/CylMBaLlbRY0k0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482615; c=relaxed/simple;
	bh=Y1Px4Zm6HKkJk+isPKGR5GIxWTKIyhfleKZCQUGyVr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwzOy3MbhLIaknO/iUNbdoqd3hebBNX8h4qGamegKpdrjuAlJaJNWACO6/4q8NFxivJQ5085NUwsEuYGTqmRhL2z6J9m8N28tn9w7pAp+RaJLcq4A6kVKAxj3o+WoempluwhDbtiVrZeTJPn4uZWJ9iJLH5N372ZsDdclw2Ze6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZC8VF5hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZC8VF5hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F6BC4CEDF;
	Tue, 21 Jan 2025 18:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482615;
	bh=Y1Px4Zm6HKkJk+isPKGR5GIxWTKIyhfleKZCQUGyVr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZC8VF5hbkeSiaZT4Ai5BSlv5ef/ZWqCjq0cSpi7x2nSwP7Cp8F517I+Yx7D8JMXPP
	 1ug0lhjAL1su0ZiLYRN5QT177qumK+/xZD4KmhBM9/lQlwg6o9+ulK9bP0oNvjNqGJ
	 en5JQsuhjdSoAqWb5FPdUHQ2wm2zgT7d5s4Za4EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/64] Revert "mtd: spi-nor: core: replace dummy buswidth from addr to data"
Date: Tue, 21 Jan 2025 18:52:14 +0100
Message-ID: <20250121174522.142225498@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit d15638bf76ad47874ecb5dc386f0945fc0b2a875 ]

This reverts commit 98d1fb94ce75f39febd456d6d3cbbe58b6678795.

The commit uses data nbits instead of addr nbits for dummy phase. This
causes a regression for all boards where spi-tx-bus-width is smaller
than spi-rx-bus-width. It is a common pattern for boards to have
spi-tx-bus-width == 1 and spi-rx-bus-width > 1. The regression causes
all reads with a dummy phase to become unavailable for such boards,
leading to a usually slower 0-dummy-cycle read being selected.

Most controllers' supports_op hooks call spi_mem_default_supports_op().
In spi_mem_default_supports_op(), spi_mem_check_buswidth() is called to
check if the buswidths for the op can actually be supported by the
board's wiring. This wiring information comes from (among other things)
the spi-{tx,rx}-bus-width DT properties. Based on these properties,
SPI_TX_* or SPI_RX_* flags are set by of_spi_parse_dt().
spi_mem_check_buswidth() then uses these flags to make the decision
whether an op can be supported by the board's wiring (in a way,
indirectly checking against spi-{rx,tx}-bus-width).

Now the tricky bit here is that spi_mem_check_buswidth() does:

	if (op->dummy.nbytes &&
	    spi_check_buswidth_req(mem, op->dummy.buswidth, true))
		return false;

The true argument to spi_check_buswidth_req() means the op is treated as
a TX op. For a board that has say 1-bit TX and 4-bit RX, a 4-bit dummy
TX is considered as unsupported, and the op gets rejected.

The commit being reverted uses the data buswidth for dummy buswidth. So
for reads, the RX buswidth gets used for the dummy phase, uncovering
this issue. In reality, a dummy phase is neither RX nor TX. As the name
suggests, these are just dummy cycles that send or receive no data, and
thus don't really need to have any buswidth at all.

Ideally, dummy phases should not be checked against the board's wiring
capabilities at all, and should only be sanity-checked for having a sane
buswidth value. Since we are now at rc7 and such a change might
introduce many unexpected bugs, revert the commit for now. It can be
sent out later along with the spi_mem_check_buswidth() fix.

Fixes: 98d1fb94ce75 ("mtd: spi-nor: core: replace dummy buswidth from addr to data")
Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Closes: https://lore.kernel.org/linux-mtd/3342163.44csPzL39Z@steina-w/
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index e82ed9d5c6564..a9000b0ebe690 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -90,7 +90,7 @@ void spi_nor_spimem_setup_op(const struct spi_nor *nor,
 		op->addr.buswidth = spi_nor_get_protocol_addr_nbits(proto);
 
 	if (op->dummy.nbytes)
-		op->dummy.buswidth = spi_nor_get_protocol_data_nbits(proto);
+		op->dummy.buswidth = spi_nor_get_protocol_addr_nbits(proto);
 
 	if (op->data.nbytes)
 		op->data.buswidth = spi_nor_get_protocol_data_nbits(proto);
-- 
2.39.5




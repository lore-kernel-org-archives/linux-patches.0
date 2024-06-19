Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FA0143C4E;
	Wed, 19 Jun 2024 13:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803318; cv=none; b=iCtgMCabyaqmk/NY3h5nGPOZnmNZS7OB7fZEPnSZR0oBX4s4IWcxsWxWkwuhAsL+D8JGQzNp2Tygu54Su+E/sC4fMTinuuOuqgUhxyat8oyjmfdkd7pyiAnIbWJnG6qbzFspPkMWroj7un+d2Dv6WPUg/LvlvdMBUjERL2ehs8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803318; c=relaxed/simple;
	bh=WeyppNck/XFhEF6RXfbDxmBZyitB8+AJTd2n8ryNrYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkSNSsk0GZw29sNPfxFTcOMIs4jL9YFUbNGmL6SjfU6ZRUFbIEObQv6HyjOSFGMbgqB9kURwXlOg2SNV64n9bJw+GaqTVAsytDGdBk0GOv+3xLfPe7fXIZ+2cgn8qaraM4cDqvNDcoDBsul9LmEVaj8fSF9ll1RARSNGSmRVkzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMumCPj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMumCPj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B341C2BBFC;
	Wed, 19 Jun 2024 13:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803317;
	bh=WeyppNck/XFhEF6RXfbDxmBZyitB8+AJTd2n8ryNrYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMumCPj+ngbKs/EGIIiIfa47vrUdt1CuU39nehLKchPgVpAou7uK5/g9ekRB4ZI9C
	 6j+Xc7fedfT3UYMNWNtYNJG5vtIsjWTQ4PfEHsEesInnleKc3vu9VCzm+c/m7CVwQ4
	 j44DCIMkIEtNXxxKwjVcuGFFycKkz8drU5ps//ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.9 227/281] null_blk: Print correct max open zones limit in null_init_zoned_dev()
Date: Wed, 19 Jun 2024 14:56:26 +0200
Message-ID: <20240619125618.693390877@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 233e27b4d21c3e44eb863f03e566d3a22e81a7ae upstream.

When changing the maximum number of open zones, print that number
instead of the total number of zones.

Fixes: dc4d137ee3b7 ("null_blk: add support for max open/active zone limit for zoned devices")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20240528062852.437599-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/zoned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -113,7 +113,7 @@ int null_init_zoned_dev(struct nullb_dev
 	if (dev->zone_max_active && dev->zone_max_open > dev->zone_max_active) {
 		dev->zone_max_open = dev->zone_max_active;
 		pr_info("changed the maximum number of open zones to %u\n",
-			dev->nr_zones);
+			dev->zone_max_open);
 	} else if (dev->zone_max_open >= dev->nr_zones - dev->zone_nr_conv) {
 		dev->zone_max_open = 0;
 		pr_info("zone_max_open limit disabled, limit >= zone count\n");



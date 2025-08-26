Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEB4321F30;
	Tue, 26 Aug 2025 11:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207830; cv=none; b=Wsxh7b6vZ9pRvGBnzF6Ly5hI6YADsVZ+1SRQvi76XnQb4GdnU8UqaWbo1Ii6I7fT6JntE9sUn62vpXW4kO1OMSnjPYni9BMAebdSZFOgG8iWd0f15eSlqVfP1xHDBuTJX4lhe6D7qFAe++/w6G4K4HBtZPPSTMwaNLfBSgAG7rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207830; c=relaxed/simple;
	bh=whFOSnS7CpLAfSw9fcyHwKsej0FrfFGpbhC/Fy1ACn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzAiZmAevc7mwH4LdoKAbjdc+LrLcoKrRaOiu/km3jwZ4xcF9wWs6MDufNfNnJqzBI4y2g4Kq3K676Pgqy5wnCaZIGqGyQ+tdIWqNFsIW1Jv/FAR8shnUkSEX503B2p5tceNPrp05LhG59OoHOl29kvSHjQWKsjMnMh5fto7xxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MW5cyQjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MW5cyQjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C55C4CEF1;
	Tue, 26 Aug 2025 11:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207830;
	bh=whFOSnS7CpLAfSw9fcyHwKsej0FrfFGpbhC/Fy1ACn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MW5cyQjW65QoNAJw7wKfttgUnjPyId/GU7uiJM4H9COvNUksg+hkX83FqOT4rPUED
	 rDyplh52YffJ/FppyqNJzeUTxTZOj+XFEwe2V5Lxv/DAoyISqxqbphm/u1KCWyq+mz
	 bKsaJ6Bh2arlPxT4rcDPGRti77hYhJhTd32H+R+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Guo <alexguo1023@gmail.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sven Eckelmann <sven@narfation.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.16 333/457] i2c: rtl9300: Fix out-of-bounds bug in rtl9300_i2c_smbus_xfer
Date: Tue, 26 Aug 2025 13:10:17 +0200
Message-ID: <20250826110945.567282136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Guo <alexguo1023@gmail.com>

commit 57f312b955938fc4663f430cb57a71f2414f601b upstream.

The data->block[0] variable comes from user. Without proper check,
the variable may be very large to cause an out-of-bounds bug.

Fix this bug by checking the value of data->block[0] first.

1. commit 39244cc75482 ("i2c: ismt: Fix an out-of-bounds bug in
   ismt_access()")
2. commit 92fbb6d1296f ("i2c: xgene-slimpro: Fix out-of-bounds bug in
   xgene_slimpro_i2c_xfer()")

Fixes: c366be720235 ("i2c: Add driver for the RTL9300 I2C controller")
Signed-off-by: Alex Guo <alexguo1023@gmail.com>
Cc: <stable@vger.kernel.org> # v6.13+
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250810-i2c-rtl9300-multi-byte-v5-1-cd9dca0db722@narfation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-rtl9300.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/i2c/busses/i2c-rtl9300.c
+++ b/drivers/i2c/busses/i2c-rtl9300.c
@@ -281,6 +281,10 @@ static int rtl9300_i2c_smbus_xfer(struct
 		ret = rtl9300_i2c_reg_addr_set(i2c, command, 1);
 		if (ret)
 			goto out_unlock;
+		if (data->block[0] < 1 || data->block[0] > I2C_SMBUS_BLOCK_MAX) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
 		ret = rtl9300_i2c_config_xfer(i2c, chan, addr, data->block[0]);
 		if (ret)
 			goto out_unlock;



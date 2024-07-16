Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD8D1DDCE;
	Tue, 16 Jul 2024 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146197; cv=none; b=NUbKflYS6coaM8QqhDawRK1XPxFQQSp0fKmIOhTHjfwOoVE5htvPw2EXqM5BJZ5S2l6FX0veLKeGdR7365bjlISbdrd7QRzMBAkQ/ZhF8L7sNC0aY5e9cKLYQZKFCpeHHYBfVFg1EvAnQx46h7AkmhRQ+YI8JFVeW0vsvldH7sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146197; c=relaxed/simple;
	bh=mYT6dJadN6eQ6fxJDA5ZPkEDQJOTzJR2b8ZIrzENMPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iElWJENEW2aCObfeK2W7JGSmfbj/ZoInedG5daWoyxKtSn1rP+zym4Kgv9NmJvtrV3osbOQf91/oQkwr7s4cYeBzJCVu75YdsGkDLXex0nffXqCAY3kJgQPQJXUeNOlOC7xHZ5yaXwuQFvVSNq5PmwEo1vsZ07x6CZvwPJTcanI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXRX9b04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXRX9b04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E7AC116B1;
	Tue, 16 Jul 2024 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146197;
	bh=mYT6dJadN6eQ6fxJDA5ZPkEDQJOTzJR2b8ZIrzENMPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXRX9b04Lvo6TLXeqiJdVFvdyCs7O5AdKAwKZ6tivblr7j/AQN1D0iNiaSRcq+vxV
	 /gQ9EY6xi+NM2Qgu3uPMKEpjsTmKnPA0ZOS13S99DdBnlOu+cdhOkFVY2kAoA6PuS7
	 gw2QOsjJXdhGXCX5JVB080WE21/rIfnorblk0qD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 060/144] mtd: rawnand: rockchip: ensure NVDDR timings are rejected
Date: Tue, 16 Jul 2024 17:32:09 +0200
Message-ID: <20240716152754.854734313@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

commit b27d8946b5edd9827ee3c2f9ea1dd30022fb1ebe upstream.

.setup_interface first gets called with a "target" value of
NAND_DATA_IFACE_CHECK_ONLY, in which case an error is expected
if the controller driver does not support the timing mode (NVDDR).

Fixes: a9ecc8c814e9 ("mtd: rawnand: Choose the best timings, NV-DDR included")
Signed-off-by: Val Packett <val@packett.cool>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240519031409.26464-1-val@packett.cool
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/rockchip-nand-controller.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/rockchip-nand-controller.c
+++ b/drivers/mtd/nand/raw/rockchip-nand-controller.c
@@ -421,13 +421,13 @@ static int rk_nfc_setup_interface(struct
 	u32 rate, tc2rw, trwpw, trw2c;
 	u32 temp;
 
-	if (target < 0)
-		return 0;
-
 	timings = nand_get_sdr_timings(conf);
 	if (IS_ERR(timings))
 		return -EOPNOTSUPP;
 
+	if (target < 0)
+		return 0;
+
 	if (IS_ERR(nfc->nfc_clk))
 		rate = clk_get_rate(nfc->ahb_clk);
 	else



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994BA1C687;
	Mon,  4 Mar 2024 21:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588070; cv=none; b=j/uUmdVMF+yYVT3DxfAMxf/FZZfA6rnIoWHdzfEb/PFxJy28SoxGeoKLDgQ6Nh+VTWGzJpC1PeiwFKwPEaN1WHO1qQ7IU5vy6hJp35rrQnSL6vd+NRobK5nbI61dTDFHJKyM4q3+y8lAmuGqDNdJA6rvLlAIt86V7srOA3mB3e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588070; c=relaxed/simple;
	bh=GcaKPwPJpjo2njfe60qvqSJ2cA8XHbsRhYjUPH0b6y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHwuSWHgYT2RxS/JC5hD0t7dFN21JJuVAYQfkdNOYgO9s258w6HENLmZ2IHXvQOgIokzE7WrxbkE1uIx74+tHYy5/Vhy5Cq1mu9iWsKql9ix26AfEAxwSe9KQAT72QYjTRVjWgug42vss9BgqH9cTMNbajLwLgSqGgfrjuLb5Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4bplZzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4bplZzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFF8C433C7;
	Mon,  4 Mar 2024 21:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588070;
	bh=GcaKPwPJpjo2njfe60qvqSJ2cA8XHbsRhYjUPH0b6y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4bplZzrmVs/ZP08cfouZ9VFzx8v1hB0x1oecTEFnjDQvizGXRgiF1MUJGuroOslJ
	 Kflp7bT0W2y2s/5oRN+RwTqDU7Sa1Nuvh1XMQxoLjzw2OAJ9uxfwXx3AsA3QmEddnX
	 co010Uw5K/yK1lW8lTr4m/rr56FsnHx5KMS28Qj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Peter Korsgaard <peter@korsgaard.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/42] net: usb: dm9601: fix wrong return value in dm9601_mdio_read
Date: Mon,  4 Mar 2024 21:23:37 +0000
Message-ID: <20240304211537.987910802@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit c68b2c9eba38ec3f60f4894b189090febf4d8d22 ]

The MII code does not check the return value of mdio_read (among
others), and therefore no error code should be sent. A previous fix to
the use of an uninitialized variable propagates negative error codes,
that might lead to wrong operations by the MII library.

An example of such issues is the use of mii_nway_restart by the dm9601
driver. The mii_nway_restart function does not check the value returned
by mdio_read, which in this case might be a negative number which could
contain the exact bit the function checks (BMCR_ANENABLE = 0x1000).

Return zero in case of error, as it is common practice in users of
mdio_read to avoid wrong uses of the return value.

Fixes: 8f8abb863fa5 ("net: usb: dm9601: fix uninitialized variable use in dm9601_mdio_read")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Peter Korsgaard <peter@korsgaard.com>
Link: https://lore.kernel.org/r/20240225-dm9601_ret_err-v1-1-02c1d959ea59@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/dm9601.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index 5aad26600b03e..9b7db5fd9e08f 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -231,7 +231,7 @@ static int dm9601_mdio_read(struct net_device *netdev, int phy_id, int loc)
 	err = dm_read_shared_word(dev, 1, loc, &res);
 	if (err < 0) {
 		netdev_err(dev->net, "MDIO read error: %d\n", err);
-		return err;
+		return 0;
 	}
 
 	netdev_dbg(dev->net,
-- 
2.43.0




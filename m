Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4541C6AB;
	Mon,  4 Mar 2024 21:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589184; cv=none; b=SmKCQswaNAuQC0zHknRgpUF6HGiZn/Av+A5bm9RUyV4PYANJcrpwvAvUsZLDyCSzdsa1pbmyQjbRFYyjlaDxwwAPhZxrUpF5pPneUcA9vaYwd7ZgZCr6iinvyTt+XRjiYRMGTzm8QtTzf1rdXDseesdlY0ZQZxQqAfOncf2o47c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589184; c=relaxed/simple;
	bh=Ls8lR0TshEflgtA+J/sIXzKN+9O7kw8KMqUfmPw5Amg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZWKjmksYL+Mf9oihTd0wZrZrsdZ1wg5D0cEcPbmpmTAE7f0YXyxkGWTXiuGrQRwyAAjJThHlUQJQzyBwIfFF0YX9bl9tkK0uHRLzlE/K3IIR9t9sxmBu13v1xwGoV4GuJWHL5a5JW9ZVWi3tTRFkaciYA0I0qdUFTxam7r6GSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cE4fCi4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cE4fCi4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0113FC433C7;
	Mon,  4 Mar 2024 21:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589184;
	bh=Ls8lR0TshEflgtA+J/sIXzKN+9O7kw8KMqUfmPw5Amg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE4fCi4mJsXlVObf+KfIhpP9rPhwuMPN5OzoLJCwLTNbgVegeYP6bjesQ1N1Y9VYK
	 pD047vSZFk2X9RdQXJMHzD3nVh4DS31HyOtHZ8yIMzNqnk5oSX8Kg4/qEw1cQ/1Kmr
	 nxUDpcIlwU9irOHWvQ9+H59J4ZSzdus56tj/mrYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Peter Korsgaard <peter@korsgaard.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/84] net: usb: dm9601: fix wrong return value in dm9601_mdio_read
Date: Mon,  4 Mar 2024 21:23:45 +0000
Message-ID: <20240304211542.756525600@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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
index 1959e12a3ff8a..f7357d884d6aa 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -232,7 +232,7 @@ static int dm9601_mdio_read(struct net_device *netdev, int phy_id, int loc)
 	err = dm_read_shared_word(dev, 1, loc, &res);
 	if (err < 0) {
 		netdev_err(dev->net, "MDIO read error: %d\n", err);
-		return err;
+		return 0;
 	}
 
 	netdev_dbg(dev->net,
-- 
2.43.0




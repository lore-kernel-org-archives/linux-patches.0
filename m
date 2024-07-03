Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED45C16C6A8;
	Wed,  3 Jul 2024 11:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004775; cv=none; b=mP904evl9rGKMZDHkN8FBPZ+efJ9s8y87k+fjgXpJtF9D1MJqm8kYdY2jqoOA18AJwxEwnKm+/mt4iM1a3vdDdh120YrKc4G7YxPBUdkTkXPG9xy+q357u6gQqbbL3wZyFnG7/xDnceGkx8+C2yBiwEBpsXO56WYcVvAVrrmj1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004775; c=relaxed/simple;
	bh=YdOGR/xkAksvrcdQi+HLBrGaasbGIzjBUhVhnbyaO2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdCB9dnIOUXtNHQLSLPCy4G/SenLk8VroFAAtTZutfyaRUhYT8ah+f37aL7szcc/gGx/Q6SSwvFqTylbeaaxFUPNnGxaojKQrq5naW8s+7cAoUl6E7+hf28U1CZul0AcCtvM58X/lgVqB6pNgEYfP3FKOuaPE7b7F3WusywjYuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3Ok2mkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3Ok2mkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E64BC2BD10;
	Wed,  3 Jul 2024 11:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004774;
	bh=YdOGR/xkAksvrcdQi+HLBrGaasbGIzjBUhVhnbyaO2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3Ok2mkEoHktXV2bWtT1UY8dEOa5V/qKwerLm4cHQGieG2vvOTrYr+//xHzlBVita
	 hChKLiLyn0RsrO5ZPGlo/oMRQi+RiM/RHzndt4LRS6iXVJ5Vtzs17OK/6otQEgqLlr
	 lAk0T6PrlHmO9tnOxs+c6moltUWqPt8lysoEKbaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/290] net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings
Date: Wed,  3 Jul 2024 12:38:54 +0200
Message-ID: <20240703102909.959898097@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit fba383985354e83474f95f36d7c65feb75dba19d ]

This functions retrieves values by passing a pointer. As the function
that retrieves them can fail before touching the pointers, the variables
must be initialized.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20240619132816.11526-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index bf8a60533f3e7..d128b4ac7c9f0 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -778,7 +778,8 @@ static int rtl8150_get_link_ksettings(struct net_device *netdev,
 				      struct ethtool_link_ksettings *ecmd)
 {
 	rtl8150_t *dev = netdev_priv(netdev);
-	short lpa, bmcr;
+	short lpa = 0;
+	short bmcr = 0;
 	u32 supported;
 
 	supported = (SUPPORTED_10baseT_Half |
-- 
2.43.0




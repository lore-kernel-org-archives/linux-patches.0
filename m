Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA4624B34;
	Tue, 25 Jun 2024 09:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309124; cv=none; b=o/WqL63P/5EHD7XUzKW0gXvKP22N1JzsqZIDP9e53zOstqGZJmibswWPRfy0TsEjUPv6MoG6PwpbiirMKpCn1UP6WK4krupkpG5sh4dmAtMnPLkQELiTGlXCUZTm+LoForLLBWRVRqc3/aryh5vOwo27g+xbqTpxbwgA+/hseeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309124; c=relaxed/simple;
	bh=JvBXihk22MuBiBkt7GbOFuOwgthZ/xBM3ijCaYzFJrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu4b4YUSlfUbvbvI3Aa82Gtvghlh9XtDUVg/cGiJKMLWEGke3znzqTVh9vTiBOpAftAhxNcPRbk74m9YwxpT/uyFkov1DrznT1KcQuPicAvtWMuy2k5fWzzJ9N56uMKZCZucnYBCinLD2E+BmOhG+80bcccUr5pBiFtc2e/+SkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jJGreIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jJGreIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2512AC32786;
	Tue, 25 Jun 2024 09:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309124;
	bh=JvBXihk22MuBiBkt7GbOFuOwgthZ/xBM3ijCaYzFJrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jJGreIEp0TM2Ea2GzyQKdjm/PYNFsxXzYthqt0txfNO5H93dm7TtpH3yzpP44Q2P
	 HK+BXTDor92e+wsfrOmOfvSc3MQVR2INZtFAR8wmX0tzdJuX3Gj99TXi8aL6G2tzRN
	 3xGT17PBQnbZFqFpeMnDQ4UBBw5SQ6ZMc5Mo5kjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/192] net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings
Date: Tue, 25 Jun 2024 11:32:55 +0200
Message-ID: <20240625085541.130872769@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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
index 97afd7335d868..01a3b2417a540 100644
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




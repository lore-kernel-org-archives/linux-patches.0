Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3E32DB7A3;
	Sun,  7 Jun 2026 10:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827362; cv=none; b=eCktxT699y+DLmFQB4ux0UjGFuGVKLKdJdtzqqkMgkXyN+lMYW5u/DC0uxCAtv4951yBrX+ur/HDbyvW+TyBL4IVDwqYiTMkcZMtkcvmsI8NYog4c4q1Xqog0MoA3MAIy5DR5gNXul96LoNRAHWCJuGZ9tlp4NH4EQVL2THUElU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827362; c=relaxed/simple;
	bh=mofzdPcuOSy5bc7EYV5tIs9g6CpK+xyEwVPZnnbKFrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTMSB6J0l5CcqmzayWlSm+zpQnSkqIJdlik3UbC2kMsBQ6u367fjl1+zS1l4IEQk4e7h7K34mkY6jUffbVnn4ovntVUQR3Si3vWOC9YSutjxzt18c3+6zQ5UEJhJdwLfYNEMwhjDDp9iRl0gJy3FUYSstUeY8GAoL2Ahk8COWLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zp9bk0UW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zp9bk0UW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23BF1F00893;
	Sun,  7 Jun 2026 10:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827361;
	bh=17lJEl5vNYP9TDsomidzSgCJLpU60Q/SERjlBPhxmKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zp9bk0UWPvcPDtpHGUd1peNTgXuRVjn5gu4ZWzm/AF9IiUTMGClfcCM2M8+CwyyyQ
	 XXbVjJjwZdYfi2VGXaRdc2yd4taKUPDSF/klAFAafMfS5dPR/3K3JodrLtbHlji0gC
	 cNFtHqNVOg4kDt7QoL4cmc0e0+nyqLeIHLjop9fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/315] ethtool: pse-pd: fix missing ethnl_ops_complete()
Date: Sun,  7 Jun 2026 11:57:34 +0200
Message-ID: <20260607095730.074982055@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ab5bf428fb6bd361163c7247b92750d1d24ca2ed ]

pse_prepare_data() is missing ethnl_ops_complete() if
ethnl_req_get_phydev() returned an error. Move getting
phydev up so that we don't have to worry about this
(similar order to linkstate_prepare_data()).

Note that phydev may still be NULL (this is checked in
pse_get_pse_attributes()), the goal isn't really to avoid
the _begin() / _complete() calls, only to simplify the error
handling.

While at it propagate the original error. Why this code
overrides the error with -ENODEV but !phydev generates
-EOPNOTSUPP is unclear to me...

Fixes: 31748765bed3 ("net: ethtool: pse-pd: Target the command to the requested PHY")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/pse-pd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
index 24def9c9dd54bf..aa4514333d13bd 100644
--- a/net/ethtool/pse-pd.c
+++ b/net/ethtool/pse-pd.c
@@ -61,14 +61,14 @@ static int pse_prepare_data(const struct ethnl_req_info *req_base,
 	struct phy_device *phydev;
 	int ret;
 
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		return ret;
-
 	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_PSE_HEADER,
 				      info->extack);
 	if (IS_ERR(phydev))
-		return -ENODEV;
+		return PTR_ERR(phydev);
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
 
 	ret = pse_get_pse_attributes(phydev, info->extack, data);
 
-- 
2.53.0




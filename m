Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DD61E98EF;
	Sun,  7 Jun 2026 10:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827241; cv=none; b=Nk6vigk/ZwsYUrlHwK45mqIJIpapC7RpLhhEWAe8x/fma2a8M/BCbNZdlAh3KlUNd7LDqTDS91bHLY+Va8+us0sy14K5kcEzjGbVHbYmx6MVtTyrhoqGxliVw68oa99ADfuOyV3aYZ5C1JHEPVUuaR/nARxvq16QkNCdvlyXwxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827241; c=relaxed/simple;
	bh=7SB6bcsebXNSdiX5WIRANdn99P5AMcs6aWuPRFns4L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R49+t9Tr4nuQbT6U5hQwh3kdsBfJBGE5da93ibe7xzr394ZXGEVkCM82EWcMNMbdeLoGiAd+fkQjoPwvKaNxrfu/5nB/YFrRGCEAgyeVB+zU8Xi9w83wAl8RDT5SppZWnNppmyZnQN6U5Ha6A77rd0a9PzgGyeT+uNtpMUUwNeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1moymGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1moymGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F951F00893;
	Sun,  7 Jun 2026 10:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827240;
	bh=NnAID6ABZtVcON3Y/wQ7CxRS+pxQ9G2Feq7DEBxEpDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1moymGQ0xEMJMagu/uORWZnzhVYphgR2ZrFWTKM3Q5xA4cdRn5S72TSk7MkHJ2nY
	 iNpDqGU3oRK3xyfs0mKMNRZmhpzI1+UuFlsMIF9a2r4niWNFi5VZyqR/F623Jf33k/
	 Xc03qzhGidnPw9fa9vK6g6tzRoC8BK2CwT4uXoPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 075/332] ethtool: strset: fix header attribute index in ethnl_req_get_phydev()
Date: Sun,  7 Jun 2026 11:57:24 +0200
Message-ID: <20260607095730.894369854@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a8d8bef6b45bf7cc0b1f6110c5cd8d0160a9bad7 ]

strset_prepare_data() passes ETHTOOL_A_HEADER_FLAGS (3) as the header
attribute to ethnl_req_get_phydev(). This is incorrect, in the main
attr space 3 is ETHTOOL_A_STRSET_COUNTS_ONLY, not the request
header attr. The correct constant is ETHTOOL_A_STRSET_HEADER (1).

ethnl_req_get_phydev() only uses this value for the extack,
so this is not a "functionally visible"(?) bug.

Fixes: e96c93aa4be9 ("net: ethtool: strset: Allow querying phy stats by index")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-9-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/strset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index f6a67109beda1b..872ca593b97668 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -309,7 +309,7 @@ static int strset_prepare_data(const struct ethnl_req_info *req_base,
 		return 0;
 	}
 
-	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_HEADER_FLAGS,
+	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_STRSET_HEADER,
 				      info->extack);
 
 	/* phydev can be NULL, check for errors only */
-- 
2.53.0




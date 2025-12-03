Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6D730AAA6;
	Wed,  3 Dec 2025 16:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779633; cv=none; b=YMR2j4AhC7yyhQm7fMgAToTFeGBYSCY975AmIA8Mdn6ZaLU4TUeHrjGTaRWsCyf1aWPfhb2geJieQuOaHw6Jj/3WhETj9aDhWhJSevtTw4nth/D2rxuAtiXDyuVqrgSlXtRORONy98ze7oetlwslcZ4f70SZK2q91DKpdnzFOHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779633; c=relaxed/simple;
	bh=vo2RneG9Ls9c15nD/GKpseQyAFNDxbgtacaeVFIhxDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lh/fqTbU/0N5nMHBO+pV+lmmMdsd/zZJbKIffItet8NE4ZTsEFQayAFqn84n3a+nwSzNGKWA/yktVGk5tnXBb4HCODVu9qSrowbp68PPFnVPQhrh/4B6G3ksy6LDK73C40elhVo2L0OGXWK0MySkraw50Gfw/YFFJ+pXsLX1kYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZydilRk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZydilRk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43AEC4CEF5;
	Wed,  3 Dec 2025 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779633;
	bh=vo2RneG9Ls9c15nD/GKpseQyAFNDxbgtacaeVFIhxDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZydilRk2lMGGqh71Zag8uWwpiXhIfJ9sx7a4FBF5RgvzLD9CYkUGgKbaMEU6CqqmN
	 7PrgSQniHnr4VcU2xhxAB6TOcm3aiC9pdyqcFqepJ2CqMDPuPmWFxD99jdgY0WUEDJ
	 Db89mIpvDc6j31bTf8XIXucvG4HL9iS7IFuktVro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 314/568] net: dsa: b53: stop reading ARL entries if search is done
Date: Wed,  3 Dec 2025 16:25:16 +0100
Message-ID: <20251203152452.214126787@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 0be04b5fa62a82a9929ca261f6c9f64a3d0a28da ]

The switch clears the ARL_SRCH_STDN bit when the search is done, i.e. it
finished traversing the ARL table.

This means that there will be no valid result, so we should not attempt
to read and process any further entries.

We only ever check the validity of the entries for 4 ARL bin chips, and
only after having passed the first entry to the b53_fdb_copy().

This means that we always pass an invalid entry at the end to the
b53_fdb_copy(). b53_fdb_copy() does check the validity though before
passing on the entry, so it never gets passed on.

On < 4 ARL bin chips, we will even continue reading invalid entries
until we reach the result limit.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251102100758.28352-3-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 037e1c7e9f45c..bdbb873fe6eb0 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1785,7 +1785,7 @@ static int b53_arl_search_wait(struct b53_device *dev)
 	do {
 		b53_read8(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_CTL, &reg);
 		if (!(reg & ARL_SRCH_STDN))
-			return 0;
+			return -ENOENT;
 
 		if (reg & ARL_SRCH_VLID)
 			return 0;
-- 
2.51.0




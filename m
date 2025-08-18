Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD344321F4C;
	Mon, 18 Aug 2025 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523899; cv=none; b=g2uw1vmMT9DdrIqb/nMW/pXxuj/WR0dqPU89VqcGTMKy8x8K/W2fXKJEHt4l4xm5ZD0vLLJANSPFaXzRxr4guoiKw7oYjnmiqjn7IkWSuWNs6fJ0atC082YXfCbtBP3vsq45gBwKZvuhgfxyg1Q9vFvei7jDvqbj48n/FZWPnAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523899; c=relaxed/simple;
	bh=HH025KR3pGHb3vnGNsnSP24NZcODR093oVwvk4KOK5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VCT+uRYPLRBdHlFJdYc4yuauxAvmWKKxWfusyn7Tto/dy1Th+Gh/3whrYW4m/miFWmpaM779t+8th5nLdjHF0mmccAAEsa75wilh2AyjJNqy1M8q5lvnJ1y8bOZZM3wEkX0/osVIZcZcVN273ShQAUgdi9mYdWKpQDMRIWaIwNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJqxm+EP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJqxm+EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F236C4CEF1;
	Mon, 18 Aug 2025 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523898;
	bh=HH025KR3pGHb3vnGNsnSP24NZcODR093oVwvk4KOK5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJqxm+EPgCr3uMhk3e+/OSGqVG147ufuLl+iqQnHv6essHrFM1F3WPAiahHgfj59f
	 ETnH3mlWzcppFuHSAiPU+eAguWAooEbhNZCVcw/RIihpdV2iuHTNqXhua91BfAFJky
	 sERAjVzAyudpxpg3Np+jb/zZQxE2U20iAakrl/+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 307/515] net: dsa: b53: prevent SWITCH_CTRL access on BCM5325
Date: Mon, 18 Aug 2025 14:44:53 +0200
Message-ID: <20250818124510.256111237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 22ccaaca43440e90a3b68d2183045b42247dc4be ]

BCM5325 doesn't implement SWITCH_CTRL register so we should avoid reading
or writing it.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://patch.msgid.link/20250614080000.1884236-8-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 990d21fad939..bb0a5fd6a372 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -361,11 +361,12 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 
 	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, mgmt);
 
-	/* Include IMP port in dumb forwarding mode
-	 */
-	b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, &mgmt);
-	mgmt |= B53_MII_DUMB_FWDG_EN;
-	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
+	if (!is5325(dev)) {
+		/* Include IMP port in dumb forwarding mode */
+		b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, &mgmt);
+		mgmt |= B53_MII_DUMB_FWDG_EN;
+		b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
+	}
 
 	/* Look at B53_UC_FWD_EN and B53_MC_FWD_EN to decide whether
 	 * frames should be flooded or not.
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006AA471257;
	Tue, 21 Jul 2026 19:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662224; cv=none; b=MN5x6rqK0k6i/ElIXzkhMsvVveTr5Qx08ZO700X1IVXv2XQud6ZU9qTrKPPp/sc1JfN6OEchzxcL/ICY21MpnKz2eE+jMROi1rf16THHxnYm+U/uMxLMa/hMDO//ca8Oo1INTIsWttL3ZrTNsaPwxlD8cHynAbZYEtmxWfRbR5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662224; c=relaxed/simple;
	bh=/Lu8YJTgzN1nMEFA38woxA2dLwKIEDhLxyoyPSiqAjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ/pWuzH9oZxhYNwuLL4wD76BxIOOZvWujFl3SHknC6dEN3ZungYu+k3fWApPezIM3ZYj93+KLWTrQHgQXXT4NGOJsyiOn4Bp4vn0ronjCqQhvcgPubbroYU0D7p5KH3iq4TtocTGLrD1nj5dcGVTDk/IPOT0L1idP2iTuiiyRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzvYFt8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzvYFt8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149D71F000E9;
	Tue, 21 Jul 2026 19:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662222;
	bh=mVnhiY6lccuJoqv/m3CKLxCDQI3/g+rWlVf2IivNbuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzvYFt8qil9x7LD/tM3fl+a4meD5rfIfAt6zFTebo8HKoP7m+H1+sX0va7swINS6e
	 77gZ0iIRT/5+o2pY+Zck3Hfa856pVJAgXOQgrRJnC0hrv+/J3+Dd2HcSYwpD9w3IXM
	 qps8PCBpPojSWIfdq1D94klJtCOwaLnDmAGP8AHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0361/1276] net: wwan: t7xx: check skb_clone in control TX
Date: Tue, 21 Jul 2026 17:13:24 +0200
Message-ID: <20260721152454.187010904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 05f789fa90d95d5771230e78453cedff2486039d ]

t7xx_port_ctrl_tx() clones each skb fragment before passing it to the
port transmit path. The clone is used immediately to set cloned->len, so
an skb_clone() failure results in a NULL pointer dereference.

Check the clone before using it. If previous fragments were already
queued, preserve the driver's existing partial-write behavior by
returning the number of bytes submitted so far.

Fixes: 36bd28c1cb0d ("wwan: core: Support slicing in port TX flow of WWAN subsystem")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260612035613.1192486-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_port_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
index 4b23ba693f3f1d..5de2b5fb647683 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -106,6 +106,8 @@ static int t7xx_port_ctrl_tx(struct t7xx_port *port, struct sk_buff *skb)
 
 	while (cur) {
 		cloned = skb_clone(cur, GFP_KERNEL);
+		if (!cloned)
+			return cnt ? cnt : -ENOMEM;
 		cloned->len = skb_headlen(cur);
 		ret = t7xx_port_send_skb(port, cloned, 0, 0);
 		if (ret) {
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CBE3EF642;
	Tue, 17 Mar 2026 16:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765778; cv=none; b=h1LZtAzFpBw3hyz7xb2iDV87SPwR53JSp16wVGYleVhWO5qr9ktbtch6+551KYV5vTo3/498yX2m9dtDnIXjxaBryuXbJ8FnZRjRoe4yVcO7dR4mi05xvz1GEhp/ni+O/Q50DKZa5jDi3q23KvmIdm/4NUn0N5HvN2Nu5+Fxq+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765778; c=relaxed/simple;
	bh=28XDHSNyGprUfTLjKLnraY0BgsU8D2filpfr6Xhffp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WPujp5RxLGdeb1Qb5lqwlfAqXIzh6Wxwo7yg/ByP3PB5NSxaBu9ImmM35HO6/rpqpLjBtBmki4bSv/bQ0ifIp4Y+vCPeY8jsVBi78Uh//RoJpCNsItJbJI7ctqmjxaLElmSzUgru//wPqgtik8E+a+QGB3JqsnjnbnIzhC13UjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiZiSjQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiZiSjQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105C9C19424;
	Tue, 17 Mar 2026 16:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765778;
	bh=28XDHSNyGprUfTLjKLnraY0BgsU8D2filpfr6Xhffp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiZiSjQvC33iXdb8SNFn8kFcbY/Wa6kwXzuyBPLf681tYZxfD55Di+H9vFZGWGGBa
	 BqX/FtwKvWVKpiclUVrbRiEOy+5UdluxkQZhUmXq0TKQuP1GWI3c3tiI3oIh1CGg9k
	 U/525M3R7uOGRE5Vw9utR9nypVmnMeGugWXX6EnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 062/378] bnxt_en: Fix RSS table size check when changing ethtool channels
Date: Tue, 17 Mar 2026 17:30:19 +0100
Message-ID: <20260317163009.273558168@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 0d9a60a0618d255530ca56072c5f39eb58e1ed4a ]

When changing channels, the current check in bnxt_set_channels()
is not checking for non-default RSS contexts when the RSS table size
changes. The current check for IFF_RXFH_CONFIGURED is only sufficient
for the default RSS context. Expand the check to include the presence
of any non-default RSS contexts.

Allowing such change will result in incorrect configuration of the
context's RSS table when the table size changes.

Fixes: b3d0083caf9a ("bnxt_en: Support RSS contexts in ethtool .{get|set}_rxfh()")
Reported-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/netdev/20260303181535.2671734-1-bjorn@kernel.org/
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260306225854.3575672-1-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index c76a7623870be..fa452d6272e0f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -979,8 +979,8 @@ static int bnxt_set_channels(struct net_device *dev,
 
 	if (bnxt_get_nr_rss_ctxs(bp, req_rx_rings) !=
 	    bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings) &&
-	    netif_is_rxfh_configured(dev)) {
-		netdev_warn(dev, "RSS table size change required, RSS table entries must be default to proceed\n");
+	    (netif_is_rxfh_configured(dev) || bp->num_rss_ctx)) {
+		netdev_warn(dev, "RSS table size change required, RSS table entries must be default (with no additional RSS contexts present) to proceed\n");
 		return -EINVAL;
 	}
 
-- 
2.51.0




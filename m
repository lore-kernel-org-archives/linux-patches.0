Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A2C320CC3;
	Mon, 18 Aug 2025 13:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524664; cv=none; b=Ei0SrfKaj/4SJHhQ5GKt+Gj94+11orPpgqUROb8WpYne/oEfTq2V2ZldlHBMx8AHiJASUtP+iuZtFQYYdNpefYzxJPa5vL0Wfe8WvQ0i6BbrBQ/KpEPcpvFuuKWpKKr21jfPFwC9X+xi0M5vjajHEdOftU5kTlU5akkdnI5tmvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524664; c=relaxed/simple;
	bh=H9Cb2HatwdVMhYZOeAZgrSMw7ZyNu508FySmvQ+cokk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfW1uSCO0ye2qoWas0za2NH/U0Sw5FeNvccJogIJVOmJAIrk43ANCohiNzyODwU3pnXgl7vwb9Zq6LgcOy+eErduTD+tudBE5tUxpg/KHXEwkACJcCe0fGRKuKQKtqkK7xg5G5ujqXGZvWEKjGMCV9TO7o6DcR4rci3dMSdDmG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWZouown; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWZouown"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97419C4CEF1;
	Mon, 18 Aug 2025 13:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524664;
	bh=H9Cb2HatwdVMhYZOeAZgrSMw7ZyNu508FySmvQ+cokk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWZouownD51cNtCOSr4xt3GJkaELUUYsOOeL4aVn16BmNmU4Hgk2vvQd2EfAVQFXY
	 GON/VU/uwowo6QGRHz65G/k5NnHmO0+u/jPL71lVMPUPJlcHDOW1ZYu9VsLW2RKlvl
	 brYqJynGssRR1O0tryapSI7KzuCf/xShO6Xl4a2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 024/570] net: gianfar: fix device leak when querying time stamp info
Date: Mon, 18 Aug 2025 14:40:11 +0200
Message-ID: <20250818124506.738526771@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit da717540acd34e5056e3fa35791d50f6b3303f55 upstream.

Make sure to drop the reference to the ptp device taken by
of_find_device_by_node() when querying the time stamping capabilities.

Note that holding a reference to the ptp device does not prevent its
driver data from going away.

Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
Cc: stable@vger.kernel.org	# 4.18
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-4-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/gianfar_ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1466,8 +1466,10 @@ static int gfar_get_ts_info(struct net_d
 	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
 		of_node_put(ptp_node);
-		if (ptp_dev)
+		if (ptp_dev) {
 			ptp = platform_get_drvdata(ptp_dev);
+			put_device(&ptp_dev->dev);
+		}
 	}
 
 	if (ptp)



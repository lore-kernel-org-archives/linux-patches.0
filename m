Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB3822AE7A;
	Mon, 18 Aug 2025 13:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524733; cv=none; b=jXzOLmyzb3JxWYyZ86vDrtjhitIpwvW+8+a5rfVCEI6xmz7HWDpjzJ3WKoFodAjuMntKkZh6q6KnVtTPgUgZX31DZWbOdYtM7MUZ9v9k06KqSrwlK2HmkoUb2EkRGbjiMJisTjg2/svvTcKLUBlK3xTgj1gskvcYfPJJ6j0V7lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524733; c=relaxed/simple;
	bh=VWuibxRmNTMAjjnzBHzCSAKulk77zs70w1c5DhyR/0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvInZ5iylnuzbYk4TO6cDG/Nb0uGbngJ0OYiEOc0v7Jh3bFW+B3BKWBH21hRaHR+9u+uetci/bsQktsynqr+PVyxejklywWIYG+d0AzURTpFh7nOef4E1zzM/+fwmA5GzZ72QaoFEwFXPBXtqg4DUbMlTcRKO+bsHrJ/Mq7sAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOXdXmJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOXdXmJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C31C4CEEB;
	Mon, 18 Aug 2025 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524732;
	bh=VWuibxRmNTMAjjnzBHzCSAKulk77zs70w1c5DhyR/0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOXdXmJjPuHHsPEyQFalQzeNVNvtm+tLXu9Rs4EiDJ6OEH5EdqVb6LcyGzbXxl5c/
	 3Fti7bt56rjF679fks2Vvo4VFAe8xdLl1FMuBwcGaBEPzmKX6pvvrDW04VfidpbyHo
	 IiB1YyiT2JSdjsugkHfqAi5aQ6YwDwzSJ/B1KAss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 028/570] net: dpaa: fix device leak when querying time stamp info
Date: Mon, 18 Aug 2025 14:40:15 +0200
Message-ID: <20250818124506.901353194@linuxfoundation.org>
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

commit 3fa840230f534385b34a4f39c8dd313fbe723f05 upstream.

Make sure to drop the reference to the ptp device taken by
of_find_device_by_node() when querying the time stamping capabilities.

Note that holding a reference to the ptp device does not prevent its
driver data from going away.

Fixes: 17ae0b0ee9db ("dpaa_eth: add the get_ts_info interface for ethtool")
Cc: stable@vger.kernel.org	# 4.19
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-2-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -401,8 +401,10 @@ static int dpaa_get_ts_info(struct net_d
 		of_node_put(ptp_node);
 	}
 
-	if (ptp_dev)
+	if (ptp_dev) {
 		ptp = platform_get_drvdata(ptp_dev);
+		put_device(&ptp_dev->dev);
+	}
 
 	if (ptp)
 		info->phc_index = ptp->phc_index;



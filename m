Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB07D350825;
	Tue, 26 Aug 2025 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217583; cv=none; b=Whsa3c29dOFzFMzwivHbUl6q1fJ+XVP9+QqylMjbL9LU9THfMc6ceFBxaWSil/FXgKlKQ3VPI53hQ1WmA9NfdGPRdy3HGA9XWEPAlG0RBLcHX+vVMVDtyoy2FcNYjx45xIsGdOvnWFYy5P3dsBEkRPqFSBxQgdW0URsNMtRHH54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217583; c=relaxed/simple;
	bh=1aT/dFmhQxOgmoAuC5/JXhwNNBjOrn9Kp/C1HmKYUtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICRPfjtFFmIE/osqMNAFbwTFhDIb6ly2Wpk4zKNBFkFoGIvIe4hV/ydYShKKHYmisdPMGlEwM5KjpS0V3Bt33Cfu5Fd7p4anG5l4BcZErCi+9NAyHrjArzF/vJC0vz5A3FvU8+UQq5cfLKf0tz9KVtUC1rzeuK6h7gUOHgFrvUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLs65fJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLs65fJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7863CC4CEF1;
	Tue, 26 Aug 2025 14:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217582;
	bh=1aT/dFmhQxOgmoAuC5/JXhwNNBjOrn9Kp/C1HmKYUtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLs65fJjoFrCVRhKIQVgM1TAJcKJYWHv1qSVWXwwX94iOUgcZGp3Y0MWqD1qWCi9A
	 8zg6z+q8mSAKz0BbZMSG/Zcq7wFeWkZYQOzWH19C3DEjgdzUNP43cw/0etZ/9B4A7Z
	 yx90Q2giWGUfZv+1k4AvgItdpgLoDanMPTbgs5RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 196/523] net: gianfar: fix device leak when querying time stamp info
Date: Tue, 26 Aug 2025 13:06:46 +0200
Message-ID: <20250826110929.282217162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1457,8 +1457,10 @@ static int gfar_get_ts_info(struct net_d
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



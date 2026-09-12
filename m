Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD203FFABF;
	Sat, 12 Sep 2026 08:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202119; cv=none; b=aL7fr5yDvHvlXGonPJC1H8QvYS+PUTIG38w1YefW0WINEMbj9rrsWzphOBjOEd/LOBc/HJhWp2YuGiz5fKcbDbH61bOgYvfIW0Xt1hieZMjfaSQbS9IFkAEJfjbubMTn3k7XJiBmWXPtMi60AMiQaSgKDDjAIMvP98G0edYrbO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202119; c=relaxed/simple;
	bh=8xYkJoGB+hyDYW418zQVJ0+yCSLTAkEyCcRJEuicqss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJeiT/wo+VPr/S0iC82zuCZIbQn9HKGaM3zoJtBdkxCXUhSFfK2VbELtCCPm/9BgZcOBwxMBoA00pxB4iXZ5PoGg9+cSIBvBXc2iDBohAJYajyiM1h7XK8s4jVgKqvb2Xe0HHXZBYVq8JAKFVT+R6nly1lrbcN5FDEMEKWEihqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmZ9Brja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmZ9Brja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C171F000FF;
	Sat, 12 Sep 2026 08:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202117;
	bh=oH5gnpHFUVPiieZqtMsBwjNhMV6diXO8aGjgP1N1zK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmZ9Brjaw24nnedcPqlwi88JpMfSbz7qVYJatu/NYKMQ4guBLZi2ee1or2HZNOLQR
	 lWCpRFPtA8Ho1DWK97XBhXPrx7E6km8YLp7wwH/8obsPBqI+rl7CQrm+dws/TS0gPa
	 0Hpu/c/8Ara8U1rtnHinMIi+OF7dn87Onhpf67CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1135/1815] drm/sun4i: Drop node references while building component list
Date: Sat, 12 Sep 2026 08:48:05 +0200
Message-ID: <20260912065715.665328926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 08a91f2a0664b73c2af9295ecbd441e852abe33c ]

Two references are leaked every time the display pipeline is walked:
the output port node in sun4i_drv_traverse_endpoints(), which was never
released since the driver was introduced, and each node taken out of
the endpoint fifo in sun4i_drv_probe(), which stopped being released
when the fifo was introduced. The latter is still safe to drop right
after processing, since drm_of_component_match_add() takes its own
reference.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Fixes: 8b11aaface2b ("drm/sun4i: Implement endpoint parsing using kfifo")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/759c74e3a22b97ca066ef7910ca4b91b852011e6.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index 8a409eee1dca5..e9baca360160b 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -289,6 +289,8 @@ static void sun4i_drv_traverse_endpoints(struct endpoint_list *list,
 
 		kfifo_put(&list->fifo, remote);
 	}
+
+	of_node_put(port);
 }
 
 static int sun4i_drv_add_endpoints(struct device *dev,
@@ -394,6 +396,7 @@ static int sun4i_drv_probe(struct platform_device *pdev)
 		/* process this endpoint */
 		ret = sun4i_drv_add_endpoints(&pdev->dev, &list, &match,
 					      endpoint);
+		of_node_put(endpoint);
 
 		/* sun4i_drv_add_endpoints can fail to allocate memory */
 		if (ret < 0)
-- 
2.53.0




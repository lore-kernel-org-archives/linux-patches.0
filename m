Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E33325490;
	Mon, 13 Apr 2026 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099357; cv=none; b=Q0awnPwSmU0SOHfokoQ7XQ8+53rvz+1gpbvW3zAQ4VQUJy4PC3B+A1lYOzHhQ3gZGj+ZiaKYB3mpz+LpuWHBMIg/Xc9sItOzUOqwVcjD2IRuz8rKvHcJCEUnuO36azybAYYI30GTxqgiOlE9yyvwA5VRuZBMlE899FZPuGl2wsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099357; c=relaxed/simple;
	bh=5n20HPf680CyKJTeMUG7qT7HE+wvkn6XQSl8Hs6NCXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOqm/Oj1L96TXpK40fhq8llarRJYfj+X+T4UthTTgjUQzIZk+xyQSXVAfx09GUNxNJYczWENfcAK74Q1lRYqJB3RJvOXb1ytpRo7Z6MM7rqdnGB6PrN+6nJkJwu7tW6awnPctZ8JAtYtlPWsZseAjvHewMvcWXGF/2sbpqUrN5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmmUVycf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmmUVycf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3216AC2BCAF;
	Mon, 13 Apr 2026 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099357;
	bh=5n20HPf680CyKJTeMUG7qT7HE+wvkn6XQSl8Hs6NCXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmmUVycfVtL3yBV3iOqy0nKDMaEPdqyY29lzvxwpgTpk9HlKjIEtdJL5YT7FZdDAx
	 pDep6iziKzXB/WmT/zzk7MtR+viLrXDZOcEZIJF54wqutsB86YihxBjZueJG4uUG//
	 HeRNG7j8ocOFuG4P8N79X1R07zoWUOUIXGa/a/00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/491] phy: ti: j721e-wiz: Fix device node reference leak in wiz_get_lane_phy_types()
Date: Mon, 13 Apr 2026 17:59:13 +0200
Message-ID: <20260413155830.572476911@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 584b457f4166293bdfa50f930228e9fb91a38392 ]

The serdes device_node is obtained using of_get_child_by_name(),
which increments the reference count. However, it is never put,
leading to a reference leak.

Add the missing of_node_put() calls to ensure the reference count is
properly balanced.

Fixes: 7ae14cf581f2 ("phy: ti: j721e-wiz: Implement DisplayPort mode to the wiz driver")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20260212-wiz-v2-1-6e8bd4cc7a4a@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-j721e-wiz.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index 5536b8f4bfd13..3c0aec368ea9f 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -799,6 +799,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 			dev_err(dev,
 				"%s: Reading \"reg\" from \"%s\" failed: %d\n",
 				__func__, subnode->name, ret);
+			of_node_put(serdes);
 			return ret;
 		}
 		of_property_read_u32(subnode, "cdns,num-lanes", &num_lanes);
@@ -811,6 +812,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 			wiz->lane_phy_type[i] = phy_type;
 	}
 
+	of_node_put(serdes);
 	return 0;
 }
 
-- 
2.53.0




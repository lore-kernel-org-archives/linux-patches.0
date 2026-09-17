Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F1F4EFFA6;
	Thu, 17 Sep 2026 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659825; cv=none; b=UaofmRoUACgzaJqkpKQQyrf3R7n+9YD7ijYK8zQ9AD6r4XR0FO7MEOs9fnaftgChkTJaq4BNjCqnx9+mN2ywzYKwy8X5pisg2ZYw6kZ+ApdwusWQu+rCFyP9VPJVngMbli44D3dL4JYqBRVZaoQ0TSO8izMVgk0//7EIlA2DAz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659825; c=relaxed/simple;
	bh=lv9Ib/lMkn317skQnwFpqe9G/b/UVHpt5LBNdI1R9m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ej036sYCTAwxrAGDOu16Fa1XZUCuFnHj9Prndjhfhp5QoSIjQ5WMMkWgxWEBQlnT7LY3qZh/pnqcr/pJ56PBZvzkOw00yXJwfSRW0DF2I7hlqqKBgKS+q6i5Y9dcN1pzHSNNEa1TLMEYBT5B5hpZWE1GAp2wvdjJwkDkXIqAifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvQRE+lf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvQRE+lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E6F1F0089B;
	Thu, 17 Sep 2026 15:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659818;
	bh=yKYrKCS5UlWEVTanjHODbF3qnXcha75VPa99Gnmt/Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvQRE+lfGTMhMfy+IKagZI+65JlpihNIpKbamKsk+wYkbJBBL1JZwivR4rzB/NP0v
	 jJb9/yZ5JALHnVj9r9UrKzth3uHNQ+9xHujka0u5WVvfU+TeOmX+FoqXvYBzZLK3Jv
	 J8aDNO+fgtR8fGHsiMBLqegljrkbwb5q+J65ZiFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 385/733] net: macb: destroy the phylink instance on the probe error path
Date: Thu, 17 Sep 2026 16:11:33 +0100
Message-ID: <20260917151401.284525413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 7d059f390750152b9bd69df934198651b94fc26d ]

macb_mii_init() creates a phylink instance on both of its success paths,
but the probe unwind frees the netdev without destroying it, so a failing
macb_alloc_tieoff() or register_netdev() leaks the instance.

Destroy it at err_out_unregister_mdio, which is only reachable once
macb_mii_init() has succeeded, so bp->phylink is valid there.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260907210856.1673589-2-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 55ed40a0a6062..404aebe01ed01 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5968,6 +5968,7 @@ static int macb_probe(struct platform_device *pdev)
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 	}
+	phylink_destroy(bp->phylink);
 
 err_out_phy_exit:
 	phy_exit(bp->phy);
-- 
2.53.0




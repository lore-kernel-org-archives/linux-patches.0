Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF30A340A70;
	Wed,  3 Dec 2025 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779342; cv=none; b=W201B5ebdcAw+x16RpTI1WFJnvGwP4QYzTkE8GsMx6QJFr6tpUdHr9lNDiE3KK+uZKQywdiy3ijo3VlSQ8i6E7g1Q3GkXsJzYcaXYWFIbYaBGU3Vn9pu11+asS8Qrc57mCWoTPFz+QALhmWDtMkDL1o1oWn5odxE3uHbje2KW7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779342; c=relaxed/simple;
	bh=Cod7trYsQT0+vPbEaMcqk5X1ZvVdsHqUjvqNFStykBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1cB3wvMy2ZbvnmoBfy48TxmcNTsGD+DnT5avevkzwbW1MA6H4DKDHJjZiJlB6+5obzWtl/uB/CJ1kgGS0fd+htLnNdIA69Q1Sdhe6h39Fjyh1PBmF76JTbnS4XxcU2m6VmOpd47LgXVIl3gvc5qqdZNidz06H99VxXS/fjeZL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfSE4Dej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfSE4Dej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE6DC4CEF5;
	Wed,  3 Dec 2025 16:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779342;
	bh=Cod7trYsQT0+vPbEaMcqk5X1ZvVdsHqUjvqNFStykBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfSE4DejqdogV6I5wZFT1Sur9eeHLIjvH5v3Bozs/FizdnFmkQ5vKr1fqdp1UiYdY
	 JtVArFwlfnEYVimIOMizk42p5vQeU5LtcEVZb1noXjn7hE+Yn8mVtMTTwoXM/K6NRQ
	 WF5lCO6EZl0NlN9XUXPj6AZqqpszR/ddQNgKEruY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/568] ethernet: Extend device_get_mac_address() to use NVMEM
Date: Wed,  3 Dec 2025 16:23:51 +0100
Message-ID: <20251203152449.108844543@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit d2d3f529e7b6ff2aa432b16a2317126621c28058 ]

A lot of modern SoC have the ability to store MAC addresses in their
NVMEM. So extend the generic function device_get_mac_address() to
obtain the MAC address from an nvmem cell named 'mac-address' in
case there is no firmware node which contains the MAC address directly.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250912140332.35395-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethernet/eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 5ba7b460cbf76..1ee90b52f9e06 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -615,7 +615,10 @@ EXPORT_SYMBOL(fwnode_get_mac_address);
  */
 int device_get_mac_address(struct device *dev, char *addr)
 {
-	return fwnode_get_mac_address(dev_fwnode(dev), addr);
+	if (!fwnode_get_mac_address(dev_fwnode(dev), addr))
+		return 0;
+
+	return nvmem_get_mac_address(dev, addr);
 }
 EXPORT_SYMBOL(device_get_mac_address);
 
-- 
2.51.0




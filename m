Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A998526B96A;
	Tue, 25 Mar 2025 12:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906295; cv=none; b=ENeqREQKxshYoFsIuo6gpqJhBkjxewPOcRfmARM3qVq5+FQgI3Rpa22QoVgrLXYS4dRTm+3bQEiS7YIBznnET+y0PftbDe4q34wCdhGqvq1aqdGsubfhjBxG2leVrJKpeUc0IrjMYwkMRAHT/FcAAQIqqr/AM+uYe5OgUKtWfOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906295; c=relaxed/simple;
	bh=HJX515fAMP2FBc5FiaW35Q6JvYrd8AVOnHdyNcFYZx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxxk8kTePhmPZ3xehtLXIXa6ytKB1I3EoE43ucVBkM04wr1Z+xCDVDIyteAdx/kB/zKzts35xTQyeTkfzwHVKG0IhRpe2+Yl69WigHpbF9vt886fZfmPkd8EIVvD6CM3q8S6MmdBECXzZ2KuhhsKLyG9J4jkB0PcMsRY9pAUw5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuX0/F3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuX0/F3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C97EC4CEE4;
	Tue, 25 Mar 2025 12:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906295;
	bh=HJX515fAMP2FBc5FiaW35Q6JvYrd8AVOnHdyNcFYZx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuX0/F3QPhiQkqngPBQWcQdbd4Yj7L+LZCdoe6/gCvs67+rJna+lER5sjlE4KxuMe
	 Up/gB8pSq3Ay0ifxk9WY0xl8i9iqw+wWOOexE27scXsOxqUJrzpJ5m/rX9i6yUj+Jz
	 +9I+kcXeYbgkqddcVW3cNxaNGwmcDuARMmPfYItU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/116] phy: fix xa_alloc_cyclic() error handling
Date: Tue, 25 Mar 2025 08:22:09 -0400
Message-ID: <20250325122150.280909942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 3178d2b048365fe2c078cd53f85f2abf1487733b ]

xa_alloc_cyclic() can return 1, which isn't an error. To prevent
situation when the caller of this function will treat it as no error do
a check only for negative here.

Fixes: 384968786909 ("net: phy: Introduce ethernet link topology representation")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_link_topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_link_topology.c b/drivers/net/phy/phy_link_topology.c
index 4a5d73002a1a8..0e9e987f37dd8 100644
--- a/drivers/net/phy/phy_link_topology.c
+++ b/drivers/net/phy/phy_link_topology.c
@@ -73,7 +73,7 @@ int phy_link_topo_add_phy(struct net_device *dev,
 				      xa_limit_32b, &topo->next_phy_index,
 				      GFP_KERNEL);
 
-	if (ret)
+	if (ret < 0)
 		goto err;
 
 	return 0;
-- 
2.39.5




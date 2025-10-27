Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6DD324B2A;
	Mon, 27 Oct 2025 18:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590589; cv=none; b=Iw+87f5T2wA/zDPCZFohHveX2Vr41ct8cxDtBXIOQHSkJA399+LXskTiVC1LfQqnYqOua1cL7OVKZh20xibh6oeLGA2ROzT3/Fb+Pk3haNipDVsvwl/8Ej5Nmia7V0GqrfxzrtFiq3i80urIpJkIVCtELLiE8nGA7j1Ek+PgjX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590589; c=relaxed/simple;
	bh=FlwamHSVFEmxQO6ExBGZQfAUt4QNn56abfOPZq/WDcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LapCd3iw6RR4kdabC8TsfUjUwFHXyM62HX0W8X/xsOgct+UeRQWBJwSAqxhWQUrZNBd+HNTzhUrdU7M1/8tXrYB7ac5hw8UnGnbHKoPHBLe20Wm76KuvXqRE6+7lgWNoXSBur23en4F8rS/8uTsAxJ2d0DTvCCw3jmOUXdxjuig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJ8rPOoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJ8rPOoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A956C113D0;
	Mon, 27 Oct 2025 18:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590589;
	bh=FlwamHSVFEmxQO6ExBGZQfAUt4QNn56abfOPZq/WDcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJ8rPOoVZURXXmbTtkQaeiSXpF8u/pfbz4wdCnvukYMzDini5gN2hrV7DY8wuEVAb
	 sPACvi6n24BxJq0lrC4iVrdH14Y94fN3X0fnwthK+RFGIvfHZ2qO99MLnzqkFsosWe
	 THp61Q3el+JZpxGLJaPv32Hm3IIY9Jb2EF1i/EIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/224] net: ena: return 0 in ena_get_rxfh_key_size() when RSS hash key is not configurable
Date: Mon, 27 Oct 2025 19:33:37 +0100
Message-ID: <20251027183510.904672408@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit f017156aea60db8720e47591ed1e041993381ad2 ]

In EC2 instances where the RSS hash key is not configurable, ethtool
shows bogus RSS hash key since ena_get_rxfh_key_size() unconditionally
returns ENA_HASH_KEY_SIZE.

Commit 6a4f7dc82d1e ("net: ena: rss: do not allocate key when not
supported") added proper handling for devices that don't support RSS
hash key configuration, but ena_get_rxfh_key_size() has been unchanged.

When the RSS hash key is not configurable, return 0 instead of
ENA_HASH_KEY_SIZE to clarify getting the value is not supported.

Tested on m5 instance families.

Without patch:
 # ethtool -x ens5 | grep -A 1 "RSS hash key"
 RSS hash key:
 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00

With patch:
 # ethtool -x ens5 | grep -A 1 "RSS hash key"
 RSS hash key:
 Operation not supported

Fixes: 6a4f7dc82d1e ("net: ena: rss: do not allocate key when not supported")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Link: https://patch.msgid.link/20250929050247.51680-1-enjuk@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index ae631b8770fc1..5f037e9db023a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -633,7 +633,10 @@ static u32 ena_get_rxfh_indir_size(struct net_device *netdev)
 
 static u32 ena_get_rxfh_key_size(struct net_device *netdev)
 {
-	return ENA_HASH_KEY_SIZE;
+	struct ena_adapter *adapter = netdev_priv(netdev);
+	struct ena_rss *rss = &adapter->ena_dev->rss;
+
+	return rss->hash_key ? ENA_HASH_KEY_SIZE : 0;
 }
 
 static int ena_indirection_table_get(struct ena_adapter *adapter, u32 *indir)
-- 
2.51.0




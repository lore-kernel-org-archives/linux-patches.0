Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97CE2FA622;
	Tue, 17 Jun 2025 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179336; cv=none; b=VeYtgRbjXaieLpBw+4aWmfqwM5CI6OV2Q8gA+5UUlw2ItxT6UCOzQBuipoLXTKuhB+ld/OiAtk8Zlkc7yue3FG8y7osOgFb5PQg3MQ3ACEy7R5LNCRsykgi0bAtaE4T/NMzjkcFe+8Qdm51xbpLc5+ruRaxE5Ikj54Ord5nhAlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179336; c=relaxed/simple;
	bh=Kj3jtTypeVWeX1Jn8XI0XCkFnwNb+UbDfl351qXKgVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDNiXBiJXESPS+zrb9wEYodDQKUP8i0jkfFWjaPXOonzQ3nHR8+qROat7hXzP1zrZMKyrBgRjF7mL3Zj0mEpdlYGOWJuVPBWUQFJchNGI45UKu109/YfURky92ytmnspaN4yHDpkXH1KGdkVUDAOwoo0yQMDPuAjcqknEmJ0fZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxdHnAJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxdHnAJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4022DC4CEE3;
	Tue, 17 Jun 2025 16:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179335;
	bh=Kj3jtTypeVWeX1Jn8XI0XCkFnwNb+UbDfl351qXKgVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxdHnAJJWcKjc9d/JB16v3VBdUrL08HKPSM9OFFpv0B58+zxr/Qsp/9UKE/kiUaB7
	 qTiiXj0snkLhKzJrTsyTwocwehKdKujOvVebf8P/+2+VCkcITFqYPfG7vHsUmSYTnr
	 4j9/hKk/3g1VlFpeJpMW9eCPjhm56EyalaI3rAB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 715/780] net/mlx5e: Fix number of lanes to UNKNOWN when using data_rate_oper
Date: Tue, 17 Jun 2025 17:27:03 +0200
Message-ID: <20250617152520.605784536@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 875d7c160d60616ff06dedb70470ad199661efe7 ]

When the link is up, either eth_proto_oper or ext_eth_proto_oper
typically reports the active link protocol, from which both speed
and number of lanes can be retrieved. However, in certain cases,
such as when a NIC is connected via a non-standard cable, the
firmware may not report the protocol.

In such scenarios, the speed can still be obtained from the
data_rate_oper field in PTYS register. Since data_rate_oper
provides only speed information and lacks lane details, it is
incorrect to derive the number of lanes from it.

This patch corrects the behavior by setting the number of lanes to
UNKNOWN instead of incorrectly using MAX_LANES when relying on
data_rate_oper.

Fixes: 7e959797f021 ("net/mlx5e: Enable lanes configuration when auto-negotiation is off")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250610151514.1094735-10-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index fdf9e9bb99ace..6253ea4e99a44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -43,7 +43,6 @@
 #include "en/fs_ethtool.h"
 
 #define LANES_UNKNOWN		 0
-#define MAX_LANES		 8
 
 void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
 			       struct ethtool_drvinfo *drvinfo)
@@ -1098,10 +1097,8 @@ static void get_link_properties(struct net_device *netdev,
 		speed = info->speed;
 		lanes = info->lanes;
 		duplex = DUPLEX_FULL;
-	} else if (data_rate_oper) {
+	} else if (data_rate_oper)
 		speed = 100 * data_rate_oper;
-		lanes = MAX_LANES;
-	}
 
 out:
 	link_ksettings->base.duplex = duplex;
-- 
2.39.5




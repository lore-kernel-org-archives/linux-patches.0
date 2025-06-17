Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069492FA639;
	Tue, 17 Jun 2025 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179326; cv=none; b=TwaEp8bJHuvo++924dLuXFxlG6QITRARpQ+Bf2d/SS/1cLGVKkvqJkwguZMqs4DlY/NRmcwhw3ZK9WmvS/f5nSamWHCl2cqNLqW7NvJ6biRvIk4X/4ky8lD1rgJAH2KM0Ol/+H0vgciRZc3MH3kRzn+gjK/xGdWFjLblv6f/PvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179326; c=relaxed/simple;
	bh=8u+pNLtVjUS91zcHFq/LSAWWA1H0+C3PLPjGo9w/iDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvuCwluP8HWUTal+ad8ZT28UoVGDyymiiMKhTaSr1kACbf/TfpLn2L5r41JCxwPGNgFPKAy202OMWpO6FpVskIO4tuuvyP8xvRamY6x2Y0/oe3EErkQeemmwQm2l2pgUR4vXqMZz0QZA86CJFS2gTqfEU7mfrKDqP5yNMDU3/IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHHQvWEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHHQvWEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A17CC4CEE3;
	Tue, 17 Jun 2025 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179325;
	bh=8u+pNLtVjUS91zcHFq/LSAWWA1H0+C3PLPjGo9w/iDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHHQvWEAUs+NnS5whRXyjL14TzaIciCfFaNnKT/mhlT0KCqjKPZSlc/OB/T6T1eGn
	 RfXWBtlpto0l1r5LHuNDE30KAxsFxIsJ0j66FGNuulOkne0lQgfFR3cLq81lsYL39d
	 XbfSV3eoN5lRp85B+jkh5CUBsjWdQUkzjy+jdxoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 712/780] net/mlx5: HWS, fix missing ip_version handling in definer
Date: Tue, 17 Jun 2025 17:27:00 +0200
Message-ID: <20250617152520.488333330@linuxfoundation.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit b5e3c76f35ee7e814c2469c73406c5bbf110d89c ]

Fix missing field handling in definer - outer IP version.

Fixes: 74a778b4a63f ("net/mlx5: HWS, added definers handling")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250610151514.1094735-6-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
index c8cc0c8115f53..293459458cc5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
@@ -559,6 +559,9 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
 	HWS_SET_HDR(fc, match_param, IP_PROTOCOL_O,
 		    outer_headers.ip_protocol,
 		    eth_l3_outer.protocol_next_header);
+	HWS_SET_HDR(fc, match_param, IP_VERSION_O,
+		    outer_headers.ip_version,
+		    eth_l3_outer.ip_version);
 	HWS_SET_HDR(fc, match_param, IP_TTL_O,
 		    outer_headers.ttl_hoplimit,
 		    eth_l3_outer.time_to_live_hop_limit);
-- 
2.39.5




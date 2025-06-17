Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3C02ED165;
	Tue, 17 Jun 2025 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178220; cv=none; b=sv37RzwbU2PmHA7wLBjFtmz8GJx4gIa2/58U0ZB4+Y9fr2RnhFX4teIFVIc+nnQXqCCbwUmxrLaOwpzXrM1uRW48k77pHzpxUvFeDINPDUbvDtva5qlBbSJRq/+RhG93f5WtUAf26D4pxXIwwFR9bOnVa7RIQ4kd56fdZu0DFH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178220; c=relaxed/simple;
	bh=DHOo6qnZZYCA3prIseip1GpmySopar0pzf0FFh2DgvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRVzRQAEUOBxBhVLl1KXGQRpYKEIIT/OMCcA518CW36oR0b/kIiL/ANYhBzsJadrQmOXwW2JzHhZ3Q9S9WcqY/G0KLUeIm61l0aQNFqJoa9gZEKARGuJqZOk/sMDn45br5UyZywCxpy9OqQpaEyF4xQdEWAVk+ozENlKUHNIfSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQQU0wxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQQU0wxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D792C4CEE3;
	Tue, 17 Jun 2025 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178219;
	bh=DHOo6qnZZYCA3prIseip1GpmySopar0pzf0FFh2DgvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQQU0wxjuVD2ScMaZNuDfH2d8a1+eE+fMdF7lD4M7BiZlLivvBoV9lyWNe8wzRTSl
	 d9BhmEGYL4L8lSJUq4Tk5IOaD4RF+JviFv+3daWnyhpyx0gvD3P5GJHS95W78Ix39y
	 onBwZ6V7I5qu1uXl+ax3/jD/1A0ve5DPr4+c4A4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 463/512] net/mlx5: HWS, fix missing ip_version handling in definer
Date: Tue, 17 Jun 2025 17:27:09 +0200
Message-ID: <20250617152438.343813704@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
 .../ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
index ab5f8f07f1f7e..72b19b05c0cf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
@@ -558,6 +558,9 @@ hws_definer_conv_outer(struct mlx5hws_definer_conv_data *cd,
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




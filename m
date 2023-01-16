Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001C246B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579A9C433D2;
	Mon, 16 Jan 2023 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885306;
	bh=quWfAdXv10+F+ADqsE8YBcbIC54+sFMQf45uTlZu8q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHgHw4/er5E4XaHmT81VnCIb96s48Ar2h89oVj0NHZtuzcwVXl23C1gbV74Y6Mstq
	 4SpciPnK+PaJesjzQTZ8+TGF/cAoK7PhtAezXRbPphyanHTlaI37kFGddW19Y+xjFz
	 FQ9d87PblHeYvbDHpMqh0k7cue+ghyvaiy2Mdn0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Li <gavinl@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/64] net/mlx5e: Dont support encap rules with gbp option
Date: Mon, 16 Jan 2023 16:51:56 +0100
Message-Id: <20230116154745.278418632@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gavin Li <gavinl@nvidia.com>

[ Upstream commit d515d63cae2cd186acf40deaa8ef33067bb7f637 ]

Previously, encap rules with gbp option would be offloaded by mistake but
driver does not support gbp option offload.

To fix this issue, check if the encap rule has gbp option and don't
offload the rule

Fixes: d8f9dfae49ce ("net: sched: allow flower to match vxlan options")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 038a0f1cecec..e44281ae570d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -88,6 +88,8 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	struct udphdr *udp = (struct udphdr *)(buf);
 	struct vxlanhdr *vxh;
 
+	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
+		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
 	*ip_proto = IPPROTO_UDP;
 
-- 
2.35.1




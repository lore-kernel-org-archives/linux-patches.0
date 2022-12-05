Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EB415C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8158C433C1;
	Mon,  5 Dec 2022 19:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269357;
	bh=+MZ2+QumjWwRw5aTQJdK75RyV23poB/ZhXBXOm23m80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cELaRYWf7q63o1kmmMbTtp4uatFKmkQWu+VNHpK+qTuOMJltBVkfL//gae6tIVrx0
	 DeVfdVdrnO8IcgQMZ7jlmcv4JLI1Gd7vkgsj2N3C7jNwDvsEiwLXhv7s3/prVPKk5i
	 YHGqE9mBnsGIqRjKy2PXjQmDme14Z0chWnjPSiIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/153] net/mlx5e: Fix use-after-free when reverting termination table
Date: Mon,  5 Dec 2022 20:10:22 +0100
Message-Id: <20221205190811.555744318@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 52c795af04441d76f565c4634f893e5b553df2ae ]

When having multiple dests with termination tables and second one
or afterwards fails the driver reverts usage of term tables but
doesn't reset the assignment in attr->dests[num_vport_dests].termtbl
which case a use-after-free when releasing the rule.
Fix by resetting the assignment of termtbl to null.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 366bda1bb1c3..c9115c0407ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -267,6 +267,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	for (curr_dest = 0; curr_dest < num_vport_dests; curr_dest++) {
 		struct mlx5_termtbl_handle *tt = attr->dests[curr_dest].termtbl;
 
+		attr->dests[curr_dest].termtbl = NULL;
+
 		/* search for the destination associated with the
 		 * current term table
 		 */
-- 
2.35.1




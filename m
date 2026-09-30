Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3950D5172E2;
	Wed, 30 Sep 2026 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787722; cv=none; b=emJEvIwI+iC78bJnbwtUt16cjjGcIKZ0VAwYX/CO/TRkTDvGttknmFfgQR4PYY1ZOkrvadLsrvSlmElQEe4UyKvA5i7Pyv2znrqJtxQ0JxubxXDgPVy12IvDVK0P6EtkCoHRdGndMVRalTeTdhNYO0xiQbUPlZePa2wQM7XaPMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787722; c=relaxed/simple;
	bh=EGwsGGsCLeOu1OWV+7RQ+FYi4r7zKrtGHRbJ128iwOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANwj4FeP6R5Gdw00nfANsuvl6ELw5gpePIl55/MKp+OLOfeVYZeoUoyNDtBXXCG8VmSrnrlLJuLF7zHjy5PfeU0w8PdXPBmULDNTkBnwgavpZ1SrCWAxEVn6L3Qw6XiBez/EgQb31VPk7RB9Z1+3onwoARSEgMBw8nyiDAaKHH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9e0S9iu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9e0S9iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9F51F000FF;
	Wed, 30 Sep 2026 17:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787721;
	bh=Jn+hzVsnfkg8EYS6zEF5xQb99F+1glRHliVb5tjCzQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9e0S9iucWQ1zU0SI5oqH4AM59auopnhnDc6A1eygwevV47DRRdJLzwVtNllQAx/M
	 D1UsekFIRStv8+mtYEufCVFje8fIk6LxzAXiXS//TQ8LA8pD2wqA82rf9Jr+FwyK+f
	 uwffxuIsEPBH1x8aot4fvS9SSJ1DFc4siifZDzkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 329/457] net/mlx5e: fix swapped IPv6 IPsec policy masks
Date: Wed, 30 Sep 2026 17:27:14 +0200
Message-ID: <20260930152353.119976175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

commit 10de7ed8ef4840da9ca21de4c29578657ac367db upstream.

IPv6 XFRM policies may use different source and destination prefix
lengths. mlx5e_ipsec_policy_mask() builds the corresponding masks
independently, but setup_fte_addr6() installs each mask in the opposite
address field.

When the prefix lengths differ, this makes the source match use the
destination prefix and the destination match use the source prefix. The
resulting hardware rule can both miss traffic covered by the policy and
match traffic outside it.

Install each mask in its corresponding match field.

Fixes: ca7992f52c2c ("net/mlx5e: Properly match IPsec subnet addresses")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260917115542.177675-1-parri.andrea@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1564,14 +1564,14 @@ static void setup_fte_addr6(struct mlx5_
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), saddr, 16);
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), dmask, 16);
+				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), smask, 16);
 	}
 
 	if (!addr6_all_zero(daddr)) {
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), daddr, 16);
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), smask, 16);
+				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), dmask, 16);
 	}
 }
 



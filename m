Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4455156F57;
	Tue,  9 Jul 2024 11:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524172; cv=none; b=Xyd5I9/sy+FBQCs+lfVjBtzB4x5celqUWGCQoAHWCGRVXxDRZcTQPrVmqBOiO28DTBQrO5kDVWhanKHo3m/QaoyY86aukT6t245pKbwWYgFbQOd3KiGnLBXTR8GLZJ1O5+oGQzxf3ViLDFUT0HWFXHTewvqfdjAsGJnkKwGzpxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524172; c=relaxed/simple;
	bh=hDSHZYBr3uUaKVHN4g+l1E6rbbmK+s/a0gJOPRYJQjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opcxnvbt3uSFUS9YAT+XeFLehb8O2cAE04eAXWhb4SBX7EMHByzoIhfInXFd64C5b+VbPY3RekjdF/5xCtYSmxXXO/XMSmmKaOYEVGwGt2rPqHuJ9yaXhfodHc41+lhUJcV/09N1xVKvXutAS9+Q9kiKx7NbUxk1GkHeW9fNOm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjzz4wz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjzz4wz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20000C3277B;
	Tue,  9 Jul 2024 11:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524172;
	bh=hDSHZYBr3uUaKVHN4g+l1E6rbbmK+s/a0gJOPRYJQjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjzz4wz+Md5T5+3xPHtmiDLFoLtXliD6oVz+2XwB4ZYQ5XwquY0iNatKAYrKMBz05
	 aZf0Vclxq1MKp5ThA5cD0CWyWyvBvEGDlJF3rIANsPZq4G4SsAnsC9y0jleV8LcN/m
	 lpxHs1of9GuEZvIrtJJJMg1YDLmghrt0eRw8aY7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 093/197] net/mlx5e: Approximate IPsec per-SA payload data bytes count
Date: Tue,  9 Jul 2024 13:09:07 +0200
Message-ID: <20240709110712.564428603@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e562f2d46d27576dd4108c1c4a67d501a5936e31 ]

ConnectX devices lack ability to count payload data byte size which is
needed for SA to return to libreswan for rekeying.

As a solution let's approximate that by decreasing headers size from
total size counted by flow steering. The calculation doesn't take into
account any other headers which can be in the packet (e.g. IP extensions).

Fixes: 5a6cddb89b51 ("net/mlx5e: Update IPsec per SA packets/bytes count")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 2a10428d820ae..3d274599015be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -994,6 +994,7 @@ static void mlx5e_xfrm_update_stats(struct xfrm_state *x)
 	u64 auth_packets = 0, auth_bytes = 0;
 	u64 success_packets, success_bytes;
 	u64 packets, bytes, lastuse;
+	size_t headers;
 
 	lockdep_assert(lockdep_is_held(&x->lock) ||
 		       lockdep_is_held(&dev_net(x->xso.real_dev)->xfrm.xfrm_cfg_mutex) ||
@@ -1026,9 +1027,20 @@ static void mlx5e_xfrm_update_stats(struct xfrm_state *x)
 	mlx5_fc_query_cached(ipsec_rule->fc, &bytes, &packets, &lastuse);
 	success_packets = packets - auth_packets - trailer_packets - replay_packets;
 	x->curlft.packets += success_packets;
+	/* NIC counts all bytes passed through flow steering and doesn't have
+	 * an ability to count payload data size which is needed for SA.
+	 *
+	 * To overcome HW limitestion, let's approximate the payload size
+	 * by removing always available headers.
+	 */
+	headers = sizeof(struct ethhdr);
+	if (sa_entry->attrs.family == AF_INET)
+		headers += sizeof(struct iphdr);
+	else
+		headers += sizeof(struct ipv6hdr);
 
 	success_bytes = bytes - auth_bytes - trailer_bytes - replay_bytes;
-	x->curlft.bytes += success_bytes;
+	x->curlft.bytes += success_bytes - headers * success_packets;
 }
 
 static int mlx5e_xfrm_validate_policy(struct mlx5_core_dev *mdev,
-- 
2.43.0




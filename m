Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A197226D1D;
	Mon,  2 Jun 2025 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877133; cv=none; b=dpszgfFJs4J8xfv1x3uJ0EeOs4HimikhWSK/uMxeuPIBoz8/dLzBU1ZzxkIKBmZoQp1etNdLScQ36aFQviXfUQq3oUmmbjlp2u9YVtSpgGFdmmLGQCtoA0YzOH2deoaJgEGbfJb/OCoVE3ej5c/iglAgzrNlngy2qrIRqa0UJyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877133; c=relaxed/simple;
	bh=HtVIZBYqu/aS1XkNp9KVS0eJQb/nNtlpzjFmIzt1hCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8BCxFSEP1hi7zU8wqQaeiCvAZen035wXjZjRN4o2OKYGBgKftOfiKIL8W+hMNAhgFDMGZTsuuCDgr0tAJ92tS/gU6W1bixF3Snn299C7rzH+GGKcAyswZR9RY+A8+vH6CSGnVCEKb0c/oVwr3dF4S/TPk5ZDApaYQtTWTpbyjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkf+2fVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkf+2fVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4974C4CEEB;
	Mon,  2 Jun 2025 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877133;
	bh=HtVIZBYqu/aS1XkNp9KVS0eJQb/nNtlpzjFmIzt1hCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkf+2fVu+VGw5A4DDMr5TKkD5n54NPK0Ff4UNk3wTta3pjLe5aYPGcW1v0n8userm
	 mzQ5Xe/8Otz3ew/kFdVi1mxksrpGJvSNkTuVU3xxVL3FR3h5adHaFsOHIe6AOxBk8Y
	 WaH0XZloyOh3b6WzKzLOGLCk97x8kiZtQB4F0Svc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/325] net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB
Date: Mon,  2 Jun 2025 15:47:39 +0200
Message-ID: <20250602134327.247331715@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit 95b9606b15bb3ce1198d28d2393dd0e1f0a5f3e9 ]

Current loopback test validation ignores non-linear SKB case in
the SKB access, which can lead to failures in scenarios such as
when HW GRO is enabled.
Linearize the SKB so both cases will be handled.

Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250209101716.112774-15-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 08a75654f5f18..c170503b3aace 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -165,6 +165,9 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
 	struct udphdr *udph;
 	struct iphdr *iph;
 
+	if (skb_linearize(skb))
+		goto out;
+
 	/* We are only going to peek, no need to clone the SKB */
 	if (MLX5E_TEST_PKT_SIZE - ETH_HLEN > skb_headlen(skb))
 		goto out;
-- 
2.39.5




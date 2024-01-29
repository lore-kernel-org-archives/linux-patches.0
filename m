Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E9D15B305;
	Mon, 29 Jan 2024 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548555; cv=none; b=IMblKDptktZfqmZPJSOseFXt7cyva7gJRSbs+F1xadQ0xyz/Xbdpxeitsc4xAsuYjDcPBFdU+buiUyIuwhDqXRH7yUceme0n4hw7YjO6IUAqgekn6EEan3NKFz2XpTHgipmR8VAyi5fMzojE5xS990ZZctjra+dx6xxVFGEKUUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548555; c=relaxed/simple;
	bh=yib4CQtk1uY7o5B1xbJQNgPuSkfNkscq9QHG0VzeNl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJMun06IK5hiPdVA2I3FaWpCPmMkXxcslDMASP6JsXzoIzH8RJObTqltgMaBeiTg4QqJu5+GOf0s1jMl38sdJ3VwB0XOsP+mRxjaQlCB+K4aPWSVWWEk+PduW+WkR88AyTPr3jn0KHDYfDgKwUZctP0nEKvkIiSDPukT+RMK2Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0sGHEUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0sGHEUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9A1C433C7;
	Mon, 29 Jan 2024 17:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548555;
	bh=yib4CQtk1uY7o5B1xbJQNgPuSkfNkscq9QHG0VzeNl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0sGHEUyyV0ErXP4dh1UzgYuaSt9U06YmaXmXuZ7JYEu2h4OrM/Mz+AGy4MuZQgK7
	 lOTwVP4HkfL4IGfzLi7T0xMjZJ4JwHF0RFer+WUA6+O/1oCw61/g6P/OXgk5OYeTBg
	 dC1QkTLfe0xWhuVIf9ux0AcMXlF2I4LrRiiIQfAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aya Levin <ayal@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/331] net/mlx5e: Ignore IPsec replay window values on sender side
Date: Mon, 29 Jan 2024 09:04:25 -0800
Message-ID: <20240129170020.761984522@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 315a597f9bcfe7fe9980985031413457bee95510 ]

XFRM stack doesn't prevent from users to configure replay window
in TX side and strongswan sets replay_window to be 1. It causes
to failures in validation logic when trying to offload the SA.

Replay window is not relevant in TX side and should be ignored.

Fixes: cded6d80129b ("net/mlx5e: Store replay window in XFRM attributes")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 5834e47e72d8..e2ffc572de18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -336,12 +336,17 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	/* iv len */
 	aes_gcm->icv_len = x->aead->alg_icv_len;
 
+	attrs->dir = x->xso.dir;
+
 	/* esn */
 	if (x->props.flags & XFRM_STATE_ESN) {
 		attrs->replay_esn.trigger = true;
 		attrs->replay_esn.esn = sa_entry->esn_state.esn;
 		attrs->replay_esn.esn_msb = sa_entry->esn_state.esn_msb;
 		attrs->replay_esn.overlap = sa_entry->esn_state.overlap;
+		if (attrs->dir == XFRM_DEV_OFFLOAD_OUT)
+			goto skip_replay_window;
+
 		switch (x->replay_esn->replay_window) {
 		case 32:
 			attrs->replay_esn.replay_window =
@@ -365,7 +370,7 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 		}
 	}
 
-	attrs->dir = x->xso.dir;
+skip_replay_window:
 	/* spi */
 	attrs->spi = be32_to_cpu(x->id.spi);
 
@@ -501,7 +506,8 @@ static int mlx5e_xfrm_validate_state(struct mlx5_core_dev *mdev,
 			return -EINVAL;
 		}
 
-		if (x->replay_esn && x->replay_esn->replay_window != 32 &&
+		if (x->replay_esn && x->xso.dir == XFRM_DEV_OFFLOAD_IN &&
+		    x->replay_esn->replay_window != 32 &&
 		    x->replay_esn->replay_window != 64 &&
 		    x->replay_esn->replay_window != 128 &&
 		    x->replay_esn->replay_window != 256) {
-- 
2.43.0




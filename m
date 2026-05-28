Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA667330D35;
	Thu, 28 May 2026 20:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000320; cv=none; b=oY2TaaHVQzT+c+qgfdQ5fgsyzCJ1S1Bb9IIlCFCGIb9jZiZPtEL2uuZUHFSSkJiCxCegx0xpPnnskKxPbq896sEEg6yarrLVjVg6Z5eFjootZELTF15cnB+Unagrt0yRg6KcVpS/NUcCY/qPD74KyiB/tJmscc8Ws6syaYraZ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000320; c=relaxed/simple;
	bh=oWzkhxp/signNZ3PQDduhRRGLf7BJ7e2AFGVP7toqUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ng8yoO1vYXhiVCPZ3WEjjgAACRWygx7MkVUV5NFikIG+xHvO++VNCwjNY1zNsfPL0YtTITAvISKTxVM4/L7CXBB9fzJf/WAC8Fljv7W1v6NcpRQlS/9WTMWnhi3l4CRwtklHc1778qWBRooG9yWYK/+PhV7Wdh+Y2Ww5yg0aMWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i05X7d0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i05X7d0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158681F000E9;
	Thu, 28 May 2026 20:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000318;
	bh=sK4kkghKaevlxJRW18pY+oXTyer+VVuHxzlodnPJij0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i05X7d0Et9uxMZxwx1a5+kQt46e7Uw5f2Jn39uhRtyMxD2Jgz/m+Mb3Xh3RJzeZiZ
	 a9riXQ6nLEM+MnOsmDQ6zdSRbzy3KuFgbwJhhWbYAl5lhOCv8nV8VaEpzUaNUZiEdJ
	 wcwafOyrrPtDo4adiOQZp6D0l49Kp9+QvqQ29GhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 354/377] net/mlx5e: Fix eswitch mode block underflow on IPsec acquire SA
Date: Thu, 28 May 2026 21:49:52 +0200
Message-ID: <20260528194648.676904271@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit abe003b33223ff33552f291644bf35d9c2f992fb ]

mlx5e_xfrm_add_state() handles acquire-flow temporary SAs by allocating
software state and skipping hardware offload setup.

That path jumps to the common success label before taking the eswitch mode
block. After tunnel-mode validation was moved earlier, the common success
label unconditionally calls mlx5_eswitch_unblock_mode(). For acquire SAs,
this decrements esw->offloads.num_block_mode without a matching increment.

Return directly after installing the acquire SA offload handle, so only the
paths that successfully called mlx5_eswitch_block_mode() call the matching
unblock.

Fixes: 22239eb258bc ("net/mlx5e: Prevent tunnel reformat when tunnel mode not allowed")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260510225903.13184-1-prathameshdeshpande7@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index f03507a522b4f..51fb857a27665 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -794,8 +794,10 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	sa_entry->dev = dev;
 	sa_entry->ipsec = ipsec;
 	/* Check if this SA is originated from acquire flow temporary SA */
-	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
-		goto out;
+	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ) {
+		x->xso.offload_handle = (unsigned long)sa_entry;
+		return 0;
+	}
 
 	err = mlx5e_xfrm_validate_state(priv->mdev, x, extack);
 	if (err)
@@ -872,7 +874,6 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		xa_unlock_bh(&ipsec->sadb);
 	}
 
-out:
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	if (allow_tunnel_mode)
 		mlx5_eswitch_unblock_encap(priv->mdev);
-- 
2.53.0




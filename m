Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2C732ABC0;
	Thu, 28 May 2026 20:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999147; cv=none; b=GCSvsvcw99IBa7T/sakfUHZnL4VohN7OXIgPTyLgUoHKg/zoC72KW2DSwERExgxjGZslJFEMH0THzz7F6HxGxJdyeS1BwT1H1Nu8zJcFpFTAql6UFG/Rw1IrSXDWP6fOudXAWV/S6GTkoBU3fN6BPxZaqdvfV0jODLMBNysdcds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999147; c=relaxed/simple;
	bh=9Z2fx+eAvYgJZiCSfOYsUNnaWs8aHFOGBuBq3s5wTgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ile7/Cip0yOVKePlyQUzP68dE/5LH0Gsa4Xxuv3Zy7VvWqbTLUev3SRHS+438XF5Gd9u8IylLeRVcdbjVXUWJVmpK+3NyvEXewu/DhpDNG2wPw0M/NrfmBZRrfTvE9vOlqnYVybRHwbiEGBuwKU8XEHJNouYfFk6ePX1KmhLbEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq4nX2mT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq4nX2mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C861F00A3A;
	Thu, 28 May 2026 20:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999146;
	bh=B2yJ7TOkXQMD6Ijq+IBGvb5iBRCyDgYdU4Zi7+edqis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fq4nX2mTjxqxKY/guT+CcJ3dcvqPmmQPwbSU1OWJN0vc3PZwTKCcZjZn1vSlCeTir
	 IvNsjGYHI6xd+vsr+CjAVq77+/dieFVGvcv8bp4DkANoK+Tsz0OUb5uUNuZPRonoAD
	 QmplToMynbrnAhJBe4c3UJnrzJA4ov+qCTmxxMw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 424/461] net/mlx5e: Fix eswitch mode block underflow on IPsec acquire SA
Date: Thu, 28 May 2026 21:49:13 +0200
Message-ID: <20260528194659.779386491@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 64e13747084ee..9c1f3d734911f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -793,8 +793,10 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
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
@@ -871,7 +873,6 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		xa_unlock_bh(&ipsec->sadb);
 	}
 
-out:
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	if (allow_tunnel_mode)
 		mlx5_eswitch_unblock_encap(priv->mdev);
-- 
2.53.0




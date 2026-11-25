Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621722;
	b=5pI4XKrbN/zFaEgilRmr1SSzHyHjDW/GhszN6qZ61Y2PHlzTCEvVugeojQxJB4xyd+oS
	 sczdNB6plCpFga0LyHLJhPfT2d4N7Wp9j7+00NxNQbPCIgD2E1Xjjxulf3IARViH5XC5A
	 f+xwi8SsBGM/gWRkFYVIOxlFS5eWCtio8PRcJeMv1/sYxrKF12C18GrpwF1bWW7bHGDMl
	 lL3Z2wJedZYKDFJuTff2x/azj2PDuqrqLOkdyxJu26Z1EpnuMbdK7ICrI4js6srrcikIu
	 WG7LKxCxIJroPurAVou3/sKXdldwT2CWRmXM/CBO244W3slc11tlwlj2qs8zPlNQnCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EuAtlF32S6kx1w7yZd9KGD7lCYe17j968ziYFaD9wSY=;
	b=LFgT0opD50CHY0kA4gTzBfo7B7eC+c3gwddO5wCSZm65sPA4mUDX/wkA2UmT1ITfldOE
	 o08q3Y2Wc5pZD/ibBvYxGnjt++Xn5Ccl2asJeBFLVYCncS0FjlxMd9D6278luU1f8JXYp
	 2RGffI8EXZrKTPE7zCIDuVqBNMbkjIUSUmQK9elW+UtPeZBNaDWPx/UV1T130dmlKkzKm
	 BWBsRm/L+OhlkIq+nElfuosc2fmNXvZc3spZMLCqzk5pqi0tEP7gH2vnIIW8pNz44h/0A
	 xfQfr9yrmZpwr0R7S6g695DN+mgyRjGU8mVHsc5XVQCNy8UwuUZi9HGHsTemtQjo2dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjPNtx6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CEE606A331;
	Wed, 25 Nov 2026 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjPNtx6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84831F000C4;
	Wed, 25 Nov 2026 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621722;
	bh=EuAtlF32S6kx1w7yZd9KGD7lCYe17j968ziYFaD9wSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjPNtx6guBK4hKTFgus2rthnvIKZw5khJdzVg3WtP8QEMrwmgBygNtJsD6C6BYqag
	 W2Yjr0kxlnASGR1T/4N/kZoZyjnGzDbQti9g9ot3vCiZnxLf/6jgkfac9L9VLnrcGY
	 lxYmqvCncRHBVYEiT7cXcMWr64dbwB1IDWyBJRuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 317/990] net/mlx5e: TC, Fix double free of branch in failure
Date: Wed, 25 Nov 2026 15:28:04 +0100
Message-ID: <20261125143829.516395512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 31f9b43a3bb3d2201eadd147440252d0912dab21 ]

When allocating the false branch fails in parse_branch_ctrl(), the
already allocated true branch is freed but attr->branch_true is left
pointing to it. The caller parse_tc_actions() fails the flow, and
free_flow_post_acts(), mlx5_free_flow_attr_actions() which calls again
free_branch_attr() on attr->branch_true.

Clear the pointer after freeing it.

This bug is theoretical and was compile tested only.

Fixes: f86488cb4685 ("net/mlx5e: TC, initialize branch flow attributes")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Tested-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e2de3a9a647c3..83e3e51420afc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4013,6 +4013,7 @@ parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
 
 err_branch_false:
 	free_branch_attr(flow, attr->branch_true);
+	attr->branch_true = NULL;
 out_err:
 	return err;
 }
-- 
2.53.0




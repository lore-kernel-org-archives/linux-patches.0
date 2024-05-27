Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3323168C4;
	Mon, 27 May 2024 19:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837894; cv=none; b=MNatdzqaCABXOuWeI4vTQlp+AnlpWfciBJ5quZTT6dWFAnTFFfLutKj7Jh9u0k2S+lFZoG4AToX5SblwB3II/C4hVExx8WpPiQdcF85N8JvVobUvTjMshMYa9m1I7nToXywZ7IlCo+3h6WXAUM6jBNJqWdGgnKKgglfe/vJXeUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837894; c=relaxed/simple;
	bh=mwKxaH8pgpbfGspGgMzKlEMHh993qRZRweDJ4eP6HA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AM1cN4dqfoGE+7WmmxZ1vXjINP1zucaKhNarb3JMP0g0RmKtZS+sQJbNzJP34XGBlEl8b/yNB3LqxVc1800Q+Bm2cU96UZejeEix6MOOAEuRIZ0C1CVzTk92x9695r582F/vd9DzgzZuPfMC724tjBVbM1asJGAA/K6iwBUpgVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynzT5KuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynzT5KuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780C4C2BBFC;
	Mon, 27 May 2024 19:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837893;
	bh=mwKxaH8pgpbfGspGgMzKlEMHh993qRZRweDJ4eP6HA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynzT5KuMpDZ7xunIbpM2ktTX1afhigjWbomY+MjMgDzx73YiIwhCdksCqCB2R+4ls
	 b2ztjYP7Awm5YOCTSoTfpd+ZOphJcwF0Q6yPyE88RncVUJB8KThf5KxGIhvJKzAbv5
	 eKiV/QgyQJVVqZN6PktAA50Cmz83Fgl6JIDDYSuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 187/493] mlx5: stop warning for 64KB pages
Date: Mon, 27 May 2024 20:53:09 +0200
Message-ID: <20240527185636.466324543@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a5535e5336943b33689f558199366102387b7bbf ]

When building with 64KB pages, clang points out that xsk->chunk_size
can never be PAGE_SIZE:

drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:19:22: error: result of comparison of constant 65536 with expression of type 'u16' (aka 'unsigned short') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (xsk->chunk_size > PAGE_SIZE ||
            ~~~~~~~~~~~~~~~ ^ ~~~~~~~~~

In older versions of this code, using PAGE_SIZE was the only
possibility, so this would have never worked on 64KB page kernels,
but the patch apparently did not address this case completely.

As Maxim Mikityanskiy suggested, 64KB chunks are really not all that
useful, so just shut up the warning by adding a cast.

Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
Link: https://lore.kernel.org/netdev/20211013150232.2942146-1-arnd@kernel.org/
Link: https://lore.kernel.org/lkml/a7b27541-0ebb-4f2d-bd06-270a4d404613@app.fastmail.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240328143051.1069575-9-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 82e6abbc17342..c969b8e709804 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -28,8 +28,10 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 			      struct mlx5e_xsk_param *xsk,
 			      struct mlx5_core_dev *mdev)
 {
-	/* AF_XDP doesn't support frames larger than PAGE_SIZE. */
-	if (xsk->chunk_size > PAGE_SIZE || xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE) {
+	/* AF_XDP doesn't support frames larger than PAGE_SIZE,
+	 * and xsk->chunk_size is limited to 65535 bytes.
+	 */
+	if ((size_t)xsk->chunk_size > PAGE_SIZE || xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE) {
 		mlx5_core_err(mdev, "XSK chunk size %u out of bounds [%u, %lu]\n", xsk->chunk_size,
 			      MLX5E_MIN_XSK_CHUNK_SIZE, PAGE_SIZE);
 		return false;
-- 
2.43.0




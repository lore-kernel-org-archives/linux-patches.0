Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E223128AC;
	Mon, 22 Sep 2025 19:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570126; cv=none; b=phgRho+OodQecMf08HgvKQx934tKICZDM0phxDxvQchEUSo892o1hZUsSIVAFOsxYCeCp2g/S5JnyUVc2MTwchu3aBZSidSmyNnBSsSKQJ6bgODAg3olQqYqNZ8Q1tbt+mWpu+eFgAgXzFnYv4CokgEVlN+uFWbZsqzqbWLgf9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570126; c=relaxed/simple;
	bh=6UDtNINuMYepadsYDxHMfrywuGIA0NMFUVouK+2XzmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgKQwNRITFVW3X7g8tY4cs2Bmpic62+9nA4xICDHhqm0eZGS6bR5UkX/kwgwYLDBfICZ71BJqS5ZVGi95G02eMrb9IkiKazRauL84zxmEa4VUpvoYHa9el2L6u1rldC2dLdtA/8Wo/Trx/khX8yP8Rk+GUalDDp4txAHcoM99Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aM3dsF0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aM3dsF0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C59C4CEF0;
	Mon, 22 Sep 2025 19:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570126;
	bh=6UDtNINuMYepadsYDxHMfrywuGIA0NMFUVouK+2XzmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aM3dsF0kujT3b7/oM2C7cNsWf6LX7qCicU3FFKjiwO0NXbp+RXnt+nM1Hfua7wQa/
	 NgR4FS/XKsL/NtbCO2C8Yfq7Rn+hZ2WqZ8esbSUFUz8zKZnVF5/ohVFDooTYLKJtn4
	 zhHqRxQcjdMbsRpH3dOC9PPDOPy5RCGXFKZk6tBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Li Tian <litian@redhat.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 015/149] net/mlx5: Not returning mlx5_link_info table when speed is unknown
Date: Mon, 22 Sep 2025 21:28:35 +0200
Message-ID: <20250922192413.268519913@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Tian <litian@redhat.com>

[ Upstream commit 5577352b55833d0f4350eb5d62eda2df09e84922 ]

Because mlx5e_link_info and mlx5e_ext_link_info have holes
e.g. Azure mlx5 reports PTYS 19. Do not return it unless speed
is retrieved successfully.

Fixes: 65a5d35571849 ("net/mlx5: Refactor link speed handling with mlx5_link_info struct")
Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Li Tian <litian@redhat.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250910003732.5973-1-litian@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 2d7adf7444ba2..aa9f2b0a77d36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -1170,7 +1170,11 @@ const struct mlx5_link_info *mlx5_port_ptys2info(struct mlx5_core_dev *mdev,
 	mlx5e_port_get_link_mode_info_arr(mdev, &table, &max_size,
 					  force_legacy);
 	i = find_first_bit(&temp, max_size);
-	if (i < max_size)
+
+	/* mlx5e_link_info has holes. Check speed
+	 * is not zero as indication of one.
+	 */
+	if (i < max_size && table[i].speed)
 		return &table[i];
 
 	return NULL;
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524D7278E63;
	Fri, 21 Nov 2025 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733204; cv=none; b=kJJmjLGqIiio4NeOnAfsv1xOltivfFj710i3dm1o/S7qrCQCrrQDpdlOouhL9du2N4wegNROKLNPXyRk45WCt4i52FT/AVdvcoc3+PBb+g79IQuH4tF5xqT8tSxkbQ7qfxuMp5wNKW0sXJCQPR3WGQO/ppReDcl0pkNNOlppsEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733204; c=relaxed/simple;
	bh=bKn74NTNUI2zIwVIEoES6I8sDDCJLr92dhAH/nVN0V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsAgkX+vAfDe6HzDXZHUn8v3mfrEP2wWwcLXts7dHd1o7T8r39Xy5v3Qmf4BqNh1ltlRNQFnG8GI+wKREuRMR2Uj28aMrT7KJZvcQwr3DIfar81H6nynvFtsRBBgvgOQdorRCXMyUDqV3KKqHJJNqIe5neFzcFAvGSuBJ5iAHko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEJaDJY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEJaDJY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995DFC4CEFB;
	Fri, 21 Nov 2025 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733204;
	bh=bKn74NTNUI2zIwVIEoES6I8sDDCJLr92dhAH/nVN0V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEJaDJY5eUKweBlG2EZsALWibTQhc9lpoaXb6UexqGz5vehs0QJyLT8eb4nO4CuUn
	 /jcEqfjyoGCw8yzs+8l9FzctVfqCSIX8PYEYKKQjSw/m9BI6nqzORB5JFDQu/+np6p
	 JmjvuIKf1UkGJV1VOBIac9Li3S+jMQrzC/tZvZAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 354/529] net/mlx5e: Use extack in get module eeprom by page callback
Date: Fri, 21 Nov 2025 14:10:53 +0100
Message-ID: <20251121130243.625796780@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit b5100b72da688282558b28255c03a2d72241a729 ]

In case of errors in get module eeprom by page, reflect it through
extack instead of a dmesg print.
While at it, make the messages more human friendly.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20240808055927.2059700-10-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d1c94bc5b90c ("net/mlx5e: Fix return value in case of module EEPROM read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 54379297a7489..b189220f8a877 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1842,8 +1842,10 @@ static int mlx5e_get_module_eeprom_by_page(struct net_device *netdev,
 		if (size_read == -EINVAL)
 			return -EINVAL;
 		if (size_read < 0) {
-			netdev_err(priv->netdev, "%s: mlx5_query_module_eeprom_by_page failed:0x%x\n",
-				   __func__, size_read);
+			NL_SET_ERR_MSG_FMT_MOD(
+				extack,
+				"Query module eeprom by page failed, read %u bytes, err %d\n",
+				i, size_read);
 			return i;
 		}
 
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FCA51B173;
	Wed, 30 Sep 2026 16:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784652; cv=none; b=rnq/sBlTRy4A8m/djl5M8N4Sfv31vKWEg7e48s6Q94i3BOIpwdMlPyhM9gvLgq1rqkissA2kS1mba0XqKfPY5TxC1nFB3RAeAYPyUDvIsrWfWZ98yy1G/OiDdkdoifE/8uvNHZkC5eWtgPQv3hTVRyf+Qg76MPCwT1ruUMUphZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784652; c=relaxed/simple;
	bh=cwETTZRHdCEA24/4dJShM+otJC6qppnJr8hOg33NP/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6cSA1T3c6yvEc4OnqakaQG2VVgfOHFo0WVtrY6kzDATVhV9a93opY53V9jzmAbqiRgNj9mxGdkriQwpzt/SumBP2qIeo/tmjkCjE7CuO91ijI5ZbIKmmS4LW7hXBFG3/kMXhVXob1lLq1INAh3ZaOE3AzAZxCr2i32qFSUBla8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQjZi7Rr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQjZi7Rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FFB1F000FF;
	Wed, 30 Sep 2026 16:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784646;
	bh=WG1jqaXl1NGTJ4Ifqj2Zw6Kzv8B6vZTv14vMlUX9QTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQjZi7RrfJWZF5ev0sXvOW4N1kNmkBoFpLIANnM1LLnWHsPPmwltOf66vBgBQANic
	 b+Oi5/k8at3CqGzkQuHQk0ToVYc0m2K9SBCXL6rlTf3iNR9futBkehxkQr5D4NiP1G
	 STOS+BnV65kmkULLodmD0d6iP3yp3lWXrrcEmNPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/982] eth: mlx5: fix macsec dependency
Date: Wed, 30 Sep 2026 17:16:05 +0200
Message-ID: <20260930152421.718902299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 87ab8276ed24d688febfef4d0c1794896e778192 ]

Configurations with mlx5 built-in but macsec=m fail to link:

x86_64-linux-ld: drivers/infiniband/hw/mlx5/macsec.o: in function `mlx5r_add_gid_macsec_operations':
macsec.c:(.text+0x77d): undefined reference to `macsec_netdev_is_offloaded'
x86_64-linux-ld: drivers/infiniband/hw/mlx5/macsec.o: in function `mlx5r_del_gid_macsec_operations':
macsec.c:(.text+0xe81): undefined reference to `macsec_netdev_is_offloaded'

Fix the dependency so this configuration cannot happen.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260622124229.2444502-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 26685fd0fdaa4..0cfe56b90556a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -142,7 +142,7 @@ config MLX5_CORE_IPOIB
 config MLX5_EN_MACSEC
 	bool "Connect-X support for MACSec offload"
 	depends on MLX5_CORE_EN
-	depends on MACSEC
+	depends on MACSEC=y || MACSEC=MLX5_CORE
 	default n
 	help
 	  Build support for MACsec cryptography-offload acceleration in the NIC.
-- 
2.53.0




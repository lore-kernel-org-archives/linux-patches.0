Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4CF36998C;
	Wed, 30 Sep 2026 18:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794607; cv=none; b=pEjgAY/hwAlcwznVISwNo/pII5TJi65uj4z4sO2IRwPy2OFYlbvDRz8O6nFUszW22GUJ7ThGj4b6PjhSbTnIToZU48zqOa9rheMIsWBNbYbotusbRRCAsKvuEQgiasdaioRSzO0sHBZlEf13o0h4rym1kQ3opJunxZ9ktNDXuxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794607; c=relaxed/simple;
	bh=LkkEx9tqRNJcLp3tKHsFFWvA1JzUIA5TrbfteCGvdbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV82aFhLGKUrBLkkutbvw2+JGHWFOhOekor2T2UKXa8sMUOdiMyclT3oGzL9tC4kum6v4PO4Cqkkj5c2BR+Xc1NHJy5uY3agfiJvbjtf12tF48TPNs0KHOWlf+PJjvPH0Pi/YLLMxpFeHwL46EIupRAsgwYV2MwU+OS8JeYbWjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yonBv4E2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yonBv4E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95B51F000FF;
	Wed, 30 Sep 2026 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794606;
	bh=c/IzMpFlykDW8Kw0jQK8qL+ZSzGD83vlVV9QhMN2wq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yonBv4E2JQ6mNTC+qM0ouh2eiUfsqxz0HUKVEkxn2TYXAeuL3+T2V9Z0kkrAnN7OY
	 3Xu7t04idnaXJlgGFd+CR3jh2BXRjpckGlNcTK5lFEJp5YwmXWKCx4nVFCElb8EXix
	 YPXs2brdoSVm+FncYUyP1oGKTrf7ShzUIpLpiqlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0268/1193] eth: mlx5: fix macsec dependency
Date: Wed, 30 Sep 2026 17:15:52 +0200
Message-ID: <20260930152440.123336701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index c4f4de82e29e2..592dbd3093ff4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -143,7 +143,7 @@ config MLX5_CORE_IPOIB
 config MLX5_MACSEC
 	bool "Connect-X support for MACSec offload"
 	depends on MLX5_CORE_EN
-	depends on MACSEC
+	depends on MACSEC=y || MACSEC=MLX5_CORE
 	default n
 	help
 	  Build support for MACsec cryptography-offload acceleration in the NIC.
-- 
2.53.0




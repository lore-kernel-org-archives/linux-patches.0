Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3304DEC09;
	Thu, 17 Sep 2026 18:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668313; cv=none; b=BDBlLX3ZhzfY/k/+c2VV/z4yU72a/HAwflYAZr5GZWzeew8B2cqYgZqYmw7lvCuC17eY8rlj8lLg6evo1qNNHvWlr36uK3e7gyMhWLyY31+ZfCYuT5JSJCCVZEgU4VyQ8QByItvKx8CwYnIVk5vWN3bHMkaAJBcrPemQG4z2GrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668313; c=relaxed/simple;
	bh=72Vo/ObD9A1GV10dfkFaCUlYVLD/xDTtzm9NAU05RJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGq++wcABqW9GtuPZCEvny37ThqbCsDuydLWkZOhj3+SukUb0ldpYfP3+Ot/v8vzLhInVWQweTe27Wfde7LVZz3bdPfixIFvl9XwQACi75NeplHDVuxqZ1KmMSwH5EFduN8bXeaFIDeE9hBAtmZD8RjMoVPV1AFlfCenBGKgKuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tNSGWRW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tNSGWRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679A91F00893;
	Thu, 17 Sep 2026 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668312;
	bh=w203Nsl9QAv2kCyGzxpdaOyUll8i65hxfMZc+qD0Ejg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tNSGWRWky/40gDORZtJNGGgSCctx6/XFNzK3OyTSnyDAO0uPG5VFSgHFEuJk/fTd
	 ZXpp8m1XP+efoeJGBUtOFMczIFLmeG2vo2fp9mlL8g48AGeJIxDtiU4ZnRgzNgrfDx
	 CrX2h6WceLbiRwTs9iUg43rSF5uJjMK1oq4+9es8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0366/1102] eth: mlx5: fix macsec dependency
Date: Thu, 17 Sep 2026 16:05:09 +0100
Message-ID: <20260917151548.838610208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ea6070180c96b..fc49900a0182d 100644
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




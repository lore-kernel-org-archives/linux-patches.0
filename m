Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9A253B33F;
	Thu, 17 Sep 2026 17:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664739; cv=none; b=iaStjn/NCmish0on/l5PsJg1Nfvy9gr7vfhqfV3V6wZ2Pav6X9hM4ZU/vnfincVVoMwspUYu7hJWdDCWkVPpNL2AcadqZghVjxuRgr4FbqHQqVPtYgTCZ2DkZOJgPjAO6b+S1ZIMogvIVCaip9JqjdVIoTDK3ImQbZrrFIZShG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664739; c=relaxed/simple;
	bh=Z7YoJc5A6xkm3O79Qly/4u4X61Q7UxRUD0G2KSHhSUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7gKz5IlQHcCuBRmbft4qRrHbT5Eq73lxJQId6NXJTPNDamMM5kzb6TyJjyByP4+quvIfB/LCO4XKi4feH9+UlTA9AF8LHCSbBPdKyBXeVJWkdyLNdIa22dJvIAIRDA0TZDu3xSX1kWKNzGlNpMhtrzILs/Z/4K26reUaQCDiI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwCcF6Gw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwCcF6Gw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC981F00893;
	Thu, 17 Sep 2026 17:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664737;
	bh=gj+GE1kq+4d6j3aJlFxOuSv+jLEznpcz7pvBzjooivs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwCcF6GwPAaXyUvoTFsHTGHsWup3Hc1CwC3HieQN69VWW1JBrEgd+q5UP7wQzYhVN
	 iOL9/6nj31dUWxsNPo8/EVYuopR8TUyd0BjKjK6WBSqLBeEl9Vkj8E7CWsTr8IhPkA
	 O0o5d7ZRl331wv2dpRwJWWs61U/wf9RLCOc1Aov4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0470/1250] eth: mlx5: fix macsec dependency
Date: Thu, 17 Sep 2026 16:04:25 +0100
Message-ID: <20260917151604.713232590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 3c3e84100d5aa..925ee25d05b47 100644
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




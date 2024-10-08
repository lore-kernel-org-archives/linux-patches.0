Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E9D1DF73A;
	Tue,  8 Oct 2024 12:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392164; cv=none; b=iavLZK+qHAIECWW4Kd/dj36YW7PrVV2juFkNVGxtR7d/3dDbtKjoqpKAF8mPtyEGVe9wfCR9rrExHcrT/KE70RRltn2Qb7jTsau3QijZbRheikFWJT2SHkfSGvZoaCd96kdwM9WEtAh1MZdiRXVJEiD+j0q/jvP1oJueJStcZS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392164; c=relaxed/simple;
	bh=CMt68s4jNh4KT9eycHZojb5C/4NLkuHHdt375z/uuPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HayVNkbYnvcD16/NES//Azii/J7xfKL32bqRY2dLZLlmdyAY/oCkw47nJ/AM0y6apyFYolqRZTgvE6biyWIC39nSzjY/M89kRHUgNnuDgp6d6hXT1PosF0XpM7MXH+/E0e4/6oyq9UwCKq5wL7xWRh4F33wtoTsrtUqFiPIIlKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBhMfzuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBhMfzuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236C0C4CECF;
	Tue,  8 Oct 2024 12:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392163;
	bh=CMt68s4jNh4KT9eycHZojb5C/4NLkuHHdt375z/uuPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBhMfzuhL25hY3FtQfl/MVeGFduWxYqNOJZTBSU9CmOHeeMI6g8W3xvlZkUhxDBeN
	 RkTcGpjHOxQnHkosMUIX55XhARPTZb86ZmFmPQgEg5o2tirWNCi6gn+qXJfbchaT9a
	 SQZPjSbP9SDNHGMQA6pGB0HxR1WkO+VgSjnErvSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 334/558] nvme-tcp: fix link failure for TCP auth
Date: Tue,  8 Oct 2024 14:06:04 +0200
Message-ID: <20241008115715.446986863@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2d5a333e09c388189238291577e443221baacba0 ]

The nvme fabric driver calls the nvme_tls_key_lookup() function from
nvmf_parse_key() when the keyring is enabled, but this is broken in a
configuration with CONFIG_NVME_FABRICS=y and CONFIG_NVME_TCP=m because
this leads to the function definition being in a loadable module:

x86_64-linux-ld: vmlinux.o: in function `nvmf_parse_key':
fabrics.c:(.text+0xb1bdec): undefined reference to `nvme_tls_key_lookup'

Move the 'select' up to CONFIG_NVME_FABRICS itself to force this
part to be built-in as well if needed.

Fixes: 5bc46b49c828 ("nvme-tcp: check for invalidated or revoked key")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 883aaab2d83e3..486afe5981845 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -41,6 +41,7 @@ config NVME_HWMON
 
 config NVME_FABRICS
 	select NVME_CORE
+	select NVME_KEYRING if NVME_TCP_TLS
 	tristate
 
 config NVME_RDMA
@@ -94,7 +95,6 @@ config NVME_TCP
 config NVME_TCP_TLS
 	bool "NVMe over Fabrics TCP TLS encryption support"
 	depends on NVME_TCP
-	select NVME_KEYRING
 	select NET_HANDSHAKE
 	select KEYS
 	help
-- 
2.43.0




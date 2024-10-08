Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D481DED43;
	Tue,  8 Oct 2024 12:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390399; cv=none; b=XRAuq67Kmw6IhWbTB3CQl1hg2OP944NdVOm6kAy7Hh9WsmpPSEWCu7IBnEKm7hNUWKyfT+B25/Lgh576YHo5oqTBJQtcYu3mhMA6pDQHy6iAo/QwtXrSNe82oKGN9VJgaXx26UOW4yKqu21PP24cMJcU8Y16aaPtZoGXu8OVEho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390399; c=relaxed/simple;
	bh=wUtMi2a4yUhvyvVQLFKTu/1wOOvZerLdYBqRoiW41xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3AwkvgFhJHCm1yurgIFgr5rtuyWINlUgAEi/+73yldOUgyJFqQiOdcoCgRmacQALJTkUvvpBvCSEhxJvVOF3fFeRN0zNc+l7INsSEJ7bVXqv0ShQD2g5dv7qUQLV/qdKxhdAeE7iFsuyRLBrDpK+TUNRP9n9Q9m3ShtIsKyUBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wx/VLGQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wx/VLGQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC67AC4CEC7;
	Tue,  8 Oct 2024 12:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390398;
	bh=wUtMi2a4yUhvyvVQLFKTu/1wOOvZerLdYBqRoiW41xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wx/VLGQFSi10MkwghUXEPIUUdJCrnLE4KbGrkTYS4u57j0o3khTf3WBnjFW5Q4xfk
	 DWAXgAQKB1ymbodSqJ9/GSJEmEXj+Bc90MFI/DOh0cGEKTwcXsQTjda67bUDOjJLI4
	 0bZQySnqgAUMuf/JmNHHqH2QCW4zrxGWaMRCZP34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 277/482] nvme-tcp: fix link failure for TCP auth
Date: Tue,  8 Oct 2024 14:05:40 +0200
Message-ID: <20241008115659.181559476@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 854eb26ac3db9..e6bb73c168872 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -42,6 +42,7 @@ config NVME_HWMON
 
 config NVME_FABRICS
 	select NVME_CORE
+	select NVME_KEYRING if NVME_TCP_TLS
 	tristate
 
 config NVME_RDMA
@@ -95,7 +96,6 @@ config NVME_TCP
 config NVME_TCP_TLS
 	bool "NVMe over Fabrics TCP TLS encryption support"
 	depends on NVME_TCP
-	select NVME_KEYRING
 	select NET_HANDSHAKE
 	select KEYS
 	help
-- 
2.43.0




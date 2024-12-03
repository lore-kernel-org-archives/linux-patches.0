Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66E123CE;
	Tue,  3 Dec 2024 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241778; cv=none; b=cRX8F25+zRI1/V7UnAx2l3eXBQ7Ty/r1+wGQnkSDsWOG8aeUAm7SDsgARTNNwx3yheXm1qpDysuXgvN96G5z8jULZy7SeRDh/JBWy2ir79mtTQANtr1v/8J5hf8eOXcC5kV/LHQFjh1K6oP5sfHtZG6GHMNj3ENAYpolC5rYLkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241778; c=relaxed/simple;
	bh=nQbMh/OV5+v82cP6HRkZecbmVtq64tV3jVn+Bi/SXeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+hsi+uwbTBmfHm24EeBl1TV0e4ckbhPFYmLX2N+Vxqqd8FIihp5bRxZlmPf5lzrhe3y8DM1nEemDlEPg77/YP+2UHaXNb3KHfj1Gxznw4Pa++N9LWV/rbsD7F8T2lxJCftbuOyWfy8VqDChiW0IpU7G66LS1eDjFtEWqOnmn18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8jfbBJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8jfbBJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B699C4CECF;
	Tue,  3 Dec 2024 16:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241777;
	bh=nQbMh/OV5+v82cP6HRkZecbmVtq64tV3jVn+Bi/SXeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8jfbBJKH98oP40Xp/0y+XdFuYOupPtxP8v6BUrJP9DH7sMkL5P9YNZ9RjTzHhA/N
	 LCy+odXc/DT4bDoDgjsWspLRhe0sbRLVXSuUGtPZExK1UHCwCmi0PZ9xKXfz2/8XWS
	 p/ZwEPyHbEpHx3mJbfBBMc9g0+APgcrlULaRy3HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 482/826] mailbox, remoteproc: k3-m4+: fix compile testing
Date: Tue,  3 Dec 2024 15:43:29 +0100
Message-ID: <20241203144802.565102618@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9c12b96ee244b9679629ac430c375a720bfec04b ]

The k3-m4 remoteproc driver was merged with incorrect dependencies.
Despite multiple people trying to fix this, the version 6.12-rc2
remains broken and causes a build failure with CONFIG_TI_SCI_PROTOCOL=m
when the driver is built-in.

arm-linux-gnueabi-ld: drivers/remoteproc/ti_k3_m4_remoteproc.o: in function `k3_m4_rproc_probe':
ti_k3_m4_remoteproc.c:(.text.k3_m4_rproc_probe+0x76): undefined reference to `devm_ti_sci_get_by_phandle'

Fix the dependency again to make it work in all configurations.
The 'select OMAP2PLUS_MBOX' no longer matches what the other drivers
dependencies. The link failure can be avoided with a simple 'depends
do, so turn that into the same 'depends' to ensure we get no circular
on TI_SCI_PROTOCOL', but the extra COMPILE_TEST alternative is what
we use elsehwere. On the other hand, building for OMAP2PLUS makes
no sense since the hardware only exists on K3.

Fixes: ebcf9008a895 ("remoteproc: k3-m4: Add a remoteproc driver for M4F subsystem")
Fixes: ba0c0cb56f22 ("remoteproc: k3-m4: use the proper dependencies")
Fixes: 54595f2807d2 ("mailbox, remoteproc: omap2+: fix compile testing")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20241007132441.2732215-1-arnd@kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 955e4e38477e6..62f8548fb46a5 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -341,9 +341,9 @@ config TI_K3_DSP_REMOTEPROC
 
 config TI_K3_M4_REMOTEPROC
 	tristate "TI K3 M4 remoteproc support"
-	depends on ARCH_OMAP2PLUS || ARCH_K3
-	select MAILBOX
-	select OMAP2PLUS_MBOX
+	depends on ARCH_K3 || COMPILE_TEST
+	depends on TI_SCI_PROTOCOL || (COMPILE_TEST && TI_SCI_PROTOCOL=n)
+	depends on OMAP2PLUS_MBOX
 	help
 	  Say m here to support TI's M4 remote processor subsystems
 	  on various TI K3 family of SoCs through the remote processor
-- 
2.43.0




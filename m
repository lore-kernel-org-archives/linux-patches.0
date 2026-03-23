Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14133B27C5;
	Mon, 23 Mar 2026 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279171; cv=none; b=q7GMfZjwNcbrScHMGczIk3LbcFeXvqf8OeGlfSfTt90hsCmGrIBSMXm4kV6olFYocXH4LprKLE63Eek1l1Li/iYSdlhWPJgK3Y06pcgIaL0bi0Cxr3pmBT0tY6tkTJM12CcH/Y49is59nrmN4FzcoV8R6Lub6zGaC5AoOhN+z+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279171; c=relaxed/simple;
	bh=L6LZ0KZKvd5VcdJePUdwTZlu496khx5FZ9DmHEQZXU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCSMpur2Roq0/6GXhiWowKcm7aC8qwNVA1vlkHd4TE5lY/8Mbt5efJAFIT0fERQPwdItpl5gwSH8PzHCQsxULIXaLqUW4tiOb96oTH6BTI9zRJlPc71LAFamDeCqUJMFlB9uxJy4LZFXSrXh0Spig76HWnxPzBoodQT9tEzUxBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUF8Pumb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUF8Pumb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE780C4CEF7;
	Mon, 23 Mar 2026 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279171;
	bh=L6LZ0KZKvd5VcdJePUdwTZlu496khx5FZ9DmHEQZXU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUF8Pumbq9NvdaCWlXF/JmueSb7hIVEmI0ZnBCi8hed8MGWSvYoZPOv89+4Rx/Tsj
	 nN3gm9L+/dcWeBVezAfFUwZjFwnzaBEr6RAm05q0mthY/NdgQdUEtb/p6wfDOYN4+j
	 BjKmMPfmOZITf2xTVw2L5UVvFrcnCSIzDSscZPGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 498/567] cache: ax45mp: Fix device node reference leak in ax45mp_cache_init()
Date: Mon, 23 Mar 2026 14:46:58 +0100
Message-ID: <20260323134546.349627302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 0528a348b04b327a4611e29589beb4c9ae81304a ]

In ax45mp_cache_init(), of_find_matching_node() returns a device node
with an incremented reference count that must be released with
of_node_put(). The current code fails to call of_node_put() which
causes a reference leak.

Use the __free(device_node) attribute to ensure automatic cleanup when
the variable goes out of scope.

Fixes: d34599bcd2e4 ("cache: Add L2 cache management for Andes AX45MP RISC-V core")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cache/ax45mp_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cache/ax45mp_cache.c b/drivers/cache/ax45mp_cache.c
index 1d7dd3d2c101c..934c5087ec2bd 100644
--- a/drivers/cache/ax45mp_cache.c
+++ b/drivers/cache/ax45mp_cache.c
@@ -178,11 +178,11 @@ static const struct of_device_id ax45mp_cache_ids[] = {
 
 static int __init ax45mp_cache_init(void)
 {
-	struct device_node *np;
 	struct resource res;
 	int ret;
 
-	np = of_find_matching_node(NULL, ax45mp_cache_ids);
+	struct device_node *np __free(device_node) =
+		of_find_matching_node(NULL, ax45mp_cache_ids);
 	if (!of_device_is_available(np))
 		return -ENODEV;
 
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FD315696E;
	Thu, 12 Dec 2024 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025051; cv=none; b=jTdN202kvlsPnQ+6X6PtX8Z4HWwmBEDSDknUOna8nOeOmmk7gCycAldbLvn6FbAqE9/86bpRY3eu2ZThDraVCSNx+oNJm8ImLYyVXPLRU1R5G9fQEZIpLqFtW8FoGpPE5XVg0i/qNxdzay/2STz/DfTuhKt6aMXfGh9jWE+dhVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025051; c=relaxed/simple;
	bh=5zRaGv909BxMuwil0VQ4XujlSaF5jTgNX5qu7FWVVVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd1CLJ9EvO1t59wm8ZSkAu7W9QVeXVCUmakx3d6KElaFJwMF58dcBo8v8fzcNOY1PkXw4Fn+BhwGK+WEt2qg5WA9eGxriNm+oCZx7My726N4wo0eFTXoIL5dif+C6kIYvGXDFF33b7DksHnJUTnj08Bj4sieurVztC/s6cHthF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JtT1Lzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JtT1Lzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B58C4CECE;
	Thu, 12 Dec 2024 17:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025051;
	bh=5zRaGv909BxMuwil0VQ4XujlSaF5jTgNX5qu7FWVVVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JtT1Lzpvfgu+tarw+VxJ9ewVKuQor97kbnPHXFMwnYE2Xsf+UlI+J0WqF/CMNWvn
	 SsjOD57eOS6zebY9182Cii0uLDq7vsHSDNRgKOReggTgihCtOVJsKbjk2iHHdhVSJZ
	 w5JXCyu8mZlnoZixfAWKunL21SbT9tC2UULiP/QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Heymans <arthur@aheymans.xyz>,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/321] firmware: google: Unregister driver_info on failure and exit in gsmi
Date: Thu, 12 Dec 2024 15:59:16 +0100
Message-ID: <20241212144231.504349017@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arthur Heymans <arthur@aheymans.xyz>

[ Upstream commit c6e7af0515daca800d84b9cfa1bf19e53c4f5bc3 ]

Fix a bug where the kernel module couldn't be loaded after unloading,
as the platform driver wasn't released on exit.

Signed-off-by: Arthur Heymans <arthur@aheymans.xyz>
Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Link: https://lore.kernel.org/r/20191118101934.22526-3-patrick.rudolph@9elements.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 32b0901e141f ("firmware: google: Unregister driver_info on failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/gsmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 94753ad18ca63..633997af4b09e 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -1026,6 +1026,9 @@ static __init int gsmi_init(void)
 	dma_pool_destroy(gsmi_dev.dma_pool);
 	platform_device_unregister(gsmi_dev.pdev);
 	pr_info("gsmi: failed to load: %d\n", ret);
+#ifdef CONFIG_PM
+	platform_driver_unregister(&gsmi_driver_info);
+#endif
 	return ret;
 }
 
@@ -1047,6 +1050,9 @@ static void __exit gsmi_exit(void)
 	gsmi_buf_free(gsmi_dev.name_buf);
 	dma_pool_destroy(gsmi_dev.dma_pool);
 	platform_device_unregister(gsmi_dev.pdev);
+#ifdef CONFIG_PM
+	platform_driver_unregister(&gsmi_driver_info);
+#endif
 }
 
 module_init(gsmi_init);
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AEC3AD537;
	Mon, 23 Mar 2026 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274063; cv=none; b=YQu+9p/KudkBkDG2TmviyLLEx5P4DUABvMqFwF+B5u40p10e1ZFwGLAcDc5J66tSLj6nI94ZDH+1uUGSi+aDHJS69FTsrW9bpfREfkoKKGeZRsa9Pctntjsjpfor57IJssqtfyz1HtJnQAqEnfecjtjN3A7s3pmfcj5IeIC6Mjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274063; c=relaxed/simple;
	bh=u9dGwY+wErL+1I4/MrKFN8uXeUAEfblKzhrdIeiU7Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrFKTVUA1G/77ITD9wCIieaBSQ9tQVN0eb3MnyFG55Tu17jgmfhwTpN/NdUf32ig3ll5AiIplm8QIlPKlnMGRYqYmhT2TfCbvxv4ngGYQwo3GA81+62qHhD3wswhqElA5te3fWdRmAs/pU/Rsp6F9+2FOABBzKqDmk5ZvyzOsFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtpHjLSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtpHjLSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA45C4CEF7;
	Mon, 23 Mar 2026 13:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274063;
	bh=u9dGwY+wErL+1I4/MrKFN8uXeUAEfblKzhrdIeiU7Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtpHjLSHJDCYqGCFP7Yf6SXOYLvHgKy6nfSfiW6JmIfm+6rQr3sDdxulTu6vNKebF
	 wpz1OcLeg3i9A3y17MXp4W1kdQ69cHTVQZHSJ6MtnFrWjou6fJ5DaWilAIYORq9YHM
	 b3sDbewHxPUGpR8rML8cv8avTlyDNiD2FtFbvp/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 097/220] soc: microchip: mpfs: Fix memory leak in mpfs_sys_controller_probe()
Date: Mon, 23 Mar 2026 14:44:34 +0100
Message-ID: <20260323134507.665856996@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 5a741f8cc6fe62542f955cd8d24933a1b6589cbd ]

In mpfs_sys_controller_probe(), if of_get_mtd_device_by_node() fails,
the function returns immediately without freeing the allocated memory
for sys_controller, leading to a memory leak.

Fix this by jumping to the out_free label to ensure the memory is
properly freed.

Also, consolidate the error handling for the mbox_request_channel()
failure case to use the same label.

Fixes: 742aa6c563d2 ("soc: microchip: mpfs: enable access to the system controller's flash")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/microchip/mpfs-sys-controller.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/microchip/mpfs-sys-controller.c b/drivers/soc/microchip/mpfs-sys-controller.c
index 30bc45d17d343..81636cfecd37e 100644
--- a/drivers/soc/microchip/mpfs-sys-controller.c
+++ b/drivers/soc/microchip/mpfs-sys-controller.c
@@ -142,8 +142,10 @@ static int mpfs_sys_controller_probe(struct platform_device *pdev)
 
 	sys_controller->flash = of_get_mtd_device_by_node(np);
 	of_node_put(np);
-	if (IS_ERR(sys_controller->flash))
-		return dev_err_probe(dev, PTR_ERR(sys_controller->flash), "Failed to get flash\n");
+	if (IS_ERR(sys_controller->flash)) {
+		ret = dev_err_probe(dev, PTR_ERR(sys_controller->flash), "Failed to get flash\n");
+		goto out_free;
+	}
 
 no_flash:
 	sys_controller->client.dev = dev;
@@ -155,8 +157,7 @@ static int mpfs_sys_controller_probe(struct platform_device *pdev)
 	if (IS_ERR(sys_controller->chan)) {
 		ret = dev_err_probe(dev, PTR_ERR(sys_controller->chan),
 				    "Failed to get mbox channel\n");
-		kfree(sys_controller);
-		return ret;
+		goto out_free;
 	}
 
 	init_completion(&sys_controller->c);
@@ -174,6 +175,10 @@ static int mpfs_sys_controller_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "Registered MPFS system controller\n");
 
 	return 0;
+
+out_free:
+	kfree(sys_controller);
+	return ret;
 }
 
 static void mpfs_sys_controller_remove(struct platform_device *pdev)
-- 
2.51.0




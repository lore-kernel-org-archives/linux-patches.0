Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09A61A5B84;
	Mon, 23 Mar 2026 14:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277246; cv=none; b=YESwrSLuqfTsVxMJxCST/F/EiiozmiFBTdLdgt8qxrA1xvE7K4YBVKXDDgWMnmM0YKmCge/1Bl8wVipGhwW6Eo9H5OSQz2dxAeHjTKAckG1U+n2TISeSvgCtb0Xv/1xMQwXAMZeeD8UrpHTS567T1VvcCj6DhjkXbf4mADOXUF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277246; c=relaxed/simple;
	bh=cWEqTiW70be5LaelkLdEp9oADPPdCydUKc3x5Q9T5eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hveA63W5Mw+6Vpf5V4qYAJbDYgwWFqU1avl1jkIdv7bw+8ujEueODZiDd8srxA0TXsW3PaABzHHtlpbPR2IdCGDOyQ6rA4B78npY3SS2rUvWCE1cnOsZDfwLeFqgIs1z7zVz6kCmFSSW+o3sHpI1vnA9mxlhgJtxV+MQKptOmHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xP4y26sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xP4y26sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC04C4CEF7;
	Mon, 23 Mar 2026 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277245;
	bh=cWEqTiW70be5LaelkLdEp9oADPPdCydUKc3x5Q9T5eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xP4y26sfPBJUt2vuYnkRpydDBt0qGsJo+kjlYxWGCu9iTaFnLsAkc6Jun+B44+8yj
	 MMiAJFiXWwb4O7cBooeb8AMTPf50NMLBd3YYz8AoA4Ls7aJYb2KdumVjc+xMZNqjyb
	 lCyHjISXb52jw6iNqXJuPWeFI4KrK9l+mpBTVb3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 368/460] soc: microchip: mpfs: Fix memory leak in mpfs_sys_controller_probe()
Date: Mon, 23 Mar 2026 14:46:04 +0100
Message-ID: <20260323134535.606985405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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




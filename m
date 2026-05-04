Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378C540DFD4;
	Mon,  4 May 2026 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903745; cv=none; b=WOvjzvOrWyfwijK3pVXoTyy2Jl5bilIoCvbjIpwGE2WxwD3laP9MsuXNyV8Ku5zje7IC6q9jby+ohoxqAujpvCrjzutKcgKPJGWlualkTInCL6Jwj85RU+3uoVhVTXCdoMPrq8l7EopetUjclnuVqzlnBpMHDd0TCLopgZDTIwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903745; c=relaxed/simple;
	bh=n2woXKzLEH6iAKYo2MkY+cT8JABedyIAgH62Gu5pi3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mT5CwYTe/F5c7HksM8hMzUxbrPiF8mvSiJwRm8xdpMooD26PZNJ19KK52T+AwLXt7XMUN64UY8uNbv1n3W4WJ3l9EcKwVkyHws4pnXpmH3hNNctStXE6tKVSZHKkY2JMZbaqBWua8TZHnNHWAsVffs4i0Fw6KzHsFbTHofLyMDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrV4+nu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrV4+nu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34E3C2BCB8;
	Mon,  4 May 2026 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903745;
	bh=n2woXKzLEH6iAKYo2MkY+cT8JABedyIAgH62Gu5pi3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrV4+nu5aBO2eXxKshGkeNnkDnnMRqmPfqSt3NLr8XaQq3deTp3Z6Db8LU9yNcwFN
	 TaFZJJx0cYCRmLFHCdh+DdF97SJF5dinNDPK/20Jxgv4HjJKeyFLA9C1FM6TUHY0ZK
	 C48h0HqASDBDhdWurphcnmB8zFmR7+t5lkMxbi0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.18 045/275] EDAC/versalnet: Fix device_node leak in mc_probe()
Date: Mon,  4 May 2026 15:49:45 +0200
Message-ID: <20260504135144.616206928@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 5c709b376460ff322580c41600e31c02f7cc0307 upstream.

of_parse_phandle() returns a device_node reference that must be released with
of_node_put(). The original code never freed r5_core_node on any exit path,
causing a memory leak.

Fix this by using the automatic cleanup attribute __free(device_node) which
ensures of_node_put() is called when the variable goes out of scope.

Fixes: d5fe2fec6c40 ("EDAC: Add a driver for the AMD Versal NET DDR controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260323-versalnet-v1-1-4ab3012635ef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/versalnet_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/versalnet_edac.c
+++ b/drivers/edac/versalnet_edac.c
@@ -868,12 +868,12 @@ static void remove_versalnet(struct mc_p
 
 static int mc_probe(struct platform_device *pdev)
 {
-	struct device_node *r5_core_node;
 	struct mc_priv *priv;
 	struct rproc *rp;
 	int rc;
 
-	r5_core_node = of_parse_phandle(pdev->dev.of_node, "amd,rproc", 0);
+	struct device_node *r5_core_node __free(device_node) =
+		of_parse_phandle(pdev->dev.of_node, "amd,rproc", 0);
 	if (!r5_core_node) {
 		dev_err(&pdev->dev, "amd,rproc: invalid phandle\n");
 		return -EINVAL;



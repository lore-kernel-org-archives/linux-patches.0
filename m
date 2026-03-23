Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678BA3AC0D2;
	Mon, 23 Mar 2026 14:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274830; cv=none; b=PWTZw7qHxxJ5Mh/8+lpF50BSOWcSoQEp7qjoQw4kEUXzZMQxBmbWSs3UG+Xl4YbWxEBIrhwEZ4eCgOP/KC+jriIYBSaGyfAjLPbBtCGdb7xyvsFK1v4nzh/e6SohKrfBlVaiF6OxvsNI1hcQb0hRkDLFIkZVeVZWezGd52zLPKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274830; c=relaxed/simple;
	bh=4LqxuwCrshgkbydM8zoxnpXoMiWc08B6k7Vf3FwNyLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcI4DD8ukOlIecumv7Mpylzj78mKBcpJ1pfM1F6gHdWOhJytaHZ5Tibo7kPD81JmhjzByMSrczqzDz0GxXUl3xQCzZMUR4DhFgKZXqVYmh+0CN9XjpqlNBz8XhKTBgE0PqnuVraFsGSyHewDz+AoCRWqBEjiG4PKWdlAc9/ADYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AezCTwO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AezCTwO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDF4C4CEF7;
	Mon, 23 Mar 2026 14:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274830;
	bh=4LqxuwCrshgkbydM8zoxnpXoMiWc08B6k7Vf3FwNyLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AezCTwO3Z0zweO62dntMA8RRHedWvfQMk0cpXC8MOnW3At3ijkdWZazM2dF8DjvgN
	 BPjQCk6MNtu5Q1cAyo1EFQLVk9gQDyiPLZUKR4eHD+GNJlT2wCgL8VXUqHWGTiyldD
	 q+s8NPvewzMOsird8O51UDwjPUkvuTE7hCsyIs1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/212] firmware: arm_scpi: Fix device_node reference leak in probe path
Date: Mon, 23 Mar 2026 14:45:41 +0100
Message-ID: <20260323134507.561381556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

[ Upstream commit 879c001afbac3df94160334fe5117c0c83b2cf48 ]

A device_node reference obtained from the device tree is not released
on all error paths in the arm_scpi probe path. Specifically, a node
returned by of_parse_phandle() could be leaked when the probe failed
after the node was acquired. The probe function returns early and
the shmem reference is not released.

Use __free(device_node) scope-based cleanup to automatically release
the reference when the variable goes out of scope.

Fixes: ed7ecb883901 ("firmware: arm_scpi: Add compatibility checks for shmem node")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Message-Id: <20260121-arm_scpi_2-v2-1-702d7fa84acb@gmail.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index 87c323de17b90..398642cc25d90 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -18,6 +18,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/bitfield.h>
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/export.h>
@@ -940,13 +941,13 @@ static int scpi_probe(struct platform_device *pdev)
 		int idx = scpi_drvinfo->num_chans;
 		struct scpi_chan *pchan = scpi_drvinfo->channels + idx;
 		struct mbox_client *cl = &pchan->cl;
-		struct device_node *shmem = of_parse_phandle(np, "shmem", idx);
+		struct device_node *shmem __free(device_node) =
+			of_parse_phandle(np, "shmem", idx);
 
 		if (!of_match_node(shmem_of_match, shmem))
 			return -ENXIO;
 
 		ret = of_address_to_resource(shmem, 0, &res);
-		of_node_put(shmem);
 		if (ret) {
 			dev_err(dev, "failed to get SCPI payload mem resource\n");
 			return ret;
-- 
2.51.0




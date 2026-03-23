Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3F13B27C5;
	Mon, 23 Mar 2026 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279187; cv=none; b=LG1xno4UjdtuUXMbiIFDccnqf5TTlFCibKl2uHCNnwTq4mA1J5CAp3tEk+8JR4CLjNHHQMB3qEQyMsqzmwBJwNhJ4DxmKa/EXxmidYNgFHcUjvSFYrI3JwKLyDvtuoWVXbdSlG0aUnkHEcyj3O4Fc3G8mSO497chcIGcbCfQLJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279187; c=relaxed/simple;
	bh=k8KHGLCUXyhHfiFHHCaAZmdcg16OYJjmRgNNYab6OGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEx2t8YWoP4uMxiN5KDfQrFLa+xd90YwVNaq9G3FjUBvvi/6twhV07lmgwg/5SMZo1qZ/30DlYmqVSOshtS0xrLWCklVx7Yq/bf89F73bJYqHDM56nNV9lpuu2fnhDcUJ4TVc011gZjKNZI+CTXxKdShS1k8ClGsqp5JtYWeS/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Wh0xnye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Wh0xnye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29AAC2BC9E;
	Mon, 23 Mar 2026 15:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279187;
	bh=k8KHGLCUXyhHfiFHHCaAZmdcg16OYJjmRgNNYab6OGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Wh0xnyeI739ukvEZHiDVPVbgKJH+3mG4rtUSLZwkj9Vvk15tSe27bZMfWvC3K2As
	 Kkoc4YaqXbelPgbnBXAdTxM1mRsSzecMm9y9rsAW8dtpJquwHFGIKu64iHOqelrJJl
	 HmQS4pXk0CMycypgprgL7rTVBP+zp1pIiyj1sDLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 502/567] firmware: arm_scpi: Fix device_node reference leak in probe path
Date: Mon, 23 Mar 2026 14:47:02 +0100
Message-ID: <20260323134546.440865513@linuxfoundation.org>
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
index 3de25e9d18ef8..2d85e783ae267 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -18,6 +18,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/bitfield.h>
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/export.h>
@@ -945,13 +946,13 @@ static int scpi_probe(struct platform_device *pdev)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCBD264FB0;
	Tue,  8 Apr 2025 12:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113674; cv=none; b=fjwQoE0aIewlO218RXMV21TCngI76Z1dHBu2JUjS3jE9NUeEFbpf0Uh9YkV1PNLO786cjWJVWFSuw7mdtUoHUHYe1udF+Dh1NiibTnt6bgz8q5VAmffCNcdSoOXgyzsuEy74Zlneh8q0JvO30kfJUj9mnB7x9elsRT8B/HWGquI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113674; c=relaxed/simple;
	bh=2g9PrQ/WAo/hU2j2wf5claVW8X/NqcoW+YPjWYqTbKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHdkP/YV/8J7GUCdPIAf0Py1BThyXm/YermSWoTVj2K0+i4r4a6UaqVqxEk1NGIYRW3SK04XKpVhtkn0mfXmP6tFhkpVyXzr0u152T4rlh2+4wpHY6K252cn8M6fElSaGKMDewZLqEVP1ErBKdPQQq+FM7r4q/MoNudP6VZAmwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7Rdacds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7Rdacds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDA8C4CEE5;
	Tue,  8 Apr 2025 12:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113674;
	bh=2g9PrQ/WAo/hU2j2wf5claVW8X/NqcoW+YPjWYqTbKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7Rdacds04gUGUKRE4BSgFIm2oPppqN8Ls0c13pzAdcgZmcveaZ6h1bhAOkPVBqcu
	 AJC7f77ymUqgCWtgQxwFIL2wFtYhDnDWY7WbPIB5T8dgAvXHogqaW7u7bmpbCM3c/M
	 4aNexFy5FfYH7cgAZ5mvcf4wTCphJiZrobfon7t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 248/268] mmc: omap: Fix memory leak in mmc_omap_new_slot
Date: Tue,  8 Apr 2025 12:50:59 +0200
Message-ID: <20250408104835.277123864@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 3834a759afb817e23a7a2f09c2c9911b0ce5c588 upstream.

Add err_free_host label to properly pair mmc_alloc_host() with
mmc_free_host() in GPIO error paths. The allocated host memory was
leaked when GPIO lookups failed.

Fixes: e519f0bb64ef ("ARM/mmc: Convert old mmci-omap to GPIO descriptors")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250318140226.19650-1-linmq006@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/omap.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1276,19 +1276,25 @@ static int mmc_omap_new_slot(struct mmc_
 	/* Check for some optional GPIO controls */
 	slot->vsd = devm_gpiod_get_index_optional(host->dev, "vsd",
 						  id, GPIOD_OUT_LOW);
-	if (IS_ERR(slot->vsd))
-		return dev_err_probe(host->dev, PTR_ERR(slot->vsd),
+	if (IS_ERR(slot->vsd)) {
+		r = dev_err_probe(host->dev, PTR_ERR(slot->vsd),
 				     "error looking up VSD GPIO\n");
+		goto err_free_host;
+	}
 	slot->vio = devm_gpiod_get_index_optional(host->dev, "vio",
 						  id, GPIOD_OUT_LOW);
-	if (IS_ERR(slot->vio))
-		return dev_err_probe(host->dev, PTR_ERR(slot->vio),
+	if (IS_ERR(slot->vio)) {
+		r = dev_err_probe(host->dev, PTR_ERR(slot->vio),
 				     "error looking up VIO GPIO\n");
+		goto err_free_host;
+	}
 	slot->cover = devm_gpiod_get_index_optional(host->dev, "cover",
 						    id, GPIOD_IN);
-	if (IS_ERR(slot->cover))
-		return dev_err_probe(host->dev, PTR_ERR(slot->cover),
+	if (IS_ERR(slot->cover)) {
+		r = dev_err_probe(host->dev, PTR_ERR(slot->cover),
 				     "error looking up cover switch GPIO\n");
+		goto err_free_host;
+	}
 
 	host->slots[id] = slot;
 
@@ -1348,6 +1354,7 @@ err_remove_slot_name:
 		device_remove_file(&mmc->class_dev, &dev_attr_slot_name);
 err_remove_host:
 	mmc_remove_host(mmc);
+err_free_host:
 	mmc_free_host(mmc);
 	return r;
 }



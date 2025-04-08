Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8314A207E14;
	Tue,  8 Apr 2025 12:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115525; cv=none; b=jkgNzM9+Tplqw87t54zLebdwluw9Jr2EJzTwnn+dLVwaTNciquREI6w7rfwtz53zdFHBT8fqROyxH8YMqfXaVAbna6BqwcsBnWS91OQAKzRl5wQHryTA9cTGrIFAFFbu6v558vwV1wncqg69rlXH0KD9sSayMrG5kR4cW/sYLp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115525; c=relaxed/simple;
	bh=jSN5pRc5QsYMx+i11Jnew3OxyDsmrai+kUV6dEFl4PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZgC37WicT6zPJT1z3EVkxaKk13oJNvpVY/RZXjIn1Kt+l1hUtau8ScUArrtEOhsf4LAZkypsg0LP+NwvD17cPLNK8EG4nC1+E9W/mfmu8Qqz00CiTgmbMdFAzaSPAw37wTeiyixoaxUfsfG/IfSfJTu3iLx9vIGEfY3sd82dTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQmryfOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQmryfOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D17C4CEE5;
	Tue,  8 Apr 2025 12:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115525;
	bh=jSN5pRc5QsYMx+i11Jnew3OxyDsmrai+kUV6dEFl4PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQmryfOJL37gMx8VfTBcJTf8dtPATN7+NBg48sm3tF1Stb0eRM1Qb9K48jrVAiKx3
	 Q3nrtL6T611t8IM1tJaVv5DVXWnOJjqL9Ha7eJVpaBFf5ZCiFvbzlR0pD5Y1Xy6Zsg
	 bi9jO76D45c5qzKmmzTKfzEgduoMBfic1HajNX90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.13 462/499] mmc: omap: Fix memory leak in mmc_omap_new_slot
Date: Tue,  8 Apr 2025 12:51:14 +0200
Message-ID: <20250408104902.761885728@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1272,19 +1272,25 @@ static int mmc_omap_new_slot(struct mmc_
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
 
@@ -1344,6 +1350,7 @@ err_remove_slot_name:
 		device_remove_file(&mmc->class_dev, &dev_attr_slot_name);
 err_remove_host:
 	mmc_remove_host(mmc);
+err_free_host:
 	mmc_free_host(mmc);
 	return r;
 }



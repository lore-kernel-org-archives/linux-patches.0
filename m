Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAE27D09F;
	Mon,  8 Apr 2024 13:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583358; cv=none; b=IeTjXXDr+JYtcrHFMRHshjAfp+3UUADr6u9cVcWG7tjKT8tsd7J2V1ukeeOS+Gq7XCPAn2iK4nNmxw0GmnvwJ98RLMHOqmbQgyx59/Nzj+0UtZKUtm4tnD/Ep2TohvG6tZc3P9AwmKamTmU3ylbR7bML+qj2mYakVdZvm/AU1Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583358; c=relaxed/simple;
	bh=zDf+dIarDF90JWDRA6b4L3VaODHtt2FIjlsw2LE5Ozc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJtg+bc97HgRSwmj7Od9Li4JacjDiibSdq0Pj/v5VKma8gWiaxKP3Abb6b6r1mOUKQrdT75ELoDWYgLnPBx/sN59M2TsuZl/DAj4Ac4kesH1XeXMpQtsxX6ZtFxVSN/ca8U+EhlLItwI97tSRA60XCXZzsfxqE5E6+J1IOBewzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ishjP7up; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ishjP7up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982BCC433F1;
	Mon,  8 Apr 2024 13:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583358;
	bh=zDf+dIarDF90JWDRA6b4L3VaODHtt2FIjlsw2LE5Ozc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ishjP7upXSy0y38nZbTEkTXezZ4/irVdLLTO39Y1XhwYiMgDF2snWS/N4hAHf3XY6
	 S3GvwihnWlXyVf1IuwsIN6HkNr2SAN4nIgyaHUNQvhvAA6b8WMtHJFRfVmetj77+3b
	 kOcyqIhkRqucgtYlxJRmPO283XWvLeYMoYlqd/m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/252] scsi: mylex: Fix sysfs buffer lengths
Date: Mon,  8 Apr 2024 14:58:04 +0200
Message-ID: <20240408125312.406504076@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1197c5b2099f716b3de327437fb50900a0b936c9 ]

The myrb and myrs drivers use an odd way of implementing their sysfs files,
calling snprintf() with a fixed length of 32 bytes to print into a page
sized buffer. One of the strings is actually longer than 32 bytes, which
clang can warn about:

drivers/scsi/myrb.c:1906:10: error: 'snprintf' will always be truncated; specified size is 32, but format string expands to at least 34 [-Werror,-Wformat-truncation]
drivers/scsi/myrs.c:1089:10: error: 'snprintf' will always be truncated; specified size is 32, but format string expands to at least 34 [-Werror,-Wformat-truncation]

These could all be plain sprintf() without a length as the buffer is always
long enough. On the other hand, sysfs files should not be overly long
either, so just double the length to make sure the longest strings don't
get truncated here.

Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240326223825.4084412-8-arnd@kernel.org
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/myrb.c | 20 ++++++++++----------
 drivers/scsi/myrs.c | 24 ++++++++++++------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index ca2e932dd9b70..f684eb5e04898 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1775,9 +1775,9 @@ static ssize_t raid_state_show(struct device *dev,
 
 		name = myrb_devstate_name(ldev_info->state);
 		if (name)
-			ret = snprintf(buf, 32, "%s\n", name);
+			ret = snprintf(buf, 64, "%s\n", name);
 		else
-			ret = snprintf(buf, 32, "Invalid (%02X)\n",
+			ret = snprintf(buf, 64, "Invalid (%02X)\n",
 				       ldev_info->state);
 	} else {
 		struct myrb_pdev_state *pdev_info = sdev->hostdata;
@@ -1796,9 +1796,9 @@ static ssize_t raid_state_show(struct device *dev,
 		else
 			name = myrb_devstate_name(pdev_info->state);
 		if (name)
-			ret = snprintf(buf, 32, "%s\n", name);
+			ret = snprintf(buf, 64, "%s\n", name);
 		else
-			ret = snprintf(buf, 32, "Invalid (%02X)\n",
+			ret = snprintf(buf, 64, "Invalid (%02X)\n",
 				       pdev_info->state);
 	}
 	return ret;
@@ -1886,11 +1886,11 @@ static ssize_t raid_level_show(struct device *dev,
 
 		name = myrb_raidlevel_name(ldev_info->raid_level);
 		if (!name)
-			return snprintf(buf, 32, "Invalid (%02X)\n",
+			return snprintf(buf, 64, "Invalid (%02X)\n",
 					ldev_info->state);
-		return snprintf(buf, 32, "%s\n", name);
+		return snprintf(buf, 64, "%s\n", name);
 	}
-	return snprintf(buf, 32, "Physical Drive\n");
+	return snprintf(buf, 64, "Physical Drive\n");
 }
 static DEVICE_ATTR_RO(raid_level);
 
@@ -1903,15 +1903,15 @@ static ssize_t rebuild_show(struct device *dev,
 	unsigned char status;
 
 	if (sdev->channel < myrb_logical_channel(sdev->host))
-		return snprintf(buf, 32, "physical device - not rebuilding\n");
+		return snprintf(buf, 64, "physical device - not rebuilding\n");
 
 	status = myrb_get_rbld_progress(cb, &rbld_buf);
 
 	if (rbld_buf.ldev_num != sdev->id ||
 	    status != MYRB_STATUS_SUCCESS)
-		return snprintf(buf, 32, "not rebuilding\n");
+		return snprintf(buf, 64, "not rebuilding\n");
 
-	return snprintf(buf, 32, "rebuilding block %u of %u\n",
+	return snprintf(buf, 64, "rebuilding block %u of %u\n",
 			rbld_buf.ldev_size - rbld_buf.blocks_left,
 			rbld_buf.ldev_size);
 }
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index a1eec65a9713f..e824be9d9bbb9 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -947,9 +947,9 @@ static ssize_t raid_state_show(struct device *dev,
 
 		name = myrs_devstate_name(ldev_info->dev_state);
 		if (name)
-			ret = snprintf(buf, 32, "%s\n", name);
+			ret = snprintf(buf, 64, "%s\n", name);
 		else
-			ret = snprintf(buf, 32, "Invalid (%02X)\n",
+			ret = snprintf(buf, 64, "Invalid (%02X)\n",
 				       ldev_info->dev_state);
 	} else {
 		struct myrs_pdev_info *pdev_info;
@@ -958,9 +958,9 @@ static ssize_t raid_state_show(struct device *dev,
 		pdev_info = sdev->hostdata;
 		name = myrs_devstate_name(pdev_info->dev_state);
 		if (name)
-			ret = snprintf(buf, 32, "%s\n", name);
+			ret = snprintf(buf, 64, "%s\n", name);
 		else
-			ret = snprintf(buf, 32, "Invalid (%02X)\n",
+			ret = snprintf(buf, 64, "Invalid (%02X)\n",
 				       pdev_info->dev_state);
 	}
 	return ret;
@@ -1066,13 +1066,13 @@ static ssize_t raid_level_show(struct device *dev,
 		ldev_info = sdev->hostdata;
 		name = myrs_raid_level_name(ldev_info->raid_level);
 		if (!name)
-			return snprintf(buf, 32, "Invalid (%02X)\n",
+			return snprintf(buf, 64, "Invalid (%02X)\n",
 					ldev_info->dev_state);
 
 	} else
 		name = myrs_raid_level_name(MYRS_RAID_PHYSICAL);
 
-	return snprintf(buf, 32, "%s\n", name);
+	return snprintf(buf, 64, "%s\n", name);
 }
 static DEVICE_ATTR_RO(raid_level);
 
@@ -1086,7 +1086,7 @@ static ssize_t rebuild_show(struct device *dev,
 	unsigned char status;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
-		return snprintf(buf, 32, "physical device - not rebuilding\n");
+		return snprintf(buf, 64, "physical device - not rebuilding\n");
 
 	ldev_info = sdev->hostdata;
 	ldev_num = ldev_info->ldev_num;
@@ -1098,11 +1098,11 @@ static ssize_t rebuild_show(struct device *dev,
 		return -EIO;
 	}
 	if (ldev_info->rbld_active) {
-		return snprintf(buf, 32, "rebuilding block %zu of %zu\n",
+		return snprintf(buf, 64, "rebuilding block %zu of %zu\n",
 				(size_t)ldev_info->rbld_lba,
 				(size_t)ldev_info->cfg_devsize);
 	} else
-		return snprintf(buf, 32, "not rebuilding\n");
+		return snprintf(buf, 64, "not rebuilding\n");
 }
 
 static ssize_t rebuild_store(struct device *dev,
@@ -1190,7 +1190,7 @@ static ssize_t consistency_check_show(struct device *dev,
 	unsigned short ldev_num;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
-		return snprintf(buf, 32, "physical device - not checking\n");
+		return snprintf(buf, 64, "physical device - not checking\n");
 
 	ldev_info = sdev->hostdata;
 	if (!ldev_info)
@@ -1198,11 +1198,11 @@ static ssize_t consistency_check_show(struct device *dev,
 	ldev_num = ldev_info->ldev_num;
 	myrs_get_ldev_info(cs, ldev_num, ldev_info);
 	if (ldev_info->cc_active)
-		return snprintf(buf, 32, "checking block %zu of %zu\n",
+		return snprintf(buf, 64, "checking block %zu of %zu\n",
 				(size_t)ldev_info->cc_lba,
 				(size_t)ldev_info->cfg_devsize);
 	else
-		return snprintf(buf, 32, "not checking\n");
+		return snprintf(buf, 64, "not checking\n");
 }
 
 static ssize_t consistency_check_store(struct device *dev,
-- 
2.43.0




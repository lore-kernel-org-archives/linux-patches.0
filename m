Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7951465BE;
	Thu, 11 Apr 2024 10:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830933; cv=none; b=JZymIcsyevcu/3khKTfVKN7XQujDnnDHqUXn2slflsU6wbOyIZF3eFZ66gbBqnvF4zzxK0rDqhRaM5vczjv7BPaDm5vf4N6XBnp+LEgWbVJUbfgULCFd2VI7P/M1Li+8qv8neKACBRLCaUE6duivFkzXXm1SFPyzkolgz6rnIdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830933; c=relaxed/simple;
	bh=tHLXW9C6FUwyojIx2+G1GWd9o9A3KWGiOXke9CoBQbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7hrZmOyrmOzzMMnaGeQTUZwE5gUVfznFuoCfxxzsBdAhs+j0yoLEqtEjV1Ip6CbeqyjV1hmWpfwFwE8SLZSNdD00C05r26uWwGhcYArp9yFgHvmvK3YQCtiWCq50d9c3yCnSM/cgKZc+rqH4DrlHUP/yYKgTLOhWRLZK/3H6xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCBK0nqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCBK0nqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0395C433F1;
	Thu, 11 Apr 2024 10:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830933;
	bh=tHLXW9C6FUwyojIx2+G1GWd9o9A3KWGiOXke9CoBQbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCBK0nqiWS9m6Un7ppF+emHccfXW4N2+I1WDMPS43auYzvSYTLtYSnhuMhfSTQ7gj
	 XddUgNUWq2pU+kVAtNcIKgtPlutlsAZhyGjvH38gidvhHyDmQiADIIcOW8E58gCGUT
	 nxLIFbm5GvNJy705RtloXIrdqaC4TfMKZYNEZNfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 167/215] scsi: mylex: Fix sysfs buffer lengths
Date: Thu, 11 Apr 2024 11:56:16 +0200
Message-ID: <20240411095429.895001223@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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
index 35b32920a94a0..c7baba5748f11 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1803,9 +1803,9 @@ static ssize_t raid_state_show(struct device *dev,
 
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
@@ -1824,9 +1824,9 @@ static ssize_t raid_state_show(struct device *dev,
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
@@ -1914,11 +1914,11 @@ static ssize_t raid_level_show(struct device *dev,
 
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
 
@@ -1931,15 +1931,15 @@ static ssize_t rebuild_show(struct device *dev,
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
index 2d3d14aa46b4b..bf0546fc555f2 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -950,9 +950,9 @@ static ssize_t raid_state_show(struct device *dev,
 
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
@@ -961,9 +961,9 @@ static ssize_t raid_state_show(struct device *dev,
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
@@ -1069,13 +1069,13 @@ static ssize_t raid_level_show(struct device *dev,
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
 
@@ -1089,7 +1089,7 @@ static ssize_t rebuild_show(struct device *dev,
 	unsigned char status;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
-		return snprintf(buf, 32, "physical device - not rebuilding\n");
+		return snprintf(buf, 64, "physical device - not rebuilding\n");
 
 	ldev_info = sdev->hostdata;
 	ldev_num = ldev_info->ldev_num;
@@ -1101,11 +1101,11 @@ static ssize_t rebuild_show(struct device *dev,
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
@@ -1194,7 +1194,7 @@ static ssize_t consistency_check_show(struct device *dev,
 	unsigned char status;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
-		return snprintf(buf, 32, "physical device - not checking\n");
+		return snprintf(buf, 64, "physical device - not checking\n");
 
 	ldev_info = sdev->hostdata;
 	if (!ldev_info)
@@ -1202,11 +1202,11 @@ static ssize_t consistency_check_show(struct device *dev,
 	ldev_num = ldev_info->ldev_num;
 	status = myrs_get_ldev_info(cs, ldev_num, ldev_info);
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




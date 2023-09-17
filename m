Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7086ABA
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0345C433C8;
	Sun, 17 Sep 2023 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982009;
	bh=jgTWJXU9rtF9UA/dQu1G9LY6FX4NAywPEWl1V9CuZlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sud7/4XIvKxtWlSTfwU9y1oynSQxtQXZ0m0bNBr+2rJrh3BfcTi94K0AwctjwibF7
	 rNINzo6AZRlvIYuUfme0d4NMgKN5YzMJyuQNHzgGRXU58Lj54MQn8dLLKyeWeg5ZMz
	 1AbzQCrnlhrAMmVIHWA+meok7QjLIAVxcrpq7SjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/219] platform/mellanox: mlxbf-pmc: Fix potential buffer overflows
Date: Sun, 17 Sep 2023 21:15:32 +0200
Message-ID: <20230917191048.348283006@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravan Kumar Ramani <shravankr@nvidia.com>

[ Upstream commit 80ccd40568bcd3655b0fd0be1e9b3379fd6e1056 ]

Replace sprintf with sysfs_emit where possible.
Size check in mlxbf_pmc_event_list_show should account for "\0".

Fixes: 1a218d312e65 ("platform/mellanox: mlxbf-pmc: Add Mellanox BlueField PMC driver")
Signed-off-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/bef39ef32319a31b32f999065911f61b0d3b17c3.1693917738.git.shravankr@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index be967d797c28e..95afcae7b9fa9 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1008,7 +1008,7 @@ static ssize_t mlxbf_pmc_counter_show(struct device *dev,
 	} else
 		return -EINVAL;
 
-	return sprintf(buf, "0x%llx\n", value);
+	return sysfs_emit(buf, "0x%llx\n", value);
 }
 
 /* Store function for "counter" sysfs files */
@@ -1078,13 +1078,13 @@ static ssize_t mlxbf_pmc_event_show(struct device *dev,
 
 	err = mlxbf_pmc_read_event(blk_num, cnt_num, is_l3, &evt_num);
 	if (err)
-		return sprintf(buf, "No event being monitored\n");
+		return sysfs_emit(buf, "No event being monitored\n");
 
 	evt_name = mlxbf_pmc_get_event_name(pmc->block_name[blk_num], evt_num);
 	if (!evt_name)
 		return -EINVAL;
 
-	return sprintf(buf, "0x%llx: %s\n", evt_num, evt_name);
+	return sysfs_emit(buf, "0x%llx: %s\n", evt_num, evt_name);
 }
 
 /* Store function for "event" sysfs files */
@@ -1139,9 +1139,9 @@ static ssize_t mlxbf_pmc_event_list_show(struct device *dev,
 		return -EINVAL;
 
 	for (i = 0, buf[0] = '\0'; i < size; ++i) {
-		len += sprintf(e_info, "0x%x: %s\n", events[i].evt_num,
-			       events[i].evt_name);
-		if (len > PAGE_SIZE)
+		len += snprintf(e_info, sizeof(e_info), "0x%x: %s\n",
+				events[i].evt_num, events[i].evt_name);
+		if (len >= PAGE_SIZE)
 			break;
 		strcat(buf, e_info);
 		ret = len;
@@ -1168,7 +1168,7 @@ static ssize_t mlxbf_pmc_enable_show(struct device *dev,
 
 	value = FIELD_GET(MLXBF_PMC_L3C_PERF_CNT_CFG_EN, perfcnt_cfg);
 
-	return sprintf(buf, "%d\n", value);
+	return sysfs_emit(buf, "%d\n", value);
 }
 
 /* Store function for "enable" sysfs files - only for l3cache */
-- 
2.40.1




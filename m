Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAECF21660B;
	Thu, 12 Dec 2024 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016296; cv=none; b=ZbstFSBi2e5wCdxWwGA6W1z/V9vQkZy3F93p+JwZQSBZzPSlChOOlPbpjXR1CTq+VkArifxFoOEC4TG5KQcr8K0kvk7SJ24g2V5hfjVM+74U7znz/nlYs/pvv8FUCHFVo3YHRJhK+oWT8/S8PNfgWejR+5qEtuY5JFIp4hJg63Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016296; c=relaxed/simple;
	bh=3K8hiSU9CKbGBhw3ylAsiFlbdQNEbBVwMaXBDpbXKTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPajuz9uEcWodYT+PbSHBgjEqZnGhhRjLhebYZkyny3XkwNHcM41hp5NZBFuNbosy7Hqu5+B1eIYEv9hrrpX+RJ+7MJQ8nPDzymFKq24haRkVqvR5X+1r+ixkMDk393bPQTBGlgBcX7QkUQgqSzyAlN2ZfNQHPtGILkquVW9nGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJFMYyGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJFMYyGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180F3C4CECE;
	Thu, 12 Dec 2024 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016295;
	bh=3K8hiSU9CKbGBhw3ylAsiFlbdQNEbBVwMaXBDpbXKTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJFMYyGhNJ5076C2ThEpHyVwiLA8BRIA+X+d1z4mLFx1xPgGX+WQzhiz8DuzT9FJj
	 lefr0d2pLRpRZbvJV/TP7FMP5Mw5K0WD1oMcBk2Y7OxoAJY0dIQqq+TpaFx3Nbrt23
	 BUOLsWloIX1d41thjKDwmtrARzESzR9PSz+XfDwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@chromium.org>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 150/466] scsi: ufs: core: sysfs: Prevent div by zero
Date: Thu, 12 Dec 2024 15:55:19 +0100
Message-ID: <20241212144312.724481761@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gwendal Grignou <gwendal@chromium.org>

commit eb48e9fc0028bed94a40a9352d065909f19e333c upstream.

Prevent a division by 0 when monitoring is not enabled.

Fixes: 1d8613a23f3c ("scsi: ufs: core: Introduce HBA performance monitor sysfs nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20241120062522.917157-1-gwendal@chromium.org
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufs-sysfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -670,6 +670,9 @@ static ssize_t read_req_latency_avg_show
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[READ])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[READ]),
 						 m->nr_req[READ]));
 }
@@ -737,6 +740,9 @@ static ssize_t write_req_latency_avg_sho
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[WRITE])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[WRITE]),
 						 m->nr_req[WRITE]));
 }



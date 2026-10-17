Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80F12D73A6;
	Sat, 17 Oct 2026 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255907; cv=none; b=Y2t3WVrH4e9yZNBlTitxTXBLEeTKbxRHdiShWZ+k+WFVVKbHvRj6jr2LOtRD9c15467DOTLO6aSSfjBBpPbTUxGxi13SmAdZJ0/Vp8YTJN/PZVP9xw6JnzUv6P/O6JGP+aFbX6iBqqQtuK/Axt4iMs1GrKVz94/OcKPnT4Igpw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255907; c=relaxed/simple;
	bh=iPsvKUr7iJnMR3eYHR+RV7cRYknyyVTOAIxvvLrFd34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQ5jK6dmoXv5zlaHKkcq//WgBENESHWYPn7Jo5mylWnR/gHqU6KbnuL/zxKAm54v5FmBlV2Aq1VCr5IcSNgDZ75l+PSG2Ez8g8gr+xQ7Z8tn7oufWSudF3Cu56q1OdpqrtblpJlJcUvqcU0x0cLCM6QO+wXu7IejZO0xrl7/pSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gs/Y5crj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gs/Y5crj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408021F000C4;
	Sat, 17 Oct 2026 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255905;
	bh=ylKVrLlt2zNYo+nrL8UwcNEsJbXbAfdUZ4VkzB2F7q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gs/Y5crjEPJ966Z0A8WC01alOlgZzrrBt2aWaD57D83OFBs3H1wAmFMhODcqVZvri
	 MDCveYR/ePyEiEQbqSJ4BUmB/Fnez/cmJkmUx2FCKc7YKeiYxfgc69jLb8FEFV9ZPx
	 9mRbKKf9mVYHW2y3S8rpbaL9ZbWS4H/9fbwEgoU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0059/1674] coresight: etm3x: Fix cntr_val_show() to match cntr_val_store() behavior
Date: Sat, 17 Oct 2026 17:38:51 +0200
Message-ID: <20261017160432.652854842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 41fb4e925528aefa4b7a5f76c7f81db99c0d0f38 ]

The cntr_val_show() function was intended to print the values of all
counters using a loop. However, due to a buffer overwrite issue with
sprintf(), it effectively only displayed the value of the last counter.

The companion function, cntr_val_store(), allows users to modify a
specific counter selected by 'cntr_idx'. To maintain consistency
between read and write operations and to align with the ETM4x driver
behavior, modify cntr_val_show() to report only the value of the
currently selected counter.

This change removes the loop and the "counter %d:" prefix, printing
only the hexadecimal value. It also adopts sysfs_emit() for standard
sysfs output formatting.

Fixes: a939fc5a71ad ("coresight-etm: add CoreSight ETM/PTM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251202082613.3265761-1-visitorckw@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-etm3x-sysfs.c   | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
index 2f271b7fb048c..c88c64900698b 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
@@ -717,26 +717,19 @@ static DEVICE_ATTR_RW(cntr_rld_event);
 static ssize_t cntr_val_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
-	int i, ret = 0;
 	u32 val;
 	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
 	struct etm_config *config = &drvdata->config;
 
 	if (!local_read(&drvdata->mode)) {
 		spin_lock(&drvdata->spinlock);
-		for (i = 0; i < drvdata->nr_cntr; i++)
-			ret += sprintf(buf, "counter %d: %x\n",
-				       i, config->cntr_val[i]);
+		val = config->cntr_val[config->cntr_idx];
 		spin_unlock(&drvdata->spinlock);
-		return ret;
-	}
-
-	for (i = 0; i < drvdata->nr_cntr; i++) {
-		val = etm_readl(drvdata, ETMCNTVRn(i));
-		ret += sprintf(buf, "counter %d: %x\n", i, val);
+	} else {
+		val = etm_readl(drvdata, ETMCNTVRn(config->cntr_idx));
 	}
 
-	return ret;
+	return sysfs_emit(buf, "%#x\n", val);
 }
 
 static ssize_t cntr_val_store(struct device *dev,
-- 
2.53.0




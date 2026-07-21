Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B4D471255;
	Tue, 21 Jul 2026 18:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657522; cv=none; b=Rcg9A0eC9wyV4JfFrwFBVlNTbptxXkhwsH3+0ePIEf+JcIYl5SToWfu1hBb8tVInTL18ywVzzTkULpldRLW+tpS25M7SXyetdukIMpNoE4jbNwZuChMWCJvioOnNZk7ko0w5/28vwGT1f8U9L1lN0bn60vq51Y9pd0Q1Wfb8b5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657522; c=relaxed/simple;
	bh=I41+mi3X3nrhd/xJM+ew3Bd+GQaffyA9e8Bl+EfHKLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsxsvL41Q06a1VY1lSTxcsLdLHWP0mwFb8j6rU6/hpa0K0PLAmmLmiBdO7u5ZDsg2KCRMWptfmYahcSTZsMrp7PLJM5yMItenfbMgHM2gN0p9Xqtx6v+FJOTSciMnyzz+wFpx14kwDsFnXDkVVWKIG5Rl5CiovR78H2JNprJvi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLVbyVlo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLVbyVlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9556C1F000E9;
	Tue, 21 Jul 2026 18:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657520;
	bh=VMvWza2SzAoticiTwZDYz+4Au2R+n8UHvZkkB8Ib1tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLVbyVloB2Bs+LAP0pgBoUD53Ej/WHRHav3zNXEjCF7LMAm2JlqJmyh0yBqjZf+dp
	 rSBf3ewg+xKAZWCsy2qpIvNLRK3o/M8KHh6vOnpsMYOzwpDOASRSFsphxHu79SO2Z/
	 iN4ubMRp13OcqMWoKN2WFnn2gMdA9ccs9SewaA+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0789/1611] i3c: master: Update dev_nack_retry_count under maintenance lock
Date: Tue, 21 Jul 2026 17:15:05 +0200
Message-ID: <20260721152533.136584030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit ab5f9c5cb527c03790a92142ad368881a9100aaf ]

Protect master->dev_nack_retry_count against concurrent sysfs updates
by updating it while holding the bus maintenance lock.

Consequently, combine adjacent return statements into one.

For consistency, read dev_nack_retry_count while holding the bus normaluse
lock.

Fixes: b58f47eb39268 ("i3c: add sysfs entry and attribute for Device NACK Retry count")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260616113752.196140-2-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index f0ff305642bf0c..90743266cd85f5 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -744,7 +744,14 @@ static DEVICE_ATTR_RW(hotjoin);
 static ssize_t dev_nack_retry_count_show(struct device *dev,
 					 struct device_attribute *attr, char *buf)
 {
-	return sysfs_emit(buf, "%u\n", dev_to_i3cmaster(dev)->dev_nack_retry_count);
+	struct i3c_bus *i3cbus = dev_to_i3cbus(dev);
+	ssize_t ret;
+
+	i3c_bus_normaluse_lock(i3cbus);
+	ret = sysfs_emit(buf, "%u\n", dev_to_i3cmaster(dev)->dev_nack_retry_count);
+	i3c_bus_normaluse_unlock(i3cbus);
+
+	return ret;
 }
 
 static ssize_t dev_nack_retry_count_store(struct device *dev,
@@ -762,14 +769,11 @@ static ssize_t dev_nack_retry_count_store(struct device *dev,
 
 	i3c_bus_maintenance_lock(i3cbus);
 	ret = master->ops->set_dev_nack_retry(master, val);
+	if (!ret)
+		master->dev_nack_retry_count = val;
 	i3c_bus_maintenance_unlock(i3cbus);
 
-	if (ret)
-		return ret;
-
-	master->dev_nack_retry_count = val;
-
-	return count;
+	return ret ?: count;
 }
 
 static DEVICE_ATTR_RW(dev_nack_retry_count);
-- 
2.53.0




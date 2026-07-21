Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F1F471246;
	Tue, 21 Jul 2026 19:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660725; cv=none; b=P7mt6mKTYJ29hPnNWR5PWwfXIpub378RKdgroMf1XD5gshYO1LdmcxCkpwr5e+rQ9bf8iQUUWF3pk5v4DdE6bVjZbFWznGI1t0yw3vbmnnPzmlZ8JlOjTdsm1aOKv+En+A4X6AHK4dTo/cgOU9oiQcLu2hsbJZi6FOi5vPkOsJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660725; c=relaxed/simple;
	bh=tR5Ngzy4m5M46iZzQAck9GvyIrrNDKkzaKdeE7e8xyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=db8ghI/afhnmzs0ybXt75nEa5P6b51U0TYgopUf0PP5myGc7AqN3H1yURezirV5134vYEso/ztsqO1jpNuRcHocYFEbqngDtZTcfQZ+EGCa8U4Pkub6IaI5ItkJbek1OFzsDMOq3HppNIjuHiAAYi6rYXMyS8gWeRMaWLiS2uhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh0PVJO6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh0PVJO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0A41F000E9;
	Tue, 21 Jul 2026 19:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660724;
	bh=G3EdM8T11q0jEhiNsuZe2IbLMfs10vLmh/Nl54rD8Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hh0PVJO6iq9RdtuBLGlgV0+k/CsgsTC97SDancXB0hXdHhXiCBOpmgT/6c1MR7ig9
	 ebOYS1hXTG0aUEm4yVBwC4VpFzwO9XHFIVRHIBhf0cAKfZRQfz2lm+0LvpNOXrjFZ5
	 AnWDI4S31WLxF6Das/LVLpLoGoSvo9BQSBc1v1g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1087/2077] i3c: master: Update dev_nack_retry_count under maintenance lock
Date: Tue, 21 Jul 2026 17:12:40 +0200
Message-ID: <20260721152618.462112095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7952a38ebc3787..4d8e1d724c52ef 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -742,7 +742,14 @@ static DEVICE_ATTR_RW(hotjoin);
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
@@ -760,14 +767,11 @@ static ssize_t dev_nack_retry_count_store(struct device *dev,
 
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




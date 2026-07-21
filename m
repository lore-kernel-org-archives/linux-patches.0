Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D2E471257;
	Tue, 21 Jul 2026 18:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657551; cv=none; b=OrrgQEQ0rtobvG5RGfqdnkm4+LYbIhQgcvudouIDGNFUKiui+cavd4Q0e6QdVEfuJfhaVcPo1koGfzEPIA7t67tIvDwVunPBYrVa4C5yg1nP91Y3FJ896QuJkPLKktFO0myJdnvSLv6bHkYorPMvamYfgTGvi6FFBFhFfz8l1WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657551; c=relaxed/simple;
	bh=Vhsp1JunEkqWy3iFGo2qIZqLKm1K5hC7y1ei0DISPYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTYgwWT9hS9EiA+4KV2GcxSE5j44jmroseQRZIGWJLgQjb7dgtQussjmRf/1hS0NuM7gKqjqId1lxcQpfXmGWVtAsxGbrrRErZDza1ydGjCfgx4KLu2k+cVc/BZyeDrZpMXTubLJ0T/bGEWYgOMsLitEWhPR+GaBsd7mzIBWI8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=166V0gYR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="166V0gYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC991F000E9;
	Tue, 21 Jul 2026 18:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657550;
	bh=+3kj9a1RU+LdLK/arw2Nr294JpHoROUzzy0j2kCl5Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=166V0gYR1kWpu+R0Uan78E+ID8s4+ZXeRSM/JUN5Fj8V3E8w2MfCjrFpE48nIvAyZ
	 7SpXsYY4lqcjn6enBWdoUpgpRUC7x1EgciZ5IXNOKsEwxQ4x6fKIBKeixl9YWMrGVf
	 IhvIsq3pMiRWfnxiOBzDSWRekxv0wzmYg6w2419s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0790/1611] i3c: master: Add missing runtime PM get in dev_nack_retry_count_store()
Date: Tue, 21 Jul 2026 17:15:06 +0200
Message-ID: <20260721152533.158259683@linuxfoundation.org>
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

[ Upstream commit 79ce29e100ab3de0cad66eb48d32a7de4043e2ae ]

Ensure the device is runtime resumed while updating the retry
configuration to avoid accessing the controller while suspended.

Call i3c_master_rpm_get() before accessing the controller in
dev_nack_retry_count_store() and release it with
i3c_master_rpm_put() afterwards.

Fixes: 990c149c61ee4 ("i3c: master: Introduce optional Runtime PM support")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260616113752.196140-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 90743266cd85f5..588395e7a77063 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -767,12 +767,18 @@ static ssize_t dev_nack_retry_count_store(struct device *dev,
 	if (ret)
 		return ret;
 
+	ret = i3c_master_rpm_get(master);
+	if (ret)
+		return ret;
+
 	i3c_bus_maintenance_lock(i3cbus);
 	ret = master->ops->set_dev_nack_retry(master, val);
 	if (!ret)
 		master->dev_nack_retry_count = val;
 	i3c_bus_maintenance_unlock(i3cbus);
 
+	i3c_master_rpm_put(master);
+
 	return ret ?: count;
 }
 
-- 
2.53.0




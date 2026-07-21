Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB8E395D8E;
	Tue, 21 Jul 2026 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660728; cv=none; b=rDMZlstT+mwMMJjRYI1+ZAco9EOldqkSufo8Anr0nFpByONf7UuuzFwvs4JJpo8u7s/dHKqzquazvEM+WeCvREmFEzQ0FB8UoqWnjYJVUuQZCL1DkcqbwO8CAnfaJVWfXp7OTVX1gCISPZUJol5ykL297DYb+QUUeJB9vMsLXVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660728; c=relaxed/simple;
	bh=bcv2nf9Nqt/80cxiNwX+Y2YhEs20Nltg2KigtaMG6iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFcm3SpFqKmhm6/bmwZKQOTKx2M5J8CRUDzfu7lrp8LiudP/OeyNJSwgvwX+VuvJedmwG0s/L/+r9s5w2XjcEjno6eyAoAF9FqH4wAis2c8CFZVvOFODXsttjXzns76HNWpBuJmh3AiTETFpBCvTihgzTyZ9lAkU+ouTZsVYPe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8wS9MJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8wS9MJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18B71F000E9;
	Tue, 21 Jul 2026 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660727;
	bh=J2/A011pAXlELXVN6PztaRxZrAe4SLUJ1VBNjSTm4q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p8wS9MJatL9nn77asgLfwawB0xTbMUC9ScKr0s4T2e2V7fV38V9rq+W6XytDLrSyJ
	 vMyNLOD0NGvalohlly0AnEZwVWCBiSs0sLmNTfqzwk+X8KfeyjgK1NFKxJG2UNPIos
	 viKgjhVfQ4Ty8AfFYydgBnN2MS/pukzNdoF+GLaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1088/2077] i3c: master: Add missing runtime PM get in dev_nack_retry_count_store()
Date: Tue, 21 Jul 2026 17:12:41 +0200
Message-ID: <20260721152618.485471033@linuxfoundation.org>
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
index 4d8e1d724c52ef..74c04e19f86c59 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -765,12 +765,18 @@ static ssize_t dev_nack_retry_count_store(struct device *dev,
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




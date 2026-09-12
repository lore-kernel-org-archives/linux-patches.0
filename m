Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDEB4D5A1;
	Sat, 12 Sep 2026 07:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198831; cv=none; b=WujT9+q/SO6k35TVR1JQjuvs32eHAJL6j2LQNdD7F6Zj+WDJv4iK8wanoRRpZUjz/aw7rGSwFrBiuy+7EjN3SPHN6P8ZCkOGOWMXnjlEi3bTg5MgowmmLERbViGwSJynMNa8EUlfaWaVlyxE4PQgUyrUNTwuTDV/AlT2fAni+jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198831; c=relaxed/simple;
	bh=b/5FTy653x/nPnlpIHk3ikQlnzYTkfZ2RZjz4iV0xdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7H4n53eODo9ATIj8BsGOozh9ZsWdeqVoQhGLvFVRL1pyr7FbV8b9qI+pU9G1mZcedOOZBgaT1rETuqJ3VjpOPY8NeGPotFgBFmkc+IGHx0kZZKe0tmqAxoGNCi872bC1teaGxPggAbePS4VrMJD/UEZ20a72HSSEIRYGup5Kvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vV3iEtLZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vV3iEtLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAF31F000FF;
	Sat, 12 Sep 2026 07:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198830;
	bh=ZOi6YNeN01WxlaUoE7KLNVNALVItanj7imRpyw16p2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vV3iEtLZL9z0JpJ5BDmkgBpr68ikQf9RZXAZu1boDu0L/fe3eFLrbObRQN261woOY
	 GqM6sA7mQkFBvNuwCgPBk/R3OZg1zknvAkUasT7/I6wzZbCAs+FU5az3NjnLekifSt
	 XVEKOzoef1+fWqV/aY9KJ/V+hx11/KMtQe3Gfjuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0408/1815] firmware: arm_scmi: Fix transport device teardown lookup
Date: Sat, 12 Sep 2026 08:35:58 +0200
Message-ID: <20260912065658.473034175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit a14dd8fe0a95db638c550ed984cfe2a7428c783d ]

SCMI transport devices are deliberately excluded from normal SCMI bus
matching so protocol drivers cannot bind to the internal transport
children. However, scmi_device_destroy() uses the same protocol/name
lookup to find devices that must be unregistered during channel teardown.

Split the match helper so driver matching still skips transport devices,
while explicit child lookup can find them for teardown. Use a shared
transport-device name prefix macro for both matching and name generation.

Since transport-device names are derived from direction and protocol ID,
reject duplicate protocol channel setup before creating or finding a
transport device. This prevents malformed firmware with duplicate
protocol child nodes from reusing an existing transport device and then
destroying it when the duplicate IDR insertion fails.

Fixes: 9593804c44c2 ("firmware: arm_scmi: Exclude transport devices from bus matching")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-16-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c    | 22 +++++++++++++++++-----
 drivers/firmware/arm_scmi/common.h |  2 ++
 drivers/firmware/arm_scmi/driver.c |  5 ++++-
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index e1f66c08c81d0..7f06d56e49053 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -200,21 +200,33 @@ scmi_protocol_table_unregister(const struct scmi_device_id *id_table)
 		scmi_protocol_device_unrequest(entry);
 }
 
-static int scmi_dev_match_by_id_table(struct scmi_device *scmi_dev,
-				      const struct scmi_device_id *id_table)
+static bool scmi_device_is_transport(const struct scmi_device *scmi_dev)
+{
+	return !strncmp(scmi_dev->name, SCMI_TRANSPORT_DEVNAME_PREFIX,
+			strlen(SCMI_TRANSPORT_DEVNAME_PREFIX));
+}
+
+static int __scmi_dev_match_by_id_table(struct scmi_device *scmi_dev,
+					const struct scmi_device_id *id_table,
+					bool skip_transport)
 {
 	if (!id_table || !id_table->name)
 		return 0;
 
-	/* Always skip transport devices from matching */
 	for (; id_table->protocol_id && id_table->name; id_table++)
 		if (id_table->protocol_id == scmi_dev->protocol_id &&
-		    strncmp(scmi_dev->name, "__scmi_transport_device", 23) &&
+		    !(skip_transport && scmi_device_is_transport(scmi_dev)) &&
 		    !strcmp(id_table->name, scmi_dev->name))
 			return 1;
 	return 0;
 }
 
+static int scmi_dev_match_by_id_table(struct scmi_device *scmi_dev,
+				      const struct scmi_device_id *id_table)
+{
+	return __scmi_dev_match_by_id_table(scmi_dev, id_table, true);
+}
+
 static int scmi_dev_match_id(struct scmi_device *scmi_dev,
 			     const struct scmi_driver *scmi_drv)
 {
@@ -234,7 +246,7 @@ static int scmi_match_by_id_table(struct device *dev, const void *data)
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
 	const struct scmi_device_id *id_table = data;
 
-	return scmi_dev_match_by_id_table(scmi_dev, id_table);
+	return __scmi_dev_match_by_id_table(scmi_dev, id_table, false);
 }
 
 /* Returns a device_find_child() reference which must be dropped by caller. */
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index b9723c105fc1b..fe8c22cfb9f7d 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -34,6 +34,8 @@
 
 #define SCMI_SHMEM_MAX_PAYLOAD_SIZE	104
 
+#define SCMI_TRANSPORT_DEVNAME_PREFIX	"__scmi_transport_device"
+
 enum scmi_error_codes {
 	SCMI_SUCCESS = 0,	/* Success */
 	SCMI_ERR_SUPPORT = -1,	/* Not supported */
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 532f1f65b2ab6..ef29fd223287d 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2762,6 +2762,9 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	idx = tx ? 0 : 1;
 	idr = tx ? &info->tx_idr : &info->rx_idr;
 
+	if (idr_find(idr, prot_id))
+		return -EEXIST;
+
 	if (!info->desc->ops->chan_available(of_node, idx)) {
 		cinfo = idr_find(idr, SCMI_PROTOCOL_BASE);
 		if (unlikely(!cinfo)) /* Possible only if platform has no Rx */
@@ -2779,7 +2782,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	cinfo->no_completion_irq = info->desc->no_completion_irq;
 
 	/* Create a unique name for this transport device */
-	snprintf(name, 32, "__scmi_transport_device_%s_%02X",
+	snprintf(name, sizeof(name), SCMI_TRANSPORT_DEVNAME_PREFIX "_%s_%02X",
 		 idx ? "rx" : "tx", prot_id);
 	/* Create a uniquely named, dedicated transport device for this chan */
 	tdev = scmi_device_create(of_node, info->dev, prot_id, name);
-- 
2.53.0




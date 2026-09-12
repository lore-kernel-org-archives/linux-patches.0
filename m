Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD23A38AC92;
	Sat, 12 Sep 2026 10:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207323; cv=none; b=FNJuMjK6yGUh/vMrGde8MBNyBCSxWfJ4TKXyEuhmJ0ZzhXEb8PL4qimncvSzG29FxT0tkq/3DeJuVdmMzFIJU8Njkn2wTFipfz/BNzPKQGU1A8fyvkhblXk+Bfu2DNiZYv9BThkZWyoW+q/+C7Dl5uVS3HU3/4z7Jq5lBzYKZEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207323; c=relaxed/simple;
	bh=3J5mQXq99xc0g7RvBWtq7ky3CiBSZ8+rNztuEE4vyzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urOAsHlIUcx8w1bqYeyvditU/HHyjSftlnByfK/WvJUTnXSrjR0IDkV6YC4fJOKujVozWvlioWap0wHWUymNVnPOK6Sc/ddHKxgliH4acU/h/YGCAO87zaJaMnuu7joUzmo48NMzVGL9ARwwPQWdVU/qxn71ntpKCsO3TLj7u+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPNy+TGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPNy+TGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682D61F000FF;
	Sat, 12 Sep 2026 10:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207322;
	bh=MyJ5BHP7zQD+2NVJQkwj18jl2P8T6+7VwVEvduLI9kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPNy+TGCmpGv78Z3twT77rg8DhIguLGK4eeASW285RuBjP0ScczZVA4YByCdku8LC
	 puZwA78wOgkksLr8bC0jr9TaKkFpJCzx/9VYTZHPKdZdd5WnRn+qBZMXIQb9oSvyee
	 m7bi6fXvCPK95WBev0OX1NPWewWTIDdk3pPK8D7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0389/1518] firmware: arm_scmi: Fix transport device teardown lookup
Date: Sat, 12 Sep 2026 08:42:38 +0200
Message-ID: <20260912065632.259177574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index c7698cfaa4e83..e5e4975b2120d 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -201,21 +201,33 @@ scmi_protocol_table_unregister(const struct scmi_device_id *id_table)
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
@@ -235,7 +247,7 @@ static int scmi_match_by_id_table(struct device *dev, const void *data)
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
 	const struct scmi_device_id *id_table = data;
 
-	return scmi_dev_match_by_id_table(scmi_dev, id_table);
+	return __scmi_dev_match_by_id_table(scmi_dev, id_table, false);
 }
 
 static struct scmi_device *scmi_child_dev_find(struct device *parent,
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 7c35c95fddbaf..ef803e1d25e15 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -33,6 +33,8 @@
 
 #define SCMI_SHMEM_MAX_PAYLOAD_SIZE	104
 
+#define SCMI_TRANSPORT_DEVNAME_PREFIX	"__scmi_transport_device"
+
 enum scmi_error_codes {
 	SCMI_SUCCESS = 0,	/* Success */
 	SCMI_ERR_SUPPORT = -1,	/* Not supported */
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 55f14953f2ebd..5a9d6df50679c 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2674,6 +2674,9 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	idx = tx ? 0 : 1;
 	idr = tx ? &info->tx_idr : &info->rx_idr;
 
+	if (idr_find(idr, prot_id))
+		return -EEXIST;
+
 	if (!info->desc->ops->chan_available(of_node, idx)) {
 		cinfo = idr_find(idr, SCMI_PROTOCOL_BASE);
 		if (unlikely(!cinfo)) /* Possible only if platform has no Rx */
@@ -2690,7 +2693,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	cinfo->max_msg_size = info->desc->max_msg_size;
 
 	/* Create a unique name for this transport device */
-	snprintf(name, 32, "__scmi_transport_device_%s_%02X",
+	snprintf(name, sizeof(name), SCMI_TRANSPORT_DEVNAME_PREFIX "_%s_%02X",
 		 idx ? "rx" : "tx", prot_id);
 	/* Create a uniquely named, dedicated transport device for this chan */
 	tdev = scmi_device_create(of_node, info->dev, prot_id, name);
-- 
2.53.0




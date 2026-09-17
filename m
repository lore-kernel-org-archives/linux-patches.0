Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD39F58B6C4;
	Thu, 17 Sep 2026 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659389; cv=none; b=SSBaElsk8np32VM5Bk29xtBWf/UC6SUKksWtSQR9YWztSHE8YdgE3+rPT79Mtmip0ni9ley+vn1nhMj8HvMJ5QUaMMHTKlo3hXxOPDMDjo1EbXs5NhDtEptnVNDrYoUf45mXHB/RqZWz9xOqKOkFIvdQz779lOc+4T/We+1T5tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659389; c=relaxed/simple;
	bh=Qv33kmbx9K0kTzBUdv2nQd7hGMd98odhF+MUodmzUqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHZMIJO6iiF2l0eBKS2sEM6u/i1BdXg8fxUxnotpmY5CK9LxTB9H49Hkz6F/LZR6UIKmJzsT4IrXEZ64/DUQvz4drTQikHg9AzA3EyvB/lMN/hXcPd88ZzoS36/6MJ7x3NO5+NItb3o4NbRMLa43CAJl7h14VmZzgdIw5wyJ1co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYCvES1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYCvES1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F081F000FF;
	Thu, 17 Sep 2026 15:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659380;
	bh=qeXd8p9yKtICTQ0XVbpm0/eJcZ/KOWgWDnolCQPjhH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYCvES1YIq1TkD2UdK9ChqbCT/LowmBdWksqzVQxUuVTL8StgUyHb8AJ1Pzr+eWZf
	 4AJL7wjNmAhPZzUF1ej+uZ0wEm+YGRIuNUI81DAM4aYC51SUylkNK3y6QKj13T447m
	 PeYUkX/zKUu26MPjbNpgC+KJOrl4VB8szBPAWO9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 236/733] nvme: print namespace IDs as unsigned 32bit value
Date: Thu, 17 Sep 2026 16:09:04 +0100
Message-ID: <20260917151357.124286196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit b2d8f2a3723103abd0f8b388691ad95817d4fff4 ]

NSIDs are 32-bit unsigned values, but a number of log messages print
them with %d. An NSID larger than 0x7fffffff is rendered as a negative
number, which is confusing in the kernel log and makes the message hard
to correlate with the namespace it talks about. Sparse NSID spaces
where high NSIDs are common are the most likely to hit this.

The nsid sysfs attribute has the same problem, and there it is worse
because userspace parses the value.

For example:
$ grep . /sys/class/block/nvme0*/nsid
/sys/class/block/nvme0c0n1/nsid:10
/sys/class/block/nvme0c0n2/nsid:-16
/sys/class/block/nvme0c0n3/nsid:11
/sys/class/block/nvme0c0n4/nsid:-2000000016
/sys/class/block/nvme0n1/nsid:10
/sys/class/block/nvme0n2/nsid:-16
/sys/class/block/nvme0n3/nsid:11
/sys/class/block/nvme0n4/nsid:-2000000016
$

Print all of them with %u. Several messages in these files, including
two in zns.c right next to the ones being changed, already use %u, so
this only makes the rest consistent with them. No functional change
other than how the NSID is formatted.

Fixes: 2b9b6e86bca7 ("NVMe: Export namespace attributes to sysfs")
Fixes: 1d5df6af8c74 ("nvme: don't blindly overwrite identifiers on disk revalidate")
Fixes: ed754e5deeb1 ("nvme: track shared namespaces")
Fixes: 9ad1927a3bc2 ("nvme: always search for namespace head")
Fixes: 71010c309454 ("nvme: implement multiple I/O Command Set support")
Fixes: 2f4c9ba23b88 ("nvme: export zoned namespaces without Zone Append support read-only")
Fixes: 0ec84df4953b ("nvme-core: check ctrl css before setting up zns")
Fixes: 2079f41ec6ff ("nvme: check that EUI/GUID/UUID are globally unique")
Fixes: ce8d78616a6b ("nvme: warn about shared namespaces without CONFIG_NVME_MULTIPATH")
Fixes: ac522fc6c316 ("nvme: don't reject probe due to duplicate IDs for single-ported PCIe devices")
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c  | 18 +++++++++---------
 drivers/nvme/host/sysfs.c |  2 +-
 drivers/nvme/host/zns.c   |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3dd2466105b7a..a73cc6a43f5e6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1592,7 +1592,7 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl,
 	}
 
 	if (nvme_multi_css(ctrl) && !csi_seen) {
-		dev_warn(ctrl->device, "Command set not reported for nsid:%d\n",
+		dev_warn(ctrl->device, "Command set not reported for nsid:%u\n",
 			 info->nsid);
 		status = -EINVAL;
 	}
@@ -4095,13 +4095,13 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 		    ((ns->ctrl->subsys->cmic & NVME_CTRL_CMIC_MULTI_CTRL) &&
 		     info->is_shared)) {
 			dev_err(ctrl->device,
-				"ignoring nsid %d because of duplicate IDs\n",
+				"ignoring nsid %u because of duplicate IDs\n",
 				info->nsid);
 			return ret;
 		}
 
 		dev_err(ctrl->device,
-			"clearing duplicate IDs for nsid %d\n", info->nsid);
+			"clearing duplicate IDs for nsid %u\n", info->nsid);
 		dev_err(ctrl->device,
 			"use of /dev/disk/by-id/ may cause data corruption\n");
 		memset(&info->ids.nguid, 0, sizeof(info->ids.nguid));
@@ -4116,7 +4116,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 		ret = nvme_subsys_check_duplicate_ids(ctrl->subsys, &info->ids);
 		if (ret) {
 			dev_err(ctrl->device,
-				"duplicate IDs in subsystem for nsid %d\n",
+				"duplicate IDs in subsystem for nsid %u\n",
 				info->nsid);
 			goto out_unlock;
 		}
@@ -4130,20 +4130,20 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 		if ((!info->is_shared || !head->shared) &&
 		    !list_empty(&head->list)) {
 			dev_err(ctrl->device,
-				"Duplicate unshared namespace %d\n",
+				"Duplicate unshared namespace %u\n",
 				info->nsid);
 			goto out_put_ns_head;
 		}
 		if (!nvme_ns_ids_equal(&head->ids, &info->ids)) {
 			dev_err(ctrl->device,
-				"IDs don't match for shared namespace %d\n",
+				"IDs don't match for shared namespace %u\n",
 					info->nsid);
 			goto out_put_ns_head;
 		}
 
 		if (!multipath) {
 			dev_warn(ctrl->device,
-				"Found shared namespace %d, but multipathing not supported.\n",
+				"Found shared namespace %u, but multipathing not supported.\n",
 				info->nsid);
 			dev_warn_once(ctrl->device,
 				"Shared namespace support requires core_nvme.multipath=Y.\n");
@@ -4392,7 +4392,7 @@ static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_info *info)
 
 	if (!nvme_ns_ids_equal(&ns->head->ids, &info->ids)) {
 		dev_err(ns->ctrl->device,
-			"identifiers changed for nsid %d\n", ns->head->ns_id);
+			"identifiers changed for nsid %u\n", ns->head->ns_id);
 		goto out;
 	}
 
@@ -4419,7 +4419,7 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 
 	if (info.ids.csi != NVME_CSI_NVM && !nvme_multi_css(ctrl)) {
 		dev_warn(ctrl->device,
-			"command set not reported for nsid: %d\n", nsid);
+			"command set not reported for nsid: %u\n", nsid);
 		return;
 	}
 
diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 75b2d69b59578..be94739e17dcf 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -166,7 +166,7 @@ static DEVICE_ATTR_RO(eui);
 static ssize_t nsid_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	return sysfs_emit(buf, "%d\n", dev_to_ns_head(dev)->ns_id);
+	return sysfs_emit(buf, "%u\n", dev_to_ns_head(dev)->ns_id);
 }
 static DEVICE_ATTR_RO(nsid);
 
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 8ed1b6a33454e..9477cfbd3a513 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -48,12 +48,12 @@ int nvme_query_zone_info(struct nvme_ns *ns, unsigned lbaf,
 			NVME_CMD_EFFECTS_CSUPP)) {
 		if (test_and_clear_bit(NVME_NS_FORCE_RO, &ns->flags))
 			dev_warn(ns->ctrl->device,
-				 "Zone Append supported for zoned namespace:%d. Remove read-only mode\n",
+				 "Zone Append supported for zoned namespace:%u. Remove read-only mode\n",
 				 ns->head->ns_id);
 	} else {
 		set_bit(NVME_NS_FORCE_RO, &ns->flags);
 		dev_warn(ns->ctrl->device,
-			 "Zone Append not supported for zoned namespace:%d. Forcing to read-only mode\n",
+			 "Zone Append not supported for zoned namespace:%u. Forcing to read-only mode\n",
 			 ns->head->ns_id);
 	}
 
-- 
2.53.0




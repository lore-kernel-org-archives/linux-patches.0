Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514F55372E4;
	Wed, 30 Sep 2026 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790040; cv=none; b=k0Tlyrbe69XMzSqmFDefKe/afSmIZcl/XrLh8VGZHulG2PgzTozWV7A+Sa3mBPoWUggjCRQvukKIh0NbytR4oRSA2PUMyTi1CLHkvQhITLJLCwB0SB5pr0mfCUAyZE2yURqHLzLQDIShlB7h/JJGEObbzDcinL0P93sQcpY4QJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790040; c=relaxed/simple;
	bh=bJwIiFj9UoEh9cTJHpOMrTJHmsZE1pTAnU4FxZL8yAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1yeCRJAFDZgC4onoa4UEFiyg+HGjBW1sWMgxQwb6ra0Y9bDFfVz0oqJF4w4kuNeZRUlyv/usWgK7HnDx22Md4UXU2rHUfARWxuq6Tfz5TX4p1ufPSXk4mVfdEgHXN5KmsGb48FOdNzuRhfW9QYz/AsuLrlr/vEaTAml64mwFAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKHNXx9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKHNXx9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A950F1F000FF;
	Wed, 30 Sep 2026 17:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790039;
	bh=agZAy1vrvBPK7bdInsMMSt9gtQgcmd5pSmeSt3FketU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKHNXx9CMLVwv7DXaPkeg5fDYLh4K/DBJ3u7w52+LsO6cwROAKlINnv4oE7sAUPS2
	 nmO7yNo4rpXb5K23vVd1BofD71zT8M7iiUlJy7Nyzn8ltpNY40kRO8IFjoaLJz8HDw
	 OOj55b5SudDap3HDGqxZlaxeZXNHYh96kXTvmdqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 644/877] nvme: fix atomic write size validation
Date: Wed, 30 Sep 2026 17:25:55 +0200
Message-ID: <20260930152428.555217388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit f46d273449ba65afd53f3dd8fe0182c9df877e08 ]

Don't mix the namespace and controller values, and validate the
per-controller limit when probing the controller.  This avoid spurious
failures for controllers with namespaces that have different namespaces
with different logical block sizes, or report the per-namespace values
only for some namespaces.

It also fixes a missing queue_limits_cancel_update in an error path by
removing that error path.

Fixes: 8695f060a029 ("nvme: all namespaces in a subsystem must adhere to a common atomic write size")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>

Stable adaptation for 6.12:
- Remove the atomic-size rejection together with its locally adapted
  queue_limits_cancel_update() and one-argument queue unfreeze calls.
  Validation now happens during controller identification, as upstream.
- Keep nvme_config_discard() in nvme_update_disk_info(), where the
  preceding dependency moved it. Do not restore a duplicate call here.
- Preserve the saved disk-info validity result and capacity handling,
  leaving the zoned update insertion point available for target
  3838e80fcfb32e62baffb63c6dc0a60153665a4d.

No additional functions are introduced.

Stable-dep-of: 3838e80fcfb3 ("nvme: skip the zoned limits update if the zone info query failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |   34 +++++++++++-----------------------
 drivers/nvme/host/nvme.h |    3 +--
 2 files changed, 12 insertions(+), 25 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2019,17 +2019,7 @@ static u32 nvme_configure_atomic_write(s
 		 * no clear language in the specification prohibiting different
 		 * values for different controllers in the subsystem.
 		 */
-		atomic_bs = (1 + ns->ctrl->awupf) * bs;
-	}
-
-	if (!ns->ctrl->subsys->atomic_bs) {
-		ns->ctrl->subsys->atomic_bs = atomic_bs;
-	} else if (ns->ctrl->subsys->atomic_bs != atomic_bs) {
-		dev_err_ratelimited(ns->ctrl->device,
-			"%s: Inconsistent Atomic Write Size, Namespace will not be added: Subsystem=%d bytes, Controller/Namespace=%d bytes\n",
-			ns->disk ? ns->disk->disk_name : "?",
-			ns->ctrl->subsys->atomic_bs,
-			atomic_bs);
+		atomic_bs = (1 + ns->ctrl->subsys->awupf) * bs;
 	}
 
 	lim->atomic_write_hw_max = atomic_bs;
@@ -2213,17 +2203,6 @@ static int nvme_update_ns_info_block(str
 	nvme_set_chunk_sectors(ns, id, &lim);
 	valid = nvme_update_disk_info(ns, id, &lim);
 
-	/*
-	 * Validate the max atomic write size fits within the subsystem's
-	 * atomic write capabilities.
-	 */
-	if (lim.atomic_write_hw_max > ns->ctrl->subsys->atomic_bs) {
-		queue_limits_cancel_update(ns->disk->queue);
-		blk_mq_unfreeze_queue(ns->disk->queue);
-		ret = -ENXIO;
-		goto out;
-	}
-
 	if (!valid)
 		capacity = 0;
 
@@ -3047,6 +3026,7 @@ static int nvme_init_subsystem(struct nv
 	memcpy(subsys->model, id->mn, sizeof(subsys->model));
 	subsys->vendor_id = le16_to_cpu(id->vid);
 	subsys->cmic = id->cmic;
+	subsys->awupf = le16_to_cpu(id->awupf);
 
 	/* Versions prior to 1.4 don't necessarily report a valid type */
 	if (id->cntrltype == NVME_CTRL_DISC ||
@@ -3376,6 +3356,15 @@ static int nvme_init_identify(struct nvm
 		if (ret)
 			goto out_free;
 	}
+
+	if (le16_to_cpu(id->awupf) != ctrl->subsys->awupf) {
+		dev_err_ratelimited(ctrl->device,
+			"inconsistent AWUPF, controller not added (%u/%u).\n",
+			le16_to_cpu(id->awupf), ctrl->subsys->awupf);
+		ret = -EINVAL;
+		goto out_free;
+	}
+
 	memcpy(ctrl->subsys->firmware_rev, id->fr,
 	       sizeof(ctrl->subsys->firmware_rev));
 
@@ -3471,7 +3460,6 @@ static int nvme_init_identify(struct nvm
 		dev_pm_qos_expose_latency_tolerance(ctrl->device);
 	else if (!ctrl->apst_enabled && prev_apst_enabled)
 		dev_pm_qos_hide_latency_tolerance(ctrl->device);
-	ctrl->awupf = le16_to_cpu(id->awupf);
 out_free:
 	kfree(id);
 	return ret;
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -410,7 +410,6 @@ struct nvme_ctrl {
 
 	enum nvme_ctrl_type cntrltype;
 	enum nvme_dctype dctype;
-	u16 awupf; /* 0's based value. */
 };
 
 static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
@@ -443,11 +442,11 @@ struct nvme_subsystem {
 	u8			cmic;
 	enum nvme_subsys_type	subtype;
 	u16			vendor_id;
+	u16			awupf; /* 0's based value. */
 	struct ida		ns_ida;
 #ifdef CONFIG_NVME_MULTIPATH
 	enum nvme_iopolicy	iopolicy;
 #endif
-	u32			atomic_bs;
 };
 
 /*



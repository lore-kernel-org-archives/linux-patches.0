Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951974E50A5;
	Fri,  9 Oct 2026 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556192; cv=none; b=OmMw9xP5fWomAwnRoF8DbSTo3RoepJSh46qX0CP1gY5U0STKCh0Av0LLnXlI2b2sBhXPhvPHEkrtDix3pMuG2BJz0Mw2m3doqtrN/YyvXCWEVAkFnKbJ644dczGMrI/Oxo6ixYFIEMzIjD0R+PYOplKl5S8E3oNE1MU1wnAHkM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556192; c=relaxed/simple;
	bh=RThqodW+WQ3OWjPwJejN4Ai2UCVNO9Cu6WEzYm6PAS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZHB/ffF8x7U0TtfKV0xcBDqZNUjXoBDcyRhANNzYvSf6KwFSDIcRq1tUEVi5E2P1o62zsUfqeDLLxPUyLAW1wQcr2IDbpSH6k4ABaWDJd4C2qoYEReeKHwM/w9FQKkz1/R6zuGZs9OfKkJy0D4Ank5MjZho6OWiJX/yxS5lGic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOImE98Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOImE98Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747911F000FF;
	Fri,  9 Oct 2026 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556190;
	bh=3O2jY3djD5eSweInJDtsCDorFzAoKSKVzygRUNs19SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOImE98ZgR8pNlAHluZOPSMNRYNKNAOvSLN65EGFPWDxBr8K9MJec0Xv3QnGS88om
	 0GpO+c61HMfRfnTlVEfKs2s1g9RUMlyNBPB23wyXZ9d4n0iKLQIJ95nTrpLCnTh4GU
	 OqRgffRX0K+2TWkvfRvVPIhhfduUG/axPkEPNDu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	John Garry <john.g.garry@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 104/428] nvme: add nvme_get_ns_head()
Date: Fri,  9 Oct 2026 16:07:21 +0200
Message-ID: <20261009140948.497348721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: John Garry <john.garry@linux.dev>

[ Upstream commit a11e0a4cb4189c468683a2f384f0c266c26a497f ]

Add a wrapper for getting a reference to the NS head.

This would be used in scenarios when we know that getting a reference
would not fail.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 6b8a5367e9e7 ("nvme: work around -Wformat-security warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      |    5 +++++
 drivers/nvme/host/multipath.c |    2 +-
 drivers/nvme/host/nvme.h      |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -691,6 +691,11 @@ static void nvme_free_ns_head(struct kre
 	kfree(head);
 }
 
+void nvme_get_ns_head(struct nvme_ns_head *head)
+{
+	kref_get(&head->ref);
+}
+
 bool nvme_tryget_ns_head(struct nvme_ns_head *head)
 {
 	return kref_get_unless_zero(&head->ref);
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -777,7 +777,7 @@ int nvme_mpath_alloc_disk(struct nvme_ct
 	set_bit(GD_SUPPRESS_PART_SCAN, &head->disk->state);
 	sprintf(head->disk->disk_name, "nvme%dn%d",
 			ctrl->subsys->instance, head->instance);
-	nvme_tryget_ns_head(head);
+	nvme_get_ns_head(head);
 	return 0;
 }
 
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1005,6 +1005,7 @@ int nvme_delete_ctrl(struct nvme_ctrl *c
 void nvme_queue_scan(struct nvme_ctrl *ctrl);
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
 		void *log, size_t size, u64 offset);
+void nvme_get_ns_head(struct nvme_ns_head *head);
 bool nvme_tryget_ns_head(struct nvme_ns_head *head);
 void nvme_put_ns_head(struct nvme_ns_head *head);
 int nvme_cdev_add(const char *name, struct cdev *cdev,



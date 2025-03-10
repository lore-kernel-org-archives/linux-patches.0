Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0E922D786;
	Mon, 10 Mar 2025 17:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627596; cv=none; b=gbQ44uVGaiIdj+1Ur5DWiWimoS3MuOieSz8IC6mcSswUmzaFyFdSvV8+b+XsTTGYfATP4M0R55oFPcMERtsgjeWSeDe7a2DQQYHS7R65Z5v/TQpkCjtIF1LFd6+iLSZ7psKlrFszpkQ7uA7CAbcRU94SF3qJXqCJTNrHb8g5aa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627596; c=relaxed/simple;
	bh=+OjgeeHGTKLSmn3o/hrhdpeOdbAerngPef1rN3LXGoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/1xtMCGU32bahn1tOrBnVRYlyAPw0cYp6xMNhQ/auVrYCU++5ES6oLP3KkH89BIso+444xWl6Bp+dxwIdwI4YMb7eNQS2ehBfSpZPUVz3iADOxG/iIsgV1tVuzeh8eNxWfRvRsEqCgLSEgea6SbnZf/yZhiXk2/LkjqtiZwHe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2loivsOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2loivsOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A57C4CEE5;
	Mon, 10 Mar 2025 17:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627596;
	bh=+OjgeeHGTKLSmn3o/hrhdpeOdbAerngPef1rN3LXGoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2loivsOhjEQOAvigN+u537n0QLVty5WWTz4Q7On9kpMDRRHpoH3YmSb7wNEuO7ps7
	 92DaLIdanl3kuE21fPKr7Tv7g6ipJfWv5sUy+qGXtvdBf/SE3lIFiOYbZcl8q3MXrL
	 zrwWbvhXyq4bCtrWV5k3iAjlTeU4OVu9QYhPsDcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/269] nvme-pci: use sgls for all user requests if possible
Date: Mon, 10 Mar 2025 18:05:04 +0100
Message-ID: <20250310170503.738636812@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 6fad84a4d624c300d03ebba457cc641765050c43 ]

If the device supports SGLs, use these for all user requests. This
format encodes the expected transfer length so it can catch short buffer
errors in a user command, whether it occurred accidently or maliciously.

For controllers that support SGL data mode, this is a viable mitigation
to CVE-2023-6238. For controllers that don't support SGLs, log a warning
in the passthrough path since not having the capability can corrupt
data if the interface is not used correctly.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 00817f0f1c45 ("nvme-ioctl: fix leaked requests on mapping error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 12 ++++++++++--
 drivers/nvme/host/pci.c   |  5 +++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 61af1583356c2..d4b80938de09c 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -120,12 +120,20 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	struct nvme_ns *ns = q->queuedata;
 	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
 	bool supports_metadata = bdev && blk_get_integrity(bdev->bd_disk);
+	struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
 	bool has_metadata = meta_buffer && meta_len;
 	struct bio *bio = NULL;
 	int ret;
 
-	if (has_metadata && !supports_metadata)
-		return -EINVAL;
+	if (!nvme_ctrl_sgl_supported(ctrl))
+		dev_warn_once(ctrl->device, "using unchecked data buffer\n");
+	if (has_metadata) {
+		if (!supports_metadata)
+			return -EINVAL;
+		if (!nvme_ctrl_meta_sgl_supported(ctrl))
+			dev_warn_once(ctrl->device,
+				      "using unchecked metadata buffer\n");
+	}
 
 	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
 		struct iov_iter iter;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 58bdd0da6b658..e1329d4974fd6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -514,7 +514,8 @@ static inline bool nvme_pci_metadata_use_sgls(struct nvme_dev *dev,
 {
 	if (!nvme_ctrl_meta_sgl_supported(&dev->ctrl))
 		return false;
-	return req->nr_integrity_segments > 1;
+	return req->nr_integrity_segments > 1 ||
+		nvme_req(req)->flags & NVME_REQ_USERCMD;
 }
 
 static inline bool nvme_pci_use_sgls(struct nvme_dev *dev, struct request *req,
@@ -532,7 +533,7 @@ static inline bool nvme_pci_use_sgls(struct nvme_dev *dev, struct request *req,
 	if (nvme_pci_metadata_use_sgls(dev, req))
 		return true;
 	if (!sgl_threshold || avg_seg_size < sgl_threshold)
-		return false;
+		return nvme_req(req)->flags & NVME_REQ_USERCMD;
 	return true;
 }
 
-- 
2.39.5




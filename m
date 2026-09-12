Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9730236404D;
	Sat, 12 Sep 2026 08:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203143; cv=none; b=QM6zUPRFBgkT+P8MR1ywGTwIYWsWxaC0Dn9rlMryGm3Fr4ae65tUR/LIWJAwtEI8WLMfPFLVX2xUs40EhSmYJLoW0SeaVjTXUFi71U8gAHaMCaym1tlLCu4bwYfuQJVMWlSe1zeH3gN5tMkcp2iLefuf1PuPkz3P3K5mw0xKkpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203143; c=relaxed/simple;
	bh=UAsfBu/WINEmD+A+9e0rg+wcUv9sbYm+10RtJYBrqlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOjL+aeLXXrHRMTC6C5IYY+hnfFgzNCdOIiq9af/5IA5NqF3vwibJb3DSAtQDwRtZIJwD9AZV+bA4Pfk+jMn1ispARcPgnXHe/u4kJhP6zVpLKpFK9EqXC/hzsMggoH8zHMXWp2MFkXHGdRReTqZHSHVNQRIovHRw8UZyOSM+Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZkZ5lQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZkZ5lQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7D71F000FF;
	Sat, 12 Sep 2026 08:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203142;
	bh=h1NrX8QRJWY8XVac5RimmlLps67JU63pLRdNAlzX00o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZkZ5lQae2jwZu928nIY9aoMtzkbczVzVTXmmyNxTwUUCuFgzFEkSLYXP15+hfroC
	 rEQrET1EL5B182+kw9PbBepjJFPLnCInUcrGvBBQgQAqqaPX5eXG/vKU4vCR9Cybvw
	 nzv8jWoiN2Fy+WDFLY1ptHhniwLp4TIUKq0dvK3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1348/1815] nvmet: fix NULL pointer dereference in nvmet_execute_identify_ns_zns()
Date: Sat, 12 Sep 2026 08:51:38 +0200
Message-ID: <20260912065720.665106027@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit f594863967d87b7fcbff6e724d51135fd701a13d ]

When a host issues an Identify command with CNS 05h (I/O Command Set
specific Identify Namespace) and CSI 02h (ZNS) targeting a file-backed
namespace, nvmet_execute_identify_ns_zns() calls bdev_is_zoned() on
req->ns->bdev. A file-backed namespace has no block device, so
req->ns->bdev is NULL and bdev_is_zoned() dereferences it, oopsing.

The I/O command set is selected by the host-supplied CSI field and the
command is routed here whenever CONFIG_BLK_DEV_ZONED is enabled,
independent of the namespace backing type, so any file-backed namespace
is exposed.

Reject the command with Invalid Field when the namespace is not backed
by a block device.

Fixes: aaf2e048af27 ("nvmet: add ZBD over ZNS backend support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/zns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index f00921931eb64..a13befd5f3adf 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -116,7 +116,7 @@ void nvmet_execute_identify_ns_zns(struct nvmet_req *req)
 		mutex_unlock(&req->ns->subsys->lock);
 	}
 
-	if (!bdev_is_zoned(req->ns->bdev)) {
+	if (!req->ns->bdev || !bdev_is_zoned(req->ns->bdev)) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc = offsetof(struct nvme_identify, nsid);
 		goto out;
-- 
2.53.0




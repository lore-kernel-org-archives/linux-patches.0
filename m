Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F272F0673;
	Sat, 12 Sep 2026 19:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240181; cv=none; b=GNMep9ZK5m85VeQkd7PI0T4eYlIXsuSZn9QeYkmTugZ0VrDDG7UcWLf4qaFHsPSl47stS/NvM/fKCv7MUBz3lkFg4e8+3OLl9brxThPAxE7EWRx2raz4sprBR+OAGpFbhZni6+gnTIGGOFjZEYa1t+ttKEDtZjQFgctsZF3inm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240181; c=relaxed/simple;
	bh=onX8zjTtaQwfCKvJ0kNiwo9b9P1FiT1EoeUVQMTIESg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAuXzLOlvrPJskpXpurd3cBzcHUpqrKQeSb7YcyIDXhMruMvJXdTz05awHbzDoO+P6eYROVKBHhqRE2kROtUnpUNZVtoImCMEAnmxjBEeHndooy+3V/ZVAxNv4Aj4n3J7rtPceBgbnRytJVg9Yy3E7qhqoehx56gIISIShiyfoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+0SvaOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+0SvaOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4C01F000FF;
	Sat, 12 Sep 2026 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240180;
	bh=qeMQ3SLr/gAV3zlX1DS6RZXVobIGF89Rqs08w7AfLgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+0SvaOsvjzGIhr9ytqhAEIdFF5I5MQc0VcVpNXJPtYIVRwEfW5GUccjqfgQIpZN9
	 ISZfIJmxrPKc/QhAdthLs425BROLVwnw2/IzS3GrFd2FiXimrwBUvrsgGMph7g/NJ9
	 2fY5Dgw6GyLBXetlmXQZ9PtVbgwwbyeUg37cit6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 772/935] nvmet: fix NULL pointer dereference in nvmet_execute_identify_ns_zns()
Date: Sat, 12 Sep 2026 09:03:22 +0200
Message-ID: <20260912065544.536294492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6b9b22cc8adb0..70f1d106b7065 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -124,7 +124,7 @@ void nvmet_execute_identify_cns_cs_ns(struct nvmet_req *req)
 		mutex_unlock(&req->ns->subsys->lock);
 	}
 
-	if (!bdev_is_zoned(req->ns->bdev)) {
+	if (!req->ns->bdev || !bdev_is_zoned(req->ns->bdev)) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc = offsetof(struct nvme_identify, nsid);
 		goto out;
-- 
2.53.0




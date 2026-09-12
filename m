Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A6C31F9B1;
	Sat, 12 Sep 2026 16:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231260; cv=none; b=tgnHJC4JFtuWTpPO13+7iyHvEgvLqq4ByTXzsPxI1Uvlk+wUdYOw//rh0hFrBjuUR6wcNRJKpZhYW7ncH7wAeyQm/ol0goSELtZhxnFCPip+6/ZpWop1n0V/JFJi6Z4C9kU9SWB31loZ3afo25DmbwmBqNZuWZ17+On0GO4K+GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231260; c=relaxed/simple;
	bh=OCqOa6MSkdwq4bRfVxKA1usNwuwThBhg8+0an6HK35Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppYofFZmMG6wwyRLxlPF4lzg7rU631A4pHLWvxVp7iENl7DfbBjuRxd23umGpGl8CSU3o57VJ4KXRXu69w1Ex8QsU+rEwc382KTEOFmJRRtiNOaaI+wcSnNVWU18+DiQRA3iPv3dvByIBXQN+XYab2J9V4Ip5vtjd6SQVplmgyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBNaSNqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBNaSNqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4E91F000FF;
	Sat, 12 Sep 2026 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231259;
	bh=pyEKpcZZre1MSpTmMi8ACliTmESOcaUjkPlwzhqEmmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tBNaSNqqgnAkjRYjKChSbs7U/VlsmuaH4UduLL38Eei8YdYQDh1QbKdD2Xi2cw9rE
	 bb2mmTieqviUBV5tNVXsvlwg7j5AJwtZHq2ewBKQLQs4uT6AbGvg9x4KIuRBT1fKE1
	 7Z1zbEQFis/r8lmbz8Kzc/DxsBNlkzwumCaXMq0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0960/1191] nvmet: fix NULL pointer dereference in nvmet_execute_identify_ns_zns()
Date: Sat, 12 Sep 2026 09:01:28 +0200
Message-ID: <20260912065609.781999077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7bc3fae63dcf7..bb512a88053df 100644
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




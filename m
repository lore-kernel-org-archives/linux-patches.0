Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9E1477E39;
	Sat, 12 Sep 2026 11:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210911; cv=none; b=L7++PUV4p/lHCZQjLjNjl94WOEQeauzahTMkxF2neYVgDKGDZIeRhO+8ocyQda3rH0uj9JizR2x+A+PO1BWaLNmirzyhC5H0sSXbXE0pEGqOk8yA+UdF+IJ3eQd8SBrjzF7l77MQ6VncwxtRdzltehIlBVF8SBQLZgyNv8P8/VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210911; c=relaxed/simple;
	bh=wm/zwXJ1MC1kLmFtqU/FXc4D4xWkNWzI19vp3kr0JcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l80OxjDurSW9P3fml9rGlfTm1RBWJBkWCeJB71UW3khisGIzmkSz1wRGWE4cNrQgBvrM6oTdGb05Ej/SGW3UQVY4WgESzaQU9M4NFUwEByuD2nf9y3WyylfEt0De+DBczTp3QVThOlcv2mKzQz5zA+k+2VklDK4jMyDZdUhsu9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ky0emCqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ky0emCqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E331F000FF;
	Sat, 12 Sep 2026 11:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210909;
	bh=ePuM9a+eCyTxX8wunl2TS5T4Jeo8R0E9cEJZixMX6KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ky0emCqiOaCJz6aRC7dQfTXGv/G0dbBhH1B3KDjHkw9+SymF2iZCMIPtW+a20eW0O
	 aWvCQT6mZGhf8Q6gXWc/zQxS2ZDfv7mx3Gdnmxz8/QAZT/7LL/azKY+l17PlLFgB75
	 YF/FFJceQAWWuoddnX9YzOZpFosZ8yA5lWCF71HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1122/1518] nvmet: fix NULL pointer dereference in nvmet_execute_identify_ns_zns()
Date: Sat, 12 Sep 2026 08:54:51 +0200
Message-ID: <20260912065648.834581573@linuxfoundation.org>
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
index 15a579cf528c1..95af4b67108c7 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -120,7 +120,7 @@ void nvmet_execute_identify_ns_zns(struct nvmet_req *req)
 		mutex_unlock(&req->ns->subsys->lock);
 	}
 
-	if (!bdev_is_zoned(req->ns->bdev)) {
+	if (!req->ns->bdev || !bdev_is_zoned(req->ns->bdev)) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc = offsetof(struct nvme_identify, nsid);
 		goto out;
-- 
2.53.0




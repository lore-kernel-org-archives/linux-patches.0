Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854DD1E98EC;
	Tue, 11 Mar 2025 15:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707505; cv=none; b=Pb2wSWzL+EHRV3Ru/3FHdzYYQoF1rCfigsjHuSkiwYW/db3d2Di3DSvE3BWNbx/pNoB9T6aGTtVrCtuO+97Oj7agpNLuCG5iy0nA8PcfHoGx5tFVPEANCsC2w+nu9StbiRh+GqYZsQhX0jmAH5iJMUjdZbGiBPT2HJ0GWY7PhaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707505; c=relaxed/simple;
	bh=rJocbMZYBBAO+SAVKjJirQntQSvOZo35jjdLBCIXx2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aqm/x+Fs620cZJfTYcUOdijyXLCrWm1z+OF+7d84bttE1N4U35iZXnsHM9wPy7BJ43Aad6ESPuqTCViF8d59Qso+04rK8/rIHvi1NX0YYk3/cEgjgw7zGp1RZbsr25UeAMywXpVo+QMuXxRJu4UaAoqkjFL5ISww4QrWc2cULFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r46tusXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r46tusXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A259C4CEE9;
	Tue, 11 Mar 2025 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707505;
	bh=rJocbMZYBBAO+SAVKjJirQntQSvOZo35jjdLBCIXx2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r46tusXhcWL2embqhBKSbEnhg1NPtA8JL8PfVSlyycIFnl2rvy4Q/+B6t/4gI180Y
	 RRNmctdRNAuyYTpg5cRCdhISAf7FuTbCyb1LkGzfa1qYHku+wRbxb38krs6FXUD7NQ
	 XBHQXzVN/+45aNp2QmhVPGcx5F8eLCqir4opF47Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 410/462] caif_virtio: fix wrong pointer check in cfv_probe()
Date: Tue, 11 Mar 2025 16:01:16 +0100
Message-ID: <20250311145814.529526142@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

[ Upstream commit a466fd7e9fafd975949e5945e2f70c33a94b1a70 ]

del_vqs() frees virtqueues, therefore cfv->vq_tx pointer should be checked
for NULL before calling it, not cfv->vdev. Also the current implementation
is redundant because the pointer cfv->vdev is dereferenced before it is
checked for NULL.

Fix this by checking cfv->vq_tx for NULL instead of cfv->vdev before
calling del_vqs().

Fixes: 0d2e1a2926b1 ("caif_virtio: Introduce caif over virtio")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Link: https://patch.msgid.link/20250227184716.4715-1-v.shevtsov@mt-integration.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index a701932f5cc29..daeaf0ca12547 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -746,7 +746,7 @@ static int cfv_probe(struct virtio_device *vdev)
 
 	if (cfv->vr_rx)
 		vdev->vringh_config->del_vrhs(cfv->vdev);
-	if (cfv->vdev)
+	if (cfv->vq_tx)
 		vdev->config->del_vqs(cfv->vdev);
 	free_netdev(netdev);
 	return err;
-- 
2.39.5




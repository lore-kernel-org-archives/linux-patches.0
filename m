Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42492253FE;
	Mon, 10 Mar 2025 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628086; cv=none; b=YCr79DMxizEIBtL8PGSXrUJNF/kYLcof2odZ1OuI6DGseDSFbi15YfQpIOWc4ObhjED+CtkjXdti/TgAYnJ+Dp2/6WMdHuK/AV+YsLUIaNEnya4VKCuJBR085ZX9ujGUjRLg9VZ/4hUVdcOd6hCsJuQYMSaqyXa7ROjMGhKgMXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628086; c=relaxed/simple;
	bh=3DZBHKlBfZTSBjRa9wLFEX391ftUgbHKDlxQt/E+IKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwhVDIaqpZb1LQyo+v4kdjJok+1vMAbCGysGcsYqaV4C1O3pzESGZMHsrP4brpHarMNEsQYMxHQjXGALR38rZxOJccsunHMbmkd/ZWN9WR7WOCSdrmOkzyLu0BzZ15OOG71o9MkfHZ/w5NeT6ZowooYRLw2n6URip7JQ6MUpchE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vr0jXpqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vr0jXpqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AD0C4CEE5;
	Mon, 10 Mar 2025 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628086;
	bh=3DZBHKlBfZTSBjRa9wLFEX391ftUgbHKDlxQt/E+IKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vr0jXpqyGBTfpvbD8Y2OhS8ucHNggMvH3gDL+LaG+GrXS/tyb9sw79dQ60AxiZOFP
	 l1NTpMXp8FHWPiMNBCjYfRUdBiNz09bCgPLWorT9XuU4llPcGDwH08CjdlrPzE+KcP
	 KACUgQnZpeuonjLjPQHHEA35mHsqHja9pwCMqP4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/145] caif_virtio: fix wrong pointer check in cfv_probe()
Date: Mon, 10 Mar 2025 18:05:59 +0100
Message-ID: <20250310170437.374408315@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0b0f234b0b508..a8b9ada7526c7 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -745,7 +745,7 @@ static int cfv_probe(struct virtio_device *vdev)
 
 	if (cfv->vr_rx)
 		vdev->vringh_config->del_vrhs(cfv->vdev);
-	if (cfv->vdev)
+	if (cfv->vq_tx)
 		vdev->config->del_vqs(cfv->vdev);
 	free_netdev(netdev);
 	return err;
-- 
2.39.5




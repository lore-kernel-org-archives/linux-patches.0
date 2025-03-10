Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93E1233705;
	Mon, 10 Mar 2025 17:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626879; cv=none; b=TpnoLawirkTAmFtj6OGvq48PoKtnf3KJpKzExVs8Y7f4STtVgAJrhT5+K52zTXlHb8QpQDu8vLeM64ZHtCXpb4PY2pW6g29JNRNs46BmEV2DaWmuq+YA1lX7vy/VUu5HXEiLBE9K3lGRFeNqO5krlid9LiHlv/H8Mzd2UNHTrV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626879; c=relaxed/simple;
	bh=itI0yDnlLqUHUtR5N8W0OdEPbQ7RqLZ7FDqqedbNdyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0EnVg/jV7XIbyrr08e3JG31ds5Hodjh7ZtB/MiEd8vcAF/EY57Pcdy87CTGOdcJaQ0SlJpTd/A/Y3LKsTJcTOuDOUmZzFBUcFGh4za2Nr4pvxyJENFF9Z0brJN5tWM+6gW0kiEk6rwC+RGeE0ARoCjqpn5mvLZbznhiwiCdMxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FO/5ygjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FO/5ygjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C06C4CEE5;
	Mon, 10 Mar 2025 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626879;
	bh=itI0yDnlLqUHUtR5N8W0OdEPbQ7RqLZ7FDqqedbNdyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FO/5ygjIljZFXQNRSLGCDnuFYFvRTNtmch7060bwKlSyRgPMRhaGNp8LId8dsmca+
	 6gPXccCA+I24yg44skjSjPb5Gt/xB4b7e5IeauFXYLgqWD1eSDlyCx8bTn3yHQ/Sbv
	 1nyt9ynBgutcOtg7FYq2hSPPjyTf8763dKAKKM7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 112/207] caif_virtio: fix wrong pointer check in cfv_probe()
Date: Mon, 10 Mar 2025 18:05:05 +0100
Message-ID: <20250310170452.267096617@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 7fea00c7ca8a6..c60386bf2d1a4 100644
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




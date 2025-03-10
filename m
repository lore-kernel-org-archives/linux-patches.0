Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C01156861;
	Mon, 10 Mar 2025 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630903; cv=none; b=Q10QoOM5x+gwwBocZlU2B7Wl7gzR4i7aw/JNa3rfxazYioacxN8HnsmqPyXcMXe2jU6xTi15YF394PeZ2dKLOKCT8wTjqw6BnznTL4QiSqkq77pr98hQAY4/yFIoX1O2gvrEY10cBxQZrlvVy2t6M1Qdwg5dcac4vsdO83gUyS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630903; c=relaxed/simple;
	bh=1VQ1Yqak4H8lsij8SmFykPqKDRuZxdsfAI9GAKFeLoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ip6XHTMkf++7vGJNI8gAW6zw5KscXBz3udKn3Lk9Tiv9iO/FDCAmeir7iuyH7GYSbiQyxEd2D6jNB8gPZB3c28uGDZ95fq0PXVsUYEtb4u+OOfGayrZFCoa73YcQ+4tqGVH3xma8IBW/Fp2E5xblW6ir+dXKYcU5XkFgz+QGtdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tkhp+6G7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tkhp+6G7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC08C4CEE5;
	Mon, 10 Mar 2025 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630902;
	bh=1VQ1Yqak4H8lsij8SmFykPqKDRuZxdsfAI9GAKFeLoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tkhp+6G7zHM/VOEHLgXM+6DUXxnYQktsYNHPB67V84HNfMAfH6i6sckXasipGWVJv
	 20BdU6MlZrTd6Lm+r/Aik2rX2Il8hlkezL6YMrqH8HE8q18DI89EadWbEu/n8COkGt
	 Axm7gJ3EbTXZAsmtBumcQZy0irHoqkxYppOFuo9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 557/620] caif_virtio: fix wrong pointer check in cfv_probe()
Date: Mon, 10 Mar 2025 18:06:43 +0100
Message-ID: <20250310170607.532349573@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index da87de02b2fcc..38a243dfcf285 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -744,7 +744,7 @@ static int cfv_probe(struct virtio_device *vdev)
 
 	if (cfv->vr_rx)
 		vdev->vringh_config->del_vrhs(cfv->vdev);
-	if (cfv->vdev)
+	if (cfv->vq_tx)
 		vdev->config->del_vqs(cfv->vdev);
 	free_netdev(netdev);
 	return err;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E3E2309B6;
	Mon, 10 Mar 2025 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627552; cv=none; b=oDl+ZdiYBUgWRkRaLZ7yv8BnJg+qZ87NSxnAL1c3bQF4S7TYbyc0fkqWZm6N2RX9hyYS2O+Lqq0fe3v2/1Ehk0Bi2Ly7UwfpdeGIbGCdwczuH6FiiR6uYwGIf4GCNlurn2nvN09IcQYpBJXQJr4bY/THYRjw1aUjDYWOOCbiceQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627552; c=relaxed/simple;
	bh=8kOOq+lB3hw8bjeYRJgmRHwkvge5rxOvBAq6eFy3WbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEeNjo5RaXTMDxEd131o9RQasYVFptA5++/UdJhYwVxLHenw+g131xL/tEyuIkDF6Xj7VvB4ptJFvPKjsEjGFDfH29eeXOvtEUIFF4eVewrrckrYvbqu1MU0B35yubIPAG2UsGa13sceVi0qbCursfkwHmWRJWuaRP/4ZyK9TQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmnNmR5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmnNmR5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F225CC4CEE5;
	Mon, 10 Mar 2025 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627552;
	bh=8kOOq+lB3hw8bjeYRJgmRHwkvge5rxOvBAq6eFy3WbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmnNmR5JGP16UIQSfM9gzxmhz2mi23c5Pj2abyUrcUBb20diKmgeY87EGmF/03rLu
	 1B10iusak6JoP8ITae1QxplCvidWkc0DytLFRPuz/7UI7be5m4nyW9q8Dij5YzsZCM
	 ToMgKj9IthCekSz2W/TCyKEgUBL5PWI9b9ToUYbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/269] caif_virtio: fix wrong pointer check in cfv_probe()
Date: Mon, 10 Mar 2025 18:05:21 +0100
Message-ID: <20250310170504.415896655@linuxfoundation.org>
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




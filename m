Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A946E1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5D8C433C8;
	Mon, 21 Aug 2023 20:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648424;
	bh=5dWc136PhNTrxIOgiPKFzKuX0x/urX5tSHxG2z62rDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgeSO0TMzMtmm6DQZxiUgGNPCCohgDGGT4xum7+UoXb3vI4bZJ9s69JWG5ospFb2Q
	 nqXWBb5Klf0ZAQkBiM9KvpxKFu91CnVjiLqy5gx1G6zJ9qQUwkrKg2UQSjhExc1eE0
	 IqfKbNrmOQsMV8XJRHW6e0DQv7mIybUuCFWgshEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 171/234] drm/nouveau/disp: fix use-after-free in error handling of nouveau_connector_create
Date: Mon, 21 Aug 2023 21:42:14 +0200
Message-ID: <20230821194136.393887865@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karol Herbst <kherbst@redhat.com>

[ Upstream commit 1b254b791d7b7dea6e8adc887fbbd51746d8bb27 ]

We can't simply free the connector after calling drm_connector_init on it.
We need to clean up the drm side first.

It might not fix all regressions from commit 2b5d1c29f6c4
("drm/nouveau/disp: PIOR DP uses GPIO for HPD, not PMGR AUX interrupts"),
but at least it fixes a memory corruption in error handling related to
that commit.

Link: https://lore.kernel.org/lkml/20230806213107.GFZNARG6moWpFuSJ9W@fat_crate.local/
Fixes: 95983aea8003 ("drm/nouveau/disp: add connector class")
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230814144933.3956959-1-kherbst@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index a2e0033e8a260..622f6eb9a8bfd 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1408,8 +1408,7 @@ nouveau_connector_create(struct drm_device *dev,
 		ret = nvif_conn_ctor(&disp->disp, nv_connector->base.name, nv_connector->index,
 				     &nv_connector->conn);
 		if (ret) {
-			kfree(nv_connector);
-			return ERR_PTR(ret);
+			goto drm_conn_err;
 		}
 
 		ret = nvif_conn_event_ctor(&nv_connector->conn, "kmsHotplug",
@@ -1426,8 +1425,7 @@ nouveau_connector_create(struct drm_device *dev,
 			if (ret) {
 				nvif_event_dtor(&nv_connector->hpd);
 				nvif_conn_dtor(&nv_connector->conn);
-				kfree(nv_connector);
-				return ERR_PTR(ret);
+				goto drm_conn_err;
 			}
 		}
 	}
@@ -1475,4 +1473,9 @@ nouveau_connector_create(struct drm_device *dev,
 
 	drm_connector_register(connector);
 	return connector;
+
+drm_conn_err:
+	drm_connector_cleanup(connector);
+	kfree(nv_connector);
+	return ERR_PTR(ret);
 }
-- 
2.40.1




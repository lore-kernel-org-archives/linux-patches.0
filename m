Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786E111703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08D9C433C7;
	Mon, 21 Aug 2023 19:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647959;
	bh=9uXSArX/wMQHY5M39yUQ5eNMegUNNCd5y+IJ0LCWyV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ru+4aMtF26tY3H+wGqH5prW5ae6l2RdE9jTtPxZPoq9bDXt44HzRBuybuzL+RyTMq
	 VcXFglucI0hLXnZUW8mjKm2Q7vstjF2sQR1L0azK03sUVMQj0EMSbTLZ6Ou9AkZZGA
	 yDoozjo5NWEiSyNL+6Uv+AWeGNrkIrJg4IcNLKbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.1 192/194] drm/nouveau/disp: fix use-after-free in error handling of nouveau_connector_create
Date: Mon, 21 Aug 2023 21:42:51 +0200
Message-ID: <20230821194131.144428893@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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

commit 1b254b791d7b7dea6e8adc887fbbd51746d8bb27 upstream.

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
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1407,8 +1407,7 @@ nouveau_connector_create(struct drm_devi
 		ret = nvif_conn_ctor(&disp->disp, nv_connector->base.name, nv_connector->index,
 				     &nv_connector->conn);
 		if (ret) {
-			kfree(nv_connector);
-			return ERR_PTR(ret);
+			goto drm_conn_err;
 		}
 	}
 
@@ -1470,4 +1469,9 @@ nouveau_connector_create(struct drm_devi
 
 	drm_connector_register(connector);
 	return connector;
+
+drm_conn_err:
+	drm_connector_cleanup(connector);
+	kfree(nv_connector);
+	return ERR_PTR(ret);
 }



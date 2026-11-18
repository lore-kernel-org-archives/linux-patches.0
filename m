Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042302;
	b=aXarh4GnmrLSqWW8orjvruA1yRth3J1RJA+A9nXz0Gqn0mFQgpnM/FIzMor+mNDFUJOP
	 iCC19mOPPFA3E/ys91Ys34P1mfTVuKPeG2LAKNi63GKAEHxWx9fYDN0Om7qqqYoLJsKGj
	 YBoTnmk6+busA7IXGJK66yUcvOWtAiOpdEx1t+mOWv5DFXtPfyv9tGgvcese7VRH9UOWG
	 Mii1SsL+VPAeUmhgmQ2EQKB4WDZK1m0iXtt960n897k3M0o8CM5Jei0zAmEo3NyQ+4RWd
	 T4tcu9dpnyeLl1T5h4P8mursw6PidcHXV9zHqhVbh4tUBucNW0tmH39YdnajyoQ/eCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/8V+N5leiRcKeeACXc375DiqGnxT3KjhzXGCmTST/8s=;
	b=rvKq5A3gkoCvnYKu98zk4v2yL/yKjD3WjSmRvbJ6ZODtDcFU5F359H8LNA2e8MeFQNwz
	 ZumLv0SfjeGylCG/y4LYeB4ghrQsIWBwagi+QUXoiG1HeUHCzOKSdfRvMqutRef+ai2Ee
	 xyxEg0xcp/4CO5wPFxd9G4Ea5rcp8xGPhmRccSg0pjYRq5FX33oyIiMXrP37Nt+vZh/j2
	 4V1OcDDjcRQdCqWegwKcZITDK2QP/7Fvyti2+cQo9pPAbkCY7LgAX/L7UVOzs3AmNZCmT
	 SCbYT5K6ZQD7/O9t67z+SIhuljw6c8KY7MMIdEtf75ecwEE00Gqi/jbozN7kn8sc7Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZTVqrm1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5335F606A325;
	Wed, 18 Nov 2026 22:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZTVqrm1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB91F000C4;
	Wed, 18 Nov 2026 22:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042302;
	bh=/8V+N5leiRcKeeACXc375DiqGnxT3KjhzXGCmTST/8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZTVqrm1OUvp77SXupr+ZbXHHf7G5lmMzy6e2xnMNU50qXBGG5jlZihvRAqrFdBIg
	 2MHkCjl4/NELE1y4vVugo5Eo9vK3cIc0E8R9kEvw7P0jjh2x2OMXjj+SD6UCmh55hi
	 D2RJ0m7QqBFQz0ZwKG8TDNeHJiPWSN2inSSLRFrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3123/3318] ionic: fix port_info use-after-free on firmware recovery
Date: Wed, 18 Nov 2026 16:02:25 +0100
Message-ID: <20261118150453.620056343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit d90d1a768b3b022c52beafb3a4701ee2ee3d2b5e ]

ionic_port_init() allocates port_info when the pointer is NULL, but its
error path frees it without checking whether this call allocated it.
Before commit ddc5911b9bd2 ("ionic: call ionic_port_init after
fw-upgrade") the function returned early when the buffer already
existed, so the two were symmetric.

Since then a failed PORT_INIT on either recovery path - fw_up or
reset_done - frees a buffer an earlier init owns, while the netdev is
registered and the ethtool ops are reading it.

Free only what this call allocated.

Fixes: ddc5911b9bd2 ("ionic: call ionic_port_init after fw-upgrade")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20261015-ionic-port-info-lifetime-v2-1-57232013fd79@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 2869922cffe2e..8766ac10783f2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -664,6 +664,7 @@ int ionic_port_init(struct ionic *ionic)
 {
 	struct ionic_identity *ident = &ionic->ident;
 	struct ionic_dev *idev = &ionic->idev;
+	bool allocated = false;
 	size_t sz;
 	int err;
 
@@ -675,6 +676,8 @@ int ionic_port_init(struct ionic *ionic)
 						     GFP_KERNEL);
 		if (!idev->port_info)
 			return -ENOMEM;
+
+		allocated = true;
 	}
 
 	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
@@ -691,10 +694,12 @@ int ionic_port_init(struct ionic *ionic)
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err) {
 		dev_err(ionic->dev, "Failed to init port\n");
-		dma_free_coherent(ionic->dev, idev->port_info_sz,
-				  idev->port_info, idev->port_info_pa);
-		idev->port_info = NULL;
-		idev->port_info_pa = 0;
+		if (allocated) {
+			dma_free_coherent(ionic->dev, idev->port_info_sz,
+					  idev->port_info, idev->port_info_pa);
+			idev->port_info = NULL;
+			idev->port_info_pa = 0;
+		}
 	}
 
 	return err;
-- 
2.53.0




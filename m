Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C4636B048;
	Tue,  6 Jan 2026 17:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722137; cv=none; b=rseuQXDjYBRgnYAit42VJSNk7KaXhW02UeQS70EUiJ23g3kCoaBVA700Azr5ikagrWSzf4PD+wsEV5l15jnYyWUPYXl/mupWlciauA/VEYNd6eMCg2ZTxYnXzw8UuLhAGK6QkS/nHxhlccvPBMHiXAckl7t1lH2oVpyVjGIm3xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722137; c=relaxed/simple;
	bh=DGhg08Ybi4/65iEm2DizkD7p6UrLXHAzGuEB4s2AZwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETZUJfmBRMx0kk59GdYWcRaszFKfbL6Qn68LBCYFXykek/H8zEl9Ll6iZz+ZDWHEMBd+YJ4t5FSASmme9HQqUSyd1ATOoMklpN4V7xB4bhDbVkB4SHCydGfAEJZx/khBOd1RIeh8el5pHU8bEWTArAatj7y7njy6NyscC57dJ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV/RyA6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV/RyA6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E9CC116C6;
	Tue,  6 Jan 2026 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722137;
	bh=DGhg08Ybi4/65iEm2DizkD7p6UrLXHAzGuEB4s2AZwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV/RyA6K95p5MeWX5+iE4K30Lj4RAONVgMnSBfGbhtIVPLGu+16n4fu62YlKR2u8h
	 acd09BVotvyNr2MUmkRSfOsQ8iG75ca7E2FDUIwjY6mdABFmfuH2tUOBaTJC9MeUjS
	 R4pNKH68tkKvY5rhhleeh4pAIJMShrHjgeQ+jvW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 177/312] media: platform: mtk-mdp3: fix device leaks at probe
Date: Tue,  6 Jan 2026 18:04:11 +0100
Message-ID: <20260106170554.236028053@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 8f6f3aa21517ef34d50808af0c572e69580dca20 upstream.

Make sure to drop the references taken when looking up the subsys
devices during probe on probe failure (e.g. probe deferral) and on
driver unbind.

Similarly, drop the SCP device reference after retrieving its platform
data during probe to avoid leaking it.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Cc: stable@vger.kernel.org	# 6.1
Cc: Moudy Ho <moudy.ho@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
@@ -157,10 +157,18 @@ void mdp_video_device_release(struct vid
 	kfree(mdp);
 }
 
+static void mdp_put_device(void *_dev)
+{
+	struct device *dev = _dev;
+
+	put_device(dev);
+}
+
 static int mdp_mm_subsys_deploy(struct mdp_dev *mdp, enum mdp_infra_id id)
 {
 	struct platform_device *mm_pdev = NULL;
 	struct device **dev;
+	int ret;
 	int i;
 
 	if (!mdp)
@@ -194,6 +202,11 @@ static int mdp_mm_subsys_deploy(struct m
 		if (WARN_ON(!mm_pdev))
 			return -ENODEV;
 
+		ret = devm_add_action_or_reset(&mdp->pdev->dev, mdp_put_device,
+					       &mm_pdev->dev);
+		if (ret)
+			return ret;
+
 		*dev = &mm_pdev->dev;
 	}
 
@@ -279,6 +292,7 @@ static int mdp_probe(struct platform_dev
 			goto err_destroy_clock_wq;
 		}
 		mdp->scp = platform_get_drvdata(mm_pdev);
+		put_device(&mm_pdev->dev);
 	}
 
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);



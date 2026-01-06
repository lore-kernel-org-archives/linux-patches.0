Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412242C21F0;
	Tue,  6 Jan 2026 17:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721208; cv=none; b=Suf1QO4DXQLPpjKHXVCrScUt/Kv70Mvzc68qGpfTerk3jLz+iadk09DzQqiOAtU0pgrdQaqQRfQYPhBeH2dcFMlXKYiOd8qn1cSv/oE6q/iRJj8p4fVZ728NCdYz7zyKMsZ/pQ+bMDyz7VBX+8uX+npLyypcNBjq/K091EKNUSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721208; c=relaxed/simple;
	bh=f1BmRVrgIfV4U7JMCOW1JoDJpQjytPXkTWdwrzVbB3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmWc4TxdW/Am6OnB7PAfmqekOeNLckb752Tow3jYGtFNEMfEdfXVaiCsEmYkUM4UUuEWZzws9rm/6L0AOnvF6h6emmybvUX8oXMFCzPPHZ8VvjrTMQ/R85H3dkpnkx8Oh+JtvLdORldQtFphWCxiFNu0tPDWkExXMwTu0GogN/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVmIkiW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVmIkiW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526C6C116C6;
	Tue,  6 Jan 2026 17:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721205;
	bh=f1BmRVrgIfV4U7JMCOW1JoDJpQjytPXkTWdwrzVbB3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVmIkiW5g+vmTULyVkK1jY6Z81Tjz9GZpasGJ3ZkTbNQdJVpEJ5bSK+LQLe8vF4jB
	 M4g2kN69xgSOoozB7ALxoaQt1GhzbxRZJDyZp2MeoJFCj3zmQghctpEnyiimr1cy5g
	 58POe+hZbttJY28iQO0M1kqrxe0TkSzjE5fvKW70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.12 468/567] drm/mediatek: Fix probe memory leak
Date: Tue,  6 Jan 2026 18:04:10 +0100
Message-ID: <20260106170508.663354538@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 5e49200593f331cd0629b5376fab9192f698e8ef upstream.

The Mediatek DRM driver allocates private data for components without a
platform driver but as the lifetime is tied to each component device,
the memory is never freed.

Tie the allocation lifetime to the DRM platform device so that the
memory is released on probe failure (e.g. probe deferral) and when the
driver is unbound.

Fixes: c0d36de868a6 ("drm/mediatek: Move clk info from struct mtk_ddp_comp to sub driver private data")
Cc: stable@vger.kernel.org	# 5.12
Cc: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250923152340.18234-3-johan@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_ddp_comp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
@@ -671,7 +671,7 @@ int mtk_ddp_comp_init(struct device *dev
 	    type == MTK_DSI)
 		return 0;
 
-	priv = devm_kzalloc(comp->dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 



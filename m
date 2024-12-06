Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5BD193;
	Fri,  6 Dec 2024 14:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496344; cv=none; b=mgmKIXd0xkp/eWNff3veimf5g5l+J5XTPF3RRAjKpnFNeot2d97R78xX1HV5lF5CkBBVYhbXBIMwaUy8XmHt96fkos6UN+5Zr67tcqaAlXJStJ4sjNP6dFVu9LKDYYYSI+6VY8DdIlPMOC79p3cM/pIEQzPDSE4nU75bwWuhA5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496344; c=relaxed/simple;
	bh=P40I/T2koxX5/ZRo6SmbFqcZhAEo6KUq/Af5PLxu6HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWDdSLz+4o/66pAu/Du2YmbdvjYIom2ICOAtLGPK28h+vqK6ZUM5XT5DcRg885B1KNTKr72K/iKiH87XfctyZpkW1exR/VEJPL2p/DDWz8eBENOKoFsIn7sbiHduRbC4WiC95HbGENZsxADwEnT4zB1+BGjBz//ynr5G4cqE7rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXLFaq+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXLFaq+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA655C4CED1;
	Fri,  6 Dec 2024 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496343;
	bh=P40I/T2koxX5/ZRo6SmbFqcZhAEo6KUq/Af5PLxu6HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXLFaq+P2LiqkXqOx6yKMVbg3WbWkTmQ9SGv9kjJbZ/geyaBeWxQxld5+Cbaj654V
	 a+ZlG6c7QRLSl+BxuZVaW2ajJRfan6sl+0LKPCPOhfjNE84+PvUE3XEBS7REPn5qES
	 OeS0rbnVH1VZi2JSjSigCc0SsofSrSd0SvD4HHiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.12 125/146] drm/mediatek: Fix child node refcount handling in early exit
Date: Fri,  6 Dec 2024 15:37:36 +0100
Message-ID: <20241206143532.467168635@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit f708e8b4cfd16e5c8cd8d7fcfcb2fb2c6ed93af3 upstream.

Early exits (goto, break, return) from for_each_child_of_node() required
an explicit call to of_node_put(), which was not introduced with the
break if cnt == MAX_CRTC.

Add the missing of_node_put() before the break.

Cc: stable@vger.kernel.org
Fixes: d761b9450e31 ("drm/mediatek: Add cnt checking for coverity issue")

Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241011-mtk_drm_drv_memleak-v1-1-2b40c74c8d75@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -405,8 +405,10 @@ static bool mtk_drm_get_all_drm_priv(str
 		if (temp_drm_priv->mtk_drm_bound)
 			cnt++;
 
-		if (cnt == MAX_CRTC)
+		if (cnt == MAX_CRTC) {
+			of_node_put(node);
 			break;
+		}
 	}
 
 	if (drm_priv->data->mmsys_dev_num == cnt) {



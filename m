Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0842D190072;
	Mon, 10 Mar 2025 17:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628570; cv=none; b=Z3nGNxHHRwfA1WmHchgiTtxaiJV6Jsesc26x40HaUYDXndQEnWsdDKAhO9ZboVsVM74sFlF7A41L9LCQ7hRD4ysanEIqM6aLtfx9AXVFlChCrw+sbFSnI2J64BshDpYiLfJqjGoyOrH9BJBYtz3hNGaXOr+ITFMcsh4rZIznlN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628570; c=relaxed/simple;
	bh=7HGq4cEcueVTZMPXT8Kl9MeqYV9Gmef1TP9NUuO1Jf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPve1vHbel9pDdtwHUgOklKwJEEw/vT2o6rhpeqqhVffYqy8w6D2sLIAVQ2Do3hZ4Y+SXqJyfLl06YrOCn0WpvN2jHKAnWPgAnbNkUkVNzac3Itd/+Orb3T3DuPZN8WW5uZ14oH1xO5dYWMZWQCLc/lX9MuRAQLEsABmiImQLGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBIvXl8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBIvXl8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311ACC4CEE5;
	Mon, 10 Mar 2025 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628569;
	bh=7HGq4cEcueVTZMPXT8Kl9MeqYV9Gmef1TP9NUuO1Jf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBIvXl8Q9+C9hGIwJdCt4NFIEKLqGQQlK9AxolGBzyF/WylQ1sNiKQC4EDxwr0BxY
	 1aY58riBX1m1Y2MFYr3vqWMuZ2/Uu3Zry0JvCZlmNZb8zGqxikrrSeqcZER6+42QNF
	 3nw3m25hSQebeOiQ0jWWUfDh2ycKhFXzmdZJWtK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Irui Wang <irui.wang@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1 104/109] media: mediatek: vcodec: Handle invalid decoder vsi
Date: Mon, 10 Mar 2025 18:07:28 +0100
Message-ID: <20250310170431.694158831@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Irui Wang <irui.wang@mediatek.com>

commit 59d438f8e02ca641c58d77e1feffa000ff809e9f upstream.

Handle an invalid decoder vsi in vpu_dec_init to ensure the decoder vsi
is valid for future use.

Fixes: 590577a4e525 ("[media] vcodec: mediatek: Add Mediatek V4L2 Video Decoder Driver")

Signed-off-by: Irui Wang <irui.wang@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[ Replace mtk_vdec_err with mtk_vcodec_err to make it work on 6.1.y ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/vdec_vpu_if.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/platform/mediatek/vcodec/vdec_vpu_if.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec_vpu_if.c
@@ -213,6 +213,12 @@ int vpu_dec_init(struct vdec_vpu_inst *v
 	mtk_vcodec_debug(vpu, "vdec_inst=%p", vpu);
 
 	err = vcodec_vpu_send_msg(vpu, (void *)&msg, sizeof(msg));
+
+	if (IS_ERR_OR_NULL(vpu->vsi)) {
+		mtk_vcodec_err(vpu, "invalid vdec vsi, status=%d", err);
+		return -EINVAL;
+	}
+
 	mtk_vcodec_debug(vpu, "- ret=%d", err);
 	return err;
 }



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D328E33D4E2;
	Thu, 30 Jul 2026 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422597; cv=none; b=TRucg5zPjBgLn4c/CAY418vJ/L+QXhRDKL7QY7dj0PIDaAw3wiExnnGpiivXAScKXK42HmqeQOl3A3yGQY8dTHqbiWkeZss6TTugWFC63KiJDroVmESeq9KhNdlJsbMvn7ZwUvXcTDIWsYhd19PvxywJf6TON84SiZEjFLr4/4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422597; c=relaxed/simple;
	bh=alEfxlm7jrB6g2QAIIaHLjk30Ww5H52UcvXRobdniL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjo2/Zer8DRUmNn8cpPUuHZq/Dxt+lvY5wYqVV1AHslyGeyxlwvRdEe2omhvn1oqeajpHVn4bfhm6wmeP/Sz3FHGuXOyMUOz8/Covyfc9642fyVz+hJSgzhZW1AmfaBVYX0J73lgmFtFGzhBWaTmTg70dMLY2+Ie1HPHdmI4Q0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQev8/wS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQev8/wS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9C61F000E9;
	Thu, 30 Jul 2026 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422594;
	bh=gu8DTPniJ00v6oOyj1sqJ9Ud04B+rmRSRnxPmVwP30c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQev8/wSbmnk7c9ke9tvKwfJ+N1JkaULWXhR+s86xug6XYe3/FTj0bClJeRxVNqOL
	 +TpfH7cw7WaMqeiT7P52aBPL7vtC66/fBVTSvuwYSVDtKmZA3JW/ulNUaTBeRSFAmG
	 Fd18E9IZSSVjhHM9Ynidd61bD820ZFWDKJzIQbUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Ak <alperyasinak1@gmail.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 491/744] media: mali-c55: Fix possible ERR_PTR in enable_streams
Date: Thu, 30 Jul 2026 16:12:44 +0200
Message-ID: <20260730141454.728727193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alper Ak <alperyasinak1@gmail.com>

commit 94c6402e423d36a2bd6f62055a65a0d439d84da7 upstream.

The media_pad_remote_pad_unique() function returns either a valid
pointer or an ERR_PTR() on failure (-ENOTUNIQ if multiple links are
enabled, -ENOLINK if no connected pad is found). The return value
was assigned directly to isp->remote_src and dereferenced in the
next line without checking for errors, which could lead to an
ERR_PTR dereference.

Add proper error checking with IS_ERR() before dereferencing the
pointer. Also set isp->remote_src to NULL on error to maintain
consistency with other error paths in the function.

Cc: stable@vger.kernel.org
Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-isp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/platform/arm/mali-c55/mali-c55-isp.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-isp.c
@@ -333,6 +333,13 @@ static int mali_c55_isp_enable_streams(s
 
 	sink_pad = &isp->pads[MALI_C55_ISP_PAD_SINK_VIDEO];
 	isp->remote_src = media_pad_remote_pad_unique(sink_pad);
+	if (IS_ERR(isp->remote_src))  {
+		ret = PTR_ERR(isp->remote_src);
+		dev_err(mali_c55->dev, "Failed to get remote source pad: %d\n", ret);
+		isp->remote_src = NULL;
+		return ret;
+	}
+
 	src_sd = media_entity_to_v4l2_subdev(isp->remote_src->entity);
 
 	isp->frame_sequence = 0;



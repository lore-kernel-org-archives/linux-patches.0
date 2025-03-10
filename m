Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8182717CA12;
	Mon, 10 Mar 2025 17:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629106; cv=none; b=EPpEN513v/TOEvxZ4yyoJzOzszb8WCUylZQMB8yzEbaMx/4waDZcAHJwA4VR/6VwSLne1fG6Bm89kKfp/OosMFEdyhYX41aT7huxka5j/FUd6KTpqsS0qjke+WOBaqlEhTYjBIu9MxQ8DJ7/vL+jNfXWlFj9em5refXJGVLun60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629106; c=relaxed/simple;
	bh=wz1hBuQRlN6oyVKkYm/fCI0efCqOnThP34Gl2eFWMvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZIGVImB/M4y+L777zCH8Iu4Q8gcdB/9vNqIleNda68Py9++ucvE+Uwdck7lIhfMvPiRtdK15JGczB7/BDC6dgrP+AIMdF6gMkycU+kH1gclBnXqU7M+whQuBQiboM/B57+puAiHLkpgiGpNNqR0JTu6pdKTd+QCa8Gohjg/w2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO2QFtkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO2QFtkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B97C4CEE5;
	Mon, 10 Mar 2025 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629106;
	bh=wz1hBuQRlN6oyVKkYm/fCI0efCqOnThP34Gl2eFWMvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO2QFtkqk3H0PEtWBGjC22ieRcPXhtB0bHQiw8x9ql09RGXnE7ol6CRATu5/QYo8f
	 zJSQHztQwCCNoWGwyRQme0KACHSyPH79z6NlbmqXJfmD6rOpI1ooeL2c5JiIuC7uip
	 2KEa8TctEziRcP0EGekK2+FRnsX9rNBAFBycurq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/620] staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()
Date: Mon, 10 Mar 2025 17:59:54 +0100
Message-ID: <20250310170551.445171185@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 094f5c315f756b19198e6c401aa821ac0e868750 ]

imx_media_add_of_subdevs() calls of_parse_phandle() and passes the
obtained node to imx_media_of_add_csi(). The passed node is used in
v4l2_async_nf_add_fwnode(), which increments the refcount of the node.
Therefore, while the current implementation only releases the node when
imx_media_of_add_csi() fails, but should always release it. Call
of_node_put() right after imx_media_of_add_csi().

Fixes: dee747f88167 ("media: imx: Don't register IPU subdevs/links if CSI port missing")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-of.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index b677cf0e0c849..386ff38821e2f 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -55,22 +55,18 @@ int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
 			break;
 
 		ret = imx_media_of_add_csi(imxmd, csi_np);
+		of_node_put(csi_np);
 		if (ret) {
 			/* unavailable or already added is not an error */
 			if (ret == -ENODEV || ret == -EEXIST) {
-				of_node_put(csi_np);
 				continue;
 			}
 
 			/* other error, can't continue */
-			goto err_out;
+			return ret;
 		}
 	}
 
 	return 0;
-
-err_out:
-	of_node_put(csi_np);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(imx_media_add_of_subdevs);
-- 
2.39.5




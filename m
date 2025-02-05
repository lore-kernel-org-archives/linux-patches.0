Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96502522A;
	Wed,  5 Feb 2025 14:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765759; cv=none; b=dsR7QQcqs9UbWBJdEyCRIcyXqxaDnaPXk26Q0qNW8IH2SSjyVOIhpw7a3V6O0Pls4BGAU17cX5rpxK3p6IlZypc0p+1u1aB/c9iJRXl9JUIJgQHo48rTCyzDcPO5Y/d1V4IxRpstE42hp3FP/jFTyTghDP0PSdPiluHDPUUmFOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765759; c=relaxed/simple;
	bh=6m06kk7r9nG7fV3WgIoIp1P70OJ2OGtgI0+BZHLwlPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5KNjW3ZCSz+/Uralb3ZBGS3CIV4YfKnAZWZEaao52j5+rIXuIQeuRkSxKDDmwCYfvXpIf8bglyH6yucRYcYFM8+r4sPc0nw+5uCWVF1M2E0oisMK6wsQFDwgPeT3c1NY6Cs+H1BS1UiJi2uUf7zPR8bvpDR0AqC+JlMyfB+Mg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10tRvXgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10tRvXgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21E6C4CED1;
	Wed,  5 Feb 2025 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765759;
	bh=6m06kk7r9nG7fV3WgIoIp1P70OJ2OGtgI0+BZHLwlPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10tRvXgXojernIH3eOygpDObaICbOG5tMArfNtq831/so26m5EBA4Sv415LeoX2Qk
	 c3rE3exgGligYnc5kqM0sPcJx+Mz/u+jcrNPlnoihw4oEGDs9ClZTaspdjFnb5aKaO
	 3GvJCH0qnIy8L8gefs+gEjLm8Xl0hirSFwjB/zC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 296/393] staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()
Date: Wed,  5 Feb 2025 14:43:35 +0100
Message-ID: <20250205134431.638410906@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 118bff988bc7e..bb28daa4d7133 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -54,22 +54,18 @@ int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
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




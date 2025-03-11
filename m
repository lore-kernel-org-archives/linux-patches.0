Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516E125DD00;
	Tue, 11 Mar 2025 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705547; cv=none; b=DPPjSxZoov7Ns0Egof1F2M/n+dUCz9faAgr1xF6WkzSbfCVEKr7cKji1V7c0cicDlbIf/Rzkg3nI+Xlh9WZ6+JFRP9bz1POyVTaCYCehq/dOh6XXhB5me7fx9HGr3haxFXOr7ptX41dzNZmn3f6fEPFTZeW9VsRqZMNPeyWEfU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705547; c=relaxed/simple;
	bh=JCs2ZuVQgJSCewp0K6SlKOl2/XaV3aGun7qj+nztoiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPRb6KAVAaiFpiK5b8kl4t04WR3UJqltjMXkFZ9BhwwbrI9oGtx6ZfL4nspF+wT8uHs9SZi0YgTHUTlOgJ9s6yGaQB7SPHyU/B0IEe8Hj1emDE1c53L2bx+9m+ZZZmyt9mzBBBTIe5xnzDgRLKJ0SsPRbK5X5PxwiAAmmeBLnYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tcQ6RLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tcQ6RLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD411C4CEE9;
	Tue, 11 Mar 2025 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705547;
	bh=JCs2ZuVQgJSCewp0K6SlKOl2/XaV3aGun7qj+nztoiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tcQ6RLwvFxYqENsJC2ecsmsy4XekT8Yf1to9AYkbY/zrtWXwDcS1frxObU2u3eqr
	 APzW4jmDrAYK+NOaPB8eR8fNVM22a1Qqxj/CmfUBzK12JdMPOyH/n73Harlngt72wb
	 srUgHLkQlYf8Bdu8k+1mYRiDxzYySnrtI/DT9onM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/328] staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()
Date: Tue, 11 Mar 2025 15:57:05 +0100
Message-ID: <20250311145717.086918563@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2d3efd2a6dde0..d9b34605ff9bc 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -55,23 +55,19 @@ int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
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




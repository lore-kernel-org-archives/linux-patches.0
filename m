Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BB21DEFD6;
	Wed, 19 Feb 2025 09:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956500; cv=none; b=I22HbLCTRlIfzVaqg2Zp47oeRJSk6OdGfLmysNOuwlcdr4elpXqoBzhgJRDarHvnwkBQY2TPvDkL/EzqWYJDf34UlUAXFNl6viKlx8QXVP8UtLJm8aKjF0f2r5rH916Bdmd2wkia2ZjT/CIAvGdfjlZR23jrLjjbre8Kc+IINis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956500; c=relaxed/simple;
	bh=W31gm26AVCWpLt9jEmEo4P8P4k869Ji8kk4LrflQ+uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfDImeAM/iwZNKhydtGt8jWwIO6yKKA/MLPLWTwv+nK/wKBZZn2R7vsd75HF4gZ81TQjMUqsF42AfJxGS+6J6R3LwzzcxitWqH2OOjv6ulWs7tA3QdWpWBonyN30T6pWxfBG5gex1jU7X/bWsH/zzu3o+iwpA2PzrCcr9wTzcjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfOJL3J1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfOJL3J1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12DCC4CEE6;
	Wed, 19 Feb 2025 09:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956500;
	bh=W31gm26AVCWpLt9jEmEo4P8P4k869Ji8kk4LrflQ+uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfOJL3J1T1hP1+OfaDDiPxFVMFNmBnSut6K+IQBdS4WBwGQQXybzgeYQjgPwRwGIY
	 wAuylZgd9gnKcrWcg7mR5bxKJbje5/F4ux5j0L2KwEi6Ch8FDidH6S5KPENddR1FS/
	 fNoJFfKV8xiDva9zLDHk9w4S6KlwRG5gwa5Evifs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/578] staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()
Date: Wed, 19 Feb 2025 09:23:23 +0100
Message-ID: <20250219082700.786882781@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
index 59f1eb7b62bcd..3771bc410dff7 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E7B34EF15;
	Fri,  4 Sep 2026 05:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499506; cv=none; b=nu/hSLZcoZs5tQSgLoUvwvZ/gepba05btH/PPkb34/XQ/kfYMWHWkUZo2ROZAbV+FFcFnX2KEVDe/BB0VBuN0XJu8/BBq5ud180M650labpHxTGzQMN4bM0ELjyMQoAAuaBunpARPnsUbCU6sxuet02CCKWoQ47mQZDT4T0xH5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499506; c=relaxed/simple;
	bh=rcnZbZnvbg8hZW/DKjCbFaPuqq5pbZNMZeCM7uvJz5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsRxDv3wAk851q6E//0Myax0jzwNPtOncAETC5rNKa5K/51DLL3GOpZTntbp+d5QMP9yH3zXAb7SMhqBLHKTyhj7NVpK7gJ3Xhfo5YOSV7DCftEircU/Vbbqekw+/MjCKhDv8+/48B2tWOvzlcO8uxO9pHpjbGpBTHzGJ7r0/AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sc/lmBcv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sc/lmBcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D561F00A3E;
	Fri,  4 Sep 2026 05:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499505;
	bh=7IrfwDpA+Lt2Sn32mQ/++ISzg4yfAwJUk9ZjzKMjqNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sc/lmBcvdDw7RhXJWgz4V9w6LNz4GnW8lhJ1cj7sJji9Bfr5XPBuO/s7uDznJZWLE
	 OQyoQjmd6uRM4iBW8MdaihCae1rq2Yq/75jpZL3fM3cTBaqLLwi8HEwxNBb3g07URI
	 pm56i5DQ9OXUNk6YYx/xtPJ4galHedXihK0udNkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 404/713] staging: media: tegra-video: fix of_node_put() on VIP parse errors
Date: Fri,  4 Sep 2026 06:56:12 +0200
Message-ID: <20260904045812.879120351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

commit 7393372f79db940acff206b43e2905685a0c57ad upstream.

tegra_vip_channel_of_parse() initializes np from dev->of_node without
taking a reference, but its error paths drop one through the
err_node_put label. This underflows the refcount of the VIP device's
OF node when endpoint parsing fails on a malformed device tree.

The only reference the function takes on np is the success-path
of_node_get() stored in vip->chan.of_node, and that one is already
released by the tegra_vip_init() error path and by tegra_vip_exit().

Return errors directly instead of jumping to the bogus cleanup label.

Fixes: e740d199cf0f ("staging: media: tegra-video: add support for Tegra20 parallel input")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/tegra-video/vip.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/staging/media/tegra-video/vip.c
+++ b/drivers/staging/media/tegra-video/vip.c
@@ -126,7 +126,7 @@ static int tegra_vip_channel_of_parse(st
 	if (!ep) {
 		err = -EINVAL;
 		dev_err_probe(dev, err, "%pOF: error getting endpoint node\n", np);
-		goto err_node_put;
+		return err;
 	}
 
 	fwh = of_fwnode_handle(ep);
@@ -134,14 +134,14 @@ static int tegra_vip_channel_of_parse(st
 	of_node_put(ep);
 	if (err) {
 		dev_err_probe(dev, err, "%pOF: failed to parse v4l2 endpoint\n", np);
-		goto err_node_put;
+		return err;
 	}
 
 	num_pads = of_graph_get_endpoint_count(np);
 	if (num_pads != TEGRA_VIP_PADS_NUM) {
 		err = -EINVAL;
 		dev_err_probe(dev, err, "%pOF: need 2 pads, got %d\n", np, num_pads);
-		goto err_node_put;
+		return err;
 	}
 
 	vip->chan.of_node = of_node_get(np);
@@ -149,10 +149,6 @@ static int tegra_vip_channel_of_parse(st
 	vip->chan.pads[TEGRA_VIP_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
 	return 0;
-
-err_node_put:
-	of_node_put(np);
-	return err;
 }
 
 static int tegra_vip_channel_init(struct tegra_vip *vip)



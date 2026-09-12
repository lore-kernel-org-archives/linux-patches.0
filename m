Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421F8340D9D;
	Sat, 12 Sep 2026 13:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220588; cv=none; b=P8CgTSyRND+ShIRaewJ+mCqnot0VgqpnHcEBTDwwpmnrbDdJ6CgJv9ZotFajkdbGg3IsW391s2wfz0rLcJiZ8gJ5LvgLnYNwFTOqHI/efqYU5cWvSkcydYRGGYg8HATAANq6FtfWq1OeiB4fDiJ/OVucvY1OQzxkEZtW7Oudbik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220588; c=relaxed/simple;
	bh=ZcyhBIZViajLjmjFoidyKOb8TZvRtjET4Dks5tP7eVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwGijNnatmbycAV/0U8VAkqpvbj7fuOwsMaSCD8nzVf5lZ1or50l2Y+P4yORUHs1nNKaRA37cg/Bf3+m3xGu8NPFxejRNSzaQ1G6dAouqkvTksb8K7cqfevgrRjHR/BOadmV7hDVCMbaYfSPGNicsfzzThceYHuo0GxyNfQRw98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QULBESRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QULBESRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152931F000FF;
	Sat, 12 Sep 2026 13:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220587;
	bh=EVDioa+FK5kUwqHqYVLkED3qNgwF47uAfILIix4vCJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QULBESRAknEcX2TYQaiGYySV75/iSlY+s2XZKgKJWFOupg9J2GrKywyrPALU2UzYM
	 IHrb+I0FNLy62cpClERJFqsCUIYM2m609Jh7bkCegB+Caj5qtB4dIs73ldlEs2K35W
	 u4y956+eJ1iV5iwWGfv9legF1lvrROrgGW9+gzUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0165/1424] staging: media: tegra-video: fix of_node_put() on VIP parse errors
Date: Sat, 12 Sep 2026 08:43:17 +0200
Message-ID: <20260912065610.988862230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/staging/media/tegra-video/vip.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/tegra-video/vip.c b/drivers/staging/media/tegra-video/vip.c
index 9ff1f1750a15..5fba11e31e1d 100644
--- a/drivers/staging/media/tegra-video/vip.c
+++ b/drivers/staging/media/tegra-video/vip.c
@@ -126,7 +126,7 @@ static int tegra_vip_channel_of_parse(struct tegra_vip *vip)
 	if (!ep) {
 		err = -EINVAL;
 		dev_err_probe(dev, err, "%pOF: error getting endpoint node\n", np);
-		goto err_node_put;
+		return err;
 	}
 
 	fwh = of_fwnode_handle(ep);
@@ -134,14 +134,14 @@ static int tegra_vip_channel_of_parse(struct tegra_vip *vip)
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
@@ -149,10 +149,6 @@ static int tegra_vip_channel_of_parse(struct tegra_vip *vip)
 	vip->chan.pads[TEGRA_VIP_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
 	return 0;
-
-err_node_put:
-	of_node_put(np);
-	return err;
 }
 
 static int tegra_vip_channel_init(struct tegra_vip *vip)
-- 
2.55.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B8313792B;
	Thu, 12 Dec 2024 15:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018758; cv=none; b=cd5H9j3zu43ZcsDc7NHqOu/zty3urVjXCGlTbqGQQUqG3pXu/frmUYxuB1iRkb625rjV2ugZfhil0rW2ihL7KZ8ehrUxhm6Z8qGf8b6N3n7zURPfqc27BZRvihszLQpSgwPHN7Ar6RlsoJd2t/LmGYAsWVhbyBM08p3yVX+I7QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018758; c=relaxed/simple;
	bh=Ej/DMhiZtuNQ29dIA1Zs2HI1fTsbHjalKJbovTBB8ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiX+eYvSSr+3V09Duymuz5VPihy2oyr3lSLymuXwNuWPfC49h9WxhvH4BZjSvwMa1EGM/NjObcWYZL9UTtW44lo3oa9hjfUxD9HcsF5DmEzmpmPNGjQ8xOYTWk7ewbisQWq7ZqEzbhmTmunmiXjuXT6rH2KmqjLa0EEhp710Tx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmW1Htdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmW1Htdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF54DC4CED0;
	Thu, 12 Dec 2024 15:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018758;
	bh=Ej/DMhiZtuNQ29dIA1Zs2HI1fTsbHjalKJbovTBB8ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmW1Htdc5u4QGDbmKCG92lAuPuw6kOXosp9Q7dnN1PYDLZ8eOIEhB4TIVy6UcHHgs
	 zq2mwp0NvEFSZLIy/gRV4W6VFcVf4yFjf8a7TIyXYBonsy6ZqeptqE5bUUdsKzbqMv
	 paSGMT2rDEODG7BXMsRYl3GpHgzGPPBzn8cbUkag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Watts <contact@jookia.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/772] ASoC: audio-graph-card2: Purge absent supplies for device tree nodes
Date: Thu, 12 Dec 2024 15:49:29 +0100
Message-ID: <20241212144350.941895024@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Watts <contact@jookia.org>

[ Upstream commit f8da001ae7af0abd9f6250c02c01a1121074ca60 ]

The audio graph card doesn't mark its subnodes such as multi {}, dpcm {}
and c2c {} as not requiring any suppliers. This causes a hang as Linux
waits for these phantom suppliers to show up on boot.
Make it clear these nodes have no suppliers.

Example error message:
[   15.208558] platform 2034000.i2s: deferred probe pending: platform: wait for supplier /sound/multi
[   15.208584] platform sound: deferred probe pending: asoc-audio-graph-card2: parse error

Signed-off-by: John Watts <contact@jookia.org>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20241108-graph_dt_fix-v1-1-173e2f9603d6@jookia.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/generic/audio-graph-card2.c b/sound/soc/generic/audio-graph-card2.c
index 8ac6df645ee6c..33f35eaa76a8b 100644
--- a/sound/soc/generic/audio-graph-card2.c
+++ b/sound/soc/generic/audio-graph-card2.c
@@ -249,16 +249,19 @@ static enum graph_type __graph_get_type(struct device_node *lnk)
 
 	if (of_node_name_eq(np, GRAPH_NODENAME_MULTI)) {
 		ret = GRAPH_MULTI;
+		fw_devlink_purge_absent_suppliers(&np->fwnode);
 		goto out_put;
 	}
 
 	if (of_node_name_eq(np, GRAPH_NODENAME_DPCM)) {
 		ret = GRAPH_DPCM;
+		fw_devlink_purge_absent_suppliers(&np->fwnode);
 		goto out_put;
 	}
 
 	if (of_node_name_eq(np, GRAPH_NODENAME_C2C)) {
 		ret = GRAPH_C2C;
+		fw_devlink_purge_absent_suppliers(&np->fwnode);
 		goto out_put;
 	}
 
-- 
2.43.0




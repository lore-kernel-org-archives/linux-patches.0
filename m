Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1847232C8B;
	Fri,  6 Dec 2024 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496523; cv=none; b=dzfKQSLYaYLClG4HDwk00z6U0B3tXOCqSHvvm2ISXJMbR/oGyBCVsksLmvLj93n03u2vaiAv6UuKVnsvh2ecfSNkYmYSjhowoDz9fB475w0UZ/vybLJS7vdMpdjVoVTYBGo7uiiG+vQgO0GQ50QWK0+yn3BgByGHRj/KJrUxF6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496523; c=relaxed/simple;
	bh=Fq/8lmD/zft2g9smWMlv0yWMszUdS1nNba6r8uONn1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sX9ycncIHM+UpLGXOgapX+qIWSXn0VKVdFsd5MQPlyLm4LJlcJANri0WgyP/3ZZu/Eqqh50A7zE0+by1Uy0ybEQgdeLR0xwyYK4cdhVM20aNC+DPNeC33KYuo3lROquLqh8+lx8GmTLkhl83aXA4yQoILbWOBwCnfkfOWwUdy/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLOQ3zlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLOQ3zlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C283C4CED1;
	Fri,  6 Dec 2024 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496523;
	bh=Fq/8lmD/zft2g9smWMlv0yWMszUdS1nNba6r8uONn1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLOQ3zlcr+2LXA6pYJP1GijO+FNJi848dA0Sy/9LorrhMvynKu3pOhunMkXCofgQs
	 9mK6aSTMI9PZdToJXN9GX4mxWhsV10usH29YXsJYlK9cNc37yZ+32UnFbvYrLwsJxF
	 9Lbz+gCbTBkRCLfG2OZUb3IOT19VtaRYl7QL8TFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Watts <contact@jookia.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/676] ASoC: audio-graph-card2: Purge absent supplies for device tree nodes
Date: Fri,  6 Dec 2024 15:27:28 +0100
Message-ID: <20241206143654.494651064@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b1c675c6b6db6..686e0dea2bc75 100644
--- a/sound/soc/generic/audio-graph-card2.c
+++ b/sound/soc/generic/audio-graph-card2.c
@@ -261,16 +261,19 @@ static enum graph_type __graph_get_type(struct device_node *lnk)
 
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




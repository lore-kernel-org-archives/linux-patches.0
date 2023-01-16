Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC6C46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30053C433D2;
	Mon, 16 Jan 2023 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886448;
	bh=xLNK1PvoJh0Dx4+icM8fpYqF4BejcDZQqWp4O/lNUEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIn3M9X5JJEGHSzjc0wQN7nfsi/BRJmyh5Pdi/MJP97WMuiIPomYXyZ71Ra+YjiY6
	 O4s2ICbFZujsqYjdhiz1/xc2/SNbOaQ4cSN6oShyvtKxYdzT36TEA46ARqhczlcCP1
	 /2F0UrNY/8mUZ6IJMOndpIzSQQiyV7F0DOfWKTwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 434/658] ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()
Date: Mon, 16 Jan 2023 16:48:42 +0100
Message-Id: <20230116154929.411118012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 8ab2d12c726f0fde0692fa5d81d8019b3dcd62d0 ]

The of_get_next_child() returns a node with refcount incremented, and
decrements the refcount of prev. So in the error path of the while loop,
of_node_put() needs be called for cpu_ep.

Fixes: fce9b90c1ab7 ("ASoC: audio-graph-card: cleanup DAI link loop method - step2")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/1670228127-13835-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/generic/audio-graph-card.c b/sound/soc/generic/audio-graph-card.c
index 96aa2c015572..a96a7cd8af6e 100644
--- a/sound/soc/generic/audio-graph-card.c
+++ b/sound/soc/generic/audio-graph-card.c
@@ -466,8 +466,10 @@ static int graph_for_each_link(struct asoc_simple_priv *priv,
 			of_node_put(codec_ep);
 			of_node_put(codec_port);
 
-			if (ret < 0)
+			if (ret < 0) {
+				of_node_put(cpu_ep);
 				return ret;
+			}
 
 			codec_port_old = codec_port;
 		}
-- 
2.35.1



